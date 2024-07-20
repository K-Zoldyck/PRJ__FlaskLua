


local socket = require 'socket'
local lcjson = require 'cjson'
local http_parse = require 'libs/http_parse'()


local flask_lua = function() 
	return {
		addr = "127.0.0.1",
		port = 3000,
		g_callbacks = {}, -- get callbacks 
		p_callbacks = {}, -- post callbacks
		link_server = nil,
	
		init = function (self,addr, port)
			self.addr = addr
			self.port = port
			self.run(self)
		end,

		get  = function(self,endpoint, callback ) self.g_callbacks[endpoint] = callback end,
		post = function(self,endpoint, callback ) self.p_callbacks[endpoint] = callback end,

		run = function(self)
			self.link_server = assert(socket.tcp(),'error on create socket')
			self.link_server:bind(self.addr,self.port)
			self.link_server:setoption("reuseaddr", true)
			self.link_server:listen(5)
			local FILE = io.open('data/404.ram','r'):read('*a')

			print('server  is online : \27[34mhttp://'..self.addr..':'..self.port..'\27[0m')

			while true do
				local client_socket = self.link_server:accept()
				local client_buffer = client_socket:receive('*l')
				local c_addr,c_port = client_socket:getpeername()
				local client_resp   = FILE 
				
				local method,path,query,_ = http_parse.request_line(client_buffer)
				
				if method == nil then 
					client_socket:send('protocol not recognized')
					client_socket:close()
				else
					print('\t[\27[32m request \27[0m] from: \27[34m'..c_addr..':'..c_port..'\27[0m'..' for \27[36m'..path..'\27[0m')
					
					if string.lower(method) == 'get' then 
						if self.g_callbacks[path] then 
							local req, res = http_parse.get_parse(client_socket,query)
							cbk_return = self.g_callbacks[path](req,res)
							
							if cbk_return == nil then
								print("\t[\27[33m warning \27[0m] callback for \27[34m" .. path .. " \27[0mnot as returned data to send")
							else 
								client_resp = cbk_return:build() end
						end
					end
					
					-- if string.lower(method) == 'post'  then print('post method') end
					-- if string.lower(method) == 'put'   then print('put method') end
					-- if string.lower(method) == 'delet' then print('delet method') end
					
					client_socket:send(client_resp)
					client_socket:close()
				end
			end
			-- self.link_server:close()
		end
	} 
end
return flask_lua