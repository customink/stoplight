#
# Stoplight Provider for Sample
#
# This is a sample provider that is only used for illustration and testing purposes.
# You should copy this file when making another provider to ensure you define all
# the necessary methods and attributes.
#
# For more information on what each method should return, see the parent class `Provider`.
#

module Stoplight::Providers
  class Sample < Provider
    def provider
      'sample'
    end

    def builds_path
      @options['builds_path'] ||= '/repositories.json'
    end

    def projects
      @projects ||= [
        Stoplight::Project.new({
          :name => 'Sample Project',
          :build_url => 'http://www.example.com/',
          :last_build_id => '1',
          :last_build_time => '',
          :last_build_status => 0,
          :current_status => 0
        })
      ]
    end
  end
end
