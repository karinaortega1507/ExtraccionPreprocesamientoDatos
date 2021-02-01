# Realizado por Karina Ortega

require 'open-uri'
require 'nokogiri'
require 'csv'

class Skill
  # métodos getters y setters
  attr_accessor :avatar, :pais, :habilidades, :categoria, :costo_por_hora, :sueldo_anual

  # se define el constructor de la clase Skill
  def initialize(avatar, pais, habilidades, categoria, costo_por_hora, sueldo_anual)
    @avatar = avatar
    @pais = pais
    @habilidades = habilidades
    @categoria = categoria
    @costo_por_hora = costo_por_hora
    @sueldo_anual = sueldo_anual   
  end

  # método registrar que recibe todos los atributos y los guarda en un archivo CSV
  def registrar(skill)
    # se abre el archivo tema.csv
    CSV.open(skill + '.csv', 'a') do |csv|
      # se almacenan los valores recibidos en el archivo
      csv << [@avatar, @pais, @habilidades, @categoria, @costo_por_hora, @sueldo_anual]
    end
  end
end

class Scraper
  def extraer(skill)
    pagina = 1
    url = 'https://www.guru.com/d/freelancers/'
    url += 'skill/' + skill
    (1..3).each do |i|
      link = url + "/pg/#{i}/"
      document = open(link)
      content = document.read
      parserd_content = Nokogiri::HTML(content)
      puts '********* Extrayendo los datos ************'
      parserd_content.css('.cozy > li').each do |row|
        avatarinfo = row.css('.avatarinfo h3 a').text.strip
        pais= row.css('.freelancerAvatar__location--country').inner_text
        habilidades = row.css('.serviceListing__title a').inner_text.strip
        categorias = row.css('.skillsList__skill a').text.strip.gsub(/\n/, " ")
        categoria = categorias[0..25]
        costo = row.css('.serviceListing__details .serviceListing__rates').text.strip.gsub(/\n/, " ")
        costo_por_hora = costo[1..2]
        if (costo[2] == "/")
          costo_por_hora = costo[1]
        end
             

        sueldo = row.css('.earnings .earnings__amount').inner_text
        sueldo_anual = sueldo.delete(',').to_i
        puts "Avatar freelancer: #{avatarinfo}"
        puts "pais: #{pais}"
        puts "Habilidades: #{habilidades}"
        puts "Categoria: #{categoria}"
        puts "Costo por hora: #{costo_por_hora}"
        puts "Salario anual: #{sueldo_anual}"
        habilidad = Skill.new(avatarinfo, pais, habilidades, categoria, costo_por_hora, sueldo_anual)
        habilidad.registrar(skill)
        puts '---------------------------------------------------------------------------'
      end
    end
  end
end
puts 'Habilidades'
puts 'AngularJs - CSS - CSS3 - Design - Drupal - Full Stack - HTML -
JQuery - Magento - Node.js - MySQL - Shopify Developer'
puts 'Ingrese una habilidad: '
habilidad = gets.chomp
nombre_archivo = habilidad + '.csv'
CSV.open(nombre_archivo, 'w') do |csv|
  csv << %w[avatar pais habilidades categoria costo_por_hora sueldo_anual]
end
scrap = Scraper.new.extraer(habilidad)