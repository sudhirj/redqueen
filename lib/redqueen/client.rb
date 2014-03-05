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

		def zadd key, *args
			@client.zadd prefix(key), args.flatten.map{|item| [item[:score], item[:member].to_msgpack]}
		end

		def zrange key, start, finish
			@client.zrange(prefix(key), start, finish).map{|i| unpack(i)}
		end

		def zrevrange key, start, finish
			@client.zrevrange(prefix(key), start, finish).map{|i| unpack(i)}
		end

		def zinterstore key, sources
			@client.zinterstore prefix(key), sources.map{|s| prefix(s)}
		end

		def select index
			@client.select index
		end

		def pipelined
			@client.pipelined do
				yield self
			end
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