require 'spec_helper'
include Stoplight::Providers

describe Travis do
  before do
    stub_sample_response
  end

  it 'should inherit from Stoplight::Provider' do
    Travis.superclass.should == Provider
  end

  context 'provider' do
    it 'should return the correct provider name' do
      stub_request(:any, 'http://www.example.com/repositories.json')
      provider = Travis.new('url' => 'http://www.example.com')
      provider.provider.should == 'travis'
    end
  end

  context 'projects' do
    context 'with no :owner_name query' do
      before do
        stub_sample_response
        @provider = Travis.new('url' => 'http://www.example.com')
      end

      it 'should return an array of Stoplight::Project' do
        @provider.projects.class.should == Array
        @provider.projects.first.class.should == Stoplight::Project
      end

      it 'should have the correct default project attributes' do
        project = @provider.projects.first

        project.name.should == 'abyss-navigation-rails'
        project.build_url.should == 'http://travis-ci.org/jtrim/abyss-navigation-rails'
        project.last_build_id.should == '2'
        project.last_build_time.should == DateTime.parse('2012-05-23T21:04:55Z')
      end

      it 'should have the correct :last_build_statuses' do
        projects = @provider.projects

        projects[0].last_build_status.should == 'passed'
        projects[0].current_status.should == 'done'

        projects[1].last_build_status.should == 'failed'
        projects[1].current_status.should == 'building'

        projects[2].last_build_status.should == 'unknown'
        projects[2].current_status.should == 'unknown'
      end
    end
  end

  private
  def stub_sample_response
    body = '[
      {
        "id":15814,
        "slug":"jtrim/abyss-navigation-rails",
        "description":"A DSL for creating navigation structures based on the Rails routing table using Abyss.",
        "last_build_id":1415864,
        "last_build_number":"2",
        "last_build_status":0,
        "last_build_result":0,
        "last_build_duration":null,
        "last_build_language":null,
        "last_build_started_at":"2012-05-23T21:04:48Z",
        "last_build_finished_at":"2012-05-23T21:04:55Z"
      },
      {
        "id":12413,
        "slug":"bem/apw",
        "description":"APW (Arch-Plan-Workers) \u2014\u00a0is the core of the build system of `bem make/server` commands",
        "last_build_id":1415860,
        "last_build_number":"88",
        "last_build_status":1,
        "last_build_result":1,
        "last_build_duration":null,
        "last_build_language":null,
        "last_build_started_at":"2012-05-23T21:03:18Z",
        "last_build_finished_at":null
      },
      {
        "id":13409,
        "slug":"project-rhex/rhex-test",
        "description":"A interoperability testing tool",
        "last_build_id":1415839,
        "last_build_number":"8",
        "last_build_status":null,
        "last_build_result":null,
        "last_build_duration":64,
        "last_build_language":null,
        "last_build_started_at":null,
        "last_build_finished_at":"unexpected_response"
      }
    ]'

    stub_request(:any, 'http://www.example.com/repositories.json').to_return(:status => 200, :body => body, :headers => { 'Content-Type' => 'application/json' })

    # stub_request(:any, 'http://www.example.com/jtrim/abyss-navigation-rails/builds.json').to_return(:status => 200, :body => { 'matrix' => { 'author_name' => 'Bill Jones', 'author_email' => 'test@example.com' } }, :headers => { 'Content-Type' => 'application/json' })
  end

end
