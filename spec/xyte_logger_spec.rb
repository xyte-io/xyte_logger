# frozen_string_literal: true

RSpec.describe XyteLogger do
  describe 'inclusion helper' do
    it 'mixes SemanticLogger::Loggable when included' do
      klass = Class.new do
        include XyteLogger
      end

      expect(klass.ancestors).to include(SemanticLogger::Loggable)
    end
  end

  describe XyteLogger::Loggable do
    it 'is a wrapper for SemanticLogger::Loggable' do
      klass = Class.new do
        include XyteLogger::Loggable
      end

      expect(klass.ancestors).to include(SemanticLogger::Loggable)
    end
  end
end
