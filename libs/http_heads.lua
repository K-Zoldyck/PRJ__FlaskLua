
local http_heads = function()
    return
    {
        -- request  scheme
        req_schm = {
            parameters = nil,
            headers    = nil,
            buffer     = nil,
        }, 

        -- response scheme
        res_schm = {},  
    }
end

return http_heads