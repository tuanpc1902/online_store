# Online Store

An educational e-commerce platform with a Spring Boot API, React + TypeScript storefront, Vue 3 + TypeScript admin, and MySQL.

Read PROJECT_PLAN.md and docs/database-design.md first. The API owns all business writes; both frontends use its REST contract.

## Local setup

Requirements: JDK 25 (the LTS version used by this project), Maven 3.6.3+, Node.js 24+, npm, Docker Desktop. Vite 8 requires Node.js 20.19+ or 22.12+; Node 24 satisfies that requirement.

1. Copy .env.example to .env. Replace both password placeholders with the same strong local-only value.
2. Start the database from the repository root:
   docker compose --env-file .env -f infra/docker-compose.yml up -d
3. From apps/api run:
   mvn spring-boot:run
   Flyway applies V1 at startup and Hibernate validates the resulting schema.
4. Import database/seed/demo-data.sql once, after the schema exists, to add fictional sample rows. Do not import it twice.
5. From the repository root run npm install once.
6. Open two terminals and run npm run dev:storefront and npm run dev:admin.

Local addresses:
- Storefront: http://localhost:5173
- Admin: http://localhost:5174
- API health: http://localhost:8080/api/v1/health
- MySQL: localhost:13306 (change MYSQL_PORT and DB_PORT together in .env if occupied)

The seed contains no usable passwords. The health endpoint is public; other API routes require authentication. The first admin bootstrap and login flow are a later implementation milestone. Do not put real customer or payment data in this learning database.

