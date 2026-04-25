<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Disaster Relief Coordination System</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--border-color:#334155;--radius-sm:8px;--radius-lg:16px;--transition:all 0.3s cubic-bezier(0.4,0,0.2,1);--font-main:'Inter','Segoe UI',system-ui,sans-serif}
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6;min-height:100vh}
        a{color:var(--accent-blue);text-decoration:none}
        .auth-container{display:flex;align-items:center;justify-content:center;min-height:100vh;background:linear-gradient(135deg,#0f172a 0%,#1e293b 50%,#0f172a 100%);padding:20px}
        .auth-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius-lg);padding:48px;width:100%;max-width:480px;box-shadow:0 8px 40px rgba(0,0,0,0.4)}
        .auth-card h1{font-size:28px;font-weight:800;text-align:center;margin-bottom:8px;background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}
        .subtitle{text-align:center;color:var(--text-muted);margin-bottom:32px;font-size:14px}
        .form-group{margin-bottom:18px}
        .form-group label{display:block;font-size:13px;font-weight:600;color:var(--text-secondary);margin-bottom:6px;text-transform:uppercase;letter-spacing:0.3px}
        .form-control{width:100%;padding:12px 16px;background:var(--bg-input);border:1px solid var(--border-color);border-radius:var(--radius-sm);color:var(--text-primary);font-size:14px;font-family:var(--font-main);transition:var(--transition)}
        .form-control:focus{outline:none;border-color:var(--accent-blue);box-shadow:0 0 0 3px rgba(59,130,246,0.2)}
        select.form-control{appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2394a3b8'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 12px center;background-size:20px;padding-right:40px}
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:12px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);width:100%}
        .btn-primary{background:linear-gradient(135deg,var(--accent-blue),#8b5cf6);color:white}
        .btn:hover{transform:translateY(-2px);box-shadow:0 4px 24px rgba(0,0,0,0.3)}
        .alert-error{padding:14px 20px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:14px;background:rgba(239,68,68,0.15);color:var(--accent-red);border:1px solid rgba(239,68,68,0.3)}
        .auth-footer{text-align:center;margin-top:24px;font-size:14px;color:var(--text-muted)}
        .form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
        .logo-icon{font-size:48px;text-align:center;margin-bottom:16px}
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="logo-icon">📋</div>
            <h1>Create Account</h1>
            <p class="subtitle">Join the Disaster Relief Network</p>

            <c:if test="${not empty error}">
                <div class="alert-error">⚠️ ${error}</div>
            </c:if>

            <form action="<c:url value='/register'/>" method="post">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control"
                           placeholder="Enter your full name" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" class="form-control"
                               placeholder="Choose username" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control"
                               placeholder="your@email.com" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Min 6 characters" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               placeholder="Phone number">
                    </div>
                </div>

                <div class="form-group">
                    <label for="role">Register As</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="">-- Select Role --</option>
                        <option value="ROLE_USER">🙋 Regular User (Can raise SOS)</option>
                        <option value="ROLE_VOLUNTEER">🦺 Volunteer (Can respond to SOS)</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">📝 Register</button>
            </form>

            <div class="auth-footer">
                Already have an account? <a href="<c:url value='/login'/>">Login here</a>
            </div>
        </div>
    </div>
</body>
</html>
