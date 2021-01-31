require 'open-uri'
require 'nokogiri'
require 'csv'

class Empleo
  attr_accessor :titulo,:oferta,:numOfertas,
  :presupuesto,:ubicacion,:skills

  def initialize(titulo,oferta,numOfertas,presupuesto,ubicacion,skills)
    @titulo = titulo
    @oferta = oferta
    @numOfertas = numOfertas
    @presupuesto = presupuesto
    @ubicacion = ubicacion
    @skills = skills
  end

  def registrar(file)
    CSV.open(file, 'a') do |csv|
      csv << [@titulo,@oferta,@numOfertas,@presupuesto,@ubicacion,@skills]
    end
  end
end

class Scraper
  def extraer(skill)
    url = "https://www.freelancer.com/"
    trabajos="jobs/#{skill}/"

    puts(url+trabajos)

    empleoHTML = open(url+trabajos)
    contenido = empleoHTML.read
    parsed = Nokogiri::HTML(contenido)
    container = parsed.css('div#project-list')

    container.css('div.JobSearchCard-item').each do |datos|
      marco = datos.css('div.JobSearchCard-primary-heading')
      a = marco.css('a')
      titulo=a.text.strip
      
      puts("\n"+"-"*48)
      puts("Empleo:#{titulo}\n")
      oferProm = datos.css('div.JobSearchCard-primary-price').text.strip.split('(')[0].split(' ')[0].gsub(/[$€₹£]/,'')
      puts("Oferta promedio:#{oferProm}")

      ofertas=datos.css('div.JobSearchCard-secondary-entry').text.split(" ")[0]
      puts("Ofertas:#{ofertas}")

      link=a.attribute('href')
      link=url+link
      descHTML=open(link)
      contenido2=descHTML.read
      parsed2=Nokogiri::HTML(contenido2)
      container2=parsed2.css('div.PageProjectViewLogout-detail')

      presupuesto=parsed2.css('p.PageProjectViewLogout-header-byLine').text.split('Budget')[1].strip.split(' ')[0].gsub(/[$€₹£]/,'')
      puts("Presupuesto:#{presupuesto}")

      ubicacion=container2.css('span.PageProjectViewLogout-detail-reputation-item-locationItem').text.strip.split(",")[1]
      puts("Ubicacion:#{ubicacion}")

      habilidades=container2.css('a.PageProjectViewLogout-detail-tags-link--highlight').text
      puts("Habilidades:#{habilidades}")
      puts("-"*48)

      e=Empleo.new(titulo,oferProm,ofertas,presupuesto,ubicacion,habilidades)
       
      e.registrar("Freelance#{skill}.csv")     
    end
  end
end


puts "Habilidades: dot-net-core,dot-net,ruby,html,css"
puts "Ingrese una habilidad:"
habilidad = gets.chomp 
file="Freelance#{habilidad}.csv"
CSV.open(file, 'w') do |csv|
  csv << %w[Trabajo Oferta  Numero_Ofertas Rango_Presupuesto Ubicacion Habilidades]
end
Scraper.new.extraer(habilidad)

