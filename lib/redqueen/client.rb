module RedQueen
	class Client
		def initialize prefix, client
			@prefix = prefix
			@client = client
		end

		def get key
			unpack @client.get prefix(key)
		end

		def mget keys
			return [] if keys.nil? or keys.empty?
			@client.mget(keys.map{|k| prefix(k)}).map{|v| unpack(v)}
		end

		def set key, value
			@client.set prefix(key), value.to_msgpack
		end

		def mset hash
			@client.mset hash.flat_map{|k, v| [prefix(k), v.to_msgpack]}
		end

		def select index
			@client.select index
		end

		def prefix key
			[@prefix, key].join(':')
		end

		def unpack item
			return nil if item.nil?
			MessagePack.unpack item
		end
	end
end