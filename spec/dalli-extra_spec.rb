require 'rspec'
require 'dalli'
require 'dalli/extra'

describe 'dalli-extra' do 

  subject(:dc) { Dalli::Client.new('localhost:11211', :expires_in => 300) }

  before(:all) do 
    dc.set('dalli-extra-abc', 123)
    dc.set('dalli-extra-abcd', 1234)
    dc.set('dalli-extra-xyz', 123)
  end

  it {should respond_to(:keys)}
  it {should respond_to(:pairs)}
  it {should respond_to(:delete_matched)}
  it {should respond_to(:cluster_stats)}

  it 'should get all keys' do
    keys = dc.keys
    keys.should_not be(nil)
    keys.size.should >= 3
  end

  it 'should get all key-value pairs' do
    pairs = dc.pairs
    pairs.should_not be(nil)
    pairs.size.should >= 3
  end

  it 'should get keys which matches the regexp' do
    keys = dc.keys(/dalli-extra-abc/)
    keys.should_not be(nil)
    keys.size.should be 2
  end

  it 'should get kay-value pairs which matches the regexp' do
    pairs = dc.pairs(/dalli-extra-abc/)
    pairs.should_not be(nil)
    pairs.size.should be 2
  end

  it 'should delete matched keys' do
    dc.delete_matched(/dalli-extra/).should be 3
  end

  it 'should return a hash with cluster stats' do 
    stats = dc.cluster_stats
    stats.should_not be(nil)
    stats.should be_a(Hash)
  end
end
