# 🚨 Disaster Relief Volunteer Coordination System

[![Java](https://img.shields.io/badge/Java-21-ED8B00?logo=java&logoColor=white)](https://www.java.com/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-4.0.6-6DB33F?logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Active%20Development-brightgreen)](#)

> **Enterprise-grade emergency response coordination platform** leveraging real-time socket communication, async task dispatch, and geolocation-based volunteer assignment to enable rapid disaster relief operations.

---

## 🎯 Problem Statement

Disaster relief operations require **rapid coordination** between victims and available volunteers. Traditional systems suffer from:
- ⏱️ **Delayed response times** — No real-time alert mechanism
- 📍 **Inefficient assignment** — Manual volunteer selection, no distance optimization
- 🔄 **No escalation** — Unhandled emergencies pile up
- 📊 **Poor visibility** — Admins lack operational metrics and SDG tracking
- 🔐 **Security gaps** — Unauthenticated access, role confusion

**This system solves these problems** through real-time socket broadcasting, intelligent distance-based assignment, automatic escalation, and comprehensive admin dashboards.

---

## ✨ Key Features

### 👥 User Management
- **Role-based Access Control (RBAC)** — Three distinct roles: User, Volunteer, Admin
- **Spring Security Integration** — Encrypted passwords, session management, CSRF protection
- **User Registration & Profile Management** — Self-service account creation

### 🚨 Emergency SOS Requests
- **Real-time SOS Creation** — Users report emergencies with location, severity, description
- **4 Severity Levels** — LOW, MEDIUM, HIGH, CRITICAL (for prioritization)
- **Multi-status Lifecycle** — NEW → ACTIVE → ASSIGNED → RESOLVED/ESCALATED
- **Audit Logging** — JDBC-based audit trail for compliance

### 👨‍💼 Volunteer Management
- **Availability Toggle** — Volunteers activate/deactivate status in real-time
- **Location Tracking** — Latitude/longitude coordinates for geolocation services
- **Skills Matching** — Categorize volunteers by expertise (medical, logistics, etc.)
- **Performance Metrics** — Track tasks completed and average response time

### 📡 Real-time Communication
- **Socket Server Broadcasting** — Java ServerSocket on port 9090 broadcasts SOS alerts to connected volunteers
- **Zero-latency Notifications** — Async notification service for immediate multi-channel updates
- **Multithreaded Architecture** — `@Async` and `@Scheduled` for concurrent operations

### 🗺️ Intelligent Volunteer Assignment
- **Haversine Distance Calculation** — Automatically select nearest available volunteers
- **Location-aware Dispatch** — Reduce response times via geospatial queries
- **Batch Task Assignment** — Assign multiple volunteers to high-severity incidents

### 📊 Admin Dashboard & Analytics
- **Operational Metrics** — Real-time SOS status, volunteer availability, response times
- **SDG Integration** — Track Sustainable Development Goal 11 (Sustainable Cities) and SDG 13 (Climate Action)
- **Response Time Analytics** — Measure average response time and % handled within threshold
- **Audit Trail Visualization** — Complete history of SOS lifecycle

### ⏰ Automatic Escalation
- **Scheduled Task Service** — Every 60 seconds, checks for unassigned SOS >5 minutes old
- **Auto-escalation Trigger** — Escalates priority to recruit additional help
- **Health Monitoring** — Periodic system health checks and performance logging

---

## 🏗️ Architecture & Workflow

### System Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                       │
│  JSP Views | JSTL Tags | REST API Controllers               │
└────────────┬────────────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────────────┐
│                    SERVICE LAYER                             │
│  UserService | SosRequestService | NotificationService     │
│  VolunteerService | ScheduledTaskService | SDG Metrics      │
│  @Async @Scheduled @Transactional                           │
└────────────┬────────────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────────────┐
│                  REPOSITORY LAYER                            │
│  Spring Data JPA | HQL Queries | Raw JDBC PreparedStatement │
└────────────┬────────────────────────────────────────────────┘
             │
┌────────────▼────────────────────────────────────────────────┐
│                   PERSISTENCE LAYER                          │
│  Hibernate ORM | MySQL Database (9 Tables, Relationships)   │
└──────────────────────────────────────────────────────────────┘
```

### Emergency Response Workflow
```
User Reports SOS
    ↓ (Spring Controller)
SosRequestService.createSosRequest()
    ↓ (Saves to DB)
JPA Repository persistence
    ↓ (Triggers async tasks)
├─→ NotificationService (@Async) → Multi-channel alert to volunteers
├─→ SosAlertSocketServer.broadcast() → Real-time socket message
└─→ JdbcSosLogRepository.insertAuditLog() → Audit trail
    ↓ (Admin views pending SOS)
AdminController lists unassigned SOS
    ↓ (Admin assigns volunteers)
VolunteerService finds nearest via Haversine
    ↓ (Creates tasks)
TaskService creates Task assignments
    ↓ (Scheduled service checks escalation)
ScheduledTaskService checks every 60s
    ↓ (If unassigned >5 min)
Auto-escalate → Recruit additional help
```

### Socket Communication Flow
```
┌──────────────────────┐                    ┌────────────────────┐
│ SosAlertSocketServer │                    │ VolunteerSocketClient│
│ (ServerSocket:9090)  │                    │ (Multiple Instances) │
└──────────┬───────────┘                    └─────────┬──────────┘
           │                                          │
    Listen on port 9090                    Connect to port 9090
           │◄─────────────────────────────────────────│
           │         Socket Connection Established    │
           │                                          │
    SOS Created                           Waiting for alerts
           │                                          │
           ├─────── SOS Broadcast ────────────────────►
           │ Format: SOS|id|severity|lat|lng|loc|desc │
           │                                          │
           │                                  Parse & Display
           │                                          │
```

### Database Schema Relationships
```
USERS (1) ─── (M) SOS_REQUESTS
  │
  └─── (1) VOLUNTEERS
         │
         └─── (M) TASKS ──── (M) SOS_REQUESTS
  │
  ├─── (M) NOTIFICATIONS
  │
  └─── (M) USER_ROLES ─── ROLES

SOS_REQUESTS
  │
  └─── (1:N) TASKS (audit via SOS_AUDIT_LOG)

LOCATIONS (reference table for geography)
```

---

## 🛠️ Technology Stack

### Backend Framework
| Technology | Version | Purpose |
|-----------|---------|---------|
| **Spring Boot** | 4.0.6 | Application framework & dependency injection |
| **Spring MVC** | 4.0.6 | Web layer, controller routing, JSP rendering |
| **Spring Security** | 4.0.6 | Authentication, authorization, RBAC, password encryption |
| **Spring Data JPA** | 4.0.6 | ORM abstraction layer, repository pattern |

### Database & ORM
| Technology | Version | Purpose |
|-----------|---------|---------|
| **Hibernate JPA** | Latest | Object-relational mapping, entity management |
| **MySQL** | 8.x | Primary data store (9 tables) |
| **MySQL Connector-J** | Latest | JDBC driver for MySQL connectivity |
| **Raw JDBC** | Jakarta | PreparedStatement for audit logging, batch operations |

### Frontend
| Technology | Purpose |
|-----------|---------|
| **JSP (Jakarta Server Pages)** | Server-side templating, dynamic HTML generation |
| **JSTL** | JSP Standard Tag Library for loops, conditionals, formatting |
| **CSS** | Styling (5.6% of codebase) |

### Real-time Communication
| Technology | Purpose |
|-----------|---------|
| **Java Socket Programming** | Low-level TCP socket communication (ServerSocket, Socket) |
| **Multithreading** | Concurrent client handling via Thread pool |
| **CopyOnWriteArrayList** | Thread-safe volunteer client list management |

### Async & Scheduling
| Technology | Purpose |
|-----------|---------|
| **@Async** | Asynchronous notification dispatch (ThreadPoolTaskExecutor) |
| **@Scheduled** | Periodic escalation checks, health monitoring |
| **Spring Task Scheduling** | Configurable thread pool for background jobs |

### Build & Dependency Management
| Technology | Purpose |
|-----------|---------|
| **Maven** | Build automation, dependency resolution |
| **Maven Wrapper** | Consistent Maven version across environments |
| **Spring Boot Maven Plugin** | Packaging as executable JAR or WAR |

---

## 📋 Installation & Setup

### Prerequisites
```bash
✓ Java 21 or higher
✓ MySQL 8.x
✓ Git (for cloning)
✓ No Maven installation needed (Maven Wrapper included)
```

### Step 1: Clone Repository
```bash
git clone https://github.com/tusharkkp/Java_Mini_Project.git
cd Java_Mini_Project
```

### Step 2: Database Setup
```bash
# Login to MySQL
mysql -u root -p

# Create database and user
CREATE DATABASE disaster_relief_db;
CREATE USER 'disaster_user'@'localhost' IDENTIFIED BY 'disaster_password';
GRANT ALL PRIVILEGES ON disaster_relief_db.* TO 'disaster_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 3: Configure Database Connection
Edit `src/main/resources/application.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/disaster_relief_db
spring.datasource.username=disaster_user
spring.datasource.password=disaster_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate Configuration
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true

# Server & Socket Configuration
server.port=8081
socket.server.port=9090

# Async & Task Configuration
spring.task.execution.pool.core-size=5
spring.task.execution.pool.max-size=10
spring.task.scheduling.pool.size=3
```

### Step 4: Run Application

**Windows:**
```bash
.\mvnw.cmd spring-boot:run
```

**Linux/Mac:**
```bash
./mvnw spring-boot:run
```

### Step 5: Access Application
```
Web Application:   http://localhost:8081
Socket Server:     Port 9090 (backend)
API Base URL:      http://localhost:8081/api/v1
```

---

## 🔐 Default Test Credentials

| Role | Username | Password | Access |
|------|----------|----------|--------|
| **Admin** | admin | admin123 | Full system access, dashboards, user management |
| **Volunteer** | volunteer1 | vol123 | View tasks, update availability, track assignments |
| **User** | user1 | user123 | Create SOS requests, track volunteer responses |

> ⚠️ **Production Security**: Change all default credentials and enable HTTPS before deploying to production.

---

## 📡 API Endpoints

### REST API (JSON Responses)

#### SOS Requests
```http
GET    /api/v1/sos                    # List all SOS requests
GET    /api/v1/sos/{id}               # Get specific SOS detail
GET    /api/v1/sos/status/{status}    # Filter SOS by status
```

#### Volunteers
```http
GET    /api/v1/volunteers             # List all volunteers
GET    /api/v1/volunteers/available   # List available volunteers only
```

#### Tasks
```http
GET    /api/v1/tasks                  # List all task assignments
GET    /api/v1/tasks/{id}             # Get task detail
```

#### Metrics
```http
GET    /api/v1/metrics                # SDG metrics & analytics
```

### MVC Endpoints (JSP Views)

#### Authentication
```http
GET    /                              # Redirects to login
GET    /login                         # Login page
GET    /register                      # Registration page
POST   /register                      # Process registration
```

#### User Dashboard
```http
GET    /user/dashboard                # User home (ROLE_USER)
GET    /user/sos/create               # Create SOS form
POST   /user/sos/create               # Submit SOS request
GET    /user/notifications            # View notifications
```

#### Volunteer Dashboard
```http
GET    /volunteer/dashboard           # Volunteer home (ROLE_VOLUNTEER)
GET    /volunteer/tasks               # Task list
POST   /volunteer/toggle-availability # Toggle status
POST   /volunteer/update-location     # Update coordinates
POST   /volunteer/task/{id}/update    # Update task status
```

#### Admin Dashboard
```http
GET    /admin/dashboard               # Admin home (ROLE_ADMIN)
GET    /admin/sos                     # All SOS requests
GET    /admin/sos/{id}                # SOS detail & assign form
POST   /admin/sos/{id}/assign         # Assign volunteer to SOS
GET    /admin/volunteers              # Volunteer management
GET    /admin/users                   # User management
GET    /admin/sdg-metrics             # SDG metrics dashboard
```

---

## 📊 Database Schema

### Tables Overview
```sql
-- User Management
users              -- User accounts (id, username, password, email, full_name, phone, created_at, enabled)
roles              -- Role definitions (id, name)
user_roles         -- User-Role mapping (user_id, role_id) [Join Table]

-- Emergency Response
sos_requests       -- SOS emergency requests (id, user_id, latitude, longitude, location_name, description, severity, status, created_at, resolved_at, response_time_ms)
volunteers         -- Volunteer profiles (id, user_id, latitude, longitude, available, skills, tasks_completed, avg_response_time_ms)
tasks              -- Volunteer task assignments (id, sos_request_id, volunteer_id, status, assigned_at, completed_at, notes)

-- Support Data
locations          -- Predefined geographic areas (id, name, latitude, longitude, area_type, description)
notifications      -- System notifications (id, user_id, message, type, is_read, created_at)
sos_audit_log      -- JDBC audit trail (id, sos_request_id, action, details, performed_by, created_at)
```

### Key Relationships
- **User ↔ Role**: `@ManyToMany` via `user_roles` join table
- **User → Volunteer**: `@OneToOne` mapping
- **User → SOS Request**: `@OneToMany` relationship
- **SOS Request → Task**: `@OneToMany` with multiple volunteer assignments
- **Volunteer → Task**: Reverse `@ManyToOne` relationship

---

## 🌍 SDG Alignment

This project supports UN Sustainable Development Goals:

### 🏙️ SDG 11: Sustainable Cities and Communities
- Objective: Make cities inclusive, safe, resilient, and sustainable
- Implementation: Real-time emergency response coordination reduces disaster impact and improves city resilience
- Metrics: Average response time, % of emergencies handled within SLA

### 🌍 SDG 13: Climate Action
- Objective: Take urgent action to combat climate change and its impacts
- Implementation: Enables rapid deployment of volunteers for climate-related disasters
- Metrics: Number of climate emergencies handled, volunteer mobilization speed

**Tracked via Admin Dashboard**: Response time analytics, volunteer utilization rates, emergency resolution rates

---

## 📁 Project Structure

```
Java_Mini_Project/
│
├── src/main/
│   ├── java/com/disasterrelief/
│   │   ├── DisasterReliefApplication.java        [Main Spring Boot Entry Point]
│   │   │
│   │   ├── entity/                               [JPA Entities]
│   │   │   ├── User.java                         [@Entity, RBAC user accounts]
│   │   │   ├── Role.java                         [@Entity, role definitions]
│   │   │   ├── Volunteer.java                    [@Entity, volunteer profiles]
│   │   │   ├── SosRequest.java                   [@Entity, emergency requests]
│   │   │   ├── Task.java                         [@Entity, volunteer assignments]
│   │   │   ├── Notification.java                 [@Entity, system notifications]
│   │   │   ├── Location.java                     [@Entity, geographic data]
│   │   │   └── enums/
│   │   │       ├── SeverityLevel.java            [LOW, MEDIUM, HIGH, CRITICAL]
│   │   │       ├── SosStatus.java                [NEW, ACTIVE, ASSIGNED, RESOLVED, ESCALATED]
│   │   │       └── TaskStatus.java               [PENDING, ASSIGNED, IN_PROGRESS, COMPLETED]
│   │   │
│   │   ├── repository/                           [Data Access Layer]
│   │   │   ├── UserRepository.java               [@Repository, Spring Data JPA]
│   │   │   ├── VolunteerRepository.java          [@Repository, HQL custom queries]
│   │   │   ├── SosRequestRepository.java         [@Repository, HQL distance queries]
│   │   │   ├── TaskRepository.java               [@Repository, JPA queries]
│   │   │   └── JdbcSosLogRepository.java         [@Repository, Raw JDBC & PreparedStatement]
│   │   │
│   │   ├── service/                              [Business Logic Layer]
│   │   │   ├── UserService.java                  [User registration, authentication]
│   │   │   ├── SosRequestService.java            [SOS creation, socket broadcast]
│   │   │   ├── VolunteerService.java             [Volunteer management, Haversine]
│   │   │   ├── NotificationService.java          [@Service, @Async notification dispatch]
│   │   │   ├── ScheduledTaskService.java         [@Service, @Scheduled escalation checks]
│   │   │   ├── SdgMetricsService.java            [@Service, SDG analytics]
│   │   │   └── CustomUserDetailsService.java     [Spring Security integration]
│   │   │
│   │   ├── controller/                           [Web Layer]
│   │   │   ├── AuthController.java               [@Controller, login/register pages]
│   │   │   ├── UserController.java               [@Controller, user dashboard]
│   │   │   ├── VolunteerController.java          [@Controller, volunteer views]
│   │   │   ├── AdminController.java              [@Controller, admin dashboards]
│   │   │   └── RestApiController.java            [@RestController, /api/v1/* JSON endpoints]
│   │   │
│   │   ├── config/                               [Spring Configuration]
│   │   │   ├── SecurityConfig.java               [@Configuration, Spring Security setup]
│   │   │   ├── AsyncConfig.java                  [@Configuration, @Async thread pool]
│   │   │   ├── RequestLoggingFilter.java         [Servlet Filter for request logging]
│   │   │   └── DataInitializer.java              [@Component, initial data setup]
│   │   │
│   │   └── socket/                               [Real-time Communication]
│   │       ├── SosAlertSocketServer.java         [ServerSocket on port 9090, broadcast]
│   │       ├── ClientHandler.java                [Runnable for individual client threads]
│   │       └── VolunteerSocketClient.java        [Client socket connection (standalone)]
│   │
│   └── resources/
│       ├── application.properties                [Spring Boot configuration]
│       ├── schema.sql                            [Database DDL scripts]
│       └── data.sql                              [Sample data initialization]
│
├── src/main/webapp/
│   └── WEB-INF/views/
│       ├── login.jsp                             [Login page]
│       ├── register.jsp                          [Registration page]
│       ├── user/
│       │   ├── dashboard.jsp                     [User home]
│       │   ├── create-sos.jsp                    [SOS creation form]
│       │   └── notifications.jsp                 [Notification list]
│       ├── volunteer/
│       │   ├── dashboard.jsp                     [Volunteer home]
│       │   ├── tasks.jsp                         [Task list]
│       │   └── task-detail.jsp                   [Task detail & update form]
│       └── admin/
│           ├── dashboard.jsp                     [Admin home with real-time metrics]
│           ├── sos-list.jsp                      [All SOS requests]
│           ├── sos-detail.jsp                    [SOS detail & volunteer assignment]
│           ├── volunteers.jsp                    [Volunteer management]
│           ├── users.jsp                         [User management]
│           └── sdg-metrics.jsp                   [SDG 11/13 analytics]
│
├── pom.xml                                       [Maven configuration]
├── README.md                                     [This file]
├── DOCUMENTATION.md                              [Technical deep-dive]
├── LICENSE                                       [MIT License]
└── Project_Report.pdf                            [Academic project report]
```

---

## 🚀 Usage Examples

### Example 1: User Creates SOS Request
```bash
# User logs in → navigates to /user/sos/create
# Fills form:
POST /user/sos/create
  latitude=28.6139
  longitude=77.2090
  locationName="Delhi City Center"
  description="Building collapse, multiple trapped"
  severity=CRITICAL

# Response:
# ✅ SOS request #42 created
# → Service sends @Async notifications to all available volunteers
# → SosAlertSocketServer broadcasts via socket
# → JdbcSosLogRepository logs audit trail
# → Admin dashboard shows new SOS
```

### Example 2: Volunteer Receives Alert
```bash
# Volunteer has socket client connected
# SOS broadcast received:
SOS|42|CRITICAL|28.6139|77.2090|Delhi City Center|Building collapse, multiple trapped

# Client parses and displays
# Volunteer logs in → sees task assignment
# Updates task status: /volunteer/task/42/update
POST /volunteer/task/42/update
  status=IN_PROGRESS

# Response:
# ✅ Task updated
# → Admin notified of progress
# → Audit log records action
```

### Example 3: Admin Assigns Volunteers
```bash
# Admin views /admin/sos/42
# Clicks "Assign Volunteers"
# System calculates nearest available via Haversine formula

POST /admin/sos/42/assign
  volunteerIds=[5,7,12]
  severity=CRITICAL

# Response:
# ✅ 3 tasks created
# → Volunteers receive notifications
# → Socket broadcasts to all clients
# → Response time counter starts
```

### Example 4: Scheduled Escalation Trigger
```bash
# ScheduledTaskService.checkUnassignedSos() runs every 60 seconds
# Found: SOS #38 unassigned for 6 minutes
# Action: Auto-escalate to HIGH priority
# Notification sent to admins
# System attempts to find volunteers again
```

---

## 🔧 Configuration

### Application Properties
```properties
# Server
server.port=8081
server.servlet.context-path=/

# Database
spring.datasource.url=jdbc:mysql://localhost:3306/disaster_relief_db
spring.datasource.username=disaster_user
spring.datasource.password=disaster_password
spring.jpa.hibernate.ddl-auto=create-drop

# Socket
socket.server.port=9090

# Async & Scheduling
spring.task.execution.pool.core-size=5
spring.task.execution.pool.max-size=10
spring.task.scheduling.pool.size=3

# Logging
logging.level.root=INFO
logging.level.com.disasterrelief=DEBUG
```

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| **MySQL connection refused** | Ensure MySQL is running: `sudo systemctl start mysql` |
| **Port 8081 already in use** | Change `server.port` in application.properties |
| **Socket port 9090 in use** | Change `socket.server.port` configuration |
| **JAR dependencies not found** | Run `./mvnw clean install` |
| **JSP pages not rendering** | Ensure `tomcat-embed-jasper` dependency is installed |
| **Socket server not starting** | Check firewall rules for port 9090 |

---

## 📚 Documentation

- **[DOCUMENTATION.md](DOCUMENTATION.md)** — Technical deep-dive: ER diagrams, class diagrams, API specs, multithreading explanations, socket architecture, JDBC usage
- **[Project_Report.pdf](Project_Report.pdf)** — Academic project report with requirements, design, and implementation details

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
   ```bash
   git clone https://github.com/tusharkkp/Java_Mini_Project.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Commit changes**
   ```bash
   git commit -m "Add: brief description of changes"
   ```

4. **Push to branch**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Open a Pull Request**
   - Describe your changes clearly
   - Reference any related issues

### Contribution Areas
- 🐛 Bug fixes and error handling improvements
- ✨ New features (e.g., SMS notifications, email alerts)
- 📖 Documentation improvements
- 🎨 UI/UX enhancements
- ⚡ Performance optimizations
- 🧪 Additional test coverage

---

## 📄 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) file for details.

**MIT License Summary:**
- ✅ Free to use, modify, and distribute
- ✅ Must include license and copyright notice
- ✅ No warranty provided
- ❌ Cannot hold author liable

---

## 👤 Author & Credits

**Developed by:** [Tushar Kaldate](https://github.com/tusharkkp)

### Connect
- 🐙 **GitHub:** [@tusharkkp](https://github.com/tusharkkp)
- 💼 **LinkedIn:** [Tushar Kaldate](https://www.linkedin.com/in/tushar-kaldate-2b5276262/)
- 📧 **Email:** [Contact via GitHub](https://github.com/tusharkkp)

### Acknowledgments
- Spring Boot team for excellent framework
- MySQL for reliable database
- OpenStreetMap community for geolocation inspiration
- UN SDG framework for social impact alignment

---

## 🎓 Learning & References

This project demonstrates:
- ✅ **Spring Boot MVC** — Web application development
- ✅ **Spring Security** — Authentication & authorization
- ✅ **Spring Data JPA & Hibernate** — ORM and persistence
- ✅ **Raw JDBC** — Low-level database operations
- ✅ **Socket Programming** — Real-time communication
- ✅ **Multithreading** — @Async, @Scheduled, Thread pools
- ✅ **RESTful APIs** — JSON endpoints
- ✅ **JSP & JSTL** — Server-side templating
- ✅ **Database Design** — Relationships, indexing, audit logging

**Perfect for:**
- 📚 Learning Spring Boot enterprise patterns
- 🎓 Understanding full-stack Java development
- 💼 Portfolio demonstration
- 🏆 Hackathon projects
- 📊 Academic coursework

---

## 📊 Project Metrics

| Metric | Value |
|--------|-------|
| **Language** | Java (94.4%), CSS (5.6%) |
| **Framework** | Spring Boot 4.0.6 |
| **Database** | MySQL 8.x |
| **Tables** | 9 entity tables + 1 audit table |
| **REST Endpoints** | 7 core APIs |
| **MVC Views** | 12+ JSP templates |
| **Async Tasks** | Configurable thread pool (5-10 threads) |
| **Scheduled Jobs** | 2 (escalation checker, health monitor) |
| **Security Roles** | 3 (ADMIN, VOLUNTEER, USER) |
| **Real-time Features** | Socket broadcasting, async notifications |

---

## 🗺️ Roadmap & Future Enhancements

### Short-term (v1.1)
- [ ] SMS/Email notifications integration (Twilio, SendGrid)
- [ ] Real-time map visualization (Leaflet.js, Google Maps API)
- [ ] Mobile app companion (React Native)
- [ ] Two-factor authentication (2FA)

### Medium-term (v1.2-v2.0)
- [ ] Machine learning volunteer matching
- [ ] Advanced analytics & reporting
- [ ] Multi-language support (i18n)
- [ ] Deployment guides (Docker, Kubernetes)
- [ ] CI/CD pipeline (GitHub Actions)

### Long-term (v2.0+)
- [ ] Microservices architecture
- [ ] GraphQL API
- [ ] Real-time collaboration features
- [ ] Integration with emergency services APIs
- [ ] Global deployment & scaling

---

## 🆘 Support & Issues

Found a bug or have a feature request?

1. **Check existing issues** — https://github.com/tusharkkp/Java_Mini_Project/issues
2. **Create new issue** — Include:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (Java version, OS, MySQL version)
3. **Join discussions** — https://github.com/tusharkkp/Java_Mini_Project/discussions

---

## ⭐ Show Your Support

If this project helped you, please:
- ⭐ **Star this repository**
- 🔖 **Fork for your use case**
- 💬 **Share feedback and suggestions**
- 🤝 **Contribute improvements**

---

**Last Updated:** 2026-05-15 | **Status:** ��� Active Development