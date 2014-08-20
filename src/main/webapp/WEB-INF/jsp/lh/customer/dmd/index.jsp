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
<jsp:include page="../../tiles/head.jsp" />

<jsp:useBean id="dateController"
	class="org.energyos.espi.datacustodian.utils.DateController" />

<script type="text/javascript">
	var usagePointId = 0;
	$(function() {
		$('.nav-group a').on('click', function(event) {
			$('.nav-group a').removeClass('active'); // remove active class from tabs
			$(this).addClass('active'); // add active class to clicked tab
		});
		$('.nav-group a').on('click', function(event) {
			$('.tab-content div').removeClass('active');
			$('.tab-content div').addClass('active');
		});

		$('.a-modal').on('click', function(e) {
			usagePointId = $(this).attr("data-usagepoint");
			buildUrl();
		});

	});
</script>
<c:set var="menu" scope="session" value="dmd" />
<body>
	<div id="wrapper">
		<jsp:include page="../../tiles/header.jsp" />

		<div id="main">
			<div class="container">
				<jsp:include page="../../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">
						<div class="heading big">
							<h1>Download My Data</h1>
						</div>
						<div class="balance-section">
							<div class="intro">
								<p>Please specify the period for your energy usage data
									extract. The data will be exported as a sequence of hourly
									intervals with energy usage information.</p>
								<p>Note: You can request your energy usage data for the last
									24 months.</p>
							</div>
							<div class="account-boxes">
								<form action="#" method="get" class="form-inline">
									<div id="dateSelectionModal" class="modal fade" tabindex="-1"
										role="dialog" aria-labelledby="myModalLabel"
										aria-hidden="true" style="display: none;">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal"
														aria-hidden="true">&times;</button>
													<h4 class="modal-title">Select Period</h4>
												</div>
												<div class="modal-body">
													<div style="margin-left: 40px;">
														<fieldset>
															<div class="form-group">
																<label>Start Date/Time: </label>
																<div class="input-group">
																	<div id="datetimepicker"
																		class="input-append date input-group">
																		<input id="startTime" type="text"
																			class=" datepicker form-control"
																			placeholder="Select start date"
																			contenteditable="false"></input> <span
																			class="input-group-addon add-on"> <i
																			data-time-icon="icon-time"
																			data-date-icon="icon-calendar"><span
																				class="glyphicon glyphicon-calendar"></span></i>
																		</span>
																	</div>
																</div>
															</div>
															<div class="form-group">
																<label>End Date/Time:</label>
																<div class="input-group">
																	<div id="datetimepicker2"
																		class="input-append date input-group">
																		<input id="endTime" type="text"
																			class="datepicker form-control"
																			placeholder="Select end date" contenteditable="false"></input>
																		<span class=" input-group-addon add-on"> <i
																			data-time-icon="icon-time"
																			data-date-icon="icon-calendar"><span
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
													<a id="downloadMyData" class="btn btn-primary" href="#">Download</a>
												</div>
											</div>
											<!-- /.modal-content -->
										</div>
										<!-- /.modal-dialog -->
									</div>
									<div class="account-boxes">
										<div>
											<div>
												<p align="right" class="nav-group">
													Group By <a class="badge active" href="#services_all"
														data-toggle="tab">No Grouping</a> <a class="badge"
														href="#services_account" data-toggle="tab">Account</a> <a
														class="badge" href="#services_service" data-toggle="tab">Service</a>
												</p>
												<div class="tab-content">
													<div class="tab-pane active" id="services_all">
														<table class="table table-striped table-hover">
															<thead>
																<tr>

																	<th>Address</th>
																	<th>Billing Number</th>
																	<th>Service Number</th>
																	<th>Meter</th>
																	<th>Status</th>
																	<th></th>
																</tr>
															</thead>
															<tfoot>
																<tr>
																	<td colspan=6><c:if test="${empty usagePoints}">
																			<c:out value="No usage point available"></c:out>
																		</c:if></td>
																</tr>
															</tfoot>
															<tbody>
																<c:forEach var="usagePoint" items="${usagePoints}">
																	<tr>

																		<td><strong><c:out
																					value="${usagePoint.usagePointDetail.streetUnit}" />
																				<c:if
																					test="${not empty usagePoint.usagePointDetail.streetUnit}">
																		- </c:if> <c:out
																					value="${usagePoint.usagePointDetail.streetNumber}" />
																				<c:out
																					value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
																			<c:out
																				value="${usagePoint.usagePointDetail.streetCity}" />
																			<br> <c:out
																				value="${usagePoint.usagePointDetail.postalCode}" />
																			<c:out
																				value="${usagePoint.usagePointDetail.streetProvince}" /></td>

																		<td><c:out
																				value="${usagePoint.usagePointDetail.accountId}"
																				default="-" /></td>
																		<td><spring:message
																				code="service.name.${usagePoint.serviceCategory.kind}" /><br />
																			<c:out
																				value="${usagePoint.usagePointDetail.serviceId}"
																				default="-" /></td>
																		<td><c:out
																				value="${usagePoint.usagePointDetail.meterNumber}"
																				default="-" /></td>
																		<td><c:choose>
																				<c:when
																					test="${usagePoint.usagePointDetail.status=='Active'}">
																					<span class="status-active"> <c:out
																							value="${usagePoint.usagePointDetail.status}"
																							default="-" />
																					</span>
																				</c:when>
																				<c:otherwise>
																					<span class="status-inactive"> Ended on <br />
																						<fmt:formatDate
																							value="${usagePoint.usagePointDetail.endDate}"
																							pattern="MMM dd, yyyy" /></span>
																				</c:otherwise>
																			</c:choose></td>
																		<td>
																			<div class="btn-group">
																				<button type="button"
																					class="btn btn-success dropdown-toggle"
																					data-toggle="dropdown">
																					<span class="glyphicon glyphicon-download"></span>
																					Download <span class="caret"></span>
																				</button>
																				<ul class="dropdown-menu" role="menu">
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.dayBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Today's
																							Usage</a></li>
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.previousdayBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Yesterday's
																							Usage</a></li>
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.weekBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Current
																							Week's Usage</a></li>
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.monthBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Current
																							Month's Usage</a></li>
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.threeMonthBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Last
																							Three Month's Usage</a></li>
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.sixMonthBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Last
																							Six Month's Usage</a></li>
																					<li><a
																						href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.twelveMonthBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Last
																							One Year's Usage</a></li>
																					<li role="presentation" class="divider"></li>
																					<li><a href="#" class="a-modal"
																						data-toggle="modal"
																						data-target="#dateSelectionModal"
																						data-usagepoint="${usagePoint.id}">Select
																							Period to <br />Download Usage
																					</a></li>
																				</ul>
																			</div> <a
																			href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/show' />"
																			class="btn btn-primary"> <span
																				class="glyphicon glyphicon-stats"></span> Usage
																		</a>
																		</td>

																	</tr>
																</c:forEach>
															</tbody>

														</table>
													</div>
													<div class="tab-pane " id="services_account">
														<c:forEach var="vAccount" items="${accountList}">
															<div class="bill-section">
																<div class="title">
																	<dl class="dl-horizontal">
																		<dt>Billing Number:</dt>
																		<dd>
																			<c:out value="${vAccount}" default="-" />
																		</dd>
																	</dl>
																</div>

																<table class="table table-striped table-hover">
																	<thead>
																		<tr>

																			<th>Address</th>
																			<th>Billing Number</th>
																			<th>Service Number</th>
																			<th>Meter</th>
																			<th>Status</th>
																			<th></th>
																		</tr>
																	</thead>
																	<tfoot>
																		<tr>
																			<td colspan=6><c:if test="${empty usagePoints}">
																					<c:out value="No usage point available"></c:out>
																				</c:if></td>
																		</tr>
																	</tfoot>
																	<tbody>

																		<c:forEach var="usagePoint"
																			items="${usagePointListGroupByAccount[vAccount]}">
																			<tr>

																				<td><strong><c:out
																							value="${usagePoint.usagePointDetail.streetUnit}" />
																						<c:if
																							test="${not empty usagePoint.usagePointDetail.streetUnit}">
																		- </c:if> <c:out
																							value="${usagePoint.usagePointDetail.streetNumber}" />
																						<c:out
																							value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
																					<c:out
																						value="${usagePoint.usagePointDetail.streetCity}" />
																					<br> <c:out
																						value="${usagePoint.usagePointDetail.postalCode}" />
																					<c:out
																						value="${usagePoint.usagePointDetail.streetProvince}" /></td>

																				<td><c:out
																						value="${usagePoint.usagePointDetail.accountId}"
																						default="-" /></td>
																				<td><spring:message
																						code="service.name.${usagePoint.serviceCategory.kind}" /><br />
																					<c:out
																						value="${usagePoint.usagePointDetail.serviceId}"
																						default="-" /></td>
																				<td><c:out
																						value="${usagePoint.usagePointDetail.meterNumber}"
																						default="-" /></td>
																				<td><c:choose>
																						<c:when
																							test="${usagePoint.usagePointDetail.status=='Active'}">
																							<span class="status-active"> <c:out
																									value="${usagePoint.usagePointDetail.status}"
																									default="-" />
																							</span>
																						</c:when>
																						<c:otherwise>
																							<span class="status-inactive"> Ended on <br />
																								<fmt:formatDate
																									value="${usagePoint.usagePointDetail.endDate}"
																									pattern="MMM dd, yyyy" /></span>
																						</c:otherwise>
																					</c:choose></td>
																				<td>
																					<div class="btn-group">
																						<button type="button"
																							class="btn btn-success dropdown-toggle"
																							data-toggle="dropdown">
																							<span class="glyphicon glyphicon-download"></span>
																							Download <span class="caret"></span>
																						</button>
																						<ul class="dropdown-menu" role="menu">
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.dayBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Today's
																									Usage</a></li>
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.previousdayBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Yesterday's
																									Usage</a></li>
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.weekBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Current
																									Week's Usage</a></li>
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.monthBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Current
																									Month's Usage</a></li>
																							<li role="presentation" class="divider"></li>
																							<li><a href="#" class="a-modal"
																								data-toggle="modal"
																								data-target="#dateSelectionModal"
																								data-usagepoint="${usagePoint.id}">Select
																									Period to <br />Download Usage
																							</a></li>
																						</ul>
																					</div> <a
																					href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/show' />"
																					class="btn btn-primary"> <span
																						class="glyphicon glyphicon-stats"></span> Usage
																				</a>
																				</td>

																			</tr>
																		</c:forEach>
																	</tbody>

																</table>
															</div>
														</c:forEach>

													</div>

													<div class="tab-pane " id="services_service">

														<c:forEach var="vKind" items="${serviceKindList}">
															<div class="bill-section">
																<div class="title">
																	<dl class="dl-horizontal">
																		<dt>
																			<spring:message code="service.name.${vKind}" />
																		</dt>

																	</dl>
																</div>
																<table class="table table-striped table-hover">
																	<thead>
																		<tr>

																			<th>Address</th>
																			<th>Billing Number</th>
																			<th>Service Number</th>
																			<th>Meter</th>
																			<th>Status</th>
																			<th></th>
																		</tr>
																	</thead>
																	<tfoot>
																		<tr>
																			<td colspan=6><c:if test="${empty usagePoints}">
																					<c:out value="No usage point available"></c:out>
																				</c:if></td>
																		</tr>
																	</tfoot>
																	<tbody>

																		<c:forEach var="usagePoint"
																			items="${usagePointListGroupByService[vKind]}">
																			<tr>

																				<td><strong><c:out
																							value="${usagePoint.usagePointDetail.streetUnit}" />
																						<c:if
																							test="${not empty usagePoint.usagePointDetail.streetUnit}">
																		- </c:if> <c:out
																							value="${usagePoint.usagePointDetail.streetNumber}" />
																						<c:out
																							value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
																					<c:out
																						value="${usagePoint.usagePointDetail.streetCity}" />
																					<br> <c:out
																						value="${usagePoint.usagePointDetail.postalCode}" />
																					<c:out
																						value="${usagePoint.usagePointDetail.streetProvince}" /></td>
																				<td><c:out
																						value="${usagePoint.usagePointDetail.accountId}"
																						default="-" /></td>
																				<td><spring:message
																						code="service.name.${usagePoint.serviceCategory.kind}" /><br />
																					<c:out
																						value="${usagePoint.usagePointDetail.serviceId}"
																						default="-" /></td>
																				<td><c:out
																						value="${usagePoint.usagePointDetail.meterNumber}"
																						default="-" /></td>
																				<td><c:choose>
																						<c:when
																							test="${usagePoint.usagePointDetail.status=='Active'}">
																							<span class="status-active"> <c:out
																									value="${usagePoint.usagePointDetail.status}"
																									default="-" />
																							</span>
																						</c:when>
																						<c:otherwise>
																							<span class="status-inactive"> Ended on <br />
																								<fmt:formatDate
																									value="${usagePoint.usagePointDetail.endDate}"
																									pattern="MMM dd, yyyy" /></span>
																						</c:otherwise>
																					</c:choose></td>
																				<td>
																					<div class="btn-group">
																						<button type="button"
																							class="btn btn-success dropdown-toggle"
																							data-toggle="dropdown">
																							<span class="glyphicon glyphicon-download"></span>
																							Download <span class="caret"></span>
																						</button>
																						<ul class="dropdown-menu" role="menu">
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.dayBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Today's
																									Usage</a></li>
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.previousdayBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Yesterday's
																									Usage</a></li>
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.weekBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Current
																									Week's Usage</a></li>
																							<li><a
																								href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/dmd?usage-min=${dateController.monthBeginUtc}&usage-max=${dateController.nowUtc}'/> ">Current
																									Month's Usage</a></li>
																							<li role="presentation" class="divider"></li>
																							<li><a href="#" class="a-modal"
																								data-toggle="modal"
																								data-target="#dateSelectionModal"
																								data-usagepoint="${usagePoint.id}">Select
																									Period to <br />Download Usage
																							</a></li>
																						</ul>
																					</div> <a
																					href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${usagePoint.id}/show' />"
																					class="btn btn-primary"> <span
																						class="glyphicon glyphicon-stats"></span> Usage
																				</a>
																				</td>

																			</tr>
																		</c:forEach>

																	</tbody>

																</table>
															</div>
														</c:forEach>
													</div>
													<br /> <br /> <br /> <br />
													<br />
													<br />
													<br />
													<br />
													<br />
												</div>

											</div>

										</div>
									</div>
								</form>

							</div>
						</div>
					</section>
				</div>

				<script type="text/javascript">
					var baseurl = '${pageContext.request.contextPath}/RetailCustomer/${currentCustomer.id}/UsagePoint/';
					var d = new Date();					
					var usageMin = utcDayBeginTime(d);
					var usageMax = utcDayEndTime(d);

					var startDate = $('#datetimepicker').datepicker({
						format : 'MM dd, yyyy',
						language : 'pt-US',
						showMeridian : true,
						autoclose : true,
						pickerPosition : "bottom-left",
						startDate : '-24m',
						endDate : '+0d',
						todayBtn : true,
						todayHighlight : true
					}).on('changeDate', function(ev) {
						usageMin = utcDayBeginTime(ev.date);
						buildUrl();
					});

					var endDate = $('#datetimepicker2').datepicker({
						format : 'MM dd, yyyy',
						language : 'pt-US',
						autoclose : true,
						showMeridian : true,
						pickerPosition : "bottom-left",
						startDate : '-24m',
						endDate : '+0d',
						todayBtn : true,
						todayHighlight : true
					}).on('changeDate', function(ev) {
						usageMax = utcDayEndTime(ev.date);
						buildUrl();
					});

					$('#datetimepicker').datepicker('update',
							new Date(usageMin * 1000));
					$('#datetimepicker2').datepicker('update',
							new Date(usageMax * 1000));

					$(function() {
						$("form input[type=radio]").on("click", function() {
							upid = $(this).val();
							buildUrl();
						});
					});

					function utcDayBeginTime(date) {						
						houroffset=5-date.getTimezoneOffset()/60;
						var nd = new Date(date.getTime());
						nd.setHours(houroffset, 0, 0, 0);
						return Math.floor(nd.getTime() / 1000);						
					}
					function utcDayEndTime(date) {						
						var nd = new Date(date.getTime());
						nd.setHours(23, 59, 59, 59);
						return Math.floor(nd.getTime() / 1000);												
					}	
					function utcTime(date) {
						time=date.getTime();
						var temp = Math.floor(time / 1000);
						;
						//temp.replace(" T", "T");
						//temp.replace(" Z", "Z");
						return temp;
					}
					function buildUrl() {
						var url = baseurl + usagePointId + "/dmd";
						if (usageMin || usageMax) {
							url += '?';
						}
						if (usageMin) {
							url += 'usage-min=' + usageMin;
						}
						if (usageMax) {
							url += '&' + 'usage-max=' + usageMax;
						}
						//alert(url);
						$("#downloadMyData").attr('href', url);

					}
				</script>


			</div>
		</div>
		<jsp:include page="../../tiles/footer.jsp" />
	</div>
</body>
<jsp:include page="../../gatracking.jsp" />
</html>
