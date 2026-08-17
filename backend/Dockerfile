
# Étape 1 : build avec Maven
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copier uniquement le pom.xml d'abord pour profiter du cache Docker
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier le reste du code source et builder
COPY src ./src
RUN mvn clean package -DskipTests -B

# Étape 2 : image finale, légère, sans Maven
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Récupère uniquement le .jar compilé depuis l'étape précédente
COPY --from=build /app/target/*.jar app.jar

# Render fournit la variable PORT — l'app doit écouter dessus (déjà géré dans application.yml)
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]