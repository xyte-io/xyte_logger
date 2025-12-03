# frozen_string_literal: true

RSpec.describe Logs::Filters::Rails do
  before do
    described_class.instance_variable_set(:@log_filter_enabled, nil)
    described_class.filter = described_class.default_filter
  end

  after do
    described_class.instance_variable_set(:@log_filter_enabled, nil)
    described_class.filter = described_class.default_filter
    $log_filtering = nil if defined?($log_filtering)
    ENV.delete('LOG_FILTER')
  end

  describe '.log_filter_enabled?' do
    it 'is true by default' do
      expect(described_class.log_filter_enabled?).to be(true)
    end

    it 'can be toggled via ENV' do
      ENV['LOG_FILTER'] = 'false'

      expect(described_class.log_filter_enabled?).to be(false)
    end

    it 'prefers the global flag when present' do
      ENV['LOG_FILTER'] = 'false'
      $log_filtering = true

      expect(described_class.log_filter_enabled?).to be(true)
    end
  end

  describe '.filter' do
    it 'defaults to a pass-through filter' do
      expect(described_class.filter.call(double)).to be(true)
    end

    it 'allows overriding the filter' do
      described_class.filter = ->(_log) { false }

      expect(described_class.call(double)).to be(false)
    end
  end
end
