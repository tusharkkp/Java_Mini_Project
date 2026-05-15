# Contributing to Disaster Relief Volunteer Coordination System

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## 📋 Code of Conduct

All contributors are expected to uphold this project's values:
- **Respectful & Inclusive** — Treat all contributors with respect
- **Professional Communication** — Keep discussions constructive and focused
- **Open-minded** — Welcome diverse perspectives and backgrounds

## 🚀 Getting Started

### Prerequisites
- Java 21+
- MySQL 8.x
- Git
- Maven (or use Maven Wrapper)
- IDE (IntelliJ IDEA, Eclipse, VS Code with Java extensions)

### Setup Development Environment

1. **Fork & Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Java_Mini_Project.git
   cd Java_Mini_Project
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix-name
   ```

3. **Setup Database**
   ```bash
   mysql -u root -p
   CREATE DATABASE disaster_relief_dev;
   CREATE USER 'dev_user'@'localhost' IDENTIFIED BY 'dev_password';
   GRANT ALL PRIVILEGES ON disaster_relief_dev.* TO 'dev_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

4. **Configure Application**
   Edit `src/main/resources/application-dev.properties`:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/disaster_relief_dev
   spring.datasource.username=dev_user
   spring.datasource.password=dev_password
   spring.jpa.hibernate.ddl-auto=create-drop
   logging.level.com.disasterrelief=DEBUG
   ```

5. **Build & Run**
   ```bash
   ./mvnw clean install
   ./mvnw spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"
   ```

---

## 📝 Contribution Types

### 🐛 Bug Fixes
**When to submit:**
- You've found and reproduced a bug
- You have a fix with test coverage

**Process:**
1. Create issue describing the bug (if not already reported)
2. Create branch: `fix/bug-description`
3. Make minimal, focused changes
4. Add/update tests
5. Submit PR with clear description

**Example PR:**
```
Title: Fix NPE in VolunteerService.findNearestVolunteers()

Description:
- Issue #42: NullPointerException when volunteer has null location coordinates
- Root cause: Missing null check before Haversine distance calculation
- Solution: Add defensive null validation in VolunteerService

Changes:
- Added null check in findNearestVolunteers()
- Added unit test for null location scenario
- Updated DOCUMENTATION.md with edge case note
```

### ✨ New Features
**When to submit:**
- Feature aligns with project roadmap
- Feature is well-scoped and testable
- You have implementation + tests

**Process:**
1. Open issue to discuss before implementing
2. Create branch: `feature/feature-description`
3. Implement with tests and documentation
4. Submit PR with motivation and usage examples

**Example PR:**
```
Title: Add email notifications for SOS updates

Description:
- Implements email notification capability via SendGrid
- Allows volunteers to opt-in to email alerts
- Extends existing NotificationService with EmailNotificationStrategy

Changes:
- New EmailNotificationService component
- Configuration for SendGrid API key
- Updated Volunteer entity with emailNotificationsEnabled flag
- Integration tests with email verification
- Updated README with setup instructions
```

### 📖 Documentation
**Types of contributions:**
- README improvements
- API documentation
- Code comments & Javadoc
- Architecture diagrams
- Troubleshooting guides
- Translation (i18n)

**Process:**
1. Create branch: `docs/documentation-improvement`
2. Update Markdown files with clear examples
3. Submit PR for review

### 🎨 UI/UX Improvements
**When to submit:**
- Improved visual design
- Better user experience
- Accessibility enhancements

**Process:**
1. Include before/after screenshots
2. Test on multiple browsers/devices
3. Ensure accessibility (WCAG 2.1 AA)
4. Submit PR with UX justification

### ⚡ Performance Optimizations
**When to submit:**
- Measurable performance improvement
- Benchmarks or profiling results
- No functional changes

**Process:**
1. Document current vs improved performance
2. Include profiling data or benchmarks
3. Explain optimization strategy
4. Submit PR with metrics

---

## 🔄 Pull Request Process

### Before Submitting

1. **Ensure Code Quality**
   ```bash
   # Format code
   ./mvnw spotless:apply
   
   # Run tests
   ./mvnw test
   
   # Check style
   ./mvnw checkstyle:check
   ```

2. **Update Documentation**
   - Update README if user-facing changes
   - Update DOCUMENTATION.md if technical changes
   - Add Javadoc to public methods
   - Update API endpoint list if needed

3. **Create Meaningful Commits**
   ```bash
   # Good commit messages
   git commit -m "feat: Add email notification service"
   git commit -m "fix: Handle null coordinates in volunteer search"
   git commit -m "docs: Add email setup guide"
   git commit -m "test: Add coverage for edge cases"
   
   # Avoid
   git commit -m "fix stuff"
   git commit -m "WIP"
   ```

### Submitting Pull Request

1. **Push to Your Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request on GitHub**
   - Title: Clear, concise description
   - Description: Use PR template below
   - Link related issues: `Closes #42`
   - Request reviewers

3. **PR Template**
   ```markdown
   ## Description
   Brief summary of changes.

   ## Motivation
   Why is this change needed?

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Performance improvement

   ## Changes
   - Detailed list of changes
   - File modifications
   - New files added

   ## Testing
   How to test this change:
   1. Step 1
   2. Step 2

   ## Screenshots (if applicable)
   [Add before/after screenshots]

   ## Checklist
   - [ ] Code follows project style guidelines
   - [ ] Tests added/updated
   - [ ] Documentation updated
   - [ ] No new warnings generated
   - [ ] Tested on dev database
   ```

### Review Process

- **Code Review:** Maintainer will review for:
  - Code quality and style
  - Architectural alignment
  - Test coverage
  - Documentation completeness
  - Security implications

- **Feedback:** Respond to reviewer comments promptly
  - Ask for clarification if needed
  - Make requested changes
  - Commit and push updates

- **Approval:** Once approved, PR will be merged to `main`

---

## 🧪 Testing Guidelines

### Test Requirements
- Minimum 70% code coverage for new features
- All public methods should have unit tests
- Integration tests for complex workflows

### Writing Tests

**Unit Test Example:**
```java
@SpringBootTest
class VolunteerServiceTest {
    
    @MockBean
    private VolunteerRepository volunteerRepository;
    
    @Autowired
    private VolunteerService volunteerService;
    
    @Test
    @DisplayName("Should find nearest volunteer within 5km")
    void testFindNearestVolunteer() {
        // Arrange
        Volunteer volunteer = new Volunteer();
        volunteer.setLatitude(28.6139);
        volunteer.setLongitude(77.2090);
        
        when(volunteerRepository.findByAvailableTrue())
            .thenReturn(List.of(volunteer));
        
        // Act
        List<Volunteer> result = volunteerService
            .findNearestVolunteers(28.6050, 77.2100, 5.0);
        
        // Assert
        assertThat(result).isNotEmpty();
        assertThat(result.get(0).getId()).isEqualTo(volunteer.getId());
    }
}
```

**Integration Test Example:**
```java
@SpringBootTest
@ActiveProfiles("test")
class SosRequestIntegrationTest {
    
    @Autowired
    private SosRequestService sosRequestService;
    
    @Autowired
    private SosRequestRepository sosRepository;
    
    @Test
    @DisplayName("Should create SOS and trigger socket broadcast")
    void testSosCreationWithBroadcast() {
        // Create SOS
        SosRequest sos = sosRequestService.createSosRequest(
            testUser, 28.6139, 77.2090, 
            "Test Location", "Test Description", 
            SeverityLevel.HIGH
        );
        
        // Verify persistence
        Optional<SosRequest> saved = sosRepository.findById(sos.getId());
        assertThat(saved).isPresent();
    }
}
```

### Running Tests

```bash
# All tests
./mvnw test

# Specific test class
./mvnw test -Dtest=VolunteerServiceTest

# Generate coverage report
./mvnw jacoco:report
```

---

## 📚 Coding Standards

### Java Code Style

**Naming Conventions:**
```java
// Classes: PascalCase
public class UserService { }

// Methods/Variables: camelCase
public void updateVolunteerLocation() { }
private String volunteerName;

// Constants: UPPER_SNAKE_CASE
private static final int MAX_VOLUNTEERS = 10;

// Enums: UPPER_SNAKE_CASE
public enum SeverityLevel {
    LOW, MEDIUM, HIGH, CRITICAL
}
```

**Formatting:**
- 4-space indentation (no tabs)
- Line length: max 120 characters
- Opening braces on same line
- One blank line between methods

**Javadoc:**
```java
/**
 * Finds nearest available volunteers based on geolocation.
 * 
 * Uses Haversine formula to calculate distances. Returns only
 * volunteers within specified radius and marked as available.
 * 
 * @param latitude User latitude coordinate
 * @param longitude User longitude coordinate
 * @param radiusKm Search radius in kilometers
 * @return List of nearest volunteers sorted by distance
 * @throws IllegalArgumentException if radius is negative
 */
public List<Volunteer> findNearestVolunteers(
    double latitude, 
    double longitude, 
    double radiusKm) {
    // implementation
}
```

### Spring Annotations

```java
// Controllers
@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor  // Lombok for dependency injection
public class SosController {
    
    private final SosRequestService sosService;
    
    @GetMapping("/sos/{id}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<SosResponseDto> getSos(@PathVariable Long id) {
        // implementation
    }
}

// Services
@Service
@Transactional
@Slf4j  // Lombok for logging
public class NotificationService {
    
    @Async("asyncExecutor")
    public void sendNotificationAsync(String message) {
        log.info("Sending async notification: {}", message);
    }
}

// Repositories
@Repository
public interface VolunteerRepository extends JpaRepository<Volunteer, Long> {
    
    @Query("SELECT v FROM Volunteer v WHERE v.available = true")
    List<Volunteer> findAvailable();
}
```

---

## 🔒 Security Considerations

### Before Submitting
- [ ] No hardcoded secrets/credentials
- [ ] No SQL injection vulnerabilities
- [ ] Input validation on all endpoints
- [ ] Authorization checks for restricted resources
- [ ] Sensitive data properly encrypted

### Security Review
- OWASP Top 10 compliance
- SQL injection prevention (use PreparedStatement)
- XSS prevention in JSP templates
- CSRF protection on POST/PUT/DELETE
- Password hashing (BCrypt)

---

## 📖 Documentation Guidelines

### When to Update Documentation
- New endpoints: Update DOCUMENTATION.md API section
- New features: Add to README features list
- New configuration: Add to Configuration section
- Schema changes: Update Database Schema section

### Documentation Format
- Use clear, concise language
- Include code examples where helpful
- Keep lines under 100 characters
- Use proper Markdown formatting
- Add table of contents for long docs

---

## 🎯 Issue Reporting

### When to Report

**Bugs:**
- Clear reproduction steps
- Expected vs actual behavior
- Environment (Java version, OS, MySQL version)
- Logs or stack traces

**Feature Requests:**
- Clear description of desired functionality
- Use case and motivation
- Suggested implementation (optional)
- Related issues or discussions

### Issue Template

```markdown
**Describe the issue:**
Clear, concise description.

**Steps to reproduce:**
1. Step 1
2. Step 2
3. ...

**Expected behavior:**
What should happen?

**Actual behavior:**
What actually happens?

**Environment:**
- Java: 21
- MySQL: 8.0
- OS: Linux/Windows/Mac
- Spring Boot: 4.0.6

**Logs/Stacktrace:**
[Paste relevant logs]

**Screenshots (if applicable):**
[Attach images]
```

---

## 📈 Review Criteria

PRs are evaluated on:

| Criteria | Weight | Details |
|----------|--------|---------|
| Code Quality | 30% | Follows style guide, readable, maintainable |
| Functionality | 25% | Solves the issue, works as intended |
| Tests | 20% | Adequate coverage, realistic test cases |
| Documentation | 15% | Clear comments, updated README/DOCS |
| Performance | 10% | No performance regressions, optimized |

---

## 🚀 Deployment & Release

### Version Numbering
- **Major.Minor.Patch** (e.g., 1.2.3)
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

### Release Process
1. Maintainer tags version on GitHub
2. Create GitHub Release with changelog
3. Deploy to production

---

## 📞 Questions & Support

- **Discussions:** https://github.com/tusharkkp/Java_Mini_Project/discussions
- **Issues:** https://github.com/tusharkkp/Java_Mini_Project/issues
- **Email:** Contact maintainer via GitHub profile

---

## 📋 Contributor License Agreement (CLA)

By submitting a PR, you agree that:
- Your contribution is your own original work
- You grant the project license to use your contribution
- You understand the project is MIT licensed

---

## 🙏 Thank You!

Your contributions make this project better. We appreciate your time and effort!