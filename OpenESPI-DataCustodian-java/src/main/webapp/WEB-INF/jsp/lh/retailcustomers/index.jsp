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

<jsp:include page="../tiles/head.jsp" />

<body>

	<jsp:include page="../tiles/header.jsp" />

	<div id="main">
		<div class="container">
			<jsp:include page="../tiles/custodian/leftmenu.jsp" />
			<div class="content">
				<section class="content-container">

					<div class="heading big">
						<h1>Manage Customer</h1>
					</div>

					<div class="balance-section">
						<div class="row">
							<div class="span12">
								<h2>Retail Customers</h2>

								<c:if test="${not empty message}">
									<div class="alert">${message}</div>
								</c:if>

								<a href="<c:url value='/custodian/retailcustomers/form'/>"
									class="btn btn-large"><i class="icon-plus"></i>&nbsp;Add
									new customer</a>

								<table class="table table-striped">
									<thead>
										<tr>
											<th></th>
											<th>Username</th>
											<th>First Name</th>
											<th>Last Name</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="customer" items="${customers}"
											varStatus="status">
											<tr>
												<td>${status.index+1}</td>
												<td><a
													href="<c:url value='/custodian/retailcustomers/${customer.id}/show'/>">
														<c:out value="${customer.username}" />
												</a></td>
												<td><c:out value="${customer.firstName}" /></td>
												<td><c:out value="${customer.lastName}" /></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
					</div>

				</section>
			</div>
		</div>

		<jsp:include page="../tiles/footer.jsp" />
	</div>
</body>
</html>
