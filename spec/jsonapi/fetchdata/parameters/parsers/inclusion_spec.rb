require 'spec_helper'

describe JSONAPI::FetchData::Parameters::Parsers::Inclusion do

  let(:query_string) do
    'include=author,comments.author,comments.links.protocol'
  end

  let(:rack_params) { Rack::Utils.parse_nested_query(query_string) }
  let(:json_params) { described_class.parse rack_params['include'] }

  context 'rack behaviour' do

    let(:expectation) do
      { 'include' => 'author,comments.author,comments.links.protocol' }
    end

    it 'parses string into a nested hash' do
      expect(rack_params).to include(expectation)
    end

  end

  context 'json behaviour' do

    let(:expectation) do
      [ 'author', 'comments' => [ 'author', { 'links' => 'protocol' } ]]
    end

    it 'must support dot notation for relationship paths' do
      expect(json_params).to eq expectation
      expect(json_params).to include('author', 'comments' => ['author', { 'links' => 'protocol' }])
    end

    it 'collects delimited fields into an array' do
      expect(json_params).to be_a Array
      expect(json_params.size).to eq 2
    end

  end

end
