
local http_heads = function()
    return
    {
        -- request  scheme
        req_schm = {
            parameters = nil,
            headers    = {},
            buffer     = nil,
        }, 

        -- response scheme
        res_schm = {
            head = '',
            code = '200 ok',
            buff = '',
            
            set_head = function(self,_key,_value)
                self.head = self.head.._key..':'.._value..'\n'
            end,

            build = function(self)
                self.head = self.head..'HTTP/1.1 '..self.code..'\n'
                self.head = self.head..'Server:LunarFlask/1.1 (unix)\n'
                self.head = self.head..'Access-Control-Allow-Origin:*\n'
                self.head = self.head..'Content-Length:'..#self.buff..'\n'

                print(self.head..'\n'..self.buff)
                return self.head..self.buff 
            end
        },  
    }
end

return http_heads