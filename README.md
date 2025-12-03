# Xyte Logger

Shared logging setup for Xyte Rails services using Rails Semantic Logger.

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

