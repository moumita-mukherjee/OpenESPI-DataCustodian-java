<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
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

<!DOCTYPE html>
<html lang="en">

<jsp:include page="tiles/head.jsp" />

<body>
	<div id="wrapper">

		<jsp:include page="tiles/header.jsp" />
		<div id="main">
			<div class="container">
				<div class="main-holder">
					<section>
						<c:if
							test="${not empty sessionScope.SPRING_SECURITY_LAST_EXCEPTION}">
							<div class="alert alert-error error">
								<c:choose>
									<c:when
										test="${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.localizedMessage=='Bad credentials'}">
										<c:out value="Invalid username and/or password." />
									</c:when>
									<c:when
										test="${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.localizedMessage=='UserDetailsService returned null, which is an interface contract violation'}">
										<c:out value="Invalid username and/or password." />
									</c:when>									
									<c:otherwise>
										<c:out
											value="${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.localizedMessage}" />
									</c:otherwise>
								</c:choose>
							</div>
						</c:if>
						<section>
							<br> <br> <br>
							<div class="login-area">
								<div class="register-area"></div>
								<form name="f" class="form-inline"
									action="<c:url value='/j_spring_security_check'/>"
									method="POST" class="login-form form-inline">
									<fieldset>
									<div class="form-group" style="padding-top: 35px;">
										<strong class="title">Login</strong></div>
										<div class="form-group">
											<label for="login">Email Address</label>
											<div class="clearfix">
												<input type="text" name="j_username" size="30"
													placeholder="Username" autofocus="autofocus"
													class="form-control">
											</div>
										</div>
										<div class="form-group">
											<label for="password">Password</label>
											<div class="clearfix">
												<input type="password" name="j_password"
													placeholder="Password" class="form-control" autocomplete="off" >
											</div>

										</div>
										<div class="form-group">
											<label>&nbsp;</label>
											<div class="clearfix">
												<button class="btn btn-primary" name="submit" type="submit">Sign
													in</button>
											</div>
										</div>
									</fieldset>
								</form>
								<br><br>
								<p>
								Please use your current MyLondonHydro login identification and password to login to the Green Button microsite.
								</p>
							</div>
						</section>

					</section>

				</div>

			</div>
		</div>
		<br> <br> <br> <br> <br> <br>
		<jsp:include page="tiles/footer.jsp" />
	</div>
	<a href="#wrapper" class="skip-link">back to top</a>
</body>
</html>
