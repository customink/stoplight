require 'spec_helper'
include Stoplight::Providers

describe Jenkins do
  use_vcr_cassette 'jenkins', :record => :new_episodes

  it 'should inherit from from Stoplight::MultiProjectStandard' do
    Jenkins.superclass.should == MultiProjectStandard
  end

  context 'provider' do
    it 'should return the correct provider name' do
      provider = Jenkins.new('url' => 'http://ci.jenkins-ci.org')
      provider.provider.should == 'jenkins'
    end
  end

  context 'projects' do
    context 'culprits' do
      it 'should return a list of the culprits who broke the build' do
        provider = Jenkins.new('url' => 'http://ci.jenkins-ci.org', 'culprits' => true)
        project = provider.projects.select{ |p| !p.culprits.empty? }.first

        project.culprits.class.should == Array

        project.culprits.first['name'].should == 'Kohsuke Kawaguchi'
        project.culprits.first['gravatar'].should == 'http://www.gravatar.com/avatar/0cb9832a01c22c083390f3c5dcb64105.jpg'
      end
    end
  end
end
