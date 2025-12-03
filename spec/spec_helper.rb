# frozen_string_literal: true

require 'bundler/setup'
require 'logger'
require 'rspec'
require 'rails'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/slice'

require 'xyte_logger'
require 'logs/formatters/json'
require 'logs/formatters/text'
require 'logs/formatters/color'
require 'logs/filters/rails'
require 'logs/filters/sidekiq'

module RailsEnvHelper
  def stub_rails_env(name: 'test', backtrace_cleaner: nil)
    env = ActiveSupport::StringInquirer.new(name)
    allow(Rails).to receive(:env).and_return(env)
    allow(Rails).to receive(:backtrace_cleaner).and_return(backtrace_cleaner || double(clean: []))
  end
end

RSpec.configure do |config|
  config.include RailsEnvHelper

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random
end
