<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
												<th>Description</th>
												<th>Action</th>

											</tr>
										</thead>
										<tbody>
											<c:forEach var="meterReading"
												items="${displayBag['MeterReadings']}">
												<tr>
													<td><strong><c:out
																value="${meterReading['ReadingType']}" /></strong></td>
													<td><spring:message
															code="readingtype.${meterReading['ReadingType']}" /></td>
													<td><a class="btn btn-success"
														href="${pageContext.request.contextPath}${meterReading['uriTail']}?usagetime-min=0&usagetime-max=0">
															<span class="glyphicon glyphicon-download"></span> View
															My Data
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

