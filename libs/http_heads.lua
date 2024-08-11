
local http_heads = {}

local parameters_metatable = {
    __index = function(table,key)
        print("\t[\27[33m warning \27[0m] request.parameters[\27[34m" ..key.. "\27[0m] is undefined")
        return 'undefined'
    end
}

http_heads.req_schm = function()
    local scheme = {
        name = 'REQ_TABLE',
        parameters = {},
        headers    = {},
        buffer     = nil
    }
    setmetatable(scheme.parameters,parameters_metatable)
    return scheme
end

http_heads.res_schm = function()
    return {
        name = 'RES_TABLE',
        head = '',
        code = '200 ok',
        buff = '',
        thed = '', -- temp usr head options
            
        set_head = function(self,_key,_value)
            self.thed = self.thed.._key..':'.._value..'\n'
        end,

        build = function(self)
            self.head = self.head..'HTTP/1.1 '..self.code..'\n'
            self.head = self.head..'Server:LunarFlask/1.1 (unix)\n'
            self.head = self.head..'Access-Control-Allow-Origin:*\n'
            self.head = self.head..'Content-Length:'..#self.buff..'\n'
            self.head = self.head..self.thed    
            return self.head..'\n'..self.buff 
        end
    }
end


return http_heads