module Stoplight
  class Project
    attr_accessor :name, :build_url, :last_build_id, :last_build_time, :last_build_status, :current_status, :culprits

    # Initialize (new) takes in a hash of options in the following format:
    #
    # {
    #   :name => 'my_project',
    #   :build_url => 'http://ci.jenkins.org/job/my_project',
    #   :web_url => 'http://github.com/username/my_project', # optional
    #   :last_build_id => '7',
    #   :last_build_time => '2012-05-24T03:19:53Z',
    #   :last_build_status => 0,
    #   :current_status => 1,
    # }
    #
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
    def initialize(options = {})
      @options = options

      @name = options[:name]
      @build_url = options[:build_url]
      @last_build_id = options[:last_build_id]
      @last_build_time = parse_date(options[:last_build_time])
      @last_build_status = parse_last_build_status(options[:last_build_status])
      @current_status = parse_current_status(options[:current_status])
      @culprits = options[:culprits]
    end

    def building?
      @current_status == 'building'
    end

    def built?
      @current_status == 'done'
    end

    def passed?
      @last_build_status == 'passed'
    end

    def failed?
      @last_build_status == 'failed'
    end

    private
    # returns the correct time from the given project time
    def parse_date(date_time)
      return nil if date_time.nil? || date_time.empty?
      begin
        DateTime.parse(date_time)
      rescue
        nil
      end
    end

    # Returns the correct last_build_status code
    def parse_last_build_status(status)
      case status
      when 0 then 'passed'
      when 1 then 'failed'
      else 'unknown'
      end
    end

    # returns the correct current_status code
    def parse_current_status(status)
      case status
      when 0 then 'done'
      when 1 then 'building'
      else 'unknown'
      end
    end
  end
end
