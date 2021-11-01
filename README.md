# Demonstração MongoDB + Rails API

Este repositório contêm uma aplicação demonstração Ruby on Rails API usando Mongoid.

It has been developed following the
[Mongoid getting started guide with Rails](https://docs.mongodb.com/mongoid/master/tutorials/getting-started-rails/).

## Implementação

O objetivo é coletar dados da página https://quotes.toscrape.com/, onde existem
citações realizadas por vários autores.

Cada citação é composta por:

- Citação (quote)
- Autor (author)
- Link da página sobre o autor (author_about)
- Etiquetas (tags)

A aplicação trabalha com os seguintes recursos:

- Ruby on Rails 6 API
- MongoDB em nuvem Atlas funcionando como cache
- Hospedada na nuvem AWS em instância EC2
- Contêiner Docker

A busca no site será realizada caso a citação e tag não estejam presentes no cache.
Foi usada ...

Copy `config/mongoid.yml.sample` to `config/mongoid.yml` and adjust the
settings within as needed:

- If you are using a MongoDB Atlas cluster, remove the hosts and database
sections from `config/mongoid.yml`, uncomment the URI section and paste the
URI to your cluster from the Atlas console.
- You may want to adjust the server selection timeout, increasing it for
a deployment used over Internet such as Atlas and decreasing it for a
local deployment.

## Como Usar

To run the application, use the standard Rails commands (``rails s``,
``rails c``).

Acesse a aplicação pelo endpoint:

Usando CLI pelo comando CURL:
    
    curl http://localhost:3000/quotes/{SEARCH_TAG}

Pelo navegador:
    
    http://localhost:3000/quotes/{SEARCH_TAG}
    
Troque {SEARCH_TAG} pela tag a buscar.