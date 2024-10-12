# FlaskLua

FlaskLua é uma microframework para desenvolvimento de aplicações web em Lua, inspirado no famoso Flask do Python. A ideia por trás deste projeto é trazer a simplicidade e a flexibilidade do Flask para a linguagem Lua, permitindo que os desenvolvedores criem APIs e aplicações web de forma rápida e eficiente.

## Características

- Simplicidade na definição de rotas para requisições HTTP.
- Suporte a métodos `GET` e `POST`.
- Possibilidade de adicionar callbacks personalizados para diferentes endpoints.
- Estrutura leve e fácil de usar.

## Pré-requisitos

Para usar o FlaskLua, você precisará ter o seguinte instalado:

- [Lua 5.1](https://www.lua.org/)
- [LuaRocks](https://luarocks.org/) (gerenciador de pacotes para Lua)
- [LuaSocket](https://luaforge.net/projects/luasocket/) (para comunicação de rede)
- [Lua CJSON](https://www.kyne.com.au/~mark/software/lua-cjson.php) (para manipulação de JSON)

Você pode instalar as dependências usando o LuaRocks com os seguintes comandos:

```bash
luarocks install luasocket
luarocks install lua-cjson
```

## Instalação

1. Clone este repositório ou baixe o arquivo do projeto:

   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd flasklua
   ```

2. Certifique-se de que todas as dependências estão instaladas.

## Uso

Para iniciar um servidor básico com o FlaskLua, você pode usar o seguinte código:

```lua
local flask_lua = require 'flask_lua'

-- Inicializando o servidor
local app = flask_lua()
app:init("127.0.0.1", 3000)

-- Definindo uma rota GET
app:get('/hello', function(req, res)
    res.body = '{"message": "Hello, World!"}'
    res.headers['Content-Type'] = 'application/json'
    return res
end)

-- Definindo uma rota POST
app:post('/data', function(req, res)
    local data = req.body
    res.body = '{"received": ' .. data .. '}'
    res.headers['Content-Type'] = 'application/json'
    return res
end)

-- Iniciando o servidor
app:run()
```

### Exemplos de Uso

1. **Requisição GET**:

   Acesse `http://127.0.0.1:3000/hello` em seu navegador ou use um cliente HTTP (como `curl`) para ver a resposta.

   ```bash
   curl http://127.0.0.1:3000/hello
   ```

   **Resposta**:

   ```json
   {"message": "Hello, World!"}
   ```

2. **Requisição POST**:

   Envie uma requisição POST para `http://127.0.0.1:3000/data` com um corpo JSON.

   ```bash
   curl -X POST -d '{"key": "value"}' http://127.0.0.1:3000/data
   ```

   **Resposta**:

   ```json
   {"received": {"key": "value"}}
   ```

## Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir um problema ou enviar um pull request.
