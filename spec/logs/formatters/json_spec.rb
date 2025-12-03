# frozen_string_literal: true

require 'json'

RSpec.describe Logs::Formatters::Json do
  let(:formatter) { described_class.new }
  let(:logger) { instance_double(Logger) }

  before do
    allow(formatter).to receive(:file_name_and_line)
    allow(formatter).to receive(:metric)
    stub_rails_env(name: 'production')
  end

  def build_log(message: 'hello world', cleansed_message: nil, named_tags: nil, payload: {}, exception: nil, name: 'app', duration: 1.234, level: :info)
    double(
      'SemanticLogger::Log',
      level: level,
      duration: duration,
      name: name,
      named_tags: named_tags,
      message: message,
      cleansed_message: cleansed_message || message,
      exception: exception,
      payload: payload,
      metric: nil
    )
  end

  def parsed_output(log)
    JSON.parse(formatter.call(log, logger))
  end

  it 'serializes messages with whitelisted named tags' do
    log = build_log(
      message: 'payload text',
      named_tags: { request_id: 'req-1', ip: '1.1.1.1', extra: 'ignore-me' },
      payload: { params: { hello: 'world' } }
    )

    data = parsed_output(log)

    expect(data['text']).to eq('payload text')
    expect(data['request_id']).to eq('req-1')
    expect(data['ip']).to eq('1.1.1.1')
    expect(data).not_to have_key('extra')
  end

  it 'uses job class as the log name when available' do
    log = build_log(
      name: 'Rails',
      message: 'job run',
      named_tags: { job_class: 'CleanupJob' }
    )

    expect(parsed_output(log)['name']).to eq('CleanupJob')
  end

  it 'falls back to exception text when message is missing' do
    error = RuntimeError.new('boom')
    allow(error).to receive(:backtrace).and_return([])
    log = build_log(message: nil, exception: error, named_tags: {})

    data = parsed_output(log)

    expect(data['text']).to eq('[RuntimeError] boom')
    expect(data['exception']).to eq('name' => 'RuntimeError', 'text' => 'boom')
  end

  it 'truncates long payload params' do
    long_params = 'a' * 1010
    log = build_log(payload: { params: long_params })

    data = parsed_output(log)

    expect(data['payload']['params']).to include('[truncated]')
    expect(data['payload']['params']).not_to eq(long_params)
  end

  it 'adds memory usage when enabled' do
    begin
      original_env = ENV['LOG_MEMORY_USAGE']
      ENV['LOG_MEMORY_USAGE'] = 'true'
      stub_const('GetProcessMem', Class.new)
      mem_tracker = instance_double(GetProcessMem, mb: 20.5)
      allow(GetProcessMem).to receive(:new).and_return(mem_tracker)

      log = build_log(named_tags: { start_mem: 10.0 })
      data = parsed_output(log)

      expect(data['memory']).to include('start' => 10.0, 'end' => 20.5, 'inc' => 10.5)
    ensure
      ENV['LOG_MEMORY_USAGE'] = original_env
    end
  end
end
