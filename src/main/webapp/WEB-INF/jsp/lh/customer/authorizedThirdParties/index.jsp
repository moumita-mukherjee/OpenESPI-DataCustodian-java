<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<jsp:useBean id="dateValue" class="java.util.Date" />
<jsp:include page="../../tiles/head.jsp" />

<body>
	<script type="text/javascript">
		function doAjaxPost(url) {
			$.ajax({
				type : "delete",
				url : url,
				success : function(response) {
					alert(response);
				},
				error : function(e) {
					alert('Error: ' + e);
				}
			});
		}
	</script>
	<jsp:include page="../../tiles/header.jsp" />

	<div id="main">
		<div class="container">
			<jsp:include page="../../tiles/customer/leftmenu.jsp" />
			<div class="content">
				<div>
					<p></p>
				</div>
				<section class="content-container">



					<div class="heading big">
						<h1>Authorizations</h1>
					</div>
					<div class="balance-section table-responsive">


						<form id="revokeform"
							action="<%=request.getContextPath()%>/oauth/authorize"
							method="delete">


							
									<table class="table table-striped" id="authorizations">
										<thead>
											<tr>
												<th>GreenButton Apps</th>
												<th>Provider</th>
												<th>Status</th>
												<th>Authorized On</th>
												<th>Valid Till</th>
												<th>Action</th>

											</tr>
										</thead>

										<tfoot>
											<tr>
												<td colspan=6><c:if test="${empty authorizationList}">
														<c:out
															value="You have not yet authorized any application to view your usage."></c:out>
													</c:if></td>
											</tr>
										</tfoot>
										<tbody>
											<c:forEach var="authorization" items="${authorizationList}">
												<tr>
													<td name="third_party" class="data_custodian"><a
														href="${authorization.resourceURI}"><c:out
																value="${authorization.applicationInformation.thirdPartyApplicationName}" /></a></td>
													<td><span> <img alt="logo" width="120"
															 class="img-rounded-2"
															src="${authorization.applicationInformation.logoUri}"
															title="${authorization.applicationInformation.clientName}" />
													</span></td>
													<td class="status"><c:out
															value="${authorization.status}" /></td>
													<td><jsp:setProperty property="time" name="dateValue"
															value="${authorization.authorizedPeriod.start}" /> <fmt:formatDate
															value="${dateValue}" pattern="MM/dd/yyyy HH:mm" /></td>
													<td><jsp:setProperty property="time" name="dateValue"
															value="${authorization.authorizedPeriod.start+authorization.authorizedPeriod.duration}" />
														<fmt:formatDate value="${dateValue}"
															pattern="MM/dd/yyyy HH:mm" /></td>
													<td class="subscription_id"><input type="button"
														value="Revoke" title="${authorization.authorizationURI}"
														onclick="doAjaxPost('${authorization.authorizationURI}')" />
														<a href="${authorization.authorizationURI}" target="_new">
															Revoke</a></td>


												</tr>
											</c:forEach>
										</tbody>
									</table>
								

						</form>
					</div>

				</section>
			</div>
		</div>

		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
