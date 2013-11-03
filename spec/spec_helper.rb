require 'msgpack'
require 'redqueen'
require 'redis'

RSpec.configure do |c|
	c.before(:each) do
		Rails ||= double
		app = double
		cls = double
		app.stub(:class).and_return cls
		cls.stub(:name).and_return "TestApp::Application"
		Rails.stub(:env).and_return 'testenv'
		Rails.stub(:application).and_return(app)
		@redis = Redis.new
		@rq = RedQueen::Queen.new 'localhost:6379'
		@redis.select 8
		@redis.flushdb
		@rq.select 8
	end
end