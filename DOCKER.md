# Guía de Docker para Hangman API

Esta guía explica cómo ejecutar la aplicación Hangman usando Docker y Docker Compose.

## 📋 Prerrequisitos

- Docker Desktop o Docker Engine instalado
- Docker Compose (incluido en Docker Desktop)
- Al menos 2GB de RAM disponible

## 🚀 Inicio Rápido

### 1. Construir y ejecutar

```bash
# Construir las imágenes y levantar los contenedores
docker-compose up --build
```

Este comando:
- Construye la imagen de la aplicación Spring Boot
- Descarga la imagen de MySQL 8.0
- Crea la red y volúmenes necesarios
- Inicia ambos contenedores

### 2. Ejecutar en segundo plano

```bash
docker-compose up -d --build
```

### 3. Verificar que todo funciona

```bash
# Ver estado de los contenedores
docker-compose ps

# Ver logs de la aplicación
docker-compose logs -f app

# Probar la API
curl http://localhost:8080/api/players
```

## 📦 Servicios

### MySQL (Base de Datos)

- **Puerto**: 3306
- **Usuario root**: `root`
- **Contraseña root**: `root`
- **Base de datos**: `demobase`
- **Usuario adicional**: `demobase` / `demobase`
- **Volumen**: Los datos persisten en `mysql_data`

### Aplicación Spring Boot

- **Puerto**: 8080
- **Perfil activo**: `docker`
- **Healthcheck**: Verifica `/api/players` cada 30 segundos

## 🔧 Comandos Útiles

### Gestión de Contenedores

```bash
# Iniciar servicios
docker-compose up -d

# Detener servicios
docker-compose down

# Detener y eliminar volúmenes (borra datos)
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart app
docker-compose restart mysql

# Ver logs
docker-compose logs -f app
docker-compose logs -f mysql
docker-compose logs -f  # Todos los servicios
```

### Construcción

```bash
# Reconstruir solo la aplicación
docker-compose build app

# Reconstruir sin cache
docker-compose build --no-cache app

# Reconstruir todo
docker-compose build --no-cache
```

### Acceso a Contenedores

```bash
# Acceder al shell de la aplicación
docker-compose exec app sh

# Conectarse a MySQL
docker-compose exec mysql mysql -u root -proot demobase

# Ejecutar comandos SQL
docker-compose exec mysql mysql -u root -proot -e "SHOW DATABASES;"
```

### Inspección

```bash
# Ver uso de recursos
docker stats

# Ver información de red
docker network inspect hangman-network

# Ver información de volúmenes
docker volume inspect hangman_mysql_data
```

## 🗄️ Base de Datos

### Conectarse desde fuera de Docker

```bash
mysql -h localhost -P 3306 -u root -proot demobase
```

### Backup y Restore

```bash
# Backup
docker-compose exec mysql mysqldump -u root -proot demobase > backup.sql

# Restore
docker-compose exec -T mysql mysql -u root -proot demobase < backup.sql
```

### Reiniciar base de datos

```bash
# Detener y eliminar volúmenes
docker-compose down -v

# Volver a iniciar (creará una BD nueva)
docker-compose up -d
```

## 🔍 Troubleshooting

### La aplicación no se conecta a MySQL

1. Verificar que MySQL esté saludable:
```bash
docker-compose ps
```

2. Ver logs de MySQL:
```bash
docker-compose logs mysql
```

3. Verificar conectividad desde el contenedor de la app:
```bash
docker-compose exec app ping mysql
```

### Puerto ya en uso

Si el puerto 8080 o 3306 está en uso, puedes:

1. Cambiar los puertos en `docker-compose.yml`:
```yaml
ports:
  - "8081:8080"  # Cambiar puerto externo
```

2. O usar un archivo override (recomendado):
```bash
cp docker-compose.override.yml.example docker-compose.override.yml
# Editar docker-compose.override.yml con tus puertos
```

### La aplicación tarda mucho en iniciar

- Verificar logs: `docker-compose logs -f app`
- Aumentar el `start_period` en el healthcheck si es necesario
- Verificar que MySQL esté listo antes de que la app intente conectarse

### Reconstruir desde cero

```bash
# Detener y eliminar todo
docker-compose down -v

# Eliminar imágenes
docker rmi hangman-app

# Reconstruir
docker-compose build --no-cache
docker-compose up -d
```

## 📝 Variables de Entorno

Puedes personalizar la configuración mediante variables de entorno en `docker-compose.yml`:

- `SPRING_DATASOURCE_URL`: URL de conexión a MySQL
- `SPRING_DATASOURCE_USERNAME`: Usuario de MySQL
- `SPRING_DATASOURCE_PASSWORD`: Contraseña de MySQL
- `SPRING_JPA_HIBERNATE_DDL_AUTO`: Estrategia de DDL (update, create, etc.)
- `SPRING_SQL_INIT_MODE`: Modo de inicialización SQL (always, never)

## 🔒 Seguridad

⚠️ **Nota de Seguridad**: Las credenciales por defecto son para desarrollo. Para producción:

1. Usa variables de entorno o secrets de Docker
2. Cambia todas las contraseñas
3. No expongas MySQL directamente al exterior
4. Usa certificados SSL para conexiones

## 📚 Recursos Adicionales

- [Documentación de Docker Compose](https://docs.docker.com/compose/)
- [Documentación de MySQL Docker](https://hub.docker.com/_/mysql)
- [Spring Boot con Docker](https://spring.io/guides/gs/spring-boot-docker/)

