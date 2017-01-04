require 'spec_helper'

describe JSONAPI::FetchData::Parameters::Parsers::FieldSet do

  let(:query_string) do
    'fields[comments]=name,text,created_at&fields[comments]=updated_at&fields[products]=name,description,price,update_at'
  end

  let(:rack_params) { Rack::Utils.parse_nested_query(query_string) }
  let(:json_params) { described_class.parse rack_params['fields'] }

  context 'rack behaviour' do

    let(:expectation) do
      { 'fields' => {
          'comments' => 'updated_at',
          'products' => 'name,description,price,update_at'
        }
      }
    end

    it 'parses string into a nested hash' do
      expect(rack_params).to include(expectation)
    end

    it 'will not merge double key definitions in the string' do
     expect(rack_params['fields']['comments']).to_not match(/description/)
    end

  end


  context 'jsonapi added behaviour' do

    let(:expectation) do
      {
        'comments' => 'updated_at',
        'products' => ['name','description','price','update_at']
      }
    end

    it 'must support comma delimiter for field names' do
      expect(json_params).to eq expectation
      expect(json_params['products']).to be_a Array
      expect(json_params['products'].count).to eq 4
    end

  end
end
