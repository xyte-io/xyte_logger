# frozen_string_literal: true

require_relative 'lib/xyte_logger/version'

Gem::Specification.new do |spec|
  spec.name          = 'xyte_logger'
  spec.version       = XyteLogger::VERSION
  spec.authors       = ['Xyte']
  spec.email         = ['dev@xyte.com']

  spec.summary       = 'Shared logging setup for Xyte Rails services'
  spec.description   = 'Rails Semantic Logger configuration, formatters, and filters shared across Xyte apps.'
  spec.homepage      = 'https://github.com/xyte/xyte_logger'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'config/**/*', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 6.0'
  spec.add_dependency 'rails_semantic_logger'
  spec.add_dependency 'semantic_logger'
  spec.add_dependency 'activemodel'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'get_process_mem'

  spec.metadata['source_code_uri'] = spec.homepage
end
