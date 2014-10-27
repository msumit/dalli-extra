require 'rubygems'
require 'net/telnet'

module Dalli
  class Client
  
  	# Return keys in Array
    def keys(reg_exp = nil)
    	keys = []
    	regex = (reg_exp.nil?) ? nil : (reg_exp.is_a?(Regexp)) ? reg_exp : Regexp.new(reg_exp)
    	@servers.each do |server|
    		connection = telnet(server)
    		begin 
	    		matches = connection.cmd("String" => "stats items").scan(/STAT items:(\d+):number (\d+)/)

					slabs = matches.inject([]) { |items, item| items << Hash[*['id','items'].zip(item).flatten]; items }

					slabs.each do |slab|
						# Below written code is not kept DRY to avoid if-else compariosions on each key
						if reg_exp.nil?
		  				connection.cmd("String" => "stats cachedump #{slab['id']} #{slab['items']}").split("\n").each do |line|
	              if /ITEM (.+) \[\d+ b; \d+ s\]/ =~ line
	                keys << $1
	              end		            
	            end
	          elsif reg_exp.is_a?(Regexp)
	          	connection.cmd("String" => "stats cachedump #{slab['id']} #{slab['items']}").split("\n").each do |line|
	              if /ITEM (.+) \[\d+ b; \d+ s\]/ =~ line
	              	cache_key = $1
	                keys << cache_key if regex.match(cache_key)
	              end
	            end
	          else # return keys which have the given string as a substring
	          	connection.cmd("String" => "stats cachedump #{slab['id']} #{slab['items']}").split("\n").each do |line|
	              if /ITEM (.+) \[\d+ b; \d+ s\]/ =~ line
	                keys << $1 if $1[reg_exp]
	              end
	            end
	      		end
	      	end	      	
	      rescue Exception => e
          Dalli.logger.error("Failed to get keys because #{e.to_s}")
        ensure
          connection.close() unless connection.nil?
        end
    	end
    	keys
    end

    # Returns the key-value pairs as Array of Arrays
    def pairs(reg_exp =  nil)
    	_keys = keys(reg_exp)
    	_keys.zip(_keys.map{|k| get(k)})
    end

    # Returns a Int, representing number of deleted keys
    def delete_matched(reg_exp)
    	_keys = keys(reg_exp)
    	_keys.map{|k| delete(k)}.reject{|y| !y}.count
    end

    # Returns a Hash representing sum of stats of each server in ring. 
    def cluster_stats(type=nil)
      hash = {'cluster_size' => @servers.length, 'active_servers' => 0}
      ignore = ['accepting_conns', 'pointer_size', 'version', 'pid', 'time']
      stats(type).each do |key,val|
        unless val.nil?
          hash['active_servers'] += 1
          val.each do |k,v|
            next if ignore.include?(k)
            if hash.has_key?(k) 
              hash[k] += v.match('\.').nil? ? Integer(v) : Float(v) rescue v
            else
              hash[k] = v.match('\.').nil? ? Integer(v) : Float(v) rescue v
            end
          end
        end
      end
      hash
    end

    private 

    def telnet(server)
      (host, port) = server.split(':')
      telnet = nil
      Dalli.logger.info("target memcahced server: #{host}:#{port}")
      begin
        telnet = Net::Telnet::new(
          'Host' => host,
          'Port' => port,
          'Prompt' => /(^END$)/,
          'Timeout' => 3
        )
      rescue Errno::ECONNREFUSED
    		Dalli.logger.error("Error: " + $!)
	  	end
	  	telnet
    end
  end
end
