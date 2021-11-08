class QuotesController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  require "open-uri"

  TOKEN = "secret"

  before_action :authenticate

  # GET /quotes/{tagname}
  def show
    tag = params[:tag]
    cache_search(tag)
  end

  def cache_search(tag)
    # Quando usar cache ou coleta (padrão: coleta)
    n = 0
    quotes = Array.new
    # Buscar tag no cache
    Quote.each do |q|
      if q.tags.include?(tag)
        a = Author.find(q.author_id)
        # Serialização JSON
        quotes << { quote: q.quote, author: a.name, author_about: a.about, tags: q.tags.to_s }
        n+=1
      end
    end
    # Coletar dados se não encontrou tag ou renderiza cache.
    n == 0 ? tag_page(tag) : json(quotes)
  end

  def json(array)
    render plain: JSON.generate(array)
  end

  # Procura tag no portal
  def tag_page(tag)

    uri = "http://quotes.toscrape.com"

    # Procura a tag em cada página
    loop do
      
      doc = Nokogiri::HTML(URI.open(uri))

      # Coleta as tags da página
      tags = doc.css(".tags .keywords")
      result = tags.map { |t| t.attributes["content"].value }

      # Acha a próxima página
      if result.any?(/#{tag}/)
        crawler(tag, result, doc)
        break
      else
        # Se não existir o botão "next", fim da busca!
        if doc.search("nav .pager .next").empty?
          render plain: "Tag não existe no site."
          break
        else
          # Próxima página
          next_page = doc.css(".pager .next a").attribute("href").text
          uri = "http://quotes.toscrape.com" + next_page
        end
      end
    end
  end

  def crawler(tag, result, doc)

    # Saber em qual dos 10 items da página estará
    count = 0

    # JSON array
    quotes = Array.new

    # Para cada conjunto de tags encontradas (cada linha = campo 'tags' na página web)
    result.each do |t|

      # Cada linha tem várias tags. Acessar uma tag de cada vez, sem a vírgula.
      t.each_line(',', chomp: true) do |a|

        # A tag encontrada é igual a recebida via GET /quotes/{tagname} ?
        if a.casecmp?(tag)

          # Coletar nome do autor
          nome = doc.css(".author")[count].text.strip
          # Coletar quote do autor
          frase = doc.css(".quote .text")[count].text.strip
          # Coletar link do autor
          link = doc.css(".quote")[count].children[3].children[3].attributes["href"].value

          # Encontre ou salve o autor
          @autor = Author.find_or_create_by(name: nome, about: link)

          # Procure se a citação já existe
          @quote = Quote.find_by(quote: frase)

          # Se não existir, cria nova citação. Se sim, adiciona nova tag.
          if @quote.nil?
            @quote = Quote.new
            @quote = Quote.create(quote: frase, tags: @quote.tags = [tag], author_id: @autor.id)
          else
            @quote.update(tags: @quote.tags << tag)
          end

          # Serialização JSON
          quotes << { quote: frase, author: nome, author_about: link, tags: @quote.tags.to_s }
        end
      end
      count+=1
    end
    # Renderizar JSON
    json(quotes)
  end
  
  private
  
  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
    end
  end
end
