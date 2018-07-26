require 'spec_helper'
require 'rack/mock'

describe JSONAPI::FetchData::Middleware do

  let(:app) { -> (env) { [200, env, 'ok'] } }
  let(:middleware) { described_class.new app, :filter, :fields }

  let(:pagination_query) { 'page[number]=3&page[size]=50' }
  let(:fieldset_query) { 'fields[comments]=name,text,created_at' }
  let(:filter_query) { 'filter[post]=1,2&filter[author]=12' }
  let(:query_string) { [pagination_query, fieldset_query, filter_query].join('&') }

  let(:request) { Rack::MockRequest.env_for('https://example.org/api/v3/list', params: query_string) }

  it 'should parse query string value only for those passed in options' do
    expect_any_instance_of(JSONAPI::FetchData::Parameters::Parsers::FieldSet).to receive(:parse)
    expect_any_instance_of(JSONAPI::FetchData::Parameters::Parsers::Paginate).to_not receive(:parse)
    expect_any_instance_of(JSONAPI::FetchData::Parameters::Parsers::Filter).to receive(:parse)

    middleware.call request
  end

end
