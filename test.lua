

local flask_lua = require 'flask_lua'
local app = flask_lua()


app:get('/all',function(req,res)
    -- http://127.0.0.1:3000/all?name=your name
    print(req.parameters['name']) 
    res.buff = '<p>ola,'..req.parameters['name']..'</p>'
    res:set_head('Content-Type','text/html')
    
    return res
end)

app:init('127.0.0.1',3000)
