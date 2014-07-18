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

<jsp:include page="../../tiles/head.jsp" />

<body>

	<jsp:include page="../../tiles/customer/header.jsp" />

	<jsp:useBean id="dateValue" class="java.util.Date" />
	<jsp:useBean id="dateValue2" class="java.util.Date" />
	<div class="container">
		<div class="row">
			<div class="span12">
				<h2>
					Meter Reading:
					<c:out value="${meterReading.description}" />
				</h2>
				<table class="table table-striped">
					<caption class="text-left">Reading Type:</caption>
					<thead>
						<tr>
							<th>Reading Type</th>
							<th>Accumulation Behaviour</th>
							<th>Commodity</th>
							<th>Currency</th>
							<th>Data Qualifier</th>
							<th>Argument</th>
							<th>Interharmonic</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><c:out value="${meterReading.readingType.description}" /></td>
							<td><c:out
									value="${meterReading.readingType.accumulationBehaviour}" /></td>
							<td><c:out value="${meterReading.readingType.commodity}" /></td>
							<td><c:out value="${meterReading.readingType.currency}" /></td>
							<td><c:out value="${meterReading.readingType.dataQualifier}" /></td>
							<td><c:out
									value="${meterReading.readingType.argument.numerator}/${meterReading.readingType.argument.denominator}" /></td>
							<td><c:out
									value="${meterReading.readingType.interharmonic.numerator}/${meterReading.readingType.interharmonic.denominator}" /></td>
						</tr>
					</tbody>
				</table>

				<div id="interval-blocks">
					<c:forEach var="intervalBlock"
						items="${meterReading.intervalBlocks}">
						<table class="table table-striped">
							<caption class="text-left">Interval:</caption>
							<thead>
								<tr>
									<th>Start</th>
									<th>Duration</th>

								</tr>
							</thead>
							<tbody>
								<tr>
									<td><jsp:setProperty property="time" name="dateValue"
											value="${intervalBlock.interval.start}" /> <fmt:formatDate
											value="${dateValue}" pattern="MM/dd/yyyy HH:mm" /></td>
									<td><fmt:formatNumber minFractionDigits="0"
											groupingUsed="true">
											<c:out value="${intervalBlock.interval.duration/60}" />
										</fmt:formatNumber></td>
								</tr>
							</tbody>
						</table>
						<table class="table table-striped">
							<caption class="text-left">Interval Readings:</caption>
							<thead>
								<tr>
									<th>Start</th>
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
										<td><jsp:setProperty property="time" name="dateValue2"
												value="${intervalReading.timePeriod.start}" /> <fmt:formatDate
												value="${dateValue2}" pattern="MM/dd/yyyy HH:mm" /></td>
										<td><fmt:formatNumber minFractionDigits="0"
												groupingUsed="true">
												<c:out value="${intervalReading.timePeriod.duration/60}" />
											</fmt:formatNumber></td>
										<td><c:out value="${intervalReading.value}" /></td>
										<td><c:out value="${intervalReading.cost}" /></td>

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
					</c:forEach>

				</div>
			</div>
		</div>

		<hr>

		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
