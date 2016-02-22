<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<jsp:useBean id="dateValue" class="java.util.Date" />
<jsp:include page="../../tiles/head.jsp" />

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
							<h1>SERVICES</h1>
						</div>
						<div class="balance-section table-responsive ">

							<c:forEach var="usagePoint" items="${usagePointList}">
								<div class="panel panel-default">
									<div class="panel-heading">
										<h4>
											ELECTRICITY -
											<c:out value="${usagePoint.usagePointDetail.streetUnit}" />
											-
											<c:out value="${usagePoint.usagePointDetail.streetNumber}" />
											<c:out value="${usagePoint.usagePointDetail.streetName}" />
										</h4>
										<h5>
											<c:out value="${usagePoint.usagePointDetail.streetCity}" />
											<br />
											<c:out value="${usagePoint.usagePointDetail.postalCode}" />
											<c:out value="${usagePoint.usagePointDetail.streetProvince}" />
										</h5>
									</div>
									<div class="panel-body">
										<div class="row">
											<div class="col-xs-6 col-md-3">
												<dl class="dl-horizontal">
													<dt>Billing Number:</dt>
													<dd>
														<c:out value="${usagePoint.usagePointDetail.accountId}" />
													</dd>
													<dt>Service Number:</dt>
													<dd>
														<c:out value="${usagePoint.usagePointDetail.serviceId}" />
													</dd>
												</dl>
											</div>
											<div class="col-xs-6 col-md-3">
												<dl class="dl-horizontal">
													<dt>Meter Number:</dt>
													<dd>
														<c:out value="${usagePoint.usagePointDetail.meterNumber}" />
													</dd>
													<dt>Status:</dt>
													<dd>
														<c:out value="${usagePoint.usagePointDetail.status}" />
													</dd>
												</dl>
											</div>
										</div>


										<p align="right">
											<a
												href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/show' />"
												class="usage-point"> <span
												class="glyphicon glyphicon-stats"></span>View Usage
											</a>
										</p>



										<div class="panel panel-default">
											<div class="panel-heading">
												<table width="100%">
													<tbody>
														<tr style="border: none">
															<td style="border: none">
																<h4>Applications</h4>
															</td>
															<td align="right" style="border: none"><a
																href="<c:url value='/RetailCustomer/${currentCustomer.id}/ThirdPartyList' />">
																	<span class="glyphicon glyphicon-plus"></span>Share
																	Usage
															</a></td>
													</tbody>
												</table>
											</div>
											<div class="panel-body">
												<c:if test="${empty usagePoint.subscriptions}">You have not share your usage with any vendor application. Try now. </c:if>
												<c:if test="${not empty usagePoint.subscriptions}">
													<table class="table table-striped" id="authorizations">
														<thead>
															<tr>
																<th>Application</th>
																<th>Provider</th>
																<th>Authorization Status</th>
																<th>Authorized On</th>
																<th>Valid Till</th>
																<th>Action</th>

															</tr>
														</thead>
														<tbody>
															<c:forEach var="subscription"
																items="${usagePoint.subscriptions}">
																<tr>
																	<td><span> <img alt="logo" width="120"
																			 class="img-rounded-2"
																			src="${subscription.authorization.applicationInformation.logoUri}"
																			title="${subscription.authorization.applicationInformation.thirdPartyApplicationName}" />
																	</span></td>

																	<td><a
																		href="${subscription.authorization.applicationInformation.clientUri}"
																		target="_new"><c:out
																				value="${subscription.authorization.applicationInformation.clientName}" /></a></td>

																	<td class="status"><spring:message
																			code="authorization.code.${subscription.authorization.status}" /></td>
																	<td><c:if
																			test="${subscription.authorization.authorizedPeriod!=null && subscription.authorization.authorizedPeriod.start!=null}">
																			<jsp:setProperty property="time" name="dateValue"
																				value="${subscription.authorization.authorizedPeriod.start}" />
																			<fmt:formatDate value="${dateValue}"
																				pattern="MM/dd/yyyy HH:mm" />
																		</c:if></td>
																	<td><c:if
																			test="${subscription.authorization.authorizedPeriod!=null && subscription.authorization.authorizedPeriod.start!=null}">
																			<jsp:setProperty property="time" name="dateValue"
																				value="${subscription.authorization.authorizedPeriod.start+subscription.authorization.authorizedPeriod.duration}" />
																			<fmt:formatDate value="${dateValue}"
																				pattern="MM/dd/yyyy HH:mm" />
																		</c:if></td>
																	<td class="subscription_id"><input type="button"
																		class="btn btn-primary" value="Edit"
																		title="${subscription.authorization.resourceURI}" /></td>


																</tr>
															</c:forEach>
														</tbody>
													</table>
												</c:if>
											</div>

										</div>
									</div>
								</div>
							</c:forEach>

						</div>
					</section>


				</div>
			</div>
		</div>

		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
