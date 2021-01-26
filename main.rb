require 'open-uri'
require 'nokogiri'
require 'csv'

class Curso
  attr_accessor :pais,:nombre,:estrellas,:valor
  def inicial(pais,nombre,estrellas,valor)
    @pais=pais
    @nombre=nombre
    @estrellas=estrellas
    @valor=valor
    
    
  end

  def registrar(pais,nombre,estrellas,valor)
    filename = 'data.csv'
    CSV.open(filename, 'a') do |csv|
      csv << [pais,nombre,estrellas,valor]
    end
  end
  
end

class Scraper
  
  def extraer(tema)
    link = "https://www.workana.com/hire/php"
    documento=open(link)
    datos=documento.read
    to_parse = Nokogiri::HTML(datos)

    to_parse.css(".wrapper").css('.col-md-4').each do |lista|
      pais = lista.css('.country').inner_text.strip.split("\n,\",\[,\]")
      nombre=lista.css('.ellipsis').css('span').text
      estrellas=lista.css('p').inner_text.strip.chomp("Valor hora:").strip
      valor=lista.css('.h4 span').text
      #nombre=lista.css('span').css('.name').inner_text
      puts "***************INICIO******************"
      puts pais
      puts nombre
      puts estrellas
      puts valor
     
      puts "***************FIN******************"
      puts ""
      temp=Curso.new
      temp.registrar(pais,nombre,estrellas,valor)
    end
  end
end


scrap=Scraper.new()
scrap.extraer('php')