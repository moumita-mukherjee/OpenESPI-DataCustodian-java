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
		$('.viewcontrol a').on('click', function(event) {
			$('.viewcontrol a').removeClass('active'); // remove active class from tabs
			$(this).addClass('active'); // add active class to clicked tab
		});

		//$('.collapse').collapse();
	});
	var plot=null;

	//<![CDATA[
	var powerOfTenMultiplier= ${meterReading.readingType.multiplier};
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
	
	$(function() {
		$('.viewcontrol a').first().click();
	
		
		
			

			var _chartdataOffPeak = [];
			var _chartdataHighPeak = [];
			var _chartdataMidPeak = [];
			//$.each(animals.entry[3].content.IntervalBlock[0].IntervalReading,
			minyValue=9999999;
			$.each(_rawdata,
					function(index, value) {
						dt = new Date(value[0]);
						if(minyValue>value[1] / powerOfTenMultiplier) {
							minyValue=value[1] / powerOfTenMultiplier;
						}
						_chartdataOffPeak.push([ value[0] ,
													value[1] / powerOfTenMultiplier ]);
						
					});
			//,
			minyValue=minyValue-minyValue*0.2;
			minyValue=Math.round(minyValue);
		
			var chartOption={
					axisLabels : {
						show : true
					},
					crosshair: {
						mode: "x"
					},
					selection: {
						mode: "x"
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
						hoverable : true,
						clikable:true,
						markings: weekendAreas
					},
					xaxis : {
						mode : "time",
						timezone : "browser",
						color : "#C0D0E0",
						timeformat : "%I:%M %p",
						tickLength : 6,
						tickColor : '#C0D0E0'
					},
					yaxis : {
						tickDecimals : 2,
						axisLabel : "<c:out value='${meterReading.readingType.description}' />",
						color : "#C0D0E0",
						tickColor : "#C0D0E0",
						min:minyValue,
						zoomRange :false,
						panRange:false
					},
					series : {
						stack : 1
						
						
					},
					tooltip : true,
					tooltipOpts : {
						content : $('#tooltip').html(),
						xDateFormat : "%I:%M %p",
						shifts : {
							x : -60,
							y : 25
						}
					},
					zoom: {
						interactive: true
					},
					pan: {
						interactive: true
					}
				};
			
			if(_chartdataOffPeak !=null && _chartdataOffPeak.length <=24) {
				chartOption.xaxis.tickSize=	 [ 3, "hour" ];
				chartOption.series.bars = {
					show : true,
					barWidth : 30 * 60000,
					fill : 1
				};
				
			}else {
				chartOption.series.lines= {
					fill: true,
					show:true
					};
				chartOption.xaxis.minTickSize= [1, "hour"];
				chartOption.xaxis.timeformat=null;
				}
			plot=$.plotAnimator("#usagegraph", [ {
				color : '#87B451',
				data :_chartdataOffPeak,
				animator: { start: 100, steps: 200, duration: 1000, direction: "right" } 
			} ], chartOption);		

		// Add the Flot version string to the footer		

		$(".start").on('click', function(event) {
			
			slicedata=[];
			curridx=0;
			timerid=setInterval(function updateRandom() {
	
				   if (slicedata.length && slicedata.length>300) {
					   slicedata = slicedata.slice(1);
			        }
			        if(curridx<_rawdata.length) {
			        	slicedata.push([ _rawdata[curridx][0] ,
						               _rawdata[curridx][1] / powerOfTenMultiplier ]);
			        	curridx++;
				    }
			        
				series = plot.getData();
				series[0].data = slicedata;
				plot.setData(series);
				//plot.setData([{data:slicedata}]);
				plot.draw();
			}, 40);
		});
		$(".puase").on('click', function(event) {
			if(timerid<=0) {
				return;
				}
			clearInterval(timerid);
			timerid=0;
		});
		$(".stop").on('click', function(event) {
			if(timerid<=0) {
				return;
				}
			clearInterval(timerid);
			timerid=0;
		});
		$("#zoomin").on('click', function(event) {
			if(!plot) return;
			event.preventDefault();
			plot.zoom({ amount: 2});
			
		
		});
		$("#zoomout").on('click', function(event) {
			if(!plot) return;
			event.preventDefault();
			plot.zoomOut();
		});
		$(".toggle-chart").on('click', function(event) {
			
			if(plot) { 
				series = plot.getData();
				if(series ==null | series[0] ==null){
					return;
				}
				console.log(series[0]);
				if(series[0].lines && series[0].lines.show) {
					series[0].lines={show:false};
					}else {
						series[0].lines= {
								fill: true,
								show:true
								};
						}
				if(series[0].bars && series[0].bars.show){
					series[0].bars={show:false};
				}else {
					series[0].bars = {
							show : true,
							barWidth : 30 * 60000,
							fill : 1
						};
						
				}
				plot.draw();
			}	
		});
		
		plot.bind('plotclick', function ( event, pos, item ) {
			if (item) {
		    alert("You clicked at " + pos.x + ", " + pos.y);
			//series = plot.getData();
			//series[0].lines.show=!series[0].lines.show;
			}
			
		});
	});
	
	var timerid=0;
	var slicedata = [];
	var curridx=0;

	function weekendAreas(axes) {
		var markings = [],
			d = new Date(axes.xaxis.min);

		// go to the first Saturday

		d.setDate(d.getDate() - ((d.getDay() + 1) % 7))
		d.setSeconds(0);
		d.setMinutes(0);
		d.setHours(0);

		var i = d.getTime();

		// when we don't set yaxis, the rectangle automatically
		// extends to infinity upwards and downwards

		do {
			markings.push({ xaxis: { from: i, to: i + 2 * 24 * 60 * 60 * 1000 },color: "#E8E8E8" });
			i += 7 * 24 * 60 * 60 * 1000;
		} while (i < axes.xaxis.max);

		return markings;
	}
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
							<section class="panel">
								<header class="panel-heading">
									<div class="row">
										<div class="col-xs-6">

											<p align="left" class="nav-group view-mode">
												<a
													class="badge <c:if test='${dpb.period==1}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=1&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">1
													day</a> <a
													class="badge <c:if test='${dpb.period==2}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=2&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">2
													days</a> <a
													class="badge <c:if test='${dpb.period==7}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=7&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">7
													days</a> <a
													class="badge <c:if test='${dpb.period==30}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=30&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">1
													mth</a> <a
													class="badge <c:if test='${dpb.period==90}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=90&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">3
													mths</a> <a
													class="badge <c:if test='${dpb.period==180}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=180&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">6
													mths</a> <a
													class="badge <c:if test='${dpb.period==365}'> active</c:if>"
													href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=365&usagetime-min=0&usagetime-max=${dpb.nextUsagetimeMin}'/>">1
													year</a>

											</p>
										</div>
										<div class="col-xs-4">
											<c:if test="${dpb.period >1}">
												<div class="btn-group">
													<button type="button" class="btn btn-default start">
														<span class="glyphicon glyphicon-play"></span>
													</button>
													<button type="button" class="btn btn-default pause">
														<span class="glyphicon glyphicon-pause"></span>
													</button>
													<button type="button" class="btn btn-default stop">
														<span class="glyphicon glyphicon-stop"></span>
													</button>
												</div>
												<div class="btn-group">
													<button type="button" id="zoomin" class="btn btn-default">
														<span class="glyphicon glyphicon-zoom-in"></span>
													</button>
													<button type="button" id="zoomout" class="btn btn-default">
														<span class="glyphicon glyphicon-zoom-out"></span>
													</button>

												</div>
												<button type="button" class="btn btn-default toggle-chart">
													<span class="glyphicon glyphicon-random"></span>
												</button>

											</c:if>
										</div>

										<div class="col-xs-2">
											<p align="right" class="nav-group viewcontrol">
												<a class="badge active" href="#usage_graph"
													data-toggle="tab"><span
													class="glyphicon glyphicon-stats"></span></a> <a class="badge"
													href="#usage_data" data-toggle="tab"><span
													class="glyphicon glyphicon-list"></span></a>
											</p>
										</div>
									</div>

									<div class="graff-title">
										<a class="btn-prev btn-prev-date previous"
											href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=${dpb.period}&usagetime-min=${dpb.prevUsagetimeMin}&usagetime-max=${dpb.prevUsagetimeMax}'/>">Previous</a><a
											class="btn-next btn-next-date next"
											href="<c:url value='/RetailCustomer/${currentCustomer.id}/UsagePoint/${meterReading.usagePoint.id}/MeterReading/${meterReading.id}/show?period=${dpb.period}&usagetime-min=${dpb.nextUsagetimeMin}&usagetime-max=${dpb.nextUsagetimeMax}'/>">Next</a>

										<div class="usageheading">
											<label> Usage Data for <jsp:setProperty
													property="time" name="dateValue"
													value="${dpb.prevUsagetimeMax*1000}" /> <a><strong><fmt:formatDate
															value="${dateValue}" pattern="EEEE MMM dd, yyyy"
															timeZone="EST5EDT" /> </strong> <c:if test="${dpb.period gt 1}">
														<span> - </span>
														<jsp:setProperty property="time" name="dateValue"
															value="${dpb.nextUsagetimeMin*1000}" />
														<a><strong><fmt:formatDate
																	value="${dateValue}" pattern="EEEE MMM dd, yyyy"
																	timeZone="EST5EDT" />
													</c:if></a>
											</label>
										</div>

									</div>
								</header>
								<div class="panel-body">

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
													<c:out
														value="Usage data is not avilable for selected date." />
												</div>
											</c:if>
											<div id="usagegraph" class="demo-placeholder"
												style="min-width: 300px; width: 100%; height: 320px"></div>
										</div>
										<div class="tab-pane" id="usage_data">
											<c:if test="${empty meterReading.intervalBlocks}">
												<div class="alert alert-warning">
													<c:out
														value="Usage data is not avilable for selected date." />
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
																							value="${intervalReading.value/meterReading.readingType.multiplier}" /></td>
																					<td><c:out value="${intervalReading.cost}"
																							default="-" /></td>

																					<td>
																						<ul class="reading-qualities">
																							<c:forEach var="readingQuality"
																								items="${intervalReading.readingQualities}">
																								<li><c:out
																										value="${readingQuality.quality}" /></li>
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

							</section>
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
