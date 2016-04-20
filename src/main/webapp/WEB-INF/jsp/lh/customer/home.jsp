<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
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

<jsp:include page="../tiles/head.jsp" />
<c:set var="menu" scope="session" value="home" />
<body onload="initOpenCloseFooter()">
	<div id="wrapper">
		<jsp:include page="../tiles/header.jsp" />

		<div id="main">
			<div class="container">
				<jsp:include page="../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">
						<div class="balance-section">
							<article class="post-box">
								<div class="text-container">
									<div data-ng-bind-html-unsafe="content.body" class="ng-binding"
										srckey="educateme">
										<p>
											<img alt="GB Landing Page" width="100%" src="<c:url value='/resources/images/gb-landing-promo.png' />">
										</p>										
									</div>
								</div>
							</article>

						</div>
					</section>
				</div>

			</div>
		</div>
		<jsp:include page="../tiles/footer.jsp" />
	</div>
</body>
</html>