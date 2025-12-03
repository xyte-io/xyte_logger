# frozen_string_literal: true

RSpec.describe Logs::Formatters::Color do
  let(:formatter) { described_class.new }

  it 'hides tags in development and test' do
    stub_rails_env(name: 'development')

    expect(formatter.tags).to be_nil
  end

  it 'omits process info in development' do
    stub_rails_env(name: 'development')

    expect(formatter.process_info).to be_nil
  end

  it 'adds new line prefix to messages in test env' do
    stub_rails_env(name: 'test')
    formatter.log = double(message: 'hi')

    expect(formatter.message).to eq("\n -- hi")
  end
end
