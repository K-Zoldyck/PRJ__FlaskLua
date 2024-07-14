


local socket = require 'socket'
local lcjson = require 'cjson'


local __Reqt = function() return {
	head = {},
	args = {},
	json = {},
	data = "",

	__set_data = function(self,head, data, args)
		if #head > 0 then self.head = head else self.head = nil end
		if #data > 0 then self.data = data else self.data = nil end  
		if #args > 0 then self.args = args else self.args = nil end  
		
		if type(data) == 'table' and type(self.head) == 'table' then
			if self.head['content-type'] == 'application/json' then
				self.json = lcjson.decode(data) else self.json = nil 
			end
		end  
	end
} end

local __Resp = function() return {
	head = {},
	data = "",
	code = 200,
		
	__raw = function(self)
		local _package = "HTTP/1.1 "..self.code.." OK\n"
		self.head['Server'] = 'LunarFlask/1.1 (unix)'
		self.head['Access-Control-Allow-Origin'] = '*'
		self.head['Content-Type'] = 'text/plain; charset=utf-8'
		self.head['Content-Length'] = #self.data
		
		for key,value in pairs(self.head) do 
			_package = _package..key..":"..value.."\n" 
		end

		_package = _package..'\n'..self.data
		return _package
	end
} end


local __request_line_parse__ = function(__buffer__)
	if __buffer__ ~= nil then
		local mth,url,vrs = string.match(__buffer__,'(%a+)%s(%S+)%s(%S+)')
		local ask_char = string.find(url,'?')

		local resp = {
			method = mth,
			versin = vrs,
			router = nil,
			params = {},
		}
		
		if ask_char == nil then 
			resp.router = url
		else 
			resp.router = string.sub(url,0,string.find(url,'?')-1)
			local tmp = string.sub(url,string.find(url,'?')+1,_)
			
			for k, v in string.gmatch(tmp,'(%w+)=(%w+)') do
				resp.params[k] = v
			end
		end
		return resp
	end
	return nil
end 


local flask_lua = function() return {
	addr = "127.0.0.1",
	port = 3000,
	getc = {},
	posc = {},

	run = function (self,addr, port)
		self.addr = addr
		self.port = port
		self._run(self)
	end,

	get  = function(self,endpoint, callback ) self.getc[endpoint] = callback end,
	post = function(self,endpoint, callback ) self.posc[endpoint] = callback end,

	_run = function(self)
		local connection = socket.tcp()
		connection:bind(self.addr,self.port)
		connection:listen()

		while true do
			local buffer = connection:accept()
			local request_line = __request_line_parse__(buffer:receive("*l"))
			
			if string.lower(request_line.method ) == 'post' then
				if self.posc[request_line.router] ~= nil then
					local head = {}
					local requ = __Reqt()
					local resp = __Resp()
				
					while true do
						local read_line = buffer:receive("*l")
						if #read_line == 0 then break end
							
						local k,v = string.match(read_line,'(%S+)%s*:%s*(%S+)')
						if k ~= nil and v ~= nil then
							head[string.lower(k)] = v
						end
					end

					local content_size = head['content-length']
						
					if content_size ~= nil and #content_size > 0 then
						local data = buffer:receive(content_size)
						requ:__set_data(head,data,request_line.params)
						print(request_line.router)
						buffer:send(self.posc[request_line.router](requ,resp):__raw())
					end
				end
				-- return 404 or 303 here
			end

			if string.lower(request_line.method ) == 'get' then
				if self.getc[request_line.router] ~= nil then 
					local head = {}
					local requ = __Reqt()
					local resp = __Resp()
				
					while true do
						local read_line = buffer:receive("*l")
						if #read_line == 0 then break end
							
						local k,v = string.match(read_line,'(%S+)%s*:%s*(%S+)')
						if k ~= nil and v ~= nil then
							head[string.lower(k)] = v
						end
					end
					requ:__set_data(head,"",request_line.params)
					print(request_line.router)
					buffer:send(self.getc[request_line.router](requ,resp):__raw())
				end
				-- return 404 or 303 here
			end
			buffer:close()
		end
		connection:close()
	end
} end

return flask_lua
