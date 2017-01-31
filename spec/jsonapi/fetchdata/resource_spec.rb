require 'spec_helper'
require 'rack/mock'

describe JSONAPI::FetchData::Resource do

  let(:klass) { Class.new }
  let(:scope) { double('scope') }
  let(:resource) { klass.new }
  let(:collection) { JSONAPI::FetchData::Resource.new(scope) }
  let(:params) {
    {
      'include' => 'address',
      'fields' => {'users' => 'name,age'},
      'filter' => { 'name'=>"Marco, Michel"},
      'sort' => 'age,-name',
      'page' => { 'number' => 2, 'size' => 20}
    }
  }

  before do
    allow(scope).to receive(:find).and_return resource
  end

  it 'builds query scope using AR methods' do
    expect(scope).to receive_message_chain(:includes, :join)
    expect(scope).to receive(:select)
    expect(scope).to_not receive(:where)
    expect(scope).to_not receive(:order)
    expect(scope).to_not receive(:page)

    collection.find(params)
  end

end
