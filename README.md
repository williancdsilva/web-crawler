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
Para a análise e coleta dos dados, foi utilizada a biblioteca Nokogiri.
O retorno da consulta é através da serialização JSON.

O código está organizado assim:

2 Modelos

- author.rb
- quote.rb

4 Métodos

- show
- search(tag)
- json(array)
- crawler(tag)

O banco mongo está organizado assim:

    database:  quotestoscrape

    2 collections:

        authors: {
            _id: ObjectId("617f2d0601352d040f76fcaa")
            name: "Albert Einstein"
            about: "/author/Albert-Einstein"
        }

        quotes: {
            _id: ObjectId("617f41c201352d040f76fcae")
            quote: "“The world as we have created it is a process of our thinking. It cann..."
            tags: Array
                0:"deep-thoughts"
                1:"world"
                2:"thinking"
                3:"change"
            author_id: ObjectId("617f2d0601352d040f76fcaa")
        }



Copy `config/mongoid.yml.sample` to `config/mongoid.yml` and adjust the
settings within as needed:

## Como Usar

Para rodar a aplicação, use o comando padrão do Rails (``rails s``,
``rails c``).

Acesse a aplicação pelo endpoint /quotes/, podendo:

Pelo comando CURL:
    
    curl http://localhost:3000/quotes/{SEARCH_TAG}

Pelo navegador:
    
    http://localhost:3000/quotes/{SEARCH_TAG}
    
Troque {SEARCH_TAG} pela tag a buscar.
