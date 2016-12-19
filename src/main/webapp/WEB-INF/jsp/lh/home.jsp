
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

<body>

	<jsp:include page="tiles/header.jsp" />
	<div id="main">
		<div class="container">


			<!-- Main hero unit for a primary marketing message or call to action -->
			<div class="balance-section" srckey="greenbuttonlandingpage">
				<!-- 				<h2>Welcome to the London Hydro Green Button Portal</h2>
				<br> <br>
				<div class="row">
					<div class="col-xs-6 col-md-3">

						<article>
							<p>
								If you have already registered with London Hydro you may login
								to our GreenButton Portal using your MyLondonHydro email address
								and password. If you have not yet registered with MyLondonHydro
								please click on <a type="button" class="btn btn-primary"
									href="https://www.londonhydro.com/site/#!/login">REGISTER NOW</a>.
							</p>
						</article>
					</div>
					<div class="col-xs-6 col-md-3"></div>
					<div class="col-xs-6 col-md-3">

						<article>
							<p>
								If you have an innovative application and would like to register
								with us. Please click below.<br> <a
									href="/DataCustodian/thirdparty/registration"
									class="btn btn-primary btn-lg" role="button">Register your
									Application</a>
							</p>

						</article>
					</div>
				</div>
 -->
			</div>
			<br> <br>
		</div>
		<jsp:include page="tiles/footer.jsp" />
	</div>
</body>
</html>