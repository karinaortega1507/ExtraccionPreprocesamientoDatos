require 'open-uri'
require 'nokogiri'
require 'csv'

class Curso
  attr_accessor :pais,:nombre,:estrellas,:completado
  def inicial(pais,nombre,estrellas,completado)
    @pais=pais
    @nombre=nombre
    @estrellas=estrellas
    #@valor=valor
    @completado=completado
    
    
  end

  def registrar(pais,nombre,estrellas,completado)
    filename = 'data.csv'
    CSV.open(filename, 'a') do |csv|
      #csv << ["pais","nombre","estrellas","completado"]
      csv << [pais,nombre,estrellas,completado]
    end
  end
  
end

class Scraper
  
  def extraer(tema,num)
    #tmp = "https://www.workana.com/freelancers?query="
    for i in(1..num)
      temporal=0
      tmp ="https://www.workana.com/freelancers/php?page=0"
      link = tmp.sub temporal.to_s, i.to_s
      puts i.to_s
      temporal= temporal.to_i+1
      puts temporal
      link = tmp.sub "php",tema
      puts link
      #link = link.sub i
      documento=open(link)
      datos=documento.read
      to_parse = Nokogiri::HTML(datos)
      puts "hola"
      to_parse.css(".search").css(".js-worker").each do |lista|
        pais = lista.css('.country').inner_text.strip.chomp("\n")
        #pais = lista.css('.country').inner_text.strip.split("\n,\",\[,\]")
        #puts "hola 2"
        #pais = lista.css('.country').inner_text
        #nombre=lista.css('.h3').css('span').inner_text.strip.chomp('\n').strip
        nombre=lista.css('a').inner_text.strip.chomp('Contratar').strip
        estrellas=lista.css('.stars-bg').css('span').inner_text
        #estrellas=lista.css('p').inner_text.strip.chomp("Valor hora:").strip
        #valor=lista.css('.text-center-sm').css('span').text.chomp('\n').strip
        valor=lista.css('.js-monetary-amount').inner_text.sub ",","."
        #nombre=lista.css('span').css('.name').inner_text
        completado=lista.css('.visible-xs').css('span').inner_text.strip
        comple=completado.sub "Proyectos completados: ",""
        nom=nombre.sub pais,""
        puts "***************INICIO******************"
        puts pais
        #puts nombre
        puts nom
        #puts estrellas
        puts valor
        #puts completado
        puts comple
       
      
        puts "***************FIN******************"
        puts ""
        temp=Curso.new
        temp.registrar(pais,nom,valor,comple)
      end
    end
  end
end

puts "Por favor, ingrese el lenguaje a buscar:"
lp=gets.chomp

puts "Escoga la cantidad de resultados: "
puts "Digite 1 para 10 resultados"
puts "Digite 2 para 20 resultados"
puts "Digite 3 para 30 resultados"
puts "Digite 4 para 40 resultados"
puts "Digite 5 para 50 resultados"
page=gets.chomp
pag=page.to_i
puts pag

scrap=Scraper.new()
scrap.extraer(lp,pag)