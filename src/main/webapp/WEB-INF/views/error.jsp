<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Disaster Relief</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',system-ui,sans-serif;background:#0f172a;color:#f1f5f9;display:flex;align-items:center;justify-content:center;min-height:100vh}
        .error-card{text-align:center;padding:60px;background:#1e293b;border:1px solid #334155;border-radius:16px;max-width:500px;box-shadow:0 8px 40px rgba(0,0,0,0.4)}
        .error-icon{font-size:72px;margin-bottom:20px}
        h1{font-size:24px;margin-bottom:12px}
        p{color:#94a3b8;margin-bottom:24px}
        a{display:inline-block;padding:12px 24px;background:linear-gradient(135deg,#3b82f6,#8b5cf6);color:white;border-radius:8px;font-weight:600;text-decoration:none;transition:all 0.3s}
        a:hover{transform:translateY(-2px)}
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-icon">⚠️</div>
        <h1>Oops! Something went wrong</h1>
        <p>The page you're looking for could not be found or an error occurred.</p>
        <a href="/">← Return to Home</a>
    </div>
</body>
</html>
