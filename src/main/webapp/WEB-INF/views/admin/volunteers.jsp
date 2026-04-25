<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteers - Admin</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s;--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-purple),var(--accent-blue));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(139,92,246,0.15);color:var(--accent-purple)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;box-shadow:0 4px 24px rgba(0,0,0,0.3)}
        .table-container{overflow-x:auto;border-radius:var(--radius);border:1px solid var(--border-color)}table{width:100%;border-collapse:collapse;font-size:14px}thead{background:rgba(139,92,246,0.1)}th{padding:14px 16px;text-align:left;font-weight:600;font-size:12px;text-transform:uppercase;color:var(--text-muted);border-bottom:1px solid var(--border-color)}td{padding:12px 16px;border-bottom:1px solid var(--border-color);color:var(--text-secondary)}
        .badge{display:inline-flex;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;text-transform:uppercase}.badge-available{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-unavailable{background:rgba(239,68,68,0.2);color:var(--accent-red)}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>⚡ Disaster Relief</h2><span>Admin Panel</span></div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/admin/dashboard'/>">📊 Dashboard</a></li>
                <li><a href="<c:url value='/admin/sos'/>">🆘 All SOS</a></li>
                <li><a href="<c:url value='/admin/volunteers'/>" class="active">🦺 Volunteers</a></li>
                <li><a href="<c:url value='/admin/users'/>">👥 Users</a></li>
                <li><a href="<c:url value='/admin/sdg-metrics'/>">🌍 SDG Metrics</a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>
        <main class="main-content">
            <div class="top-bar"><h1>🦺 Volunteer Management</h1></div>
            <div class="card">
                <div class="table-container">
                    <table>
                        <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Location</th><th>Status</th><th>Tasks Done</th><th>Skills</th></tr></thead>
                        <tbody>
                            <c:forEach items="${volunteers}" var="v">
                                <tr>
                                    <td>#${v.id}</td>
                                    <td>${v.user.fullName}</td>
                                    <td>${v.user.email}</td>
                                    <td>${v.user.phone}</td>
                                    <td>${v.latitude}, ${v.longitude}</td>
                                    <td><span class="badge ${v.available ? 'badge-available' : 'badge-unavailable'}">${v.available ? 'Available' : 'Unavailable'}</span></td>
                                    <td><strong>${v.tasksCompleted}</strong></td>
                                    <td>${v.skills != null ? v.skills : '—'}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
