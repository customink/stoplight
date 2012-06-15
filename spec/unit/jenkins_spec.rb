require 'spec_helper'
include Stoplight::Providers

describe Jenkins do
  it 'should inherit from from Stoplight::MultiProjectStandard' do
    Jenkins.superclass.should == MultiProjectStandard
  end

  context 'provider' do
    it 'should return the correct provider name' do
      stub_request(:any, 'http://www.example.com/cc.xml').to_return(:status => 200)
      provider = Jenkins.new('url' => 'http://www.example.com')
      provider.provider.should == 'jenkins'
    end
  end
end
