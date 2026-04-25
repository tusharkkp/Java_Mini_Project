# 📖 Disaster Relief Volunteer Coordination System — Technical Documentation

## 1. ER Diagram (Textual Description)

```
┌──────────────┐    M:N     ┌──────────────┐
│    USERS     │◄──────────►│    ROLES     │
│──────────────│  user_roles │──────────────│
│ id (PK)      │            │ id (PK)      │
│ username     │            │ name         │
│ password     │            └──────────────┘
│ email        │
│ full_name    │    1:1     ┌──────────────────┐
│ phone        │───────────►│   VOLUNTEERS     │
│ created_at   │            │──────────────────│
│ enabled      │            │ id (PK)          │
└──────┬───────┘            │ user_id (FK)     │
       │                    │ latitude         │
       │ 1:N                │ longitude        │
       │                    │ available        │
       ▼                    │ skills           │
┌──────────────────┐        │ tasks_completed  │
│  SOS_REQUESTS    │        └────────┬─────────┘
│──────────────────│                 │
│ id (PK)          │                 │ M:1
│ user_id (FK)     │    1:N    ┌─────┴────────────┐
│ latitude         │──────────►│     TASKS         │
│ longitude        │           │───────────────────│
│ location_name    │           │ id (PK)           │
│ description      │           │ sos_request_id(FK)│
│ severity (ENUM)  │           │ volunteer_id (FK) │
│ status (ENUM)    │           │ status (ENUM)     │
│ created_at       │           │ assigned_at       │
│ resolved_at      │           │ completed_at      │
│ response_time_ms │           │ notes             │
└──────────────────┘           └───────────────────┘

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  NOTIFICATIONS   │     │    LOCATIONS      │     │  SOS_AUDIT_LOG   │
│──────────────────│     │──────────────────│     │──────────────────│
│ id (PK)          │     │ id (PK)          │     │ id (PK)          │
│ user_id (FK)     │     │ name             │     │ sos_request_id   │
│ message          │     │ latitude         │     │ action           │
│ type             │     │ longitude        │     │ details          │
│ is_read          │     │ area_type        │     │ performed_by     │
│ created_at       │     │ description      │     │ created_at       │
└──────────────────┘     └──────────────────┘     └──────────────────┘
```

### JPA Relationships Summary:
- **User ↔ Role**: `@ManyToMany` via `user_roles` join table
- **User → Volunteer**: `@OneToOne` (mappedBy in User, JoinColumn in Volunteer)
- **User → SosRequest**: `@OneToMany` / `@ManyToOne`
- **User → Notification**: `@OneToMany` / `@ManyToOne`
- **SosRequest → Task**: `@OneToMany` / `@ManyToOne`
- **Volunteer → Task**: reverse `@ManyToOne`

---

## 2. Class Diagram (Textual)

```
┌─────────────────────────┐
│   DisasterReliefApp     │  @SpringBootApplication
│─────────────────────────│  @EnableAsync
│ + main()                │  @EnableScheduling
└─────────────────────────┘

ENTITY LAYER:
┌──────────┐  ┌──────────┐  ┌────────────┐  ┌──────────────┐
│   User   │  │   Role   │  │  Volunteer │  │  SosRequest  │
│  @Entity │  │  @Entity │  │   @Entity  │  │   @Entity    │
└──────────┘  └──────────┘  └────────────┘  └──────────────┘
┌──────────┐  ┌──────────────┐  ┌──────────────┐
│   Task   │  │ Notification │  │   Location   │
│  @Entity │  │   @Entity    │  │   @Entity    │
└──────────┘  └──────────────┘  └──────────────┘

REPOSITORY LAYER:
┌─────────────────────┐  ┌───────────────────────┐
│  UserRepository     │  │  VolunteerRepository  │
│  @Repository        │  │  @Repository (HQL)    │
│  extends JpaRepo    │  │  extends JpaRepo      │
└─────────────────────┘  └───────────────────────┘
┌─────────────────────┐  ┌───────────────────────┐
│  SosRequestRepo     │  │  JdbcSosLogRepo       │
│  @Repository (HQL)  │  │  @Repository (JDBC)   │
│  extends JpaRepo    │  │  PreparedStatement    │
└─────────────────────┘  └───────────────────────┘

SERVICE LAYER:
┌─────────────────────┐  ┌───────────────────────────┐
│  UserService        │  │  NotificationService      │
│  @Service           │  │  @Service + @Async        │
└─────────────────────┘  └───────────────────────────┘
┌─────────────────────┐  ┌───────────────────────────┐
│  SosRequestService  │  │  ScheduledTaskService     │
│  @Service           │  │  @Service + @Scheduled    │
└─────────────────────┘  └───────────────────────────┘
┌─────────────────────┐  ┌───────────────────────────┐
│  VolunteerService   │  │  SdgMetricsService        │
│  @Service           │  │  @Service                 │
└─────────────────────┘  └───────────────────────────┘

CONTROLLER LAYER:
┌─────────────────┐  ┌──────────────────┐  ┌─────────────────┐
│ AuthController  │  │ SosController    │  │ VolunteerCtrl   │
│ @Controller     │  │ @Controller      │  │ @Controller     │
└─────────────────┘  └──────────────────┘  └─────────────────┘
┌─────────────────┐  ┌──────────────────┐
│ AdminController │  │ RestApiController│
│ @Controller     │  │ @RestController  │
└─────────────────┘  └──────────────────┘

CONFIG:
┌─────────────────────┐  ┌───────────────────────┐
│  SecurityConfig     │  │  RequestLoggingFilter  │
│  @Configuration     │  │  implements Filter     │
└─────────────────────┘  └───────────────────────┘

SOCKET:
┌─────────────────────────┐  ┌───────────────────────┐
│  SosAlertSocketServer   │  │ VolunteerSocketClient │
│  @Component             │  │  (Standalone)         │
│  ServerSocket + Thread  │  │  Socket + Thread      │
└─────────────────────────┘  └───────────────────────┘
```

---

## 3. API Endpoints List

### MVC Endpoints (Returns JSP Views):

| Method | URL | Access | Description |
|--------|-----|--------|-------------|
| GET | / | Public | Redirects to login |
| GET | /login | Public | Login page |
| GET/POST | /register | Public | Registration |
| GET | /user/dashboard | ROLE_USER | User dashboard |
| GET/POST | /user/sos/create | ROLE_USER | Create SOS |
| GET | /user/notifications | ROLE_USER | View notifications |
| GET | /volunteer/dashboard | ROLE_VOLUNTEER | Volunteer dashboard |
| GET | /volunteer/tasks | ROLE_VOLUNTEER | Task list |
| POST | /volunteer/toggle-availability | ROLE_VOLUNTEER | Toggle status |
| POST | /volunteer/update-location | ROLE_VOLUNTEER | Update coords |
| POST | /volunteer/task/{id}/update | ROLE_VOLUNTEER | Update task status |
| GET | /admin/dashboard | ROLE_ADMIN | Admin dashboard |
| GET | /admin/sos | ROLE_ADMIN | All SOS requests |
| GET | /admin/sos/{id} | ROLE_ADMIN | SOS detail + assign |
| POST | /admin/sos/{id}/assign | ROLE_ADMIN | Assign volunteer |
| GET | /admin/volunteers | ROLE_ADMIN | Volunteer list |
| GET | /admin/users | ROLE_ADMIN | User management |
| GET | /admin/sdg-metrics | ROLE_ADMIN | SDG metrics |

### REST API Endpoints (Returns JSON):

| Method | URL | Description |
|--------|-----|-------------|
| GET | /api/v1/sos | All SOS requests |
| GET | /api/v1/sos/{id} | SOS detail |
| GET | /api/v1/sos/status/{status} | Filter by status |
| GET | /api/v1/volunteers | All volunteers |
| GET | /api/v1/volunteers/available | Available volunteers |
| GET | /api/v1/tasks | All tasks |
| GET | /api/v1/metrics | SDG metrics |

---

## 4. Multithreading Explanation

### @Async (NotificationService)
- Methods annotated with `@Async` execute in a separate thread pool
- Configured in `AsyncConfig.java` with `ThreadPoolTaskExecutor`
- When SOS is created, notifications are sent asynchronously — the HTTP response returns immediately while notifications are processed in background threads
- Thread pool: 5 core, 10 max, 100 queue capacity

### @Scheduled (ScheduledTaskService)
- `checkUnassignedSos()` runs every 60 seconds — finds SOS requests unassigned for >5 minutes and escalates them
- `logSystemHealth()` runs every 5 minutes — logs system metrics
- Configured via `spring.task.scheduling.pool.size=3`

---

## 5. Socket Programming Explanation

### Server (SosAlertSocketServer)
- Creates `ServerSocket` on port 9090 at application startup (`@PostConstruct`)
- Runs in a daemon thread to avoid blocking Spring Boot
- Each client connection spawns a new `Thread` running `ClientHandler`
- Maintains thread-safe `CopyOnWriteArrayList<PrintWriter>` of connected clients
- `broadcastMessage()` sends to all connected clients

### Client (VolunteerSocketClient)
- Creates `Socket` connection to `localhost:9090`
- Spawns listener thread for receiving messages
- Parses SOS alert format: `SOS|id|severity|lat|lng|location|description`
- Can be run standalone via `main()` method

---

## 6. JDBC Usage Explanation

### JdbcSosLogRepository
- Uses `@Autowired DataSource` for database connections
- All operations use `PreparedStatement` with parameter binding (prevents SQL injection)
- **Batch Insert**: Uses `addBatch()` and `executeBatch()` for efficient multi-row inserts
- **Bulk Update**: Batch updates task statuses using PreparedStatement
- **ResultSet Processing**: Reads audit logs with `rs.next()` iteration
- **Table Creation**: DDL execution via `Statement`
- Manual `Connection`, `PreparedStatement`, `ResultSet` management with try-with-resources
