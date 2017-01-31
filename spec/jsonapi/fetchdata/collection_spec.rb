require 'spec_helper'
require 'rack/mock'

describe JSONAPI::FetchData::Collection do

  let(:scope) { double('scope') }
  let(:collection) { JSONAPI::FetchData::Collection.new(scope) }
  let(:params) {
    {
      'include' => 'address',
      'fields' => {'users' => 'name,age'},
      'filter' => { 'name'=>"Marco, Michel "},
      'sort' => 'age,-name',
      'page' => { 'number' => 2, 'size' => 20}
    }
  }

  it 'builds query scope using AR methods' do
    expect(scope).to receive_message_chain(:includes, :join)
    expect(scope).to receive(:select).with(params['fields'])
    expect(scope).to receive(:where).with(params['filter'])
    expect(scope).to receive(:order).with(params['sort'])
    expect(scope).to receive_message_chain(:page,:per)

    collection.find(params)
  end

end
