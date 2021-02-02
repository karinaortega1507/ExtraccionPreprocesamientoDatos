install.packages("readr")
library(readr)

ruta<-file.choose()
datos<-read_csv(ruta)
datos

View(datos)

grafico<-plot(datos$Valor,datos$Proyectos)

proyectos=round(prop.table(table(datos$Proyectos))) 
valor_pais=table(datos$Valor)
barplot(proyectos) 
pie(valor_pais)