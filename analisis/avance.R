install.packages("readr")
install.packages("dplyr")
install.packages("ggplot2")
library(readr)
library(ggplot2)
library("dplyr")


ruta<-file.choose()
datos<-read_csv(ruta)
datos

View(datos)

df=data.frame(datos$Pais,datos$Nombre,datos$ValorPorHora,datos$ProyectosCompletados) 
df
ggplot(data=df, aes(x=datos$Nombre, y=datos$ValorPorHora)) + geom_bar(stat="identity")


ggplot(data=df, aes(x=reorder(datos$Nombre,datos$ValorPorHora), y=datos$ValorPorHora, fill=datos$Pais)) + 
  geom_bar(stat="identity", position="dodge")


ggplot(data=df, aes(x=datos$Pais, y=datos$ProyectosCompletados, fill=datos$Nombre)) + 
  geom_bar(stat="identity", position="dodge")



