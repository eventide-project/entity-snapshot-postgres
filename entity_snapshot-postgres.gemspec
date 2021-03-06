# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'evt-entity_snapshot-postgres'
  s.version = '2.1.1.0'
  s.summary = 'Projected entity snapshotting for Postgres'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/entity-snapshot-postgres'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'evt-entity_store'
  s.add_runtime_dependency 'evt-messaging-postgres'

  s.add_development_dependency 'test_bench'
end
