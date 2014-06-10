<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<jsp:include page="../../../tiles/head.jsp" />

<body>

	<jsp:include page="../../../tiles/custodian/header.jsp" />



	<div id="main">
		<div class="container">
			<jsp:include page="../../../tiles/custodian/leftmenu.jsp" />
			<div class="content">
				<section class="content-container">

					<div class="heading big">
						<h1>Add Usage Point</h1>
					</div>

					<div class="balance-section">

						<form:form modelAttribute="usagePointForm" name="usagePointForm"
							class="form-horizontal"
							action="${pageContext.request.contextPath}/custodian/retailcustomers/${retailCustomerId}/usagepoints/create">
							<div class="control-group">
								<label class="control-label" for="UUID">UUID</label>
								<div class="controls">
									<form:input path="UUID" />
									<form:errors path="UUID" cssClass="error" />
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<input type="submit" name="create" class="btn" value="Create" />
								</div>
							</div>
						</form:form>

					</div>
				</section>

			</div>
		</div>
		<jsp:include page="../../../tiles/footer.jsp" />

	</div>

</body>
</html>
