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
<jsp:include page="tiles/head.jsp" />
<body>

	<script type="text/javascript">
		$(function() {
			$("form input[type=checkbox]")
					.on(
							"click",
							function() {
								var tos = $('#tos').prop('checked');
								var privacypolicy = $('#privacypolicy').prop(
										'checked');

								$("input[type=submit]").attr("disabled",
										!(tos && privacypolicy));

							});
		});
	</script>
	<div id="wrapper">
		<jsp:include page="tiles/header.jsp" />

		<div id="main">
			<div class="container">
				<jsp:include page="./tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">

					<div class="heading big">
						<h1>Confirmation</h1>
					</div>
					<div class="balance-section">


						<%
							if (session.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION) != null
									&& !(session
											.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION) instanceof UnapprovedClientAuthenticationException)) {
						%>
						<div class="error">

							<h2>Whoops!</h2>

							<p>
								Access could not be granted. (<%=((AuthenticationException) session
						.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION))
						.getMessage()%>)
							</p>
						</div>
						<%
							}
						%>
						<c:remove scope="session" var="SPRING_SECURITY_LAST_EXCEPTION" />

						<authz:authorize ifAllGranted="ROLE_USER">



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
							<span class="nowrap"> You are authorizing the service
								shown below until <strong><fmt:formatDate
										value="${authorizationEndDate}" pattern="MMM dd, yyyy" /></strong> <a
								class="btn btn-primary" href="#" data-toggle="modal"
								data-target="#dateSelectionModal">Change </a>
							</span>
							<br />
							<br />
							<c:if test="${selectedUsagePoint ==null}">
								<c:forEach var="oneselectedUsagePoint"
									items="${selectedUsagePoints}">
									<!-- default auto select case for single service -->
									<div class="panel panel-default">
										<div class="panel-heading">
											<h4>
												<c:out
													value="${oneselectedUsagePoint.usagePointDetail.streetUnit}" />
												<c:if
													test="${not empty oneselectedUsagePoint.usagePointDetail.streetUnit}">
											-
											</c:if>
												<c:out
													value="${oneselectedUsagePoint.usagePointDetail.streetNumber}" />
												<c:out
													value="${oneselectedUsagePoint.usagePointDetail.streetName}" />
											</h4>
											<h5>
												<c:out
													value="${oneselectedUsagePoint.usagePointDetail.streetCity}" />
												<br />
												<c:out
													value="${oneselectedUsagePoint.usagePointDetail.postalCode}" />
												<c:out
													value="${oneselectedUsagePoint.usagePointDetail.streetProvince}" />
											</h5>

										</div>
										<div class="panel-body">
											<div class="row">
												<div class="col-xs-6 col-md-3">
													<dl class="dl-horizontal">
														<dt>Billing Number:</dt>
														<dd>
															<c:out
																value="${oneselectedUsagePoint.usagePointDetail.accountId}" />
														</dd>
														<dt>Service Number:</dt>
														<dd>
															<c:out
																value="${oneselectedUsagePoint.usagePointDetail.serviceId}" />
														</dd>
													</dl>
												</div>
												<div class="col-xs-6 col-md-6">
													<dl class="dl-horizontal">
														<dt>Meter Number:</dt>
														<dd>
															<c:out
																value="${oneselectedUsagePoint.usagePointDetail.meterNumber}" />
														</dd>
														<dt>Status:</dt>
														<dd>
															<c:choose>
																<c:when
																	test="${oneselectedUsagePoint.usagePointDetail.status=='Active'}">
																	<span class="status-active"> <c:out
																			value="${oneselectedUsagePoint.usagePointDetail.status}"
																			default="-" />
																	</span>
																</c:when>
																<c:otherwise>
																	<span class="status-inactive"> Ended On <br />
																		<fmt:formatDate
																			value="${oneselectedUsagePoint.usagePointDetail.endDate}"
																			pattern="MMM dd, yyyy" /></span>
																</c:otherwise>
															</c:choose>
														</dd>
													</dl>
												</div>
											</div>

										</div>
									</div>
								</c:forEach>
							</c:if>
							<c:if test="${selectedUsagePoint !=null}">
								<!-- user select case -->
								<div class="panel panel-default">
									<div class="panel-heading">
										<h4>
											<c:out
												value="${selectedUsagePoint.usagePointDetail.streetUnit}" />
											<c:if
												test="${not empty selectedUsagePoint.usagePointDetail.streetUnit}">
											-
											</c:if>
											<c:out
												value="${selectedUsagePoint.usagePointDetail.streetNumber}" />
											<c:out
												value="${selectedUsagePoint.usagePointDetail.streetName}" />
										</h4>
										<h5>
											<c:out
												value="${selectedUsagePoint.usagePointDetail.streetCity}" />
											<br />
											<c:out
												value="${selectedUsagePoint.usagePointDetail.postalCode}" />
											<c:out
												value="${selectedUsagePoint.usagePointDetail.streetProvince}" />
										</h5>

									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col-xs-6 col-md-3">
												<dl class="dl-horizontal">
													<dt>Billing Number:</dt>
													<dd>
														<c:out
															value="${selectedUsagePoint.usagePointDetail.accountId}" />
													</dd>
													<dt>Service Number:</dt>
													<dd>
														<c:out
															value="${selectedUsagePoint.usagePointDetail.serviceId}" />
													</dd>
												</dl>
											</div>
											<div class="col-xs-6 col-md-6">
												<dl class="dl-horizontal">
													<dt>Meter Number:</dt>
													<dd>
														<c:out
															value="${selectedUsagePoint.usagePointDetail.meterNumber}" />
													</dd>
													<dt>Status:</dt>
													<dd>
														<c:choose>
															<c:when
																test="${selectedUsagePoint.usagePointDetail.status=='Active'}">
																<span class="status-active"> <c:out
																		value="${selectedUsagePoint.usagePointDetail.status}"
																		default="-" />
																</span>
															</c:when>
															<c:otherwise>
																<span class="status-inactive"> Ended On <br /> <fmt:formatDate
																		value="${selectedUsagePoint.usagePointDetail.endDate}"
																		pattern="MMM dd, yyyy" /></span>
															</c:otherwise>
														</c:choose>
													</dd>
												</dl>
											</div>
										</div>

									</div>
								</div>
							</c:if>


							<form id="confirmationForm" name="confirmationForm"
								action="<%=request.getContextPath()%>/oauth/authorize"
								method="post">
								<input name="user_oauth_approval" value="true" type="hidden" />

								<!-- 
								<ul class="list-group">
									<li class="list-group-item"><input type="checkbox"
										id="tos" /> I agree to the <a
										href="https://www.londonhydro.com/site/#!/residential/content?page=conditions-of-service"
										target="_new">Terms of service.</a></li>
									<li class="list-group-item"><input type="checkbox"
										id="privacypolicy" />I agree to the <a
										href="https://www.londonhydro.com/site/#!/residential/content?page=conditions-of-service"
										target="_new">Privacy Policy.</a></li>
								</ul>
								 -->
								<div class="table-responsive">
									<table class="table    table-striped table-hover">
										<thead>

										</thead>
										<tbody>
											<c:forEach items="${scopeForApproval}" var="scope">
												<c:set var="approved">
													<c:if test="${scope.selected}"> checked</c:if>
												</c:set>
												<c:set var="denied">
													<c:if test="${!scope.selected}"> checked</c:if>
												</c:set>

												<tr>

													<td>I authorize the Third-Party application to access
														my energy data. <input type="submit"
														class="btn btn-success" name="scope.${scope.scope}"
														value="Approve" data-toggle="modal" data-target="#myModal">
													</input><input type="submit" class="btn btn-danger"
														name="scope.${scope.scope}" value="Deny"></input>
													</td>

													<div class="modal fade" id="myModal" tabindex="-1"
														role="dialog" aria-labelledby="myModalLabel"
														aria-hidden="true">
														<div class="modal-dialog">
															<div class="modal-content">
																<div class="modal-header">
																	<button type="button" class="close"
																		data-dismiss="modal" aria-hidden="true">&times;</button>
																	<h4 class="modal-title" id="myModalLabel">Approve</h4>
																</div>
																<div class="modal-body">
																	<h4>I agree to the Terms of Service</h4>
																	<iframe id="browse" style="width: 100%; height: 160px"
																		src="${pageContext.request.contextPath}/resources/html/tos.html"></iframe>
																	<h4>I agree with London Hydro's Privacy Policy</h4>
																	<iframe id="browse" style="width: 100%; height: 160px"
																		src="${pageContext.request.contextPath}/resources/html/privacy.html"></iframe>
																</div>
																<div class="modal-footer">
																	<button type="button" class="btn btn-default"
																		data-dismiss="modal">Close</button>
																	<input type="submit" name="scope.${scope.scope}"
																		value="Approve" class="btn btn-success" />
																</div>
															</div>
														</div>
													</div>

												</tr>
											</c:forEach>
										</tbody>
									</table>




								</div>
							</form>
						</authz:authorize>
					</div>
					</section>


				</div>
			</div>

		</div>

		<div id="dateSelectionModal" class="modal fade" tabindex="-1"
			role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"
			style="display: none;">
			<div class="modal-dialog">
				<div class="modal-content">
					<form id="confirmationForm" name="confirmationForm"
						action="<%=request.getContextPath()%>/accessconfirm/setdate"
						method="post">
						<input name="usage_point" value="${usagePointId}" type="hidden" />
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">&times;</button>
							<h4 class="modal-title">Set Date</h4>
						</div>
						<div class="modal-body">
							<div style="margin-left: 40px;">
								<fieldset>
									<div class="form-group">
										<label>End Date: </label>
										<div class="input-group">
											<div class="input-append date input-group"
												style="width: 210px" id="dp3">
												<input class="datepicker form-control" size="16"
													type="text" name="iauthorizationEndDate" /> <span
													class="input-group-addon add-on"> <i
													data-time-icon="icon-time" data-date-icon="icon-calendar"><span
														class="glyphicon glyphicon-calendar"></span></i>
												</span>
											</div>
										</div>
									</div>
								</fieldset>
							</div>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default"
								data-dismiss="modal">Close</button>
							<input type="submit" class="btn btn-primary"></input>
						</div>
					</form>
				</div>
				<!-- /.modal-content -->
			</div>
			<!-- /.modal-dialog -->
		</div>

		<jsp:include page="tiles/footer.jsp" />

		<script type="text/javascript">
			$(function() {
				$("#dp3").datepicker({
					format : 'MM dd, yyyy',
					language : 'pt-US',
					autoclose : true,
					showMeridian : true,
					pickerPosition : "bottom-left",
					todayBtn : true,
					todayHighlight : true,
					startDate : '+0d'
				});

			});
		</script>

	</div>

</body>
<jsp:include page="gatracking.jsp" />
</html>
