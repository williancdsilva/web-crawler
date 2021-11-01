class QuotesController < ApplicationController
  require "open-uri"
  
  # GET /quotes/{tagname}
  def show
    tag = params[:tag]
    search(tag)
  end

  def search(tag)
    # Quando usar cache ou crawler (padrão: crawler)
    n = 0
    quotes = Array.new
    # Buscar tag no cache
    Quote.each do |q|
      if q.tags.include?(tag)
        a = Author.find(q.author_id)
        quotes << { quote: q.quote, author: a.name, author_about: a.about, tags: q.tags.to_s }
        n+=1
      end
    end
    # Use cache, senão, crawlear página.
    n == 0 ? crawler(tag) : json(quotes)
  end

  def json(array)
    render plain: JSON.generate(array)
  end

  private

  def crawler(tag)
    uri = "http://quotes.toscrape.com/"
    doc = Nokogiri::HTML(URI.open(uri))

    # Crawler tags
    tags = doc.css(".tags .keywords")
    result = tags.map { |t| t.attributes["content"].value }

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

          # Crawlear nome do autor
          nome = doc.css(".author")[count].text.strip
          # Crawlear quote do autor
          frase = doc.css(".quote .text")[count].text.strip
          # Crawlear link do autor
          link = doc.css(".quote")[count].children[3].children[3].attributes["href"].value

          # Encontre ou salve o autor
          @autor = Author.find_or_create_by(name: nome, about: link)

          # Procure se a citação já existe:
          quote = Quote.find_by(quote: frase)

          # Se não, array novo. Se sim, nova tag.
          quote.nil?? Quote.create(quote: frase, tags: tg_ar = [tag], author_id: @autor.id) :
          quote.update(tags: quote.tags << tag)

          # Serialização JSON
          quotes << { quote: frase, author: nome, author_about: link, tags: quote.tags.to_s }
        end
      end
      count+=1
    end
    # Renderizar JSON
    json(quotes)
  end
end
