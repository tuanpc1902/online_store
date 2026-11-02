# Online Store

An educational e-commerce platform with a Spring Boot API, React + TypeScript storefront, Vue 3 + TypeScript admin, and MySQL.

Read PROJECT_PLAN.md and docs/database-design.md first. The API owns business writes; both frontends call its REST API.

## Requirements

- JDK 25. This project uses Spring Boot 3.5.16 and targets Java 25.
- Maven 3.6.3 or newer.
- Node.js 24 and npm. Vite 8 requires Node.js 20.19+ or 22.12+.
- MySQL 8.0.16+; Docker Desktop is optional.

## Option A: use an existing MySQL service

If MySQL80 is already running, use that server. Do not start another server on the same port.

1. In MySQL Workbench, connect to your local MySQL port as an account that can create databases. Create the database if missing:

       CREATE DATABASE IF NOT EXISTS ecommerce_platform
         CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

2. Check the ignored .env file in the repository root. Set DB_USER, DB_PASSWORD and DB_PORT to match your MySQL account and port.
3. Install JDK 25, Maven and Node.js 24 if needed. Open a new PowerShell and verify:

       java -version
       mvn -version
       node -v
       npm -v

   Java must report version 25. If only JDK 27 is available, install JDK 25 for this Spring Boot 3.5 project.
4. In the same PowerShell that will run the API, load .env into that process. Spring Boot does not read .env files automatically:

       cd "$env:TEMP\online-store"
       foreach ($line in Get-Content .env) {
         if ($line -match '^\s*([^#][^=]*)=(.*)$') {
           $name = $matches[1].Trim()
           $value = $matches[2].Trim()
           Set-Item -Path "Env:$name" -Value $value | Out-Null
         }
       }

5. Start the API in that PowerShell:

       cd "$env:TEMP\online-store\apps\api"
       mvn spring-boot:run

   Flyway applies V1 and creates the tables. Do not manually import the full schema SQL on this route.
6. After the API starts successfully, open database/seed/demo-data.sql in Workbench and run it once. It inserts fictional demo records.
7. In a second PowerShell, install frontend packages from the repository root:

       cd "$env:TEMP\online-store"
       npm install

8. Start each frontend in a separate PowerShell window from the repository root:

       npm run dev:storefront

       npm run dev:admin

## Option B: run MySQL in Docker

Use this instead of the existing MySQL service if you want an isolated database. Docker Desktop must be installed and running.

1. Copy .env.example to .env only if it does not already exist. In .env set MYSQL_ROOT_PASSWORD and DB_PASSWORD to the same local password; set DB_USER=root, MYSQL_PORT=13307 and DB_PORT=13307.
2. Compose maps the container to host port 13307 by default. Keep MYSQL_PORT and DB_PORT equal.
3. From the repository root run:

       docker compose --env-file .env -f infra/docker-compose.yml up -d

4. In the API PowerShell, load .env using step 4 above, then follow steps 5 through 8. Flyway creates the schema.

Do not run two database servers on the same host port.

## Local URLs

- Storefront: http://localhost:5173
- Admin: http://localhost:5174
- Public API health: http://localhost:8080/api/v1/health
- Existing MySQL: localhost on the DB_PORT configured in .env
- Optional Docker MySQL: localhost:13307

The health endpoint is public; other API routes require authentication. Login and admin bootstrap are not implemented yet. Dashboard metrics and storefront collections are placeholders, not live database data.

