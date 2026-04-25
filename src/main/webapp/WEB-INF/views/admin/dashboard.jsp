<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Disaster Relief</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--accent-yellow:#eab308;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s;--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100;overflow-y:auto}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-purple),var(--accent-blue));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(139,92,246,0.15);color:var(--accent-purple)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;box-shadow:0 4px 24px rgba(0,0,0,0.3);margin-bottom:24px}
        .card-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:32px}
        .stat-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:20px;position:relative;overflow:hidden;transition:var(--transition)}.stat-card:hover{transform:translateY(-4px);box-shadow:0 8px 40px rgba(0,0,0,0.4)}.stat-card::before{content:'';position:absolute;top:0;left:0;width:4px;height:100%}
        .stat-card.red::before{background:var(--accent-red)}.stat-card.orange::before{background:var(--accent-orange)}.stat-card.green::before{background:var(--accent-green)}.stat-card.blue::before{background:var(--accent-blue)}.stat-card.purple::before{background:var(--accent-purple)}.stat-card.cyan::before{background:var(--accent-cyan)}
        .stat-card .stat-label{font-size:12px;color:var(--text-muted);font-weight:500;text-transform:uppercase;letter-spacing:0.5px}.stat-card .stat-value{font-size:32px;font-weight:800;margin:4px 0}
        .two-col{display:grid;grid-template-columns:1fr 1fr;gap:24px}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);text-decoration:none}.btn:hover{transform:translateY(-2px)}.btn-primary{background:linear-gradient(135deg,var(--accent-blue),var(--accent-purple));color:white}.btn-outline{background:transparent;border:1px solid var(--border-color);color:var(--text-secondary)}.btn-sm{padding:6px 14px;font-size:12px}
        .table-container{overflow-x:auto;border-radius:var(--radius);border:1px solid var(--border-color)}table{width:100%;border-collapse:collapse;font-size:14px}thead{background:rgba(139,92,246,0.1)}th{padding:12px 14px;text-align:left;font-weight:600;font-size:11px;text-transform:uppercase;color:var(--text-muted);border-bottom:1px solid var(--border-color)}td{padding:10px 14px;border-bottom:1px solid var(--border-color);color:var(--text-secondary);font-size:13px}tr:hover td{background:rgba(59,130,246,0.05)}
        .badge{display:inline-flex;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;text-transform:uppercase}
        .badge-new{background:rgba(59,130,246,0.2);color:var(--accent-blue)}.badge-active{background:rgba(6,182,212,0.2);color:var(--accent-cyan)}.badge-assigned{background:rgba(139,92,246,0.2);color:var(--accent-purple)}.badge-resolved{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-escalated{background:rgba(239,68,68,0.2);color:var(--accent-red)}
        .badge-critical{background:rgba(239,68,68,0.2);color:var(--accent-red)}.badge-high{background:rgba(249,115,22,0.2);color:var(--accent-orange)}.badge-medium{background:rgba(234,179,8,0.2);color:var(--accent-yellow)}.badge-low{background:rgba(34,197,94,0.2);color:var(--accent-green)}
        .bar-chart{display:flex;flex-direction:column;gap:12px;margin-top:16px}.bar-row{display:flex;align-items:center;gap:12px}.bar-label{width:90px;font-size:12px;color:var(--text-secondary);text-align:right;flex-shrink:0}.bar-track{flex:1;height:28px;background:var(--bg-input);border-radius:6px;overflow:hidden}.bar-fill{height:100%;border-radius:6px;display:flex;align-items:center;padding-left:10px;font-size:11px;font-weight:700;color:white;min-width:30px;transition:width 1s ease}.bar-fill.red{background:linear-gradient(90deg,var(--accent-red),#f87171)}.bar-fill.orange{background:linear-gradient(90deg,var(--accent-orange),#fb923c)}.bar-fill.green{background:linear-gradient(90deg,var(--accent-green),#4ade80)}.bar-fill.blue{background:linear-gradient(90deg,var(--accent-blue),#60a5fa)}.bar-fill.purple{background:linear-gradient(90deg,var(--accent-purple),#a78bfa)}.bar-value{font-size:13px;font-weight:700;color:var(--text-primary);width:40px;text-align:right;flex-shrink:0}
        .notif-badge{display:inline-flex;align-items:center;justify-content:center;min-width:20px;height:20px;padding:0 6px;border-radius:10px;background:var(--accent-red);color:white;font-size:11px;font-weight:700}
        @media(max-width:1024px){.two-col{grid-template-columns:1fr}}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>⚡ Disaster Relief</h2><span>Admin Panel</span></div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/admin/dashboard'/>" class="active">📊 Dashboard</a></li>
                <li><a href="<c:url value='/admin/sos'/>">🆘 All SOS</a></li>
                <li><a href="<c:url value='/admin/volunteers'/>">🦺 Volunteers</a></li>
                <li><a href="<c:url value='/admin/users'/>">👥 Users</a></li>
                <li><a href="<c:url value='/admin/sdg-metrics'/>">🌍 SDG Metrics</a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <h1>📊 Admin Dashboard</h1>
                <div style="display:flex;gap:12px;align-items:center">
                    <span style="font-size:13px;color:var(--text-muted)">🔌 Socket: <strong style="color:var(--accent-green)">${socketRunning ? 'Running' : 'Stopped'}</strong> on port ${socketPort} | Clients: <strong style="color:var(--accent-green)">${connectedClients}</strong></span>
                </div>
            </div>

            <!-- Key Metrics -->
            <div class="card-grid">
                <div class="stat-card red">
                    <div class="stat-label">Total SOS</div>
                    <div class="stat-value">${metrics.totalSosRequests}</div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-label">New / Pending</div>
                    <div class="stat-value">${metrics.newSos}</div>
                </div>
                <div class="stat-card purple">
                    <div class="stat-label">Assigned</div>
                    <div class="stat-value">${metrics.assignedSos}</div>
                </div>
                <div class="stat-card green">
                    <div class="stat-label">Resolved</div>
                    <div class="stat-value">${metrics.resolvedSos}</div>
                </div>
                <div class="stat-card cyan">
                    <div class="stat-label">Volunteers</div>
                    <div class="stat-value">${metrics.totalVolunteers}</div>
                </div>
                <div class="stat-card blue">
                    <div class="stat-label">Avg Response</div>
                    <div class="stat-value">${metrics.avgResponseTimeMinutes}<span style="font-size:14px;color:var(--text-muted)"> min</span></div>
                </div>
            </div>

            <!-- Charts & Tables Row -->
            <div class="two-col">
                <!-- SOS Status Chart -->
                <div class="card">
                    <h3 style="margin-bottom:8px">📈 SOS Status Overview</h3>
                    <div class="bar-chart">
                        <c:set var="maxVal" value="${metrics.totalSosRequests > 0 ? metrics.totalSosRequests : 1}"/>
                        <div class="bar-row">
                            <div class="bar-label">New</div>
                            <div class="bar-track"><div class="bar-fill blue" style="width:${metrics.newSos * 100 / maxVal}%">${metrics.newSos}</div></div>
                            <div class="bar-value">${metrics.newSos}</div>
                        </div>
                        <div class="bar-row">
                            <div class="bar-label">Assigned</div>
                            <div class="bar-track"><div class="bar-fill purple" style="width:${metrics.assignedSos * 100 / maxVal}%">${metrics.assignedSos}</div></div>
                            <div class="bar-value">${metrics.assignedSos}</div>
                        </div>
                        <div class="bar-row">
                            <div class="bar-label">Resolved</div>
                            <div class="bar-track"><div class="bar-fill green" style="width:${metrics.resolvedSos * 100 / maxVal}%">${metrics.resolvedSos}</div></div>
                            <div class="bar-value">${metrics.resolvedSos}</div>
                        </div>
                        <div class="bar-row">
                            <div class="bar-label">Escalated</div>
                            <div class="bar-track"><div class="bar-fill red" style="width:${metrics.escalatedSos * 100 / maxVal}%">${metrics.escalatedSos}</div></div>
                            <div class="bar-value">${metrics.escalatedSos}</div>
                        </div>
                    </div>
                </div>

                <!-- SDG Metrics Quick View -->
                <div class="card">
                    <h3 style="margin-bottom:8px">🌍 SDG Impact Metrics</h3>
                    <div style="padding:16px 0">
                        <div style="margin-bottom:20px">
                            <div style="font-size:12px;color:var(--text-muted);text-transform:uppercase;margin-bottom:4px">Avg Response Time</div>
                            <div style="font-size:28px;font-weight:800;color:var(--accent-cyan)">${metrics.avgResponseTimeMinutes} <span style="font-size:14px;color:var(--text-muted)">minutes</span></div>
                        </div>
                        <div style="margin-bottom:20px">
                            <div style="font-size:12px;color:var(--text-muted);text-transform:uppercase;margin-bottom:4px">% Handled Within ${metrics.responseThresholdMinutes} min</div>
                            <div style="font-size:28px;font-weight:800;color:var(--accent-green)">${metrics.percentHandledWithinThreshold}%</div>
                            <div class="bar-track" style="margin-top:8px"><div class="bar-fill green" style="width:${metrics.percentHandledWithinThreshold}%"></div></div>
                        </div>
                        <div>
                            <div style="font-size:12px;color:var(--text-muted);text-transform:uppercase;margin-bottom:4px">Available Volunteers</div>
                            <div style="font-size:28px;font-weight:800;color:var(--accent-blue)">${metrics.availableVolunteers} <span style="font-size:14px;color:var(--text-muted)">/ ${metrics.totalVolunteers}</span></div>
                        </div>
                    </div>
                    <a href="<c:url value='/admin/sdg-metrics'/>" class="btn btn-outline btn-sm" style="margin-top:8px">View Full Report →</a>
                </div>
            </div>

            <!-- Recent SOS Table -->
            <div class="card">
                <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px">
                    <h3>🆘 Recent SOS Requests</h3>
                    <a href="<c:url value='/admin/sos'/>" class="btn btn-outline btn-sm">View All →</a>
                </div>
                <div class="table-container">
                    <table>
                        <thead><tr><th>ID</th><th>User</th><th>Location</th><th>Severity</th><th>Status</th><th>Created</th><th>Action</th></tr></thead>
                        <tbody>
                            <c:forEach items="${recentSos}" var="sos" end="9">
                                <tr>
                                    <td>#${sos.id}</td>
                                    <td>${sos.user.fullName}</td>
                                    <td>${sos.locationName}</td>
                                    <td><span class="badge badge-${sos.severity.cssClass}">${sos.severity}</span></td>
                                    <td><span class="badge badge-${sos.status.cssClass}">${sos.status}</span></td>
                                    <td>${sos.createdAt}</td>
                                    <td><a href="<c:url value='/admin/sos/${sos.id}'/>" class="btn btn-primary btn-sm">View</a></td>
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
