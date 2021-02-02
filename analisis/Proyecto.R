#Librerias 
library(ggplot2)
library(dplyr) 


#lectura del archivo
dataCss <- read.csv(file = 'Freelancecss.csv') 

#2. Eliminar filas donde hayan NA
dataCss<-dataCss[complete.cases(dataCss),]

#3 Almacenar datos limpios y transformados
datos_listos<-transform(dataCss, Oferta = as.numeric(Oferta),
                        Numero_Ofertas= as.numeric(Numero_Ofertas))
View(datos_listos)
saveRDS(datos_listos,file="misDatosParaGraficar.RDS") #Guardar los datos

#4. Analisis de datos
#4.1. Leer el archivo generado RDS
data <- readRDS(file = "misDatosParaGraficar.RDS")
View(data)

#Qué porcentaje de plazas de trabajos se presentan por pais?
porcentaje=round(prop.table(table(data$Ubicacion))*100,2) #Porcentajes
porcentaje= as.data.frame(porcentaje)
View(porcentaje)

# Piechart
ggplot(porcentaje, aes(x="", y=Freq, fill=Var1)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +  theme_void() +
  ggtitle("Pocentaje de trabajos por ubicacion")
ggsave("Piechart.png", width = 18, height = 14)

write.csv(x = porcentaje, file = "Porcentajes.csv", row.names = FALSE)

#grafico de dispersión entre la oferta media y el numero de ofertas en general
corr=round(cor(data$Oferta,data$Numero_Ofertas),3)
ggplot(data, aes(Oferta,Numero_Ofertas))+ geom_point()+ 
  xlab("OfertaMedia")+
  ylab("Personas ofertando")+
  ggtitle( paste("Diagrama de Dispersión",corr,sep=" "))
ggsave("Dispersion.png", width = 6, height = 6)


#Análisis del valor de oferta por país y numero de plazas
OfertaXPais<-data %>% 
  group_by(Ubicacion)%>%
  summarise(Oferta_Media=mean(Oferta),Oferta_Mediana=median(Oferta),
            Oferta_Min=min(Oferta),Oferta_Max=max(Oferta),
            plazas=length(Ubicacion),personas_ofertando=sum(Numero_Ofertas))%>%
  print()
write.csv(x = OfertaXPais, file = "OfertaXPais.csv", row.names = FALSE)

#Diagrama de barras oferta max por pais 
ggplot(OfertaXPais, aes(x=Oferta_Max, y=Ubicacion, fill=Ubicacion)) + 
  geom_bar(stat="identity", position="dodge")+
  ggtitle("Oferta media por país")
ggsave("Barras.png", width = 18, height = 14)





