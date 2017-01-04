require 'spec_helper'

describe JSONAPI::FetchData::Parameters::Parsers::Filter do

  let(:query_string) do
    'filter[comment]=1,2,3&filter[author]=12'
  end

  let(:rack_params) { Rack::Utils.parse_nested_query(query_string) }
  let(:json_params) { described_class.parse rack_params['filter'] }


  context 'rack behaviour' do

    let(:expectation) do
      {
        'filter' => {
          'comment' => '1,2,3',
          'author' => '12'
        }
      }
    end

    it 'parses string into a nested hash' do
      expect(rack_params).to include(expectation)
    end

  end


  context 'json behaviour' do

    let(:expectation) do
      {
        'comment' => ['1', '2', '3'],
        'author' => '12'
      }
    end

    it 'collects delimited fields into an array' do
      expect(json_params).to eq expectation
      expect(json_params['comment']).to be_a Array
    end

  end
end
