require 'spec_helper'

describe JSONAPI::FetchData::Parameters::Parsers::Sort do

  let(:query_string) do
    'sort[]=name,-created_at&sort[]=price'
  end

  let(:rack_params) { Rack::Utils.parse_nested_query(query_string) }
  let(:json_params) { described_class.parse rack_params['sort'] }


  context 'rack behaviour' do

    let(:expectation) do
      { 'sort' => ['name,-created_at','price'] }
    end

    it 'parses string into a nested hash' do
      expect(rack_params).to include(expectation)
    end

  end


  context 'json behaviour' do

    let(:expectation) do
      [:name, { created_at: :desc }, :price]
    end

    it 'must support comma delimiter for field names' do
      expect(json_params).to eq expectation
      expect(json_params.count).to eq 3
    end

    it 'mark negated fields with starting dash as descending' do
      expect(json_params).to include(created_at: :desc)
    end

    it 'symbolizes keys' do
      expect(json_params).to include(:name, :price)
    end


  end
end
