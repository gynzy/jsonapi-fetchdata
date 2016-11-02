require 'spec_helper'

describe JSONAPI::FetchData::Parameters::Parsers::Paginate do

  let(:query_string) do
    'page[number]=3&page[size]=50&page[mud]=five'
  end

  let(:rack_params) { Rack::Utils.parse_nested_query(query_string) }
  let(:json_params) { described_class.parse rack_params['page'] }


  context 'rack behaviour' do

    let(:expectation) do
      { 'page' => {
          'number' => '3',
          'size' => '50',
          'mud' => 'five'
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
        number: 3,
        size: 50
      }
    end

    it 'ignores undefined page keys' do
      expect(json_params.keys).to_not include('mud')
    end

    it 'symbolizes keys' do
      expect(json_params.keys).to all be_a(Symbol)
    end

    it 'converts string params to numbers' do
        expect(json_params.values.flatten).to all be_a(Integer)
    end

  end
end
