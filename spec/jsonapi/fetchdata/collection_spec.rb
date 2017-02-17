require 'spec_helper'
require 'rack/mock'

describe JSONAPI::FetchData::Collection do

  let(:klass) { Class.new(Object) }
  let(:scope) { double('scope', klass: klass) }
  let(:service_object) { JSONAPI::FetchData::Collection.new(scope) }
  let(:params) {
    {
      'include' => 'address',
      'fields' => {'users' => 'name,age'},
      'filter' => { 'name'=>"Marco, Michel "},
      'sort' => 'age,-name',
      'page' => { 'number' => 2, 'size' => 20}
    }
  }

  before do
    allow(klass).to receive(:table_name).and_return 'addresses'
    allow(String).to receive(:tablelize).and_return klass.table_name
  end

  it 'builds query scope using AR methods' do
    expect(scope).to receive(:includes).with(['address']).and_return scope
    expect(scope).to receive(:references).with([klass.table_name]).and_return scope
    expect(scope).to receive(:select).with(['users.name', 'users.age']).and_return scope
    expect(scope).to receive(:where).with('name' => ['Marco', 'Michel']).and_return scope
    expect(scope).to receive(:order).with(['age', { 'name' => 'desc' }]).and_return scope
    expect(scope).to receive(:offset).with(40).and_return scope
    expect(scope).to receive(:limit).with(20).and_return scope

    service_object.find(params)
  end

end
