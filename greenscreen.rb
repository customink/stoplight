require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'erb'
require 'rexml/document'
require 'hpricot'
require 'open-uri'
require 'yaml'
require 'erb'
require 'timeout' # to catch error

get '/' do
  servers = load_servers
  return "Add the details of build server to the config.yml file to get started" unless servers

  @projects = load_projects( servers )

  @successful_projects = @projects.select { |p| p.last_build_status == 'success' }
  @unsuccessful_projects = @projects.select { |p| p.last_build_status != 'success' }

  erb :index
end

get '/:project_name.png' do |project_name|
  projects = load_projects( load_servers )

  project = projects.find { |p| p.name == project_name }

  if project
    project_state = project.activity == 'Sleeping' ? project.last_build_status : project.activity

    image = case project_state
      when 'success' then 'passing'
      when 'failure' then 'failing'
      else 'unknown'
    end

    content_type 'image/png'
    File.read( File.join('public', 'images', 'status', "#{image}.png" ) )
  else
    status 404
  end
end

def load_projects( servers )
  projects = []

  servers.each do |server|
    open_opts = {}
    if server["username"] || server["password"]
      open_opts[:http_basic_authentication] = [ server["username"], server["password"] ]
    end
    begin
      xml = REXML::Document.new(open(server["url"], open_opts))
      projects.push(*accumulate_projects(server, xml))
    rescue => e
      projects.push(MonitoredProject.server_down(server, e))
    rescue Timeout::Error => e
      projects.push(MonitoredProject.server_down(server, e))
    end
  end

  projects.sort_by { |p| p.name.downcase }
end

def load_servers
  YAML.load(StringIO.new(ERB.new(File.read 'config.yml').result))
end

def accumulate_projects(server, xml)
  projects = xml.elements["//Projects"]

  job_matchers =
    if server["jobs"]
      server["jobs"].collect do |j|
        if j =~ %r{^/.*/$}
          Regexp.new(j[1..(j.size-2)])
        else
          Regexp.new("^#{Regexp.escape(j)}$")
        end
      end
    end

  ignore_job_matchers =
    if server["ignore_jobs"]
      server["ignore_jobs"].collect do |j|
        if j =~ %r{^/.*/$}
          Regexp.new(j[1..(j.size-2)])
        else
          Regexp.new("^#{Regexp.escape(j)}$")
        end
      end
    end

  projects.collect do |project|
    monitored_project = MonitoredProject.create(project)
    include_this_project = true
    if job_matchers || ignore_job_matchers
      # first, check if we should ignore this job
      if ignore_job_matchers
        if ignore_job_matchers.detect { |ignore| monitored_project.name =~ ignore }
          include_this_project = false
        end
      end

      if job_matchers
        # ignore the project, unless it's included
        include_this_project = false
        if job_matchers.detect { |matcher| monitored_project.name =~ matcher }
          include_this_project = true
        end
      end
    
    end
    if include_this_project
      monitored_project
    end
  end.flatten.compact
end

class MonitoredProject
  attr_accessor :name, :last_build_status, :activity, :last_build_time, :web_url, :last_build_label

  def self.create(project)
    MonitoredProject.new.tap do |mp|
      mp.activity = project.attributes["activity"]
      mp.last_build_time = Time.parse(project.attributes["lastBuildTime"]).localtime
      mp.web_url = project.attributes["webUrl"]
      mp.last_build_label = project.attributes["lastBuildLabel"]
      mp.last_build_status = project.attributes["lastBuildStatus"].downcase
      mp.name = project.attributes["name"]
    end
  end

  def self.server_down(server, e)
    MonitoredProject.new.tap do |mp|
      mp.name = e.to_s
      mp.last_build_time = Time.now.localtime
      mp.last_build_label = server["url"]
      mp.web_url = server["url"]
      mp.last_build_status = "Failure"
      mp.activity = "Sleeping"
    end
  end

  def building?
    self.activity =~ /building/i
  end
end
