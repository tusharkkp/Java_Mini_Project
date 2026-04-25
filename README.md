# 🚨 Disaster Relief Volunteer Coordination System

An enterprise-grade Java web application for emergency response coordination built with Spring Boot, Hibernate, JSP, and Socket Programming.

## 🎯 Overview

This system enables:
- **Users** to raise SOS emergency requests with location and severity
- **Volunteers** to receive real-time alerts and manage rescue tasks
- **Admins** to monitor operations, assign volunteers, and track SDG metrics

## 🛠 Technology Stack

| Technology | Usage |
|-----------|-------|
| Spring Boot 4.x | Application framework |
| Spring MVC | MVC controllers + JSP views |
| Hibernate ORM (JPA) | Entity mapping & persistence |
| Spring Data JPA | Repository layer |
| JSP + JSTL | Frontend views |
| MySQL | Database |
| Spring Security | Authentication & authorization (3 roles) |
| JDBC (PreparedStatement) | Raw SQL operations for audit logging |
| Java Socket Programming | Real-time SOS broadcast to volunteers |
| Multithreading (@Async, @Scheduled) | Async notifications & scheduled escalation |

## 📋 Setup Instructions

### Prerequisites
- Java 21+
- MySQL 8.x
- No Maven installation needed (Maven Wrapper included)

### Database Setup
```sql
CREATE DATABASE disaster_relief_db;
```

### Running the Application
```bash
# Windows
.\mvnw.cmd spring-boot:run

# Linux/Mac
./mvnw spring-boot:run
```

### Access
- **Web App**: http://localhost:8081
- **Socket Server**: Port 9090

### Default Login Credentials
| Role | Username | Password |
|------|----------|----------|
| Admin | admin | admin123 |
| Volunteer | volunteer1 | vol123 |
| User | user1 | user123 |

## 🏗 Architecture

```
Controller Layer (@Controller, @RestController)
        ↓
Service Layer (@Service, @Async, @Scheduled)
        ↓
Repository Layer (@Repository, JpaRepository, JDBC)
        ↓
Entity Layer (@Entity, JPA Annotations)
        ↓
MySQL Database (8 tables)
```

## 📊 Features

### Core Features
- ✅ User Registration & Login (Spring Security)
- ✅ Role-based Access Control (ADMIN, VOLUNTEER, USER)
- ✅ SOS Emergency Request Creation
- ✅ Real-time Socket Broadcast to Volunteers
- ✅ Volunteer Availability Management
- ✅ Task Assignment & Lifecycle Tracking
- ✅ Distance-based Volunteer Selection (Haversine)
- ✅ Admin Dashboard with Charts

### Technical Features
- ✅ @Async Notification Service
- ✅ @Scheduled Escalation & Health Check
- ✅ Raw JDBC with PreparedStatement (Audit Logs)
- ✅ HQL Queries (Distance-based, Metrics)
- ✅ Servlet Filter (Request Logging)
- ✅ REST API Endpoints (/api/v1/)
- ✅ SDG Metrics Dashboard

## 🗄 Database Tables

1. `users` - User accounts
2. `roles` - Role definitions
3. `user_roles` - User-Role mapping (join table)
4. `volunteers` - Volunteer profiles
5. `sos_requests` - Emergency requests
6. `tasks` - Volunteer task assignments
7. `notifications` - System notifications
8. `locations` - Predefined geographic areas
9. `sos_audit_log` - JDBC audit trail (raw SQL)

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/v1/sos | List all SOS requests |
| GET | /api/v1/sos/{id} | Get SOS detail |
| GET | /api/v1/sos/status/{status} | Filter SOS by status |
| GET | /api/v1/volunteers | List all volunteers |
| GET | /api/v1/volunteers/available | List available volunteers |
| GET | /api/v1/tasks | List all tasks |
| GET | /api/v1/metrics | SDG metrics data |

## 🌍 SDG Integration

- **SDG 11**: Sustainable Cities — Measuring disaster response times
- **SDG 13**: Climate Action — Emergency coordination for climate disasters
- **Metrics**: Average response time, % handled within threshold

## 📁 Project Structure

```
src/main/java/com/disasterrelief/
├── DisasterReliefApplication.java
├── entity/          # JPA entities + enums
├── repository/      # Spring Data JPA + JDBC
├── service/         # Business logic + @Async + @Scheduled
├── controller/      # MVC + REST controllers
├── config/          # Security, Async, Filter, DataInitializer
└── socket/          # ServerSocket + Client
```
