#instalar paquetes
install.packages("dplyr")
library(ggplot2)
library("dplyr")
library(MASS)
#1. importar datos predatos
datos <- read.csv("analisis/angular.csv")
View(datos)
#2. Eliminar filas donde hayan NA
datos<-datos[complete.cases(datos),] # solo seleccionamos filas completas (sin NA)
View(datos)

sapply(datos, mode)
sapply(datos, class)
#3 Almacenar datos limpios y transformados
#3.1. Guardar datos transformados
datos_listos<-transform(datos, sueldo_anual = as.numeric(sueldo_anual),
                 costo_por_hora = as.numeric(costo_por_hora))
View(datos_listos)
saveRDS(datos_listos,file="misDatosParaGraficar.RDS") #Guardar los datos

#4. Analisis de datos
#4.1. Leer el archivo generado RDS
mi_data <- readRDS(file = "misDatosParaGraficar.RDS")
View(mi_data)

#¿Existe relación entre el sueldo y el número de plazas por país?
ggplot(mi_data, mapping= aes(x=pais, y=sueldo_anual, color = pais)) +
        geom_boxplot() + # dibujamos el diagrama de cajas
        xlab("País")+
        ylab("Sueldo Anual")+
        ggtitle("Diagrama de Cajas Sueldo Anual")
        ggsave("plot5.png", width = 18, height = 14)

#visualizamos el sueldo promedio, minimo y maximo junto con número de plazas de trabajo de cada país
sueldo_x_pais<-mi_data %>% 
        group_by(pais)%>%
        summarise(Media_sueldo=mean(sueldo_anual),Mediana_sueldo=median(sueldo_anual), Sueldo_minimo=min(sueldo_anual),Sueldo_maximo=max(sueldo_anual), Numero_plazas=length(pais))%>%
        print()
write.csv(x = sueldo_x_pais, file = "sueldoXpais.csv", row.names = FALSE)

#grafico de dispersión entre la media del sueldo y el numero de plazas por pais
ggplot(sueldo_x_pais, aes(Media_sueldo, Numero_plazas, colour = pais)) + geom_point()+ 
        xlab("Sueldo anual promedio")+
        ylab("Plazas de trabajo")+
        ggtitle("Diagrama de Dispersión")
ggsave("plot1.png", width = 6, height = 6)


cor(x=sueldo_x_pais$Media_sueldo, y=sueldo_x_pais$Numero_plazas)

#visualizamos el sueldo por hora promedio junto con número de plazas de trabajo de cada país
costoH_x_pais<-mi_data %>% 
        group_by(pais)%>%
        summarise(Media_costo_hora=mean(costo_por_hora), Numero_plazas=length(pais))%>%
        print()
write.csv(x = costoH_x_pais, file = "sueldoXHora_pais.csv", row.names = FALSE)

#grafico de dispersion entre el costo por hora y el numero de plazas por pais
ggplot(costoH_x_pais, aes(Media_costo_hora , Numero_plazas,  colour = pais)) + 
        geom_point()+ 
        xlab("Salario por hora")+
        ylab("Plazas de trabajo")+
        ggtitle("Diagrama de Dispersión")
ggsave("plot2.png", width = 6, height = 6)

cor(x=costoH_x_pais$Media_costo_hora, y=costoH_x_pais$Numero_plazas)

#grafico de barras entre el Pais y el sueldo anual promedio
ggplot(sueldo_x_pais, aes(x=pais, y=Media_sueldo , fill=pais)) + 
        geom_bar(stat="identity") +
        theme(axis.title.x = element_text(face="bold", size=3))+ 
        xlab("País")+ 
        ylab("Sueldo Anual Promedio")+
        ggtitle("Sueldo Anual por país")
ggsave("plot3.png", width = 13, height = 13)





