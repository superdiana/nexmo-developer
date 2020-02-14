require 'rails_helper'

RSpec.describe UseCaseListFilter do
  let(:mock_tutorial) do
    UseCase.new(
      title: 'Test Tutorial',
      products: 'messaging/sms',
      description: 'This is a demo tutorial',
      document_path: Pathname.new("#{Rails.configuration.docs_base_path}/_use_cases/path/to/test-tutorial.md"),
      external_link: '/path/to/test-tutorial',
      languages: 'en'
    )
  end

  it 'returns an instance of Tutorial with matching input' do
    allow(UseCase).to receive(:all).and_return([mock_tutorial])

    input = <<~HEREDOC
      ```use_cases
      product: messaging/sms
      ```
    HEREDOC

    output = described_class.call(input)

    expected_output = "FREEZESTARTPHVsIGNsYXNzPSJWbHQtbGlzdCBWbHQtbGlzdC0tc2ltcGxlIj4KICAKICAgIDxsaT48YSBocmVmPSIvdXNlLWNhc2VzL3BhdGgvdG8vdGVzdC10dXRvcmlhbCI-VGVzdCBUdXRvcmlhbDwvYT48L2xpPgogIAo8L3VsPgo=FREEZEEND\n"

    expect(output).to eq(expected_output)
  end

  it 'raises error if layout specified but cannot be found' do
    input = <<~HEREDOC
      ```use_cases
      product: messaging/sms
      layout: list/json
      ```
    HEREDOC

    expect { described_class.call(input) }.to raise_error(Errno::ENOENT)
  end

  it 'raises a NoMethodError if no content is provided' do
    input = <<~HEREDOC
      ```use_cases
      ```
    HEREDOC

    expect { described_class.call(input) }.to raise_error(NoMethodError)
  end

  it 'returns encoded string even if product cannot be found' do
    allow(UseCase).to receive(:all).and_return([mock_tutorial])

    input = <<~HEREDOC
      ```use_cases
      product: not real
      ```
    HEREDOC

    expected_output = "FREEZESTARTPHVsIGNsYXNzPSJWbHQtbGlzdCBWbHQtbGlzdC0tc2ltcGxlIj4KICAKPC91bD4KFREEZEEND\n"

    expect(described_class.call(input)).to eql(expected_output)
  end
end
