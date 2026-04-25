<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SDG Metrics - Admin</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--accent-yellow:#eab308;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s;--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-purple),var(--accent-blue));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(139,92,246,0.15);color:var(--accent-purple)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;box-shadow:0 4px 24px rgba(0,0,0,0.3);margin-bottom:24px}
        .card-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:20px;margin-bottom:32px}
        .metric-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:28px;text-align:center}.metric-card .metric-icon{font-size:48px;margin-bottom:12px}.metric-card .metric-value{font-size:48px;font-weight:800;margin:8px 0}.metric-card .metric-label{font-size:14px;color:var(--text-muted);text-transform:uppercase}
        .bar-chart{display:flex;flex-direction:column;gap:12px;margin-top:16px}.bar-row{display:flex;align-items:center;gap:12px}.bar-label{width:120px;font-size:13px;color:var(--text-secondary);text-align:right;flex-shrink:0}.bar-track{flex:1;height:32px;background:var(--bg-input);border-radius:6px;overflow:hidden}.bar-fill{height:100%;border-radius:6px;display:flex;align-items:center;padding-left:12px;font-size:12px;font-weight:700;color:white;min-width:40px;transition:width 1s ease}.bar-fill.red{background:linear-gradient(90deg,var(--accent-red),#f87171)}.bar-fill.orange{background:linear-gradient(90deg,var(--accent-orange),#fb923c)}.bar-fill.green{background:linear-gradient(90deg,var(--accent-green),#4ade80)}.bar-fill.blue{background:linear-gradient(90deg,var(--accent-blue),#60a5fa)}.bar-fill.purple{background:linear-gradient(90deg,var(--accent-purple),#a78bfa)}.bar-fill.cyan{background:linear-gradient(90deg,var(--accent-cyan),#22d3ee)}.bar-value{font-size:14px;font-weight:700;color:var(--text-primary);width:50px;text-align:right;flex-shrink:0}
        .sdg-banner{background:linear-gradient(135deg,rgba(34,197,94,0.15),rgba(6,182,212,0.15));border:1px solid rgba(34,197,94,0.3);border-radius:var(--radius);padding:24px;margin-bottom:24px}.sdg-banner h2{font-size:20px;margin-bottom:8px;color:var(--accent-green)}.sdg-banner p{color:var(--text-secondary);font-size:14px}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>⚡ Disaster Relief</h2><span>Admin Panel</span></div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/admin/dashboard'/>">📊 Dashboard</a></li>
                <li><a href="<c:url value='/admin/sos'/>">🆘 All SOS</a></li>
                <li><a href="<c:url value='/admin/volunteers'/>">🦺 Volunteers</a></li>
                <li><a href="<c:url value='/admin/users'/>">👥 Users</a></li>
                <li><a href="<c:url value='/admin/sdg-metrics'/>" class="active">🌍 SDG Metrics</a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>
        <main class="main-content">
            <div class="top-bar"><h1>🌍 SDG Impact Dashboard</h1></div>

            <!-- SDG Banner -->
            <div class="sdg-banner">
                <h2>🎯 UN Sustainable Development Goals Alignment</h2>
                <p><strong>SDG 11:</strong> Sustainable Cities and Communities — Reducing disaster response times to build resilient urban areas.<br>
                <strong>SDG 13:</strong> Climate Action — Improving emergency coordination for climate-related disasters.</p>
            </div>

            <!-- Key Metrics -->
            <div class="card-grid">
                <div class="metric-card">
                    <div class="metric-icon">⏱️</div>
                    <div class="metric-value" style="color:var(--accent-cyan)">${metrics.avgResponseTimeMinutes}</div>
                    <div class="metric-label">Avg Response Time (minutes)</div>
                </div>
                <div class="metric-card">
                    <div class="metric-icon">✅</div>
                    <div class="metric-value" style="color:var(--accent-green)">${metrics.percentHandledWithinThreshold}%</div>
                    <div class="metric-label">Handled Within ${metrics.responseThresholdMinutes} min</div>
                </div>
                <div class="metric-card">
                    <div class="metric-icon">🆘</div>
                    <div class="metric-value" style="color:var(--accent-red)">${metrics.totalSosRequests}</div>
                    <div class="metric-label">Total SOS Requests</div>
                </div>
                <div class="metric-card">
                    <div class="metric-icon">🦺</div>
                    <div class="metric-value" style="color:var(--accent-blue)">${metrics.availableVolunteers}/${metrics.totalVolunteers}</div>
                    <div class="metric-label">Active Volunteers</div>
                </div>
            </div>

            <!-- Status Breakdown Chart -->
            <div class="card">
                <h3 style="margin-bottom:8px">📊 SOS Status Breakdown</h3>
                <div class="bar-chart">
                    <c:set var="maxVal" value="${metrics.totalSosRequests > 0 ? metrics.totalSosRequests : 1}"/>
                    <div class="bar-row"><div class="bar-label">New</div><div class="bar-track"><div class="bar-fill blue" style="width:${metrics.newSos * 100 / maxVal}%">${metrics.newSos}</div></div><div class="bar-value">${metrics.newSos}</div></div>
                    <div class="bar-row"><div class="bar-label">Assigned</div><div class="bar-track"><div class="bar-fill purple" style="width:${metrics.assignedSos * 100 / maxVal}%">${metrics.assignedSos}</div></div><div class="bar-value">${metrics.assignedSos}</div></div>
                    <div class="bar-row"><div class="bar-label">Resolved</div><div class="bar-track"><div class="bar-fill green" style="width:${metrics.resolvedSos * 100 / maxVal}%">${metrics.resolvedSos}</div></div><div class="bar-value">${metrics.resolvedSos}</div></div>
                    <div class="bar-row"><div class="bar-label">Escalated</div><div class="bar-track"><div class="bar-fill red" style="width:${metrics.escalatedSos * 100 / maxVal}%">${metrics.escalatedSos}</div></div><div class="bar-value">${metrics.escalatedSos}</div></div>
                </div>
            </div>

            <!-- Task Metrics -->
            <div class="card">
                <h3 style="margin-bottom:8px">📋 Task Metrics</h3>
                <div class="bar-chart">
                    <c:set var="taskMax" value="${(metrics.pendingTasks + metrics.completedTasks) > 0 ? (metrics.pendingTasks + metrics.completedTasks) : 1}"/>
                    <div class="bar-row"><div class="bar-label">Pending</div><div class="bar-track"><div class="bar-fill orange" style="width:${metrics.pendingTasks * 100 / taskMax}%">${metrics.pendingTasks}</div></div><div class="bar-value">${metrics.pendingTasks}</div></div>
                    <div class="bar-row"><div class="bar-label">Completed</div><div class="bar-track"><div class="bar-fill green" style="width:${metrics.completedTasks * 100 / taskMax}%">${metrics.completedTasks}</div></div><div class="bar-value">${metrics.completedTasks}</div></div>
                </div>
            </div>

            <!-- Response Time Target -->
            <div class="card">
                <h3 style="margin-bottom:16px">🎯 Response Time Target</h3>
                <div style="display:flex;align-items:center;gap:24px">
                    <div>
                        <div style="font-size:12px;color:var(--text-muted);text-transform:uppercase">Target</div>
                        <div style="font-size:24px;font-weight:800;color:var(--accent-cyan)">&lt; ${metrics.responseThresholdMinutes} min</div>
                    </div>
                    <div>
                        <div style="font-size:12px;color:var(--text-muted);text-transform:uppercase">Achievement Rate</div>
                        <div style="font-size:24px;font-weight:800;color:var(--accent-green)">${metrics.percentHandledWithinThreshold}%</div>
                    </div>
                    <div style="flex:1">
                        <div class="bar-track"><div class="bar-fill green" style="width:${metrics.percentHandledWithinThreshold}%">${metrics.percentHandledWithinThreshold}%</div></div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
