# Xyte Logger

Shared logging setup for Xyte Rails services using Rails Semantic Logger.

Requires Ruby 3.1.3.

## Usage

Add to your Gemfile:

```ruby
gem 'xyte_logger', path: '../xyte_logger'
```

The Railtie will install the logger initializer automatically. To override filters:

```ruby
Logs::Filters::Rails.filter = ->(log) { true }
Logs::Filters::Sidekiq.filter = ->(log) { log.level != :debug }
```

## Development

Run tests with:

```bash
bundle exec rspec
```

To install dependencies and enable the hooks that auto-run Rubocop and RSpec:

```bash
bin/setup
```
