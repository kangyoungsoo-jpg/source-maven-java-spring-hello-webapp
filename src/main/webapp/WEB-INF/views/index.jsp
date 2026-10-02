<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<html>
<head>
<title>Hello World</title>
</head>
<body>
<h1><Hello Spring Boot Web App!/h1>
<p>Updated via GitOps with ArgoCD!</p>
<h2>Today is <fmt:formatDate value="${today}" pattern="yyyy-MM-dd"/></h2>
<h3>Version: 1.0</h3>
</body>
</html>
