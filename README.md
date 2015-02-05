# IndiePants [![Build Status](https://travis-ci.org/hmans/indiepants.svg?branch=master)](https://travis-ci.org/hmans/indiepants)

Pants Phase 2: A clean IndieWeb implementation of Pants.


### Status

* Currently trying to reach feature parity with the previous implementation. ([Roadmap](https://github.com/hmans/indiepants/issues?q=milestone%3AOne))
* Please don't use this code yet; I'm still messing with the basics.
* Please don't send unsolicited pull requests. If you want to submit a change, talk to me first.

### Mission Notes

* Open-Source from day 1.
* Use simple and open protocols.
* Be a good [IndieWeb](http://indiewebify.me/) citizen.

### Dependencies

* Ruby 2.2.0
* PostgreSQL 9.4

### Deploy on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

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
