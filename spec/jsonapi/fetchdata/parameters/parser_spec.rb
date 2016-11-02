require 'spec_helper'

describe JSONAPI::FetchData::Parameters::Parser do

  it 'must be implemented' do
    expect(described_class).to receive(:new).and_call_original
    expect{described_class.parse}.to raise_error(NotImplementedError)
  end

end
