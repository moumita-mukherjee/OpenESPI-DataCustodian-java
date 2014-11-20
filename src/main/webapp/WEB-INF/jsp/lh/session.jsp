<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<title>View Session JSP</title>
</head>
<body>
	<h2>Session Info From A JSP</h2>

	The session id:
	<c:out value="${pageContext.session.id}" />

	<h3>Session date values formatted as Dates</h3>

	<jsp:useBean id="timeValues" class="java.util.Date" />

	<c:set target="${timeValues}"
		value="${pageContext.session.creationTime}" property="time" />
	The creation time:
	<fmt:formatDate value="${timeValues}" type="both" dateStyle="long"
		timeZone="EST" />
	<br />
	<br />

	<c:set target="${timeValues}"
		value="${pageContext.session.lastAccessedTime}" property="time" />
	The last accessed time:

	<fmt:formatDate value="${timeValues}" type="both" dateStyle="long"
		timeZone="EST" />
	<br />

	<c:out value="${timeValues}" />
</body>
</html>