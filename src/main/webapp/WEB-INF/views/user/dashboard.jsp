<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Disaster Relief</title>
    <link rel="stylesheet" href="<c:url value='/WEB-INF/css/style.css'/>">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s cubic-bezier(0.4,0,0.2,1);--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;overflow-y:auto;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(59,130,246,0.15);color:var(--accent-blue)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;transition:var(--transition);box-shadow:0 4px 24px rgba(0,0,0,0.3);margin-bottom:24px}.card:hover{border-color:var(--accent-blue);transform:translateY(-2px)}
        .card-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px;margin-bottom:32px}
        .stat-card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;position:relative;overflow:hidden;transition:var(--transition)}.stat-card::before{content:'';position:absolute;top:0;left:0;width:4px;height:100%}.stat-card.red::before{background:var(--accent-red)}.stat-card.blue::before{background:var(--accent-blue)}.stat-card.green::before{background:var(--accent-green)}.stat-card.orange::before{background:var(--accent-orange)}
        .stat-card .stat-label{font-size:13px;color:var(--text-muted);font-weight:500;text-transform:uppercase}.stat-card .stat-value{font-size:36px;font-weight:800;margin:8px 0}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);text-decoration:none}.btn:hover{transform:translateY(-2px)}.btn-danger{background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));color:white}.btn-outline{background:transparent;border:1px solid var(--border-color);color:var(--text-secondary)}.btn-outline:hover{border-color:var(--accent-blue);color:var(--accent-blue)}
        .table-container{overflow-x:auto;border-radius:var(--radius);border:1px solid var(--border-color)}table{width:100%;border-collapse:collapse;font-size:14px}thead{background:rgba(59,130,246,0.1)}th{padding:14px 16px;text-align:left;font-weight:600;font-size:12px;text-transform:uppercase;color:var(--text-muted);border-bottom:1px solid var(--border-color)}td{padding:12px 16px;border-bottom:1px solid var(--border-color);color:var(--text-secondary)}tr:hover td{background:rgba(59,130,246,0.05)}
        .badge{display:inline-flex;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;text-transform:uppercase}.badge-new{background:rgba(59,130,246,0.2);color:var(--accent-blue)}.badge-assigned{background:rgba(139,92,246,0.2);color:var(--accent-purple)}.badge-resolved{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-escalated{background:rgba(239,68,68,0.2);color:var(--accent-red)}.badge-active{background:rgba(6,182,212,0.2);color:var(--accent-cyan)}
        .badge-critical{background:rgba(239,68,68,0.2);color:var(--accent-red)}.badge-high{background:rgba(249,115,22,0.2);color:var(--accent-orange)}.badge-medium{background:rgba(234,179,8,0.2);color:#eab308}.badge-low{background:rgba(34,197,94,0.2);color:var(--accent-green)}
        .alert{padding:14px 20px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:14px}.alert-success{background:rgba(34,197,94,0.15);color:var(--accent-green);border:1px solid rgba(34,197,94,0.3)}.alert-error{background:rgba(239,68,68,0.15);color:var(--accent-red);border:1px solid rgba(239,68,68,0.3)}
        .notif-badge{display:inline-flex;align-items:center;justify-content:center;min-width:20px;height:20px;padding:0 6px;border-radius:10px;background:var(--accent-red);color:white;font-size:11px;font-weight:700}
        .empty-state{text-align:center;padding:60px 20px;color:var(--text-muted)}.empty-state h3{font-size:18px;margin-bottom:8px;color:var(--text-secondary)}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <!-- Sidebar Navigation -->
        <nav class="sidebar">
            <div class="sidebar-logo">
                <h2>🚨 Disaster Relief</h2>
                <span>User Panel</span>
            </div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/user/dashboard'/>" class="active">📊 Dashboard</a></li>
                <li><a href="<c:url value='/user/sos/create'/>">🆘 Create SOS</a></li>
                <li><a href="<c:url value='/user/notifications'/>">🔔 Notifications <c:if test="${unreadCount > 0}"><span class="notif-badge">${unreadCount}</span></c:if></a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="top-bar">
                <h1>Welcome, ${user.fullName}</h1>
                <a href="<c:url value='/user/sos/create'/>" class="btn btn-danger">🆘 Create SOS</a>
            </div>

            <c:if test="${not empty message}"><div class="alert alert-success">✅ ${message}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-error">⚠️ ${error}</div></c:if>

            <!-- Stats Cards -->
            <div class="card-grid">
                <div class="stat-card red">
                    <div class="stat-label">Total SOS Requests</div>
                    <div class="stat-value">${sosRequests.size()}</div>
                </div>
                <div class="stat-card blue">
                    <div class="stat-label">Active Requests</div>
                    <div class="stat-value">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach items="${sosRequests}" var="s">
                            <c:if test="${s.status == 'NEW' || s.status == 'ACTIVE' || s.status == 'ASSIGNED'}">
                                <c:set var="activeCount" value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </div>
                </div>
                <div class="stat-card green">
                    <div class="stat-label">Resolved</div>
                    <div class="stat-value">
                        <c:set var="resolvedCount" value="0"/>
                        <c:forEach items="${sosRequests}" var="s">
                            <c:if test="${s.status == 'RESOLVED'}">
                                <c:set var="resolvedCount" value="${resolvedCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${resolvedCount}
                    </div>
                </div>
            </div>

            <!-- SOS Request History -->
            <div class="card">
                <h3 style="margin-bottom:16px">📋 My SOS Request History</h3>
                <c:choose>
                    <c:when test="${not empty sosRequests}">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr><th>ID</th><th>Location</th><th>Description</th><th>Severity</th><th>Status</th><th>Created</th></tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${sosRequests}" var="sos">
                                        <tr>
                                            <td>#${sos.id}</td>
                                            <td>${sos.locationName}</td>
                                            <td>${sos.description}</td>
                                            <td><span class="badge badge-${sos.severity.cssClass}">${sos.severity}</span></td>
                                            <td><span class="badge badge-${sos.status.cssClass}">${sos.status}</span></td>
                                            <td>${sos.createdAt}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div style="font-size:48px">📭</div>
                            <h3>No SOS requests yet</h3>
                            <p>Click "Create SOS" to raise an emergency request</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</body>
</html>
