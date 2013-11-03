module RedQueen
	class Client
		def initialize prefix, client
			@prefix = prefix
			@client = client
		end

		def get key
			unpack @client.get prefix(key)
		end

		def set key, value
			@client.set prefix(key), value.to_msgpack
		end

		def select index
			@client.select index
		end

		def prefix key
			[@prefix, key].join(':')
		end

		def unpack item
			MessagePack.unpack item
		end
	end
end