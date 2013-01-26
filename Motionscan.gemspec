# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motionscan/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "motionscan"
  s.version     = Motionscan::VERSION
  s.authors     = ["Joffrey Jaffeux"]
  s.email       = ["j.jaffeux@gmail.com"]
  s.homepage    = "https://github.com/jjaffeux/motionscan"
  s.summary     = "A RubyMotion Moodstocks SDK image recognition wrapper"
  s.description = "A RubyMotion Moodstocks SDK image recognition wrapper"

  s.files         = `git ls-files`.split($\)
  s.require_paths = ["lib"]

  s.add_dependency "motion-cocoapods", ">= 1.2.1"
  s.add_development_dependency 'rake'
end