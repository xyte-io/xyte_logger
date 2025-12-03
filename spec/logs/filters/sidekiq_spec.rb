# frozen_string_literal: true

RSpec.describe Logs::Filters::Sidekiq do
  after do
    described_class.filter = described_class.default_filter
  end

  it 'passes through logs by default' do
    expect(described_class.call(double)).to be(true)
  end

  it 'applies a custom filter when provided' do
    described_class.filter = ->(_log) { false }

    expect(described_class.call(double)).to be(false)
  end
end
