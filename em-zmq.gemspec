$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'eventmachine/zmq/version'

Gem::Specification.new do |s|
  s.name        = 'em-zmq'
  s.version     = EventMachine::ZMQ::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Chris Lloyd'
  s.email       = 'christopher.lloyd@gmail.com'
  s.homepage    = 'https://github.com/chrislloyd/em-zmq'

  s.summary     = 'ZMQ bindings for EventMachine.'
  s.description = s.summary

  s.add_dependency 'eventmachine', '>= 1.0.0.beta.3'
  s.add_dependency 'ffi', '>= 1.0.8'
  s.add_dependency 'ffi-rzmq', '>= 0.7.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
