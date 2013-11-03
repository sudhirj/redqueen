require 'spec_helper'

describe RedQueen::Queen do
	it 'should create as many clients as passed in' do
		queen = RedQueen::Queen.new ['localhost:6379','localhost:6379','localhost:6379']
		queen.clients.size.should == 3
		queen.clients.should include queen.client
	end
end

