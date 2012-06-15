# This is a sample spec for testing a provider. You should copy this spec when testing
# a new provider.

require 'spec_helper'
include Stoplight::Providers

describe Sample do
  use_vcr_cassette 'sample', :record => :new_episodes

  context 'provider' do
    it 'should return the correct provider name' do
      provider = Sample.new('url' => 'http://www.example.com')
      provider.provider.should == 'sample'
    end
  end

  context 'projects' do
    it 'should return an array of Stoplight::Project' do
      provider = Sample.new('url' => 'http://www.example.com')

      provider.projects.class.should == Array
      provider.projects.first.class.should == Stoplight::Project
    end
  end
end
