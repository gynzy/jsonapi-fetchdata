require 'spec_helper'
require 'rack/mock'

describe JSONAPI::FetchData::Resource do

  let(:klass) { Class.new(Object) }
  let(:scope) { double('Relation', klass: klass) }
  let(:resource) { instance_double(klass) }
  let(:service_object) { JSONAPI::FetchData::Resource.new(scope) }
  let(:params) {
    {
      'id' => '5',
      'include' => 'address',
      'fields' => {'users' => 'name,age'},
      'filter' => { 'name'=>"Marco, Michel"},
      'sort' => 'age,-name',
      'page' => { 'number' => '2', 'size' => '20'}
    }
  }

  before do
    allow(klass).to receive(:table_name).and_return 'addresses'
    allow(String).to receive(:tablelize).and_return klass.table_name
    allow(scope).to receive(:find).and_return resource
  end

  it 'builds query scope using AR methods' do
    expect(scope).to receive(:includes).with(['address']).and_return scope
    expect(scope).to receive(:references).with([klass.table_name]).and_return scope
    expect(scope).to receive(:select).with(['users.name', 'users.age']).and_return scope
    expect(scope).to_not receive(:where)
    expect(scope).to_not receive(:order)
    expect(scope).to_not receive(:page)

    expect(scope).to receive(:find).with('5')

    service_object.find(params)
  end

end
