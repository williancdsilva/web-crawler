# Web Crawler Rails API + MongoDB + Nokogiri

Este repositório contêm uma aplicação demonstração Ruby on Rails API usando Mongodb.

## Sobre

O objetivo é coletar dados da página https://quotes.toscrape.com/, onde existem
citações realizadas por vários autores.

A busca no site será realizada caso a citação e tag não estejam presentes no cache.
Cada página será analisada, e a tag de retorno será a que vier primeiro.
O retorno da consulta é através da serialização JSON nativa do Rails.
É necessário token de acesso na requisição para usar a API.

Cada citação é composta por:

- Citação (quote)
- Autor (author)
- Link da página sobre o autor (author_about)
- Etiquetas (tags)

A aplicação possui os seguintes recursos:

- Ruby on Rails 6 API
- Análise e coleta HTML usando a biblioteca Nokogiri
- MongoDB em nuvem Atlas funcionando como cache
- Acesso por token
- Serialização JSON (nativa)

O código está organizado assim:

Controladoras

    - quotes_controller.rb

Modelos

    - author.rb
    - quote.rb

Métodos

    - show
    - search(tag)
    - json(array)
    - crawler(tag)

O banco de dados mongo está organizado assim:

Database:  quotestoscrape

Collections:

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

## Como Usar

Para rodar a aplicação, clone-a, e use o comando padrão do Rails (``rails s``,
``rails c``).

Para usar mongodb na nuvem, crie uma conta em https://cloud.mongodb.com/.
Configure `mongoid.yml` como é sugerido pelo portal.

Acesse a aplicação pelo endpoint /quotes/, sendo:

Pela linha de comando:
    
    curl -H "Authorization: Token token=secret" \
        http://localhost:3000/quotes/{SEARCH_TAG}
    
Troque {SEARCH_TAG} pela tag de consulta.
