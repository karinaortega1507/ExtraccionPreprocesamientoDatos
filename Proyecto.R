css <- read.csv(file = 'Freelancecss.csv') #Leemos el archivo css
dotnet <- read.csv(file = 'Freelancedot-net.csv') #Leemos el archivo dot-net
View(css)
View(dotnet)

#Trabajos por ubicación
porcentajeCss=round(prop.table(table(css$Ubicacion))*100,2) #Porcentajes
frecuenciasCss=table(css$Ubicacion)#Frecuencias por pais
barplot(frecuenciasCss) #Representación Gráfica frecuencias
pie(porcentajeCss)

porcentajesDNet=round(prop.table(table(dotnet$Ubicacion))*100,2)#Porcentajes
frecuenciasDNet=table(dotnet$Ubicacion)#Frecuencias por pais
barplot(frecuenciasDNet) #Representación Gráfica frecuencias
pie(porcentajeCss)

#Media de oferta 
mean(css$Oferta)
mean(dotnet$Oferta)
