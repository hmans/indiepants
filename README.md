# IndiePants [![Build Status](https://travis-ci.org/hmans/indiepants.svg?branch=master)](https://travis-ci.org/hmans/indiepants) ![status](https://img.shields.io/badge/ready_for_use-nope-red.svg)

Pants Phase 2: A clean IndieWeb implementation of Pants.


### Status

* Currently trying to reach feature parity with the previous implementation. ([Roadmap/Status](https://github.com/hmans/indiepants/milestones))
* Please don't use this code yet; I'm still messing with the basics.
* Please don't send unsolicited pull requests. If you want to submit a change, talk to me first.

### Mission Notes

* Open-Source from day 1.
* Use simple and open protocols.
* Be a good [IndieWeb](http://indiewebify.me/) citizen.

### Dependencies

* Ruby 2.2.0
* PostgreSQL 9.4
* ImageMagick

### Running with Docker

For hosting your own instance of IndiePants using [Docker](https://www.docker.com/), please use the
[indiepants-docker](https://github.com/hmans/indiepants-docker) project.

### Deploy on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

If you want to give IndiePants a spin, clicking this button will set up a copy on the
free Heroku tier. Heroku will let you sign up for free and only ask you for credit
card details once you either upgrade to the paid tier, or start using Heroku addons
(which are not required for IndiePants to function.)

### Configuration

Please take a look at `config/initializers/indiepants.rb` for some additional
settings that let you further customize your IndiePants installation.

### Interesting Links

* [Webmention](http://webmention.org)
* [h-entry documentation](http://microformats.org/wiki/h-entry)

### Hacking

* Install [Pow](http://pow.cx)
* `echo 5000 > ~/.pow/pants`
* Create & seed database
* `foreman start`
* http://alice.pants.dev and http://bob.pants.dev
* `bin/rake spec`
