


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
			print('server start: http://'..self.addr..':'..self.port)

			while true do
				local client_socket = self.link_server:accept()
				local client_buffer = client_socket:receive('*l')
				local client_resp   = io.open('data/404.ram','r'):read('*a')
				local method,path,_ = http_parse.request_line(client_buffer)
				
				if method == nil then 
					client_socket:send('protocol not recognized')
					client_socket:close()
				else
					if string.lower(method) == 'get' then 
						if self.g_callbacks[path] then 
							local req, res = http_parse.get_parse(client_socket,path)
							cbk_return = self.g_callbacks[path](req,res)
							
							if cbk_return == nil then
								print('[ warning ] callback for '..path..' not as returned data to send')
							else client_resp = cbk_return:build() end
						end
					end 
					
					if string.lower(method) == 'post'  then print('post method') end
					if string.lower(method) == 'put'   then print('put method') end
					if string.lower(method) == 'delet' then print('delet method') end
					
					client_socket:send(client_resp)
					client_socket:close()
				end
			end
		end
	} 
end
return flask_lua