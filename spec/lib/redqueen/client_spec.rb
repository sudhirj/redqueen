require 'spec_helper'

describe RedQueen::Client do

	it 'should get' do
		@redis.set 'TestApp:testenv:key1', 'abc'.to_msgpack
		@redis.set 'TestApp:testenv:mod1:key1', 'def'.to_msgpack
		@redis.set 'TestApp:testenv:objkey1', {hello: 'world'}.to_msgpack
		@rq.get('key1').should == 'abc'
		@rq.get(['mod1','key1']).should == 'def'
		@rq.get('objkey1').should == {"hello" => "world"}
	end

	it 'should set' do
		@rq.set 'key1', "abc"
		MessagePack.unpack(@redis.get('TestApp:testenv:key1')).should == "abc"
		@rq.set ['mod1','key1'], "def"
		MessagePack.unpack(@redis.get('TestApp:testenv:mod1:key1')).should == "def"
		@rq.set ['key2'], {hello: 'world2'}
		MessagePack.unpack(@redis.get('TestApp:testenv:key2')).should == {"hello" => "world2"}
	end
end