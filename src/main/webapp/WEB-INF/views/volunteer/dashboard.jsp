<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Dashboard - Disaster Relief</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--accent-yellow:#eab308;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s cubic-bezier(0.4,0,0.2,1);--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-green),var(--accent-cyan));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(34,197,94,0.15);color:var(--accent-green)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;box-shadow:0 4px 24px rgba(0,0,0,0.3);margin-bottom:24px}.card:hover{border-color:var(--accent-green)}
        .card-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px;margin-bottom:32px}
        .stat-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;position:relative;overflow:hidden}.stat-card::before{content:'';position:absolute;top:0;left:0;width:4px;height:100%}.stat-card.green::before{background:var(--accent-green)}.stat-card.blue::before{background:var(--accent-blue)}.stat-card.orange::before{background:var(--accent-orange)}.stat-card.purple::before{background:var(--accent-purple)}
        .stat-card .stat-label{font-size:13px;color:var(--text-muted);font-weight:500;text-transform:uppercase}.stat-card .stat-value{font-size:36px;font-weight:800;margin:8px 0}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);text-decoration:none}.btn:hover{transform:translateY(-2px)}.btn-success{background:linear-gradient(135deg,var(--accent-green),var(--accent-cyan));color:white}.btn-danger{background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));color:white}.btn-outline{background:transparent;border:1px solid var(--border-color);color:var(--text-secondary)}.btn-sm{padding:6px 14px;font-size:12px}
        .table-container{overflow-x:auto;border-radius:var(--radius);border:1px solid var(--border-color)}table{width:100%;border-collapse:collapse;font-size:14px}thead{background:rgba(34,197,94,0.1)}th{padding:14px 16px;text-align:left;font-weight:600;font-size:12px;text-transform:uppercase;color:var(--text-muted);border-bottom:1px solid var(--border-color)}td{padding:12px 16px;border-bottom:1px solid var(--border-color);color:var(--text-secondary)}
        .badge{display:inline-flex;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;text-transform:uppercase}
        .badge-assigned{background:rgba(139,92,246,0.2);color:var(--accent-purple)}.badge-in_progress{background:rgba(59,130,246,0.2);color:var(--accent-blue)}.badge-completed{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-pending{background:rgba(234,179,8,0.2);color:var(--accent-yellow)}
        .badge-available{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-unavailable{background:rgba(239,68,68,0.2);color:var(--accent-red)}
        .alert{padding:14px 20px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:14px}.alert-success{background:rgba(34,197,94,0.15);color:var(--accent-green);border:1px solid rgba(34,197,94,0.3)}.alert-error{background:rgba(239,68,68,0.15);color:var(--accent-red);border:1px solid rgba(239,68,68,0.3)}
        .notif-badge{display:inline-flex;align-items:center;justify-content:center;min-width:20px;height:20px;padding:0 6px;border-radius:10px;background:var(--accent-red);color:white;font-size:11px;font-weight:700}
        .form-control{width:100%;padding:10px 14px;background:var(--bg-input);border:1px solid var(--border-color);border-radius:var(--radius-sm);color:var(--text-primary);font-size:14px;font-family:var(--font-main)}.form-control:focus{outline:none;border-color:var(--accent-blue)}
        .location-form{display:flex;gap:12px;align-items:end;flex-wrap:wrap}.location-form .form-group{margin-bottom:0}
        .empty-state{text-align:center;padding:60px 20px;color:var(--text-muted)}.empty-state h3{font-size:18px;margin-bottom:8px;color:var(--text-secondary)}
        .availability-toggle{display:flex;align-items:center;gap:12px;padding:16px;background:rgba(34,197,94,0.05);border-radius:var(--radius-sm);border:1px solid var(--border-color);margin-bottom:24px}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>🦺 Disaster Relief</h2><span>Volunteer Panel</span></div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/volunteer/dashboard'/>" class="active">📊 Dashboard</a></li>
                <li><a href="<c:url value='/volunteer/tasks'/>">📋 My Tasks</a></li>
                <li><a href="<c:url value='/volunteer/notifications'/>">🔔 Notifications <c:if test="${unreadCount > 0}"><span class="notif-badge">${unreadCount}</span></c:if></a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <div class="top-bar">
                <h1>Welcome, ${user.fullName}</h1>
                <c:if test="${volunteer != null}">
                    <span class="badge ${volunteer.available ? 'badge-available' : 'badge-unavailable'}">
                        ${volunteer.available ? '🟢 Available' : '🔴 Unavailable'}
                    </span>
                </c:if>
            </div>

            <c:if test="${not empty message}"><div class="alert alert-success">✅ ${message}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-error">⚠️ ${error}</div></c:if>

            <c:if test="${volunteer != null}">
                <!-- Availability & Location Controls -->
                <div class="availability-toggle">
                    <form action="<c:url value='/volunteer/toggle-availability'/>" method="post" style="display:inline">
                        <button type="submit" class="btn ${volunteer.available ? 'btn-danger' : 'btn-success'} btn-sm">
                            ${volunteer.available ? '⏸ Go Inactive' : '▶ Go Active'}
                        </button>
                    </form>
                    <span style="color:var(--text-muted);font-size:13px">|</span>
                    <form action="<c:url value='/volunteer/update-location'/>" method="post" class="location-form">
                        <div class="form-group">
                            <input type="number" name="latitude" class="form-control" step="0.000001" placeholder="Latitude" value="${volunteer.latitude}" style="width:140px" required>
                        </div>
                        <div class="form-group">
                            <input type="number" name="longitude" class="form-control" step="0.000001" placeholder="Longitude" value="${volunteer.longitude}" style="width:140px" required>
                        </div>
                        <button type="submit" class="btn btn-outline btn-sm">📍 Update Location</button>
                    </form>
                </div>

                <!-- Stats -->
                <div class="card-grid">
                    <div class="stat-card green">
                        <div class="stat-label">Tasks Completed</div>
                        <div class="stat-value">${volunteer.tasksCompleted}</div>
                    </div>
                    <div class="stat-card blue">
                        <div class="stat-label">Active Tasks</div>
                        <div class="stat-value">
                            <c:set var="activeTasks" value="0"/>
                            <c:forEach items="${tasks}" var="t">
                                <c:if test="${t.status == 'ASSIGNED' || t.status == 'IN_PROGRESS'}"><c:set var="activeTasks" value="${activeTasks + 1}"/></c:if>
                            </c:forEach>${activeTasks}
                        </div>
                    </div>
                    <div class="stat-card purple">
                        <div class="stat-label">Total Assigned</div>
                        <div class="stat-value">${tasks != null ? tasks.size() : 0}</div>
                    </div>
                </div>

                <!-- Recent Tasks -->
                <div class="card">
                    <h3 style="margin-bottom:16px">📋 Recent Assignments</h3>
                    <c:choose>
                        <c:when test="${not empty tasks}">
                            <div class="table-container">
                                <table>
                                    <thead><tr><th>Task ID</th><th>SOS #</th><th>Description</th><th>Status</th><th>Assigned</th><th>Action</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${tasks}" var="task">
                                            <tr>
                                                <td>#${task.id}</td>
                                                <td>#${task.sosRequest.id}</td>
                                                <td>${task.sosRequest.description}</td>
                                                <td><span class="badge badge-${task.status.cssClass}">${task.status}</span></td>
                                                <td>${task.assignedAt}</td>
                                                <td>
                                                    <c:if test="${task.status == 'ASSIGNED'}">
                                                        <form action="<c:url value='/volunteer/task/${task.id}/update'/>" method="post" style="display:inline">
                                                            <input type="hidden" name="status" value="IN_PROGRESS">
                                                            <button type="submit" class="btn btn-outline btn-sm">▶ Start</button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${task.status == 'IN_PROGRESS'}">
                                                        <form action="<c:url value='/volunteer/task/${task.id}/update'/>" method="post" style="display:inline">
                                                            <input type="hidden" name="status" value="COMPLETED">
                                                            <button type="submit" class="btn btn-success btn-sm">✅ Complete</button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state"><div style="font-size:48px">📭</div><h3>No tasks assigned yet</h3><p>You'll be notified when an admin assigns you to an SOS.</p></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>
