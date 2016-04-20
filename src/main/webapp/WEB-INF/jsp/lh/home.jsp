<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@ page session="false"%>
<%--
  ~ Copyright 2013 EnergyOS.org
  ~
  ~    Licensed under the Apache License, Version 2.0 (the "License");
  ~    you may not use this file except in compliance with the License.
  ~    You may obtain a copy of the License at
  ~
  ~        http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~    Unless required by applicable law or agreed to in writing, software
  ~    distributed under the License is distributed on an "AS IS" BASIS,
  ~    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~    See the License for the specific language governing permissions and
  ~    limitations under the License.
  --%>
<security:authorize access="isAuthenticated()">
	<jsp:forward page="/RetailCustomer/${currentCustomer.id}/home"></jsp:forward>
</security:authorize>
<!DOCTYPE html>
<html lang="en">

<jsp:include page="tiles/head.jsp" />

<body onload="initOpenCloseFooter()">

	<jsp:include page="tiles/header.jsp" />
	<div id="main">
		<div class="container">


			<!-- Main hero unit for a primary marketing message or call to action -->
			<div class="balance-section" srckey="greenbuttonlandingpage">
			<div class="balance-section" srckey="greenbuttonlandingpage">
			<p>
				<img alt="GB Landing Page" width="100%" src="<c:url value='/resources/images/gb-landing-promo.png' />">
			</p>

<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
.<a href="http://mygreenbutton.ca/" target="_new">
<img alt="Educate Me" width="32%" align="middle" src="/resources/images/educateme_april7.png">
</a> <a href="<c:url value='/login'/>">
<img alt="Let Me Participate" width="32%" align="middle" src="/resources/images/letmeparticipate_april7.png">
</a></p>


</div>

			</div>
			<br> <br>
		</div>
		<jsp:include page="tiles/footer.jsp" />
	</div>
</body>
</html>