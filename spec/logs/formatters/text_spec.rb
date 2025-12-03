# frozen_string_literal: true

RSpec.describe Logs::Formatters::Text do
  let(:formatter) { described_class.new }

  it 'returns nil when no exception is attached' do
    formatter.log = double(message: 'hello', exception: nil)

    expect(formatter.exception).to be_nil
  end

  it 'formats exception with cleaned backtrace' do
    stub_rails_env(
      name: 'test',
      backtrace_cleaner: double(clean: ['cleaned:1'])
    )

    error = RuntimeError.new('bad stuff')
    allow(error).to receive(:backtrace).and_return(['dirty:1', 'dirty:2'])
    formatter.log = double(message: nil, exception: error)

    output = formatter.exception

    expect(output).to include('RuntimeError: bad stuff')
    expect(output).to include('cleaned:1')
  end

  it 'formats message with leading separator' do
    formatter.log = double(message: 'hello world')

    expect(formatter.message.strip).to eq('-- hello world')
  end
end
