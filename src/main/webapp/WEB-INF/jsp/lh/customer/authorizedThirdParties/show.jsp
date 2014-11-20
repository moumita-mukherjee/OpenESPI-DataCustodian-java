<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
<jsp:useBean id="dateValue" class="java.util.Date" />
<jsp:include page="../../tiles/head.jsp" />

<body>
	<script type="text/javascript">
		function doAjaxDelete(url) {
			$.ajax({
				type : "delete",
				url : url,
				success : function(response) {
					alert(response);
				},
				error : function(e) {
					alert('Error: ' + e);
				}
			});
		}
	</script>
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
						<h1>Edit Application Authorization</h1>
					</div>
					<div class="balance-section">
						<form:form
							action="${pageContext.request.contextPath}/RetailCustomer/${currentCustomer.id}/AuthorizedThirdParties/${authorization.id}"
							method="POST" class="form-inline">
							<input type="hidden" name="_method" value="PUT" />
							<div class="media">
								<a class="pull-left" href="#"> <img class="media-object"
									width="120"
									src="${authorization.applicationInformation.logoUri}"
									alt="${authorization.applicationInformation.thirdPartyApplicationName}"
									title="${authorization.applicationInformation.thirdPartyApplicationName}" /></a>
								<div class="media-body">
									<h4 class="media-heading">
										<c:out
											value="${authorization.applicationInformation.thirdPartyApplicationName}" />
									</h4>

									<span class="lable-note">From</span> <a
										href="${authorization.applicationInformation.clientUri}"
										target="_new"><c:out
											value="${authorization.applicationInformation.clientName}" /></a>
									<hr />
									<c:out
										value="${authorization.applicationInformation.thirdPartyApplicationDescription}" />
								</div>
							</div>
							<hr />
							<h3>Authorization Period</h3>


							<dl class="dl-horizontal">
								<dt>Valid From:</dt>
								<dd>
									<jsp:setProperty property="time" name="dateValue"
										value="${authorization.authorizedPeriod.start*1000}" />
									<fmt:formatDate value="${dateValue}" pattern="MMM dd, yyyy" timeZone="EST"/>
								</dd>
								<dt>Valid Until:</dt>
								<dd>
									<jsp:setProperty property="time" name="dateValue"
										value="${authorization.authorizedPeriod.start*1000+authorization.authorizedPeriod.duration*1000}" />
									<c:choose>
										<c:when test="${authorization.status==0}">
											<span class="status-inactive"> Revoked <br /> <fmt:formatDate
													value="${dateValue}" pattern="MMM dd, yyyy" timeZone="EST"/></span>

										</c:when>
										<c:when test="${authorization.status==1}">
											<div class="input-append date input-group" id="dp3"
												style="width: 210px">
												<input class="datepicker form-control" size="16" type="text"
													name="authorization_end_date"
													value='<fmt:formatDate value="${dateValue}" pattern="MMM dd, yyyy" timeZone="EST"/>' />
												<span class="input-group-addon add-on"> <i
													data-time-icon="icon-time" data-date-icon="icon-calendar"><span
														class="glyphicon glyphicon-calendar"></span></i>
												</span>
											</div>
										</c:when>
									</c:choose>



								</dd>
							</dl>

							<h3>Service</h3>
							<table class="table table-striped" id="authorizations">

								<thead>
									<tr>
										<th>Address</th>
										<th>Billing Number</th>
										<th>Service</th>
										<th>Meter</th>
										<th>Service Status</th>
										<th>Action</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="usagePoint"
										items="${authorization.subscription.usagePoints}">
										<tr>
											<td><strong><c:out
														value="${usagePoint.usagePointDetail.streetUnit}" /> <c:if
														test="${not empty usagePoint.usagePointDetail.streetUnit}"> - </c:if>
													<c:out value="${usagePoint.usagePointDetail.streetNumber}" />
													<c:out value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
												<c:out value="${usagePoint.usagePointDetail.streetCity}" />
												<br /> <c:out
													value="${usagePoint.usagePointDetail.postalCode}" /> <c:out
													value="${usagePoint.usagePointDetail.streetProvince}" /></td>
											<td><c:out
													value="${usagePoint.usagePointDetail.accountId}" /></td>
											<td><spring:message
													code="service.name.${usagePoint.serviceCategory.kind}" /><br />
												<c:out value="${usagePoint.usagePointDetail.serviceId}" /></td>
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
																pattern="MMM dd, yyyy" timeZone="EST"/></span>
													</c:otherwise>
												</c:choose></td>
											<td><c:if
													test="${authorization.status==1 and fn:length(authorization.subscription.usagePoints) gt 1}">
													<a
														href="<c:url value='/RetailCustomer/${currentCustomer.id}/AuthorizedThirdParties/${authorization.id}/UsagePoint/${usagePoint.id}/delete'/>">REMOVE</a>
												</c:if></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							<c:if test="${fn:length(usagePoints) gt 0}">
									<p> Below is the list of services that are not included in the authorization. If you would like to authorize these services, please click on the "Add" button located under the Action heading.</p>									
									<table class="table table-striped" id="authorizations">

										<thead>
											<tr>
												<th>Address</th>
												<th>Billing Number</th>
												<th>Service</th>
												<th>Meter</th>
												<th>Service Status</th>
												<th>Action</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="usagePoint" items="${usagePoints}">
												<tr>
													<td><strong><c:out
																value="${usagePoint.usagePointDetail.streetUnit}" /> <c:if
																test="${not empty usagePoint.usagePointDetail.streetUnit}"> - </c:if>
															<c:out
																value="${usagePoint.usagePointDetail.streetNumber}" />
															<c:out value="${usagePoint.usagePointDetail.streetName}" /></strong><br />
														<c:out value="${usagePoint.usagePointDetail.streetCity}" />
														<br /> <c:out
															value="${usagePoint.usagePointDetail.postalCode}" /> <c:out
															value="${usagePoint.usagePointDetail.streetProvince}" /></td>
													<td><c:out
															value="${usagePoint.usagePointDetail.accountId}" /></td>
													<td><spring:message
															code="service.name.${usagePoint.serviceCategory.kind}" /><br />
														<c:out value="${usagePoint.usagePointDetail.serviceId}" /></td>
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
																		pattern="MMM dd, yyyy" timeZone="EST"/></span>
															</c:otherwise>
														</c:choose></td>
													<td><a
														href="<c:url value='/RetailCustomer/${currentCustomer.id}/AuthorizedThirdParties/${authorization.id}/UsagePoint/${usagePoint.id}/add'/>">ADD</a></td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								
							</c:if>

							<hr />
							<p align="right">
								<a class="btn btn-primary"
									href="<c:url value='/RetailCustomer/${currentCustomer.id}/cmd'/>">Back</a>
								<input type="submit" class="btn btn-primary" name="save"
									value="Save" ${authorization.status==0?'disabled':''}>
								<input type="submit" class="btn btn-danger" name="revoke"
									value="Revoke" ${authorization.status==0?'disabled':''} />
							</p>


						</form:form>
					</div>

				</section>
			</div>
		</div>

		<jsp:include page="../../tiles/footer.jsp" />

	</div>
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
</body>
</html>


