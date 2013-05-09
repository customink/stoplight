Stoplight
=========
[![Build Status](https://secure.travis-ci.org/customink/stoplight.png?branch=master)](http://travis-ci.org/customink/stoplight)

Introduction
------------
Stoplight is a build monitoring tool that is largely based off [greenscreen](https://github.com/martinjandrews/greenscreen), but is much improved and expandable. To quickly name a few, Stoplight has:

 - built-in support for [Jenkins](http://www.jenkis-ci.org)
 - built-in support for Travis-CI(http://travis-ci.org)
 - custom provider support
 - community contributions
 - full test suite
 - resuable DSL

Stoplight is designed to be displayed on large television screens or monitors. It automatically resizes to fill the maximum real estate the screen can offer.

Installation
------------
Stoplight is a Rack application, so you'll need to install Ruby and Rubygems before you can run Stoplight. **Stoplight requires Ruby 1.9.x**.

Start by cloning the application repository:

    git clone git@github.com:customink/stoplight.git

And then bundle all the application's dependencies:

    bundle install

Next, copy the `config/servers.example.yml` file to `config/servers.yml`:

    cp config/servers.example.yml config/servers.yml

If you want to get up and running quickly and just see what Stoplight looks like, add the following to your configuration file. It will pull from Travis CI:

```yaml
-
  type: 'travis'
  url: http://travis-ci.org
  owner_name: github_username
```

Start the server with the `rackup` command:

    rackup ./config.ru

Navigate to `http://localhost:9292` and check it out! You should see the status of a bunch of builds. The screen will refresh every 15 seconds to keep itself up to date.


Configuration
-------------
All configuration options are specified through the `config/servers.yml` file we copied over before. There's significant documentation in that file on how to configure your servers.

All servers must specify a `type` option. This tells Stoplight what provider it should use. For example, if you are using Travis CI, your provider is `Travis` and the server type is `travis`. If you were using a custom server, the configuration might look like:

```yaml
-
  type: 'my_server'
  url: '...'
```

This would look for a provider named `MyServer` under `lib/stoplight/providers`. For more information on writing a custom provider, see the **Contributing** section.

If you have a lot of projects, you may want to selective display them on Stoplight. Luckily, this is just a simple configuration option. To ignore certain projects, just add the `ignored_projects` field to the config. It even supports regular expressions:

```yml
-
  type: 'travis'
  url: 'http://travis-ci.org'
  ignored_projects:
    - /^rails-(.*)$/
    - some_other_project
```

Conversely, you can choose to only show certain projects with the `projects` option:

```yml
-
  type: 'jenkins'
  url: 'http://jenkins.mycompany.com/cc.xml'
  projects:
    - /^public-(.*)$/
    - some_other_project
```

Contributing
------------
The development environment is configured with all kinds of goodies like Spork, Guard, and Foreman. If you're developing, just run `foreman start` and code! As you write tests and code, Guard will run the tests, Spork will make it fast, and Growl will tell you if they passed or failed!

### Providers
One of the larger goals of Stoplight was to server the open source community. As more Continuous Integration servers emerge, we needed a common DSL for interacting with them. This all arose when we wanted to add Travis CI support to Greenscreen. Greenscreen was written for CI's that conform to a standard that doesn't even exist anymore. Stoplight doesn't care how the data comes in from the provider!

A `Provider` is really just a ruby class that defines two methods:

```ruby
class MyProvider < Provider
  def provider
    'my provider'
  end

  def projects
    # logic here
  end
end
```

The `provider` method is just a utility method that returns the name of the provider. The `projects` method is the "magical" method. This is where a developer parses the data into the given specification. You should take a look in `lib/stoplight/providers/sample.rb` for a good starting point.

### Views/Styles/Layouts
If you are looking to change the design, add styles or javascripts, you'll need to know a little bit about the architecture of the application.

- **All** javascript should be written in coffeescript. The coffeescript files live in `app/assets/javascripts`. They are compiled to `public/javascripts`.
- **All** css should be written in scss + compass. The scss files live in `app/assets/stylesheets`. They are compiled to `public/stylesheets`.

Deployment
----------
Deploying Stoplight to [Heroku](http://www.heroku.com) is a snap.

Of course, if your build servers aren't publicly accessible, Heroku won't be a great option. A [Chef Cookbook for deploying Stoplight](http://community.opscode.com/cookbooks/stoplight) is available on [the Opscode Community site](http://community.opscode.com).  You can read more about both options in [Nathen Harvey's blog](http://nathenharvey.com/blog/2012/01/02/deploying-green-screen/). Note that, in his post, Nathen talks about Greenscreen. Stoplight can be deployed in the same manner.

[William Durand](https://github.com/willdurand) also ported a [Puppet Module for installing Stoplight](https://github.com/willdurand/puppet-stoplight).

Credits
-------
 - GreenScreen was original developed by [martinjandrews](https://github.com/martinjandrews/greenscreen/).
 - The former version of GreenScreen was a fork of the updates made by [rsutphin](https://github.com/rsutphin/greenscreen/).
 - This version of Stoplight was written by [sethvargo](https://github.com/sethvargo)
