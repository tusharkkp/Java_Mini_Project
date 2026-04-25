<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create SOS - Disaster Relief</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s cubic-bezier(0.4,0,0.2,1);--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(59,130,246,0.15);color:var(--accent-blue)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:32px;box-shadow:0 4px 24px rgba(0,0,0,0.3);max-width:700px}
        .form-group{margin-bottom:20px}.form-group label{display:block;font-size:13px;font-weight:600;color:var(--text-secondary);margin-bottom:6px;text-transform:uppercase;letter-spacing:0.3px}
        .form-control{width:100%;padding:12px 16px;background:var(--bg-input);border:1px solid var(--border-color);border-radius:var(--radius-sm);color:var(--text-primary);font-size:14px;font-family:var(--font-main);transition:var(--transition)}.form-control:focus{outline:none;border-color:var(--accent-blue);box-shadow:0 0 0 3px rgba(59,130,246,0.2)}
        select.form-control{appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2394a3b8'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 12px center;background-size:20px;padding-right:40px}
        textarea.form-control{resize:vertical;min-height:120px}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:12px 24px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);text-decoration:none}.btn:hover{transform:translateY(-2px)}.btn-danger{background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));color:white}.btn-outline{background:transparent;border:1px solid var(--border-color);color:var(--text-secondary)}
        .form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px}
        .severity-options{display:grid;grid-template-columns:repeat(4,1fr);gap:10px}
        .severity-option{position:relative}
        .severity-option input{position:absolute;opacity:0;width:0;height:0}
        .severity-option label{display:flex;flex-direction:column;align-items:center;padding:16px 8px;border:2px solid var(--border-color);border-radius:var(--radius-sm);cursor:pointer;transition:var(--transition);text-align:center;font-size:13px}
        .severity-option input:checked+label{border-color:var(--accent-blue);background:rgba(59,130,246,0.1)}
        .severity-option label .sev-icon{font-size:24px;margin-bottom:6px}
        .severity-option label .sev-name{font-weight:600}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>🚨 Disaster Relief</h2><span>User Panel</span></div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/user/dashboard'/>">📊 Dashboard</a></li>
                <li><a href="<c:url value='/user/sos/create'/>" class="active">🆘 Create SOS</a></li>
                <li><a href="<c:url value='/user/notifications'/>">🔔 Notifications</a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <h1>🆘 Create Emergency SOS</h1>
                <a href="<c:url value='/user/dashboard'/>" class="btn btn-outline">← Back to Dashboard</a>
            </div>

            <div class="card">
                <form action="<c:url value='/user/sos/create'/>" method="post" id="sosForm">
                    <div class="form-group">
                        <label>Emergency Description *</label>
                        <textarea name="description" class="form-control"
                                  placeholder="Describe the emergency situation in detail..." required></textarea>
                    </div>

                    <div class="form-group">
                        <label>Location Name *</label>
                        <input type="text" name="locationName" class="form-control"
                               placeholder="e.g., City Center, Near Hospital" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Latitude *</label>
                            <input type="number" name="latitude" id="latitude" class="form-control"
                                   step="0.000001" placeholder="18.5204" required value="18.5204">
                        </div>
                        <div class="form-group">
                            <label>Longitude *</label>
                            <input type="number" name="longitude" id="longitude" class="form-control"
                                   step="0.000001" placeholder="73.8567" required value="73.8567">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Severity Level *</label>
                        <div class="severity-options">
                            <div class="severity-option">
                                <input type="radio" name="severity" id="sev-low" value="LOW">
                                <label for="sev-low"><span class="sev-icon">🟢</span><span class="sev-name">Low</span>Minor help</label>
                            </div>
                            <div class="severity-option">
                                <input type="radio" name="severity" id="sev-med" value="MEDIUM" checked>
                                <label for="sev-med"><span class="sev-icon">🟡</span><span class="sev-name">Medium</span>Moderate</label>
                            </div>
                            <div class="severity-option">
                                <input type="radio" name="severity" id="sev-high" value="HIGH">
                                <label for="sev-high"><span class="sev-icon">🟠</span><span class="sev-name">High</span>Serious</label>
                            </div>
                            <div class="severity-option">
                                <input type="radio" name="severity" id="sev-crit" value="CRITICAL">
                                <label for="sev-crit"><span class="sev-icon">🔴</span><span class="sev-name">Critical</span>Life-threat</label>
                            </div>
                        </div>
                    </div>

                    <div style="display:flex;gap:12px;margin-top:24px">
                        <button type="submit" class="btn btn-danger">🚨 Send SOS Alert</button>
                        <a href="<c:url value='/user/dashboard'/>" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            </div>
        </main>
    </div>

    <script>
        // Try to get user's current location
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(pos) {
                document.getElementById('latitude').value = pos.coords.latitude.toFixed(6);
                document.getElementById('longitude').value = pos.coords.longitude.toFixed(6);
            });
        }
    </script>
</body>
</html>
