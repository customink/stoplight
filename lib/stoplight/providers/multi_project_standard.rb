#
# This is the multiproject standard supported by Jenkis and CruiseControl
# (and probably other CIs). If your CI supports this standard, create a new
# provider and inherity from `MultiProjectStandard` instead of `Provider`.
#
# http://confluence.public.thoughtworks.org/display/CI/Multiple+Project+Summary+Reporting+Standard
#
# Then simply define the `provider` method to return the name of your provider.
#

module Stoplight::Providers
  class MultiProjectStandard < Provider
    def provider
      raise Stoplight::Exceptions::NoProviderError, "a provider name must be specified"
    end

    def builds_path
      @options['builds_path'] ||= 'cc.xml'
    end

    def projects
      if @response.parsed_response.nil? || @response.parsed_response['Projects'].nil?
        @projects ||= []
      else
        @projects ||= @response.parsed_response['Projects']['Project'].collect do |project|
          Stoplight::Project.new({
            :name => project['name'],
            :build_url => project['webUrl'],
            :last_build_id => project['lastBuildLabel'],
            :last_build_time => project['lastBuildTime'],
            :last_build_status => status_to_int(project['lastBuildStatus']),
            :current_status => activity_to_int(project['activity'])
          })
        end
      end
    end

    private
    def status_to_int(status)
      case status
      when /success/i then 0
      when /failure/i then 1
      else -1
      end
    end

    def activity_to_int(activity)
      case activity
      when /sleeping/i then 0
      when /building/i then 1
      else -1
      end
    end
  end
end
