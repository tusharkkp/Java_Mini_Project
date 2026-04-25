<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SOS #${sos.id} Detail - Admin</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--bg-input:#334155;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-orange:#f97316;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--accent-yellow:#eab308;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s;--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-purple),var(--accent-blue));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(139,92,246,0.15);color:var(--accent-purple)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius);padding:24px;box-shadow:0 4px 24px rgba(0,0,0,0.3);margin-bottom:24px}
        .detail-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:24px}.detail-item .label{font-size:12px;color:var(--text-muted);text-transform:uppercase;margin-bottom:4px}.detail-item .value{font-size:16px;font-weight:600}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);text-decoration:none}.btn:hover{transform:translateY(-2px)}.btn-primary{background:linear-gradient(135deg,var(--accent-blue),var(--accent-purple));color:white}.btn-success{background:linear-gradient(135deg,var(--accent-green),var(--accent-cyan));color:white}.btn-outline{background:transparent;border:1px solid var(--border-color);color:var(--text-secondary)}.btn-sm{padding:6px 14px;font-size:12px}
        .table-container{overflow-x:auto;border-radius:var(--radius);border:1px solid var(--border-color)}table{width:100%;border-collapse:collapse;font-size:14px}thead{background:rgba(139,92,246,0.1)}th{padding:12px 14px;text-align:left;font-weight:600;font-size:11px;text-transform:uppercase;color:var(--text-muted);border-bottom:1px solid var(--border-color)}td{padding:10px 14px;border-bottom:1px solid var(--border-color);color:var(--text-secondary)}
        .badge{display:inline-flex;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:600;text-transform:uppercase}.badge-new{background:rgba(59,130,246,0.2);color:var(--accent-blue)}.badge-assigned{background:rgba(139,92,246,0.2);color:var(--accent-purple)}.badge-resolved{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-escalated{background:rgba(239,68,68,0.2);color:var(--accent-red)}.badge-active{background:rgba(6,182,212,0.2);color:var(--accent-cyan)}.badge-completed{background:rgba(34,197,94,0.2);color:var(--accent-green)}.badge-in_progress{background:rgba(59,130,246,0.2);color:var(--accent-blue)}.badge-pending{background:rgba(234,179,8,0.2);color:var(--accent-yellow)}
        .badge-critical{background:rgba(239,68,68,0.2);color:var(--accent-red)}.badge-high{background:rgba(249,115,22,0.2);color:var(--accent-orange)}.badge-medium{background:rgba(234,179,8,0.2);color:var(--accent-yellow)}.badge-low{background:rgba(34,197,94,0.2);color:var(--accent-green)}
        .alert{padding:14px 20px;border-radius:var(--radius-sm);margin-bottom:20px;font-size:14px}.alert-success{background:rgba(34,197,94,0.15);color:var(--accent-green);border:1px solid rgba(34,197,94,0.3)}.alert-error{background:rgba(239,68,68,0.15);color:var(--accent-red);border:1px solid rgba(239,68,68,0.3)}
        .form-control{width:auto;padding:8px 12px;background:var(--bg-input);border:1px solid var(--border-color);border-radius:var(--radius-sm);color:var(--text-primary);font-size:14px;font-family:var(--font-main)}
        select.form-control{appearance:none;padding-right:30px}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>⚡ Disaster Relief</h2><span>Admin Panel</span></div>
            <ul class="sidebar-nav">
                <li><a href="<c:url value='/admin/dashboard'/>">📊 Dashboard</a></li>
                <li><a href="<c:url value='/admin/sos'/>" class="active">🆘 All SOS</a></li>
                <li><a href="<c:url value='/admin/volunteers'/>">🦺 Volunteers</a></li>
                <li><a href="<c:url value='/admin/users'/>">👥 Users</a></li>
                <li><a href="<c:url value='/admin/sdg-metrics'/>">🌍 SDG Metrics</a></li>
                <li style="margin-top:auto;padding-top:24px;border-top:1px solid #334155"><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>
        <main class="main-content">
            <div class="top-bar">
                <h1>🆘 SOS Request #${sos.id}</h1>
                <a href="<c:url value='/admin/sos'/>" class="btn btn-outline">← Back to All SOS</a>
            </div>

            <c:if test="${not empty message}"><div class="alert alert-success">✅ ${message}</div></c:if>
            <c:if test="${not empty error}"><div class="alert alert-error">⚠️ ${error}</div></c:if>

            <!-- SOS Details -->
            <div class="card">
                <h3 style="margin-bottom:16px">📋 SOS Details</h3>
                <div class="detail-grid">
                    <div class="detail-item"><div class="label">Status</div><div class="value"><span class="badge badge-${sos.status.cssClass}">${sos.status}</span></div></div>
                    <div class="detail-item"><div class="label">Severity</div><div class="value"><span class="badge badge-${sos.severity.cssClass}">${sos.severity}</span></div></div>
                    <div class="detail-item"><div class="label">Reported By</div><div class="value">${sos.user.fullName}</div></div>
                    <div class="detail-item"><div class="label">Location</div><div class="value">${sos.locationName}</div></div>
                    <div class="detail-item"><div class="label">Coordinates</div><div class="value">${sos.latitude}, ${sos.longitude}</div></div>
                    <div class="detail-item"><div class="label">Created</div><div class="value">${sos.createdAt}</div></div>
                    <div class="detail-item"><div class="label">Response Time</div><div class="value"><c:if test="${sos.responseTimeMs != null}">${sos.responseTimeMs / 1000}s</c:if><c:if test="${sos.responseTimeMs == null}">Pending</c:if></div></div>
                </div>
                <div style="margin-top:12px"><strong>Description:</strong> ${sos.description}</div>
            </div>

            <!-- Assign Volunteer -->
            <c:if test="${sos.status == 'NEW' || sos.status == 'ACTIVE' || sos.status == 'ESCALATED'}">
                <div class="card">
                    <h3 style="margin-bottom:16px">🦺 Assign Volunteer (Nearest Available)</h3>
                    <c:choose>
                        <c:when test="${not empty availableVolunteers}">
                            <form action="<c:url value='/admin/sos/${sos.id}/assign'/>" method="post" style="display:flex;gap:12px;align-items:center">
                                <select name="volunteerId" class="form-control" required>
                                    <c:forEach items="${availableVolunteers}" var="v">
                                        <option value="${v.id}">${v.user.fullName} — (${v.latitude}, ${v.longitude}) — ${v.tasksCompleted} tasks done</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-success">✅ Assign</button>
                            </form>
                        </c:when>
                        <c:otherwise><p style="color:var(--text-muted)">No available volunteers found.</p></c:otherwise>
                    </c:choose>
                </div>
            </c:if>

            <!-- Assigned Tasks -->
            <div class="card">
                <h3 style="margin-bottom:16px">📋 Assigned Tasks</h3>
                <c:choose>
                    <c:when test="${not empty tasks}">
                        <div class="table-container">
                            <table>
                                <thead><tr><th>Task ID</th><th>Volunteer</th><th>Status</th><th>Assigned</th><th>Completed</th></tr></thead>
                                <tbody>
                                    <c:forEach items="${tasks}" var="t">
                                        <tr>
                                            <td>#${t.id}</td>
                                            <td>${t.volunteer.user.fullName}</td>
                                            <td><span class="badge badge-${t.status.cssClass}">${t.status}</span></td>
                                            <td>${t.assignedAt}</td>
                                            <td>${t.completedAt != null ? t.completedAt : '—'}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise><p style="color:var(--text-muted)">No tasks assigned yet.</p></c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</body>
</html>
