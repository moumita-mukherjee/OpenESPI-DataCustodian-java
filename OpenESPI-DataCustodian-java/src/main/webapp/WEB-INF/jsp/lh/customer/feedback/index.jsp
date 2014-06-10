<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%--
  ~ Copyright 2013, 2014 EnergyOS.org
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

<jsp:include page="../../tiles/head.jsp" />

<jsp:useBean id="dateController"
	class="org.energyos.espi.datacustodian.utils.DateController" />
<script type="text/javascript"
	src="<c:url value='/resources/bootstrap-datetimepicker-0.0.11/js/bootstrap-datetimepicker.min.js'/> ">
	
</script>
<c:set var="menu" scope="session" value="feedback"/>
<body>
	<div id="wrapper">
		<jsp:include page="../../tiles/header.jsp" />

		<div id="main">
			<div class="container">
				<jsp:include page="../../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">
						<div class="heading big">
							<h1>YOUR FEEDBACK</h1>
						</div>
						<div class="balance-section">
							<p>
							<!-- 
								<img alt="educateme" width="100%"
									src="${pageContext.request.contextPath}/resources/images/navigation/greenbutton_evaluation.png">
									 -->
									<iframe style="background-color: #ffffff;" width="100%" height="2650px" src="https://docs.google.com/a/londonhydro.com/forms/d/1kPeCsNXa01Rt3uhObxvzJPCMuJ0bWclQIpaTOs-LQA8/viewform"></iframe>
							</p>
						</div>
					</section>
				</div>


			</div>
		</div>
		<jsp:include page="../../tiles/footer.jsp" />
	</div>
</body>
</html>
