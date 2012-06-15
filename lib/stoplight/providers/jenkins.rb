#
# Stoplight Provider for Jenkins CI (http://jenkinsci.org)
#
# Jenkis inherits from the MultProjectStandard
#

module Stoplight::Providers
  class Jenkins < MultiProjectStandard
    include HTTParty
    require 'digest/md5'
    def provider
      'jenkins'
    end
    def projects
      @projects ||= @response.parsed_response['Projects']['Project'].collect do |project|
        Stoplight::Project.new({
         :name => project['name'],
         :build_url => project['webUrl'],
         :last_build_id => project['lastBuildLabel'],
         :last_build_time => project['lastBuildTime'],
         :last_build_status => status_to_int(project['lastBuildStatus']),
         :current_status => activity_to_int(project['activity']),
         :culprits => get_culprits(project['webUrl'])
        })
      end
    end

    private
    def get_culprits(url)
    	# grab fullName, and the address property from the users who are culprits on the last build
    	response = HTTParty.get("#{url}lastBuild/api/json?tree=culprits[fullName,property[address]]")
    	# for each culprit in culprits get their fullName and email and store it as a hash
      response['culprits'].collect do |culprit|
        user = {'name' => culprit['fullName']}
        culprit['property'].each do |property|
          unless property['address'].nil? then
          	# create a hash of users email to use for their gravatar
            hash = Digest::MD5.hexdigest(property['address'].downcase)
            user['gravatar'] = "http://www.gravatar.com/avatar/#{hash}.jpg"
          end
        end
        user
      end
    end
  end
end
