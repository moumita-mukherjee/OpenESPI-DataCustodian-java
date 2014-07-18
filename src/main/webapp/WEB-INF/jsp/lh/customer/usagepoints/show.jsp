<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

<body>
	<div id="wrapper">
		<jsp:include page="../../tiles/header.jsp" />
		<div id="main">
			<div class="container">
				<jsp:include page="../../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">

						<div class="heading big">
							<h1>Service</h1>
						</div>

						<div class="balance-section">

							<div class="row">
								<div class="span12">
									<h4>
										<c:out value="${usagePoint.usagePointDetail.streetUnit}" />
										<c:if
											test="${not empty usagePoint.usagePointDetail.streetUnit}">
										-
										</c:if>
										<c:out value="${usagePoint.usagePointDetail.streetNumber}" />
										<c:out value="${usagePoint.usagePointDetail.streetName}" />
									</h4>
									<h5>
										<c:out value="${usagePoint.usagePointDetail.streetCity}" />
										<br />
										<c:out value="${usagePoint.usagePointDetail.postalCode}" />
										<c:out value="${usagePoint.usagePointDetail.streetProvince}" />
									</h5>
									<hr />
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
									<br />

									<table class="table table-striped table-hover">
										<thead>
											<tr>
												<th>Reading Type</th>
												<th>Direction</th>
												<th>Interval</th>
												<th>Reading From</th>
												<th>Reading Till</th>
												<th>Description</th>
												<th>Action</th>

											</tr>
										</thead>
										<tbody>
											<c:forEach var="meterReading"
												items="${displayBag['MeterReadings']}">
												<tr>
													<td><strong><c:out
																value="${meterReading['ReadingType'].description}" /></strong></td>
													<td><c:choose>
															<c:when
																test="${meterReading['ReadingType'].flowDirection==1}">
																<span class="glyphicon glyphicon-cloud-download"></span>
															</c:when>
															<c:otherwise>
																<span class="glyphicon glyphicon-cloud-upload"></span>
															</c:otherwise>
														</c:choose> <spring:message
															code="readingtype.flowdirection.${meterReading['ReadingType'].flowDirection}" /></td>
													<td><fmt:formatNumber maxFractionDigits="0"
															value="${meterReading['ReadingType'].intervalLength/60}" />
														minutes</td>
													<td><fmt:formatDate
															value="${meterReading['intervalReadingFrom']}"
															pattern="MMM dd, yyyy HH:mm z" timeZone="EST5EDT" /></td>
													<td><fmt:formatDate
															value="${meterReading['intervalReadingTill']}"
															pattern="MMM dd, yyyy HH:mm z" timeZone="EST5EDT" /></td>
													<td><spring:message
															code="readingtype.${meterReading['ReadingType'].description}" /></td>
													<td><a class="btn btn-primary"
														href="${pageContext.request.contextPath}${meterReading['uriTail']}?period=1&usagetime-min=0&usagetime-max=0">
															<span class="glyphicon glyphicon-stats"></span> View My
															Data
													</a></td>

												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>
							<p align="right">
								<a class="btn btn-primary"
									href="<c:url value='/RetailCustomer/${currentCustomer.id}/dmd' />">Back</a>
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

