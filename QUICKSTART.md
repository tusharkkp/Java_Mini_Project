# ⚡ Quick Start Guide

Get the Disaster Relief Volunteer Coordination System running in **5 minutes**.

---

## 🏃 TL;DR — 3 Commands

```bash
# 1. Clone
git clone https://github.com/tusharkkp/Java_Mini_Project.git && cd Java_Mini_Project

# 2. Setup database
mysql -u root -p -e "CREATE DATABASE disaster_relief_db; CREATE USER 'disaster_user'@'localhost' IDENTIFIED BY 'disaster_password'; GRANT ALL PRIVILEGES ON disaster_relief_db.* TO 'disaster_user'@'localhost';"

# 3. Run
./mvnw spring-boot:run
```

Then visit: **http://localhost:8081**

---

## ✅ Prerequisites Check

```bash
# Check Java (need 21+)
java -version

# Check MySQL (need 8.x, must be running)
mysql --version
mysql -u root -p -e "SELECT VERSION();"

# Check Git
git --version
```

**Not installed?** Get them:
- [Java 21](https://www.oracle.com/java/technologies/downloads/#java21)
- [MySQL 8.x](https://dev.mysql.com/downloads/mysql/)
- [Git](https://git-scm.com/)

---

## 📥 Step 1: Clone Repository

```bash
git clone https://github.com/tusharkkp/Java_Mini_Project.git
cd Java_Mini_Project
```

**✅ Verify:** You should see `pom.xml` and `src/` directory

---

## 🗄️ Step 2: Create Database

### Option A: MySQL Command Line

```bash
mysql -u root -p
```

Then paste:

```sql
CREATE DATABASE disaster_relief_db;
CREATE USER 'disaster_user'@'localhost' IDENTIFIED BY 'disaster_password';
GRANT ALL PRIVILEGES ON disaster_relief_db.* TO 'disaster_user'@'localhost';
FLUSH PRIVILEGES;
exit;
```

### Option B: One Command

```bash
mysql -u root -p -e "CREATE DATABASE disaster_relief_db; CREATE USER 'disaster_user'@'localhost' IDENTIFIED BY 'disaster_password'; GRANT ALL PRIVILEGES ON disaster_relief_db.* TO 'disaster_user'@'localhost'; FLUSH PRIVILEGES;"
```

**✅ Verify:**

```bash
mysql -u disaster_user -p -h localhost -e "SELECT DATABASE();"
# Enter password: disaster_password
# Should show: disaster_relief_db
```

---

## ⚙️ Step 3: Configure Application

File: `src/main/resources/application.properties`

**Already configured for defaults**, but verify:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/disaster_relief_db
spring.datasource.username=disaster_user
spring.datasource.password=disaster_password
server.port=8081
socket.server.port=9090
```

**Custom config?** Edit these values to match your setup.

---

## 🚀 Step 4: Run Application

### On Windows:

```bash
mvnw.cmd clean install
mvnw.cmd spring-boot:run
```

### On Linux/Mac:

```bash
./mvnw clean install
./mvnw spring-boot:run
```

**✅ Wait for:**

```
Tomcat started on port(s): 8081
DisasterReliefApplication started successfully
```

Then press Enter to continue.

---

## 🌐 Step 5: Access Application

Open your browser:

| URL | Purpose |
|-----|----------|
| **http://localhost:8081** | Web application |
| **http://localhost:8081/login** | Login page |
| **http://localhost:8081/api/v1/sos** | REST API |

---

## 🔑 Test Credentials

### Admin Account
- **Username:** `admin`
- **Password:** `admin123`
- **Access:** Full system, dashboards, user management

### Volunteer Account
- **Username:** `volunteer1`
- **Password:** `vol123`
- **Access:** View tasks, update availability

### User Account
- **Username:** `user1`
- **Password:** `user123`
- **Access:** Create SOS, view assignments

---

## 🧪 Test the System

### Test 1: Admin Dashboard

1. Login as `admin` / `admin123`
2. Click "Dashboard"
3. You should see: Real-time metrics, volunteer list, SOS requests

### Test 2: Create SOS Request

1. Logout, then login as `user1` / `user123`
2. Click "Create SOS"
3. Fill form:
   - Location: "Test Location"
   - Description: "Test emergency"
   - Severity: "HIGH"
4. Click "Submit"
5. Should see: SOS created confirmation

### Test 3: View Tasks (Volunteer)

1. Logout, then login as `volunteer1` / `vol123`
2. Click "My Tasks"
3. Should see: List of assigned tasks
4. Update status → Click "Mark as In Progress"

### Test 4: REST API

```bash
# Get all SOS requests
curl http://localhost:8081/api/v1/sos

# Get all volunteers
curl http://localhost:8081/api/v1/volunteers

# Get available volunteers
curl http://localhost:8081/api/v1/volunteers/available
```

---

## 🐛 Common Issues & Solutions

### Issue: "Connection refused" for MySQL

**Solution:** Start MySQL

```bash
# Mac
brew services start mysql

# Windows
net start MySQL80

# Linux
sudo systemctl start mysql
```

### Issue: "Port 8081 already in use"

**Solution:** Change port in `application.properties`:

```properties
server.port=8082
```

Then restart application.

### Issue: "Socket connection refused" (port 9090)

**Solution:** Change socket port in `application.properties`:

```properties
socket.server.port=9091
```

### Issue: "JSP pages not rendering"

**Solution:** Rebuild with dependencies:

```bash
./mvnw clean install
./mvnw spring-boot:run
```

### Issue: "Database connection timeout"

**Solution:** Verify credentials in `application.properties` match what you created.

---

## 📁 What Gets Created

After running, you'll have:

```
Java_Mini_Project/
├── target/                          [Compiled files]
├── logs/                            [Application logs]
├── src/main/resources/
│   └── schema-h2.sql               [Database schema]
└── [Database tables created in MySQL]
    ├── users
    ├── volunteers
    ├── sos_requests
    ├── tasks
    ├── notifications
    └── ... (9 total tables)
```

---

## 🔍 Verify Installation

Check if everything works:

```bash
# Check application log
tail -f target/application.log

# Verify database tables
mysql -u disaster_user -p -e "USE disaster_relief_db; SHOW TABLES;"

# Test API
curl -s http://localhost:8081/api/v1/sos | head -20
```

---

## 📚 Next Steps

### Explore Documentation
- **[README.md](README.md)** — Full project overview
- **[DOCUMENTATION.md](DOCUMENTATION.md)** — Technical details
- **[API Endpoints](README.md#-api-documentation)** — REST API reference

### Deploy to Production
- See [SECURITY.md](SECURITY.md) for production checklist
- Change default credentials
- Enable HTTPS
- Configure firewall

### Contribute
- See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
- Report bugs on [GitHub Issues](https://github.com/tusharkkp/Java_Mini_Project/issues)
- Join [GitHub Discussions](https://github.com/tusharkkp/Java_Mini_Project/discussions)

### Advanced Setup
- Docker deployment → Coming soon
- Kubernetes setup → Coming soon
- CI/CD pipeline → See GitHub Actions

---

## 💬 Need Help?

- **Documentation:** [README.md](README.md)
- **Issues:** [GitHub Issues](https://github.com/tusharkkp/Java_Mini_Project/issues)
- **Discussions:** [GitHub Discussions](https://github.com/tusharkkp/Java_Mini_Project/discussions)
- **Report Security Issues:** See [SECURITY.md](SECURITY.md)

---

**Great! You're ready to use the system.** 🎉

Happy coding! ⭐ Star the repo if it helped you.
