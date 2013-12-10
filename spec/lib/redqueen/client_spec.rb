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

	it 'should zadd' do
		@rq.zadd 'myzset', {score: 2, member: 'two'}
		@rq.zadd 'myzset', {score: 1, member: 'one'}, {score: 5, member: 'five'}
		@rq.zadd 'myzset', [{score: 3, member: 'three'}, {score: 4, member: 'four'}]
		@redis.zrange('TestApp:testenv:myzset', 0, 4).map{|i| MessagePack.unpack(i)}.should == ['one', 'two', 'three', 'four', 'five']
	end

	it 'should zrange' do
		@rq.zadd 'myzset', {score: 2, member: 'two'}
		@rq.zadd 'myzset', {score: 1, member: 'one'}, {score: 3, member: 'three'}
		@rq.zrange('myzset', 0, 100).should == ['one', 'two', 'three']
	end

	it 'should zrevrange' do
		@rq.zadd 'myzset', {score: 2, member: 'two'}
		@rq.zadd 'myzset', {score: 1, member: 'one'}, {score: 3, member: 'three'}
		@rq.zrevrange('myzset', 0, 2).should == ['three', 'two', 'one']

		@rq.zrevrange('nonexistentkey', 0, -1).should == []
	end

	it 'should zinterstore' do
		@rq.zadd ['myset', 1], {score: 2, member: 'two'}, {score: 10, member: 'one'}
		@rq.zadd ['myset', 2], {score: 1, member: 'one'}, {score: 3, member: 'three'}
		@rq.zinterstore 'myset', [['myset', 1], ['myset', 2]]
		@rq.zrange('myset', 0, -1).should == ['one']
	end

end