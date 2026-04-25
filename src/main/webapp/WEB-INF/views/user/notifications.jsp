<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');
        :root{--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-card:#1e293b;--text-primary:#f1f5f9;--text-secondary:#94a3b8;--text-muted:#64748b;--accent-red:#ef4444;--accent-blue:#3b82f6;--accent-green:#22c55e;--accent-orange:#f97316;--accent-purple:#8b5cf6;--accent-cyan:#06b6d4;--border-color:#334155;--radius:12px;--radius-sm:8px;--transition:all 0.3s;--font-main:'Inter',system-ui,sans-serif}
        *{box-sizing:border-box;margin:0;padding:0}body{font-family:var(--font-main);background:var(--bg-primary);color:var(--text-primary);line-height:1.6}a{color:var(--accent-blue);text-decoration:none}
        .page-wrapper{display:flex;min-height:100vh}.sidebar{width:260px;background:var(--bg-secondary);border-right:1px solid var(--border-color);padding:24px 0;position:fixed;top:0;left:0;height:100vh;z-index:100}
        .sidebar-logo{padding:0 24px 24px;border-bottom:1px solid var(--border-color);margin-bottom:16px}.sidebar-logo h2{font-size:18px;font-weight:700;background:linear-gradient(135deg,var(--accent-red),var(--accent-orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}.sidebar-logo span{font-size:12px;color:var(--text-muted)}
        .sidebar-nav{list-style:none;padding:0 12px}.sidebar-nav li{margin-bottom:4px}.sidebar-nav a{display:flex;align-items:center;gap:12px;padding:10px 16px;border-radius:var(--radius-sm);color:var(--text-secondary);font-size:14px;font-weight:500;transition:var(--transition)}.sidebar-nav a:hover,.sidebar-nav a.active{background:rgba(59,130,246,0.15);color:var(--accent-blue)}
        .main-content{margin-left:260px;flex:1;padding:32px}.top-bar{display:flex;justify-content:space-between;align-items:center;margin-bottom:32px;padding-bottom:16px;border-bottom:1px solid var(--border-color)}.top-bar h1{font-size:28px;font-weight:700}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:10px 20px;border-radius:var(--radius-sm);font-size:14px;font-weight:600;border:none;cursor:pointer;transition:var(--transition);text-decoration:none}.btn:hover{transform:translateY(-2px)}.btn-primary{background:linear-gradient(135deg,var(--accent-blue),var(--accent-purple));color:white}.btn-outline{background:transparent;border:1px solid var(--border-color);color:var(--text-secondary)}.btn-sm{padding:6px 14px;font-size:12px}
        .notif-item{background:var(--bg-card);border:1px solid var(--border-color);border-radius:var(--radius-sm);padding:16px 20px;margin-bottom:8px;display:flex;align-items:center;gap:16px;transition:var(--transition)}
        .notif-item:hover{border-color:var(--accent-blue)}
        .notif-item.unread{border-left:3px solid var(--accent-blue);background:rgba(59,130,246,0.05)}
        .notif-icon{font-size:24px;flex-shrink:0}
        .notif-content{flex:1}.notif-content .message{font-size:14px;color:var(--text-primary)}.notif-content .meta{font-size:12px;color:var(--text-muted);margin-top:4px}
        .empty-state{text-align:center;padding:60px 20px;color:var(--text-muted)}.empty-state h3{font-size:18px;margin-bottom:8px;color:var(--text-secondary)}
    </style>
</head>
<body>
    <div class="page-wrapper">
        <nav class="sidebar">
            <div class="sidebar-logo"><h2>🚨 Disaster Relief</h2><span>Notifications</span></div>
            <ul class="sidebar-nav">
                <li><a href="javascript:history.back()">← Back</a></li>
                <li><a href="<c:url value='/logout'/>">🚪 Logout</a></li>
            </ul>
        </nav>
        <main class="main-content">
            <div class="top-bar">
                <h1>🔔 Notifications</h1>
                <form action="notifications/read-all" method="post"><button class="btn btn-outline btn-sm">✅ Mark All Read</button></form>
            </div>
            <c:choose>
                <c:when test="${not empty notifications}">
                    <c:forEach items="${notifications}" var="n">
                        <div class="notif-item ${!n.read ? 'unread' : ''}">
                            <div class="notif-icon">
                                <c:choose>
                                    <c:when test="${n.type == 'SOS_ALERT'}">🆘</c:when>
                                    <c:when test="${n.type == 'TASK_ASSIGNED'}">📋</c:when>
                                    <c:when test="${n.type == 'ESCALATION'}">⚠️</c:when>
                                    <c:otherwise>🔔</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="notif-content">
                                <div class="message">${n.message}</div>
                                <div class="meta">${n.createdAt} · ${n.type}</div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state"><div style="font-size:48px">🔕</div><h3>No notifications</h3><p>You're all caught up!</p></div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</body>
</html>
