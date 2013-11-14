require 'spec_helper'

describe RedQueen::Client do

	it 'should get' do
		@redis.set 'TestApp:testenv:key1', 'abc'.to_msgpack
		@redis.set 'TestApp:testenv:mod1:key1', 'def'.to_msgpack
		@redis.set 'TestApp:testenv:objkey1', {hello: 'world'}.to_msgpack
		@rq.get('key1').should == 'abc'
		@rq.get(['mod1','key1']).should == 'def'
		@rq.get('objkey1').should == {"hello" => "world"}
		@rq.get('non_existent_key').should be_nil
	end

	it 'should set' do
		@rq.set 'key1', "abc"
		MessagePack.unpack(@redis.get('TestApp:testenv:key1')).should == "abc"
		@rq.set ['mod1','key1'], "def"
		MessagePack.unpack(@redis.get('TestApp:testenv:mod1:key1')).should == "def"
		@rq.set ['key2'], {hello: 'world2'}
		MessagePack.unpack(@redis.get('TestApp:testenv:key2')).should == {"hello" => "world2"}
	end

	it 'should mget' do
		@rq.set 'key1', "abc"
		@rq.set ['mod1','key1'], "def"
		@rq.set ['key2'], {hello: 'world2'}
		@rq.mget(['key1', ['mod1','key1']]).should == ["abc", "def"]
		@rq.mget(['key1', 'key2']).should == ["abc", {"hello" => "world2"}]
		@rq.mget(['key1', ['key2']]).should == ["abc", {"hello" => "world2"}]
		@rq.mget(['key1', 'non_existent_key', ['key2']]).should == ["abc", nil, {"hello" => "world2"}]
		@rq.mget([nil, 'non_existent_key', ['key2']]).should == [nil, nil, {"hello" => "world2"}]
		@rq.mget([nil]).should == [nil]
		@rq.mget([]).should == []
		@rq.mget(nil).should == []
	end

	it 'should mset' do
		@rq.mset hello: 'world', inty: 'minty'
		@rq.mget(['hello', 'inty']).should == ['world', 'minty']
		@rq.mset({['m1', 'k1'] => 'a1', "k2" => 'a2', 24 => 42})
		@rq.mget([['m1', 'k1'], 'k2', '24']).should == ['a1', 'a2', 42]
	end
end