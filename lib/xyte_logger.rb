# frozen_string_literal: true

require 'semantic_logger'
require 'rails_semantic_logger'
require_relative 'xyte_logger/version'
require_relative 'xyte_logger/railtie' if defined?(Rails)

module XyteLogger
  # Includeable wrapper so apps can `include XyteLogger` instead of `SemanticLogger::Loggable`.
  def self.included(base)
    base.include SemanticLogger::Loggable
  end

  module Loggable
    def self.included(base)
      base.include SemanticLogger::Loggable
    end
  end
end
