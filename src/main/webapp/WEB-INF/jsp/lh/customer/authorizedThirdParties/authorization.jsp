<%@page import="java.net.URLEncoder"%>
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
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
<script type="text/javascript" src="/resources/js/jquery.min.js"></script>
</head>
<jsp:include page="../../tiles/head.jsp" />
<c:set var="menu" scope="session" value="cmd" />
<body>
	<div id="wrapper">
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
						<c:choose>
							<c:when test="${fn:length(usagePoints) gt 0}">								
								
								<form id="confirmationForm" name="confirmationForm"
								action="<%=request.getContextPath()%>/oauth/accesstoken?client_id=${thirdParty.clientId}"
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
														<th>Address</th>
														<th>Billing Number</th>
														<th>Service</th>
														<th>Usage Point</th>
														<th>Meter</th>
														<th>Status</th>
													</tr>
												</thead>
												
												<tbody>
													<c:forEach var="usagePoint" items="${usagePoints}">
														<tr>
															
															<td><strong><c:out
																		value="${usagePoint.usagePointDetail.streetUnit}" />
																	<c:if
																		test="${not empty usagePoint.usagePointDetail.streetUnit}"> -
																	</c:if> <c:out
																		value="${usagePoint.usagePointDetail.streetNumber}" />
																	<c:out
																		value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
																<c:out value="${usagePoint.usagePointDetail.streetCity}" /><br />
																<c:out value="${usagePoint.usagePointDetail.postalCode}" />
																<c:out
																	value="${usagePoint.usagePointDetail.streetProvince}" /></td>
															<td><c:out
																	value="${usagePoint.usagePointDetail.accountId}" /></td>
															<td><spring:message
																	code="service.name.${usagePoint.serviceCategory.kind}" /><br />
																<c:out value="${usagePoint.usagePointDetail.serviceId}" /></td>
															<td><c:out value="${usagePoint.id}" /></td>
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
																		<span class="status-inactive"> Ended On <br />
																			<fmt:formatDate
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

									<label> <input name="Authorize" value="Authorize"
										 type="submit" class="btn btn-primary"></input></label>

								</form>
							</c:when>
							<c:otherwise>
							You are not able to authorize this application due to one or more of the following reasons:
							<ul>
									<li>You have already authorized the application for
										another service. If you would like to add more services to
										that authorization, please click on the "Edit" button (located
										next to the application listing in the Authorized Applications
										screen).</li>
									<li>The application does not support the service(s) that you require.</li>
								</ul>
							</c:otherwise>
						</c:choose>

					</div>
					</section>
				</div>

			</div>
		</div>
		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
