#
# Stoplight Provider for coconut-ci (http://coconut-ci.com)
#

module Stoplight::Providers
  class Coconut < MultiProjectStandard
    def provider
      'coconut'
    end

    # - `name` - the name of this project
    # - `build_url` - the url where the build came from
    # - `build_id` - the unique build_id for this project
    # - `last_build_time` - last successful build
    # - `last_build_status` - integer representing the exit code of the last build:
    #   - -1: unknown
    #   -  0: passed (success)
    #   -  1: failed (error, failure)
    # - `current_status` - the current status of the build:
    #   - -1: unknwon
    #   -  0: done (sleeping, waiting)
    #   -  1: building (building, working, compiling)
    def projects
      if @response.nil? || @response.parsed_response.nil? 
        @projects ||= []
      else
        # Jenkins doesn't return an array when there's only one job...
        @projects ||= [@response.parsed_response].flatten.collect do |project|
          build = get_last_build(project['id'])
          
          Stoplight::Project.new({
           :name => project['name'],
           :build_url => "http://coconut-ci.com/jobs/#{project['id']}/builds",
           :last_build_id => build == false ? '' : build['id'],
           :last_build_time => build == false ? '' : build['created_at'],
           :last_build_status => build == false ? '' : status_to_int(build['status']),
           :current_status => activity_to_int(project['status']),
           :culprits => []
          })
        end
      end
    end

    private
    def status_to_int(status)
      case status
      when /success/i then 0
      when /failure/i then 1
      when /running/i then -1
      else -1
      end
    end

    private
    def activity_to_int(status)
      case status
      when /success/i then 0
      when /failure/i then 0
      when /running/i then 1
      else -1
      end
    end

    private
    def get_last_build(project_id)
      response = load_server_data(:path => "/jobs/#{project_id}/builds")

      return false if response.nil? || response.parsed_response.nil?
      [response.parsed_response].flatten.collect do |build|
        if build['status'] != 'running'
          return build
        end
      end
  
     return false
    end

    def builds_path
      @options['builds_path'] ||= '/jobs'
    end

  end
end
