require 'spec_helper'
include Stoplight::Providers

describe Provider do
  before do
    stub_request(:any, 'http://www.example.com').to_return(:status => 200)
  end

  context 'initialize' do
    context 'with no parameters' do
      it 'should require a :url parameter' do
        lambda { Provider.new }.should raise_error(ArgumentError)
      end

      it 'should not create an instance' do
        begin
          provider = Provider.new
        rescue
        end

        provider.should be_nil
      end
    end

    context 'with an invalid :url parameter' do
      it 'should raise an exception' do
        lambda { Provider.new('url' => 'not_a_url') }.should raise_error
      end
    end

    context 'with a valid :url parameter' do
      it 'should not raise an exception' do
        lambda { Provider.new('url' => 'http://www.example.com') }.should_not raise_error(ArgumentError)
      end

      it 'should return an "okay" response' do
        provider = Provider.new('url' => 'http://www.example.com')
        provider.response.code.should satisfy { |n|
          n/100 == 2 # starts with 2 = okay
        }
      end

      context 'with basic authentication' do
        before do
          stub_request(:any, 'http://my_username:my_password@www.example.com').to_return(:status => 200)
          provider = Provider.new('url' => 'http://www.example.com', 'username' => 'my_username', 'password' => 'my_password')
          @basic_auth = provider.response.request.options[:basic_auth]
        end

        it 'should set :basic_auth' do
          @basic_auth.should_not be_nil
        end

        it 'should pass :username :basic_auth' do
          @basic_auth[:username].should == 'my_username'
        end

        it 'should pass :password :basic_auth' do
          @basic_auth[:password].should == 'my_password'
        end
      end

      context 'with a querystring' do
        it 'should set :owner_name' do
          stub_request(:any, 'http://www.example.com/?owner_name=my_owner_name').to_return(:status => 200)
          provider = Provider.new('url' => 'http://www.example.com', 'owner_name' => 'my_owner_name')
          provider.response.request.options[:query][:owner_name].should == 'my_owner_name'
        end

        it 'should not set an unknown key' do
          provider = Provider.new('url' => 'http://www.example.com', 'not_an_allowed_key' => 'should_never_see_this')
          provider.response.request.options[:query].should be_nil
        end
      end

      context 'with proxy settings defined' do 
        before do
          stub_request(:any, 'http://www.example.com').to_return(:status => 200)
        end

        it "should set :http_proxyaddr" do
          provider = Provider.new('url' => 'http://www.example.com', 'http_proxyaddr' => 'proxy')
          provider.response.request.options[:http_proxyaddr].should == 'proxy'
        end

        it "should set :http_proxyport" do
          provider = Provider.new('url' => 'http://www.example.com', 'http_proxyport' => '8000')
          provider.response.request.options[:http_proxyport].should == '8000'
        end

        it "should set :http_proxyuser" do
          provider = Provider.new('url' => 'http://www.example.com', 'http_proxyuser' => 'username')
          provider.response.request.options[:http_proxyuser].should == 'username'
        end

        it "should set :http_proxypass" do
          provider = Provider.new('url' => 'http://www.example.com', 'http_proxypass' => 'password')
          provider.response.request.options[:http_proxypass].should == 'password'          
        end
      end
    end
  end

  context 'projects' do
    it 'should raise an exception' do
      provider = Provider.new('url' => 'http://www.example.com')
      lambda { provider.projects }.should raise_error(Stoplight::Exceptions::NoParserError)
    end
  end
end
