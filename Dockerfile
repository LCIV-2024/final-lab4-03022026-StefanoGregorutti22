# TODO: Implementar el Dockerfile para la aplicación

# Etapa 1: Build de la aplicación con Maven
FROM maven:3.9.5-eclipse-temurin-17 AS build

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de Maven
COPY pom.xml .

# Descargar dependencias (se cachean si no cambia el pom.xml)
RUN mvn dependency:go-offline -B

# Copiar el código fuente
COPY src ./src

# Compilar y empaquetar la aplicación (saltando tests para build más rápido)
RUN mvn clean package -DskipTests

# Etapa 2: Imagen final con JRE
FROM eclipse-temurin:17-jre-alpine


WORKDIR /app

# Copiar el JAR desde la etapa de build
COPY --from=build /app/target/*.jar app.jar

# Exponer el puerto 8080
EXPOSE 8080


ENTRYPOINT ["java", "-jar", "app.jar"]
