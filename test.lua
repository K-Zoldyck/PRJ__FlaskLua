
local sqlit = require 'lsqlite3'
local flask_lua = require 'flask_lua'
local app = flask_lua()

app:init('127.0.0.1',3000)
