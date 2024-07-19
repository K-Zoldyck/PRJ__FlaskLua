
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
        
        get_parse = function(client_socket)
            local req,res = nil, nil

            return req,res 
        end
    }
end


return http_parse