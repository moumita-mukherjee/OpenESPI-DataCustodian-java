<%@ page
	import="org.springframework.security.core.AuthenticationException"%>
<%@ page
	import="org.springframework.security.oauth2.common.exceptions.UnapprovedClientAuthenticationException"%>
<%@ page import="org.springframework.security.web.WebAttributes"%>
<%@ taglib prefix="authz"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<jsp:include page="../../tiles/head.jsp" />
<c:set var="menu" scope="session" value="cmd" />
<body>
	<div id="wrapper">
		<jsp:include page="../../tiles/header.jsp" />

		<script type="text/javascript">
			$(function() {
				$("form input[type=radio]").on("click", function() {
					$("input[type=submit]").removeAttr("disabled");
				});
			});
		</script>

		<div id="main">
			<div class="container">
				<jsp:include page="../../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<div>
						<p></p>
					</div>
					<section class="content-container">
					<div class="heading big">
						<h1>Services</h1>
					</div>
					<div class="balance-section">

						<%
							if (session.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION) != null
									&& !(session.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION) instanceof UnapprovedClientAuthenticationException)) {
						%>
						<div class="error">

							<h2>Whoops!</h2>

							<p>
								Access could not be granted. (<%=((AuthenticationException) session.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION))
						.getMessage()%>)
							</p>
						</div>
						<%
							}
						%>

						<c:remove scope="session" var="SPRING_SECURITY_LAST_EXCEPTION" />

						<c:if test="${message !=null}">
							<div class="alert">
								<c:out value="${message}" />
							</div>
						</c:if>
						<div class="panel panel-default">
							<div class="panel-heading">
								<h4>Application Details</h4>
							</div>
							<div class="panel-body">

								<div class="media">
									<a class="pull-left" href="#"> <img class="media-object"
										width="120" src="${thirdParty.logoUri}"
										alt="${thirdParty.thirdPartyApplicationName}"
										title="${thirdParty.thirdPartyApplicationName}" /></a>
									<div class="media-body">
										<h4 class="media-heading">
											<c:out value="${thirdParty.thirdPartyApplicationName}" />
										</h4>

										<span class="lable-note">From</span> <a
											href="${thirdParty.clientUri}" target="_new"><c:out
												value="${thirdParty.clientName}" /></a>
										<hr />
										<c:out value="${thirdParty.thirdPartyApplicationDescription}" />
									</div>
								</div>
							</div>

						</div>

						<form id="scopeselection" name="scopeselection"
							action="<%=request.getContextPath()%>/RetailCustomer/ScopeSelectionList"
							method="post">
							<input name="ThirdPartyID" value="${thirdParty.clientId}"
								type="hidden" />
							<div class="panel panel-default">
								<div class="panel-heading">
									<h4>SERVICES</h4>
								</div>
								<div class="panel-body">
									<table class="table table-striped table-hover">
										<thead>
											<tr>
												<th></th>
												<th>Address</th>
												<th>Service Number</th>
												<th>Billing Number</th>
												<th>Meter</th>
												<th>Status</th>
											</tr>
										</thead>
										<!-- 
											<tfoot>
												<tr>
													<td colspan=6><c:if test="${empty usagePointList}">
															<c:out value="No usage point available"></c:out>
														</c:if> <c:if test="${not empty usagePointList}">
														</c:if> <input type="radio" name="usage_point" value="0" /> I
														would like to authorize all services.</td>
												</tr>
											</tfoot>
											 -->
										<tbody>
											<c:forEach var="usagePoint" items="${usagePoints}">
												<tr>
													<td><input type="radio" class="checkbox"
														name="usage_point" value="${usagePoint.id}" /></td>
													<td><strong><c:out
																value="${usagePoint.usagePointDetail.streetUnit}" /> <c:if
																test="${not empty usagePoint.usagePointDetail.streetUnit}"> -
																	</c:if> <c:out
																value="${usagePoint.usagePointDetail.streetNumber}" />
															<c:out value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
														<c:out value="${usagePoint.usagePointDetail.streetCity}" /><br />
														<c:out value="${usagePoint.usagePointDetail.postalCode}" />
														<c:out
															value="${usagePoint.usagePointDetail.streetProvince}" /></td>
													<td><spring:message
															code="service.name.${usagePoint.serviceCategory.kind}" /><br />
														<c:out value="${usagePoint.usagePointDetail.serviceId}" /></td>
													<td><c:out
															value="${usagePoint.usagePointDetail.accountId}" /></td>
													<td><c:out
															value="${usagePoint.usagePointDetail.meterNumber}" /></td>
													<td><c:choose>
															<c:when
																test="${usagePoint.usagePointDetail.status=='Active'}">
																<span class="status-active"> <c:out
																		value="${usagePoint.usagePointDetail.status}"
																		default="-" />
																</span>
															</c:when>
															<c:otherwise>
																<span class="status-inactive"> Ended On <br /> <fmt:formatDate
																		value="${usagePoint.usagePointDetail.endDate}"
																		pattern="MMM dd, yyyy" /></span>
															</c:otherwise>
														</c:choose></td>


												</tr>
											</c:forEach>
										</tbody>

									</table>
								</div>
							</div>
							<label> <input name="continue" value="Continue"
								disabled="disabled" type="submit" class="btn btn-primary"></input></label>
						</form>

					</div>
					</section>
				</div>

			</div>
		</div>
		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
