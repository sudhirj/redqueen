require 'redqueen/version'
require 'redqueen/client'

require 'active_support/all'


module RedQueen
  class Queen
  	attr_reader :clients
  	delegate :get, :set, to: :client

  	def initialize servers
			@clients = [servers].reject{|s| s.blank?}.flatten.map do |server|
				parts = server.split(':')
				client = Redis.new host: (parts[0] || 'localhost'), port: (parts[1].to_i || 6379 rescue 6379)
				RedQueen::Client.new prefix, client
			end
  	end

  	def select index
  		@clients.map{|c| c.select index}
  	end

  	def client
  		@clients.sample
  	end

  	def prefix
  		[app_name, app_env]
  	end

  	def app_name
  		::Rails.application.class.name.split('::')[0]
  	end

  	def app_env
  		::Rails.env
  	end
  end
end
