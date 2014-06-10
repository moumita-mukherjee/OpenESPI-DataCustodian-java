<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tld/duration.tld" prefix="dur"%>

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

<jsp:include page="../../tiles/head.jsp" />
<script type="text/javascript">
	$(function() {
		$('.nav-group a').on('click', function(event) {
			$('.nav-group a').removeClass('active'); // remove active class from tabs
			$(this).addClass('active'); // add active class to clicked tab
		});

		//$('.collapse').collapse();
	});

	$(function() {
		$('.nav-group a').first().click();
		//<![CDATA[
		var _rawdata=[
		<c:forEach var="intervalBlock" items="${meterReading.intervalBlocks}"
			varStatus="loopStatusIb">
			<c:forEach var="intervalReading"
				items="${intervalBlock.intervalReadings}">
				[${intervalReading.timePeriod.start*1000},${intervalReading.value}],
			</c:forEach>
		</c:forEach>
		];
		//]]>
		
		
			

			var _chartdataOffPeak = [];
			var _chartdataHighPeak = [];
			var _chartdataMidPeak = [];
			//$.each(animals.entry[3].content.IntervalBlock[0].IntervalReading,
			$.each(_rawdata,
					function(index, value) {
						dt = new Date(value[0]);
						_chartdataOffPeak.push([ value[0] ,
													value[1] / 1000 ]);
						
					});
			//,
			
			
			$.plotAnimator("#usagegraph", [ {
				color : '#87B451',
				data :_chartdataOffPeak,
				animator: { start: 100, steps: 200, duration: 1000, direction: "right" } 
			} ], {
				axisLabels : {
					show : true
				},
				grid : {
					borderWidth : {
						top : 0,
						right : 0,
						bottom : 1,
						left : 1
					},
					borderColor : {
						top : "#C0D0E0",
						left : "#C0D0E0"
					},
					hoverable : true
				},
				xaxis : {
					mode : "time",
					timezone : "browser",
					color : "#C0D0E0",
					tickSize : [ 3, "hour" ],
					timeformat : "%I:%M %p",
					tickLength : 6,
					tickColor : '#C0D0E0'
				},
				yaxis : {
					tickDecimals : 2,
					axisLabel : "kWh",
					color : "#C0D0E0",
					tickColor : "#C0D0E0"
				},
				series : {
					stack : 1,
					bars : {
						show : true,
						barWidth : 30 * 60000,
						fill : 1
					}
				},
				tooltip : true,
				tooltipOpts : {
					content : $('#tooltip').html(),
					xDateFormat : "%I:%M %p",
					shifts : {
						x : -60,
						y : 25
					}
				}
			});		

		// Add the Flot version string to the footer		
	});
</script>
<body>

	<div id="wrapper">
		<jsp:include page="../../tiles/header.jsp" />

		<jsp:useBean id="dateValue" class="java.util.Date" />
		<jsp:useBean id="dateValue2" class="java.util.Date" />

		<div id="main">
			<div class="container">
				<jsp:include page="../../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">
						<div class="heading big">
							<h1>My Usage Data</h1>
						</div>

						<div class="balance-section">
							<div class="row">
								<div class="graff-title">
									<a class="btn-prev btn-prev-date previous"
										href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?usagetime-min=${dpb.prevUsagetimeMin}&usagetime-max=${dpb.prevUsagetimeMax}'/>">Previous</a><a
										class="btn-next btn-next-date next"
										href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?usagetime-min=${dpb.nextUsagetimeMin}&usagetime-max=${dpb.nextUsagetimeMax}'/>">Next</a>

									<div class="usageheading">
										<label> Usage Data for <jsp:setProperty
												property="time" name="dateValue"
												value="${dpb.prevUsagetimeMax*1000}" /> <a><strong><fmt:formatDate
														value="${dateValue}" pattern="EEEE MMM dd, yyyy"
														timeZone="EST5EDT" /> </strong></a>
										</label>
									</div>

								</div>
							</div>

							<div>
								<p align="right" class="nav-group">
									<a class="badge active" href="#usage_graph" data-toggle="tab">Graph</a>
									<a class="badge" href="#usage_data" data-toggle="tab">Data</a>
								</p>
								<div class="tab-content active">
									<div class="tab-pane" id="usage_graph">
										<div id="tooltip"
											style="top: 44px; left: 509px; display: none; background-position: -195px -145px;">
											<div class="On-Peak">
												<span class="title1">Period</span> <span class="timespan">%x</span>
												<p class="usage">
													Your Usage: <span>%y kWh</span>
												</p>
											</div>
										</div>
										<c:if test="${empty meterReading.intervalBlocks}">
											<div class="alert alert-warning">
												<c:out value="Usage data is not avilable for selected date." />
											</div>
										</c:if>
										<div id="usagegraph" class="demo-placeholder"
											style="min-width: 300px; width: 100%; height: 300px"></div>
									</div>
									<div class="tab-pane" id="usage_data">
										<c:if test="${empty meterReading.intervalBlocks}">
											<div class="alert alert-warning">
												<c:out value="Usage data is not avilable for selected date." />
											</div>
										</c:if>
										<div class="panel-group" id="accordion">
											<div id="interval-blocks">
												<c:forEach var="intervalBlock"
													items="${meterReading.intervalBlocks}"
													varStatus="loopStatusIb">
													<div class="panel panel-default">
														<div class="panel-heading">
															<table class="table table-striped">
																<caption class="text-left">
																	<a data-toggle="collapse" data-parent="#accordion"
																		href='#collapse<c:out value="${loopStatusIb.index}" />'>Interval
																		Block</a>
																</caption>
																<thead>
																	<tr>
																		<th>Start</th>
																		<th>Duration</th>
																		<th>Usage</th>
																		<th>Cost</th>
																		<th>Published</th>
																		<th>Updated</th>

																	</tr>
																</thead>
																<tbody>
																	<tr>
																		<td><jsp:setProperty property="time"
																				name="dateValue"
																				value="${intervalBlock.interval.start*1000}" /> <fmt:formatDate
																				value="${dateValue}" pattern="MMM dd, yyyy"
																				timeZone="EST5EDT" /></td>
																		<td><dur:duration
																				value="${intervalBlock.interval.duration*1000}"
																				format="2" /></td>
																		<td></td>
																		<td></td>
																		<td><fmt:formatDate
																				value="${intervalBlock.published.time}"
																				pattern="MMM dd, yyyy HH:mm z" timeZone="EST5EDT" /></td>
																		<td><fmt:formatDate
																				value="${intervalBlock.updated.time}"
																				pattern="MMM dd, yyyy HH:mm z" timeZone="EST5EDT" /></td>
																	</tr>
																</tbody>
															</table>
														</div>
														<div id='collapse<c:out value="${loopStatusIb.index}" />'
															class="panel-collapse collapse in">
															<div class="panel-body">

																<table class="table table-striped table-hover">

																	<thead>
																		<tr>
																			<th>Time</th>
																			<th>Duration</th>
																			<th>Usage</th>
																			<th>Cost</th>
																			<th>Reading Qualities</th>
																		</tr>
																	</thead>
																	<tbody>
																		<c:forEach var="intervalReading"
																			items="${intervalBlock.intervalReadings}">
																			<tr>
																				<td><jsp:setProperty property="time"
																						name="dateValue2"
																						value="${intervalReading.timePeriod.start*1000}" />
																					<fmt:formatDate value="${dateValue2}"
																						pattern="MMM dd, yyyy HH:mm z" timeZone="EST5EDT" /></td>
																				<td><dur:duration
																						value="${intervalReading.timePeriod.duration*1000}"
																						format="2" /></td>
																				<td><c:out
																						value="${intervalReading.value/1000}" /></td>
																				<td><c:out value="${intervalReading.cost}"
																						default="-" /></td>

																				<td>
																					<ul class="reading-qualities">
																						<c:forEach var="readingQuality"
																							items="${intervalReading.readingQualities}">
																							<li><c:out value="${readingQuality.quality}" /></li>
																						</c:forEach>
																					</ul>
																				</td>
																			</tr>
																		</c:forEach>
																	</tbody>
																</table>
															</div>
														</div>
													</div>
												</c:forEach>
											</div>
										</div>
									</div>
								</div>

							</div>
							<p align="right">
								<a class="btn btn-primary"
									href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/show'/>">Back</a>
							</p>
						</div>
					</section>
				</div>
			</div>

			<jsp:include page="../../tiles/footer.jsp" />
		</div>

	</div>

</body>
</html>
