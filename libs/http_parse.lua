
local http_heads = require 'libs/http_heads'

local http_parse = function()
    return {
        request_line = function(buffer)
            local accept_methods = { get=true,put=true,delete=true,post=true }
            
            if buffer ~= nil then
                local method,path,version = string.match(buffer,'(%a+)%s(%S+)%s(%S+)')
                local querys = {}
                                
                if method == nil or #method == 0 then return nil end
                if path   == nil or #path   == 0 then return nil end

                if accept_methods[string.lower(method)] then 
                    local ask = string.find(path,'?')
                    if ask ~= nil then 
                        temp_path = string.sub(path,0,ask-1)
                        temp_quer = string.sub(path,ask+1,_)
                        if #temp_quer >= 3 then 
                            for key,value in string.gmatch(temp_quer,'(%w+)=(%w+)') do
                                querys[key] = value
                            end
                        end
                        return method,temp_path,querys,version
                    end
                    return method,path,{},version
                end
            end
            return nil
        end,
        
        get_parse = function(client_socket,query)
            local req = http_heads.req_schm();
            local res = http_heads.res_schm();
            
            -- if #query >= 3 then 
               for key,value in pairs(query) do
                    req.parameters[key] = value
               end
            -- end
            
            while true do
                local buff = client_socket:receive('*l')
                if not buff or #buff == 0 or #buff <= 3 then break end
                local key, value = string.match(buff, '(%S+)%s*:%s*(%S+)')
    
                if key and value then
                    req.headers[string.lower(key)] = value
                end
            end           
            return req, res
        end
    }
end


return http_parse