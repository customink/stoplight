require 'spec_helper'
include Stoplight::Providers

describe MultiProjectStandard do
  use_vcr_cassette 'multi-project-standard', :record => :new_episodes

  it 'should inherit from Stoplight::Provider' do
    MultiProjectStandard.superclass.should == Provider
  end

  context 'provider' do
    it 'should raise an exception' do
      provider = MultiProjectStandard.new('url' => 'http://ci.jenkins-ci.org')
      lambda { provider.provider }.should raise_error(Stoplight::Exceptions::NoProviderError)
    end
  end

  context 'builds_path' do
    it 'should set the builds_path if an option is specified' do
      provider = MultiProjectStandard.new('url' => 'http://ci.jenkins-ci.org', 'builds_path' => 'foobar.xml')
      provider.builds_path.should == 'foobar.xml'
    end

    it 'should use the default builds_path value if an option is not specified' do
      provider = MultiProjectStandard.new('url' => 'http://ci.jenkins-ci.org')
      provider.builds_path.should == 'cc.xml'
    end
  end

  context 'projects' do
    before do
      @provider = MultiProjectStandard.new('url' => 'http://ci.jenkins-ci.org/view/All')
    end

    it 'should return an array of Stoplight::Project' do
      @provider.projects.class.should == Array
      @provider.projects.first.class.should == Stoplight::Project
    end

    it 'should have the correct default project attributes' do
      project = @provider.projects.first

      project.name.should == 'config-provider-model'
      project.build_url.should == 'http://ci.jenkins-ci.org/job/config-provider-model/'
      project.last_build_id.should == '15'
      project.last_build_time.should == DateTime.parse('2012-03-25T19:01:25Z')
    end

    it 'should have the correct :last_build_statuses' do
      projects = @provider.projects

      projects[0].last_build_status.should == 'passed'
      projects[0].current_status.should == 'done'

      projects[11].last_build_status.should == 'failed'
      projects[11].current_status.should == 'done'
    end
  end
end
