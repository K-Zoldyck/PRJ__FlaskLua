

local flask_lua = require 'flask_lua'
local app = flask_lua()


app:get('/all',function(req,res)
    print(req.parameters['name']) 
    res.buff = 'ola, mundo'
    res:set_head('Content-Type','text/plain')
    
    return res
end)

app:init('127.0.0.1',3000)
