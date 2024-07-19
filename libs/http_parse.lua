
local http_headers = require 'http_heads'()

local http_parse = function()
    return {
        request_line = function(buffer)
            local accept_methods = {GET=true,PUT=true,DELET=true,POST=true}
            if buffer ~= nil then
                local method,path,version = string.match(buffer,'(%a+)%s(%S+)%s(%S+)')
                if accept_methods[method] and #path > 0 then 
                    return method,path,version
                end
            end
            return nil
        end,
        
        get_parse = function(client_socket,path)
            local req = http_headers.req_schm;
            local res = http_headers.res_schm;
            
            while true do
                local buff = client_socket('*l')
                if #buff == 0 then break end 
                local key,value = string.match(read_line,'(%S+)%s*:%s*(%S+)')
                
                if k ~= nil and v ~= nil then
                    req.headers[string.lower(k)] = v
                end
            end 
        end
    }
end


return http_parse