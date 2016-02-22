<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
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
<jsp:useBean id="dateValue2" class="java.util.Date" />
<jsp:include page="../../tiles/head.jsp" />
<style>
table.bor {
	border: 1px soldi red;
}

table.bor td {
	border: 1px soldi red !important;
}

.commentBox {
	display: none;
	position: absolute;
	z-index: 9999;
	font-size: 80%;
}
</style>


<c:set var="menu" scope="session" value="cmd" />
<body>

	<script type="text/javascript">
		$('table').on('click', 'tr', function(e) {
			$('table').find('tr.highlight').removeClass('highlight');
			$(this).addClass('highlight');
		});
		$(document)
				.ready(
						function() {
							$(".more")
									.click(
											function() {
												$(this)
														.html(
																$(this).html() == "View more" ? "View less"
																		: "View more");

												//alert($(this).attr('data-target'));
												$($(this).attr('data-target'))
														.toggle();
											});
						});

		$(function() {
			$('.nav-group a').on('click', function(event) {
				$('.nav-group a').removeClass('active'); // remove active class from tabs
				$(this).addClass('active'); // add active class to clicked tab
			});
			$('.nav-group a').on('click', function(event) {
				$('.tab-content div').removeClass('active');
				$('.tab-content div').addClass('active');
			});

		});
	</script>
	<div id="wrapper">
		<jsp:include page="../../tiles/header.jsp" />
		<div id="main">
			<div class="container">
				<jsp:include page="../../tiles/customer/leftmenu.jsp" />

				<div class="content">
					<div>
						<p></p>
					</div>


					<c:choose>
						<c:when test="${not empty authorizationList}">
							<section class="content-container">


								<div class="heading big">
									<h1>Authorized Applications</h1>
								</div>
								<div class="balance-section  table-responsive">


									<p>
										The list below shows all active authorizations for this
										account. If you would like to edit or delete an authorized
										application, please use the <b>"Edit"</b> button.
									</p>
									<p align="right" class="nav-group">
										Group By <a class="badge active" href="#auth_all"
											data-toggle="tab">No Grouping</a> <a class="badge"
											href="#auth_services" data-toggle="tab">Service</a> <a
											class="badge" href="#auth_applications" data-toggle="tab">Application</a>
									</p>
									<div class="tab-content">
										<div class="tab-pane active" id="auth_all">
											<table class="table table-striped" id="authorizations">
												<thead>
													<tr>
														<th>Application</th>
														<th>Rating</th>
														<th>Provider</th>
														<th>Authorized On</th>
														<th>Valid Until</th>
														<th>Action</th>

													</tr>
												</thead>

												<tfoot>
													<tr>
														<td colspan=6><c:if test="${empty authorizationList}">
																<c:out
																	value="You have not yet authorized any application to view your usage."></c:out>
															</c:if></td>
													</tr>
												</tfoot>
												<tbody>
													<c:forEach var="authorization" items="${authorizationList}">
														<tr app_id="${authorization.applicationInformation.id}" current_login_id="${currentuser.id}">
															<td><span> <img alt="logo" width="120"
																	class="img-rounded-2"
																	src="${authorization.applicationInformation.logoUri}"
																	title="${authorization.applicationInformation.thirdPartyApplicationName}"
																	data-toggle="tooltip" />
															</span></td>															
																<td><span class="rating-input" app_id="${authorization.applicationInformation.id}" current_login_id="${currentUser.id}" app_type="single">
 																<input type="number" class="rating" id="ratingValue" name="test" data-min="1" data-max="5" data-value="0">
 																</span>
 																<div class="comments-input"><a  href="javascript:void(0)" id="commentsLink">Comment</a>
 																							<a  href="javascript:void(0)" id="commentsHideLink" style="display:none;" >Hide</a>
 																
 																<div class="commentBox"  class="popupContainer" style="display:none;">
 																	<span><textarea style="width:250px;height:40px" id="comments"></textarea></span>
 																	<span style="line-height:20px;"><a class="badge active" href="javascript:void(0)" id="saveComment" app_id="${authorization.applicationInformation.id}" current_login_id="${currentUser.id}">Comment</a></span>
 																</div>
 																</div>
 															</td>
															<td><a
																href="${authorization.applicationInformation.clientUri}"
																target="_new"><c:out
																		value="${authorization.applicationInformation.clientName}" /></a></td>

															<td><jsp:setProperty property="time"
																	name="dateValue"
																	value="${authorization.authorizedPeriod.start*1000}" /> <fmt:formatDate
																	value="${dateValue}" pattern="MMM dd, yyyy" timeZone="EST"/></td>
															<td><jsp:setProperty property="time"
																	name="dateValue"
																	value="${authorization.authorizedPeriod.start*1000+authorization.authorizedPeriod.duration*1000}" /><c:choose>
																	<c:when test="${authorization.status==1}">
																		<span class="status-active"> <fmt:formatDate
																				value="${dateValue}" pattern="MMM dd, yyyy"  timeZone="EST"/>
																		</span>
																	</c:when>
																	<c:otherwise>
																		<span class="status-inactive"> Revoked <br />
																			<fmt:formatDate value="${dateValue}"
																				pattern="MMM dd, yyyy"  timeZone="EST"/></span>
																	</c:otherwise>
																</c:choose></td>
															<td><c:if test="${authorization.status==1}">
																	<a class="btn btn-primary"
																		title="${authorization.authorizationURI}"
																		href="<c:url value='/RetailCustomer/${currentCustomer.id}/AuthorizedThirdParties/${authorization.id}'/>">Edit</a>
																</c:if></td>


														</tr>
													</c:forEach>
												</tbody>
											</table>
										</div>
										<div class="tab-pane" id="auth_services">
											<c:forEach var="usagePoint" items="${usagePointList}">
												<c:if test="${not empty usagePoint.subscriptions}">
													<div class="panel panel-default">
														<div class="panel-heading">
															<h4>
																ELECTRICITY -
																<c:out value="${usagePoint.usagePointDetail.streetUnit}" />
																<c:if
																	test="${not empty usagePoint.usagePointDetail.streetUnit}">
															-
															</c:if>
																<c:out
																	value="${usagePoint.usagePointDetail.streetNumber}" />
																<c:out value="${usagePoint.usagePointDetail.streetName}" />
															</h4>
															<h5>
																<c:out value="${usagePoint.usagePointDetail.streetCity}" />
																<br />
																<c:out value="${usagePoint.usagePointDetail.postalCode}" />
																<c:out
																	value="${usagePoint.usagePointDetail.streetProvince}" />
															</h5>
														</div>
														<div class="panel-body">
															<div class="row">
																<div class="col-xs-4 col-md-3">
																	<dl class="dl-horizontal">
																		<dt>Billing Number:</dt>
																		<dd>
																			<c:out
																				value="${usagePoint.usagePointDetail.accountId}" />
																		</dd>
																		<dt>Service Number:</dt>
																		<dd>
																			<c:out
																				value="${usagePoint.usagePointDetail.serviceId}" />
																		</dd>
																	</dl>
																</div>
																<div class="col-xs-4 col-md-3">
																	<dl class="dl-horizontal">
																		<dt>Meter Number:</dt>
																		<dd>
																			<c:out
																				value="${usagePoint.usagePointDetail.meterNumber}" />
																		</dd>
																		<dt>Usage Point:</dt>
																		<dd>
																			<c:out value="${usagePoint.id}" />
																		</dd>
																	</dl>
																</div>
																<div class="col-xs-4 col-md-3">
																	<dl class="dl-horizontal">
																		<dt>Status:</dt>
																		<dd>
																			<c:choose>
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
																							pattern="MMM dd, yyyy"  timeZone="EST"/></span>
																				</c:otherwise>
																			</c:choose>
																		</dd>
																	</dl>
																</div>
															</div>



															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4>AUTHORIZATION</h4>
																</div>
																<div class="panel-body">
																	<c:if test="${empty usagePoint.subscriptions}">You have not share your usage with any vendor application. Try now. </c:if>
																	<c:if test="${not empty usagePoint.subscriptions}">
																		<table class="table table-striped" id="authorizations">
																			<thead>
																				<tr>
																					<th>Application</th>
																					<th>Rating</th>
																					<th>Provider</th>
																					<th>Authorized On</th>
																					<th>Valid Until</th>
																					<th>Action</th>

																				</tr>
																			</thead>
																			<tbody>
																				<c:forEach var="subscription"
																					items="${usagePoint.subscriptions}">
																					<c:if test="${subscription.authorization.status==1}">
																					<tr>
																						<td><span> <img alt="logo" width="120"
																								class="img-rounded-2"
																								src="${subscription.authorization.applicationInformation.logoUri}"
																								title="${subscription.authorization.applicationInformation.thirdPartyApplicationName}" />
																						</span></td>
																						<td><span class="rating-input" app_id="${subscription.authorization.applicationInformation.id}" app_type="average">
																						<input type="number" class="rating" id="ratingValue" name="test" data-min="1" data-max="5" data-value="0">
																						</span></td>
																						<td><a
																							href="${subscription.authorization.applicationInformation.clientUri}"
																							target="_new"><c:out
																									value="${subscription.authorization.applicationInformation.clientName}" /></a></td>
																						<td><c:if
																								test="${subscription.authorization.authorizedPeriod!=null && subscription.authorization.authorizedPeriod.start!=null}">
																								<jsp:setProperty property="time"
																									name="dateValue"
																									value="${subscription.authorization.authorizedPeriod.start*1000}" />
																								<fmt:formatDate value="${dateValue}"
																									pattern="MMM dd, yyyy"  timeZone="EST"/>
																							</c:if></td>
																						<td><jsp:setProperty property="time"
																								name="dateValue"
																								value="${subscription.authorization.authorizedPeriod.start*1000+subscription.authorization.authorizedPeriod.duration*1000}" /><c:choose>
																								<c:when
																									test="${subscription.authorization.status==1}">
																									<span class="status-active"> <fmt:formatDate
																											value="${dateValue}" pattern="MMM dd, yyyy"  timeZone="EST"/>
																									</span>
																								</c:when>
																								<c:otherwise>
																									<span class="status-inactive"> Revoked <br />
																										<fmt:formatDate value="${dateValue}"
																											pattern="MMM dd, yyyy"  timeZone="EST"/>
																									</span>
																								</c:otherwise>
																							</c:choose></td>

																						<td><c:if
																								test="${subscription.authorization.status==1}">
																								<a class="btn btn-primary"
																									title="${subscription.authorization.authorizationURI}"
																									href="<c:url value='/RetailCustomer/${currentCustomer.id}/AuthorizedThirdParties/${subscription.authorization.id}'/>">Edit</a>
																							</c:if></td>


																					</tr>
																					</c:if>
																				</c:forEach>
																			</tbody>
																		</table>
																	</c:if>
																</div>


															</div>
														</div>
													</div>
												</c:if>
											</c:forEach>

										</div>
										<div class="tab-pane" id="auth_applications">
											<c:forEach var="authorizedApplication"
												items="${applicationInformationList}">
												<c:if
													test="${not empty subscriptionByApp[authorizedApplication.thirdPartyApplicationName]}">

													<div class="panel panel-default">
														<div class="panel-heading">

															<div class="media">
																<a class="pull-left" href="#"> <img
																	class="media-object" width="120"
																	src="${authorizedApplication.logoUri}"
																	alt="${authorizedApplication.thirdPartyApplicationName}"
																	title="${authorizedApplication.thirdPartyApplicationName}" /></a>
																<div class="media-body">
																	<h4 class="media-heading">
																		<c:out
																			value="${authorizedApplication.thirdPartyApplicationName}" />
																	</h4>

																	<span class="lable-note">From</span> <a
																		href="${authorizedApplication.clientUri}"
																		target="_new"><c:out
																			value="${authorizedApplication.clientName}" /></a>
																</div>
															</div>
														</div>
														<div class="panel-body">
															<p>
																<c:out
																	value="${authorizedApplication.thirdPartyApplicationDescription}" />
															</p>
															<p>
																<span class="nowrap"> <span class="note-lable">Global
																		Rating</span><span class="rating-input"> <span
																		class="glyphicon glyphicon-star-empty" data-value="1"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="2"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="3"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="4"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="5"></span>
																</span> <span class="note-lable">Your Rating</span> <span
																	class="rating-input"><span
																		class="glyphicon glyphicon-star-empty" data-value="1"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="2"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="3"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="4"></span><span
																		class="glyphicon glyphicon-star-empty" data-value="5"></span>
																</span>
																</span>
															</p>
															<div class="panel panel-default">
																<div class="panel-heading">
																	<h4>AUTHORIZATION</h4>
																</div>
																<div class="panel-body">
																	<c:if
																		test="${empty subscriptionByApp[authorizedApplication.thirdPartyApplicationName]}">You have not share your usage with any vendor application. Try now. </c:if>
																	<c:if
																		test="${not empty subscriptionByApp[authorizedApplication.thirdPartyApplicationName]}">
																		<table class="table table-striped" id="authorizations">
																			<thead>
																				<tr>
																					<th id="authorizations_address">Address</th>
																					<th>Billing Number</th>
																					<th>Service</th>
																					<th id="authorizations_usagepoint">Usage Point</th>
																					<th>Meter</th>
																					<th>Authorized On</th>
																					<th>Valid Until</th>
																					<th>Action</th>

																				</tr>
																			</thead>
																			<tbody>
																				<c:forEach var="subscription"
																					items="${subscriptionByApp[authorizedApplication.thirdPartyApplicationName]}">
																					<c:forEach var="usagePoint"
																						items="${subscription.usagePoints}">
																						<tr>
																							<td id="authorizations_address"><strong><c:out
																										value="${usagePoint.usagePointDetail.streetUnit}" />
																									<c:if
																										test="${not empty usagePoint.usagePointDetail.streetUnit}">
																								- </c:if> <c:out
																										value="${usagePoint.usagePointDetail.streetNumber}" />
																									<c:out
																										value="${usagePoint.usagePointDetail.streetName}" />
																							</strong> <br /> <c:out
																									value="${usagePoint.usagePointDetail.streetCity}" />
																								<br /> <c:out
																									value="${usagePoint.usagePointDetail.postalCode}" />
																								<c:out
																									value="${usagePoint.usagePointDetail.streetProvince}" />

																							</td>
																							<td><c:out
																									value="${usagePoint.usagePointDetail.accountId}" /></td>
																							<td><spring:message
																									code="service.name.${usagePoint.serviceCategory.kind}" /><br />
																								<c:out
																									value="${usagePoint.usagePointDetail.serviceId}" /></td>
																							<td id="authorizations_usagepoint"><c:out value="${usagePoint.id}" /></td>
																							<td><c:out
																									value="${usagePoint.usagePointDetail.meterNumber}" /></td>
																							<td><c:if
																									test="${subscription.authorization.authorizedPeriod!=null && subscription.authorization.authorizedPeriod.start!=null}">
																									<jsp:setProperty property="time"
																										name="dateValue"
																										value="${subscription.authorization.authorizedPeriod.start*1000}" />
																									<fmt:formatDate value="${dateValue}"
																										pattern="MMM dd, yyyy"  timeZone="EST"/>
																								</c:if></td>
																							<td><jsp:setProperty property="time"
																									name="dateValue"
																									value="${subscription.authorization.authorizedPeriod.start*1000+subscription.authorization.authorizedPeriod.duration*1000}" /><c:choose>
																									<c:when
																										test="${subscription.authorization.status==1}">
																										<span class="status-active"> <fmt:formatDate
																												value="${dateValue}" pattern="MMM dd, yyyy"  timeZone="EST"/>
																										</span>
																									</c:when>
																									<c:otherwise>
																										<span class="status-inactive"> Revoked
																											<br /> <fmt:formatDate value="${dateValue}"
																												pattern="MMM dd, yyyy"  timeZone="EST"/>
																										</span>
																									</c:otherwise>
																								</c:choose></td>
																							<td><c:if
																									test="${subscription.authorization.status==1}">
																									<a class="btn btn-primary"
																										title="${authorization.authorizationURI}"
																										href="<c:url value='/RetailCustomer/${currentCustomer.id}/AuthorizedThirdParties/${subscription.authorization.id}'/>">Edit</a>
																								</c:if></td>


																						</tr>
																					</c:forEach>
																				</c:forEach>
																			</tbody>
																		</table>
																	</c:if>
																</div>

															</div>
														</div>
													</div>
												</c:if>
											</c:forEach>

										</div>

									</div>
									<p>
										<a href="#">View All Authorizations</a>
									</p>
								</div>

							</section>
						</c:when>
						<c:otherwise>
						<section srckey="let-me-participate"><!--  
							<p>
								<img alt="green button connect my data" width="100%"
									src="https://www.londonhydro.com/site/binaries/content/gallery/londonhydrohippo/corporate/residential/landing-page/greenbutton_leaf.png">
							</p>
							<p>London Hydro is piloting the Green Button Connect My Data
								features on our website, which will allow you to authorize and
								share your information with any two apps, depending on your
								customer class. Based on your consent, these apps will obtain
								your energy usage information from us and provide valuable
								insight, feedback and in some cases, even rewards points that
								will help you better understand your electricity consumption and
								manage your bills. All of these solutions are free for the
								entire duration of the pilot.</p>
						-->		
						</section>
						</c:otherwise>
					</c:choose>


					<section class="content-container">
						<div class="heading big">
							<h1>Applications</h1>
						</div>
						<div class="balance-section" id="cmd"> 


							<article>
								<p>
									Below are the applications supplied by our authorized third
									party vendors. You may authorize one or more applications
									listed to monitor your electricity usage on your mobile device.<br>
									<br>To initiate the process please click the <b>"Authorize"</b>
									button. This action will redirect you to the authorized
									vendor's web page.
								</p>
							</article>


							<p align="right">

								Sort By <span class="badge active"><a href="#">Name</a></span> <span
									class="badge"><a href="#">New</a></span> <span class="badge"><a
									href="#">Popularity</a></span></

							</p>
							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<colgroup width="75%">
									<colgroup width="10%">
									<thead>
										<tr>
											<th></th>
											<th></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="applicationInformation"
											items="${applicationInformationList}" varStatus="vStatus">
											<tr>
												<td>

													<div class="media">
														<a class="pull-left" href="#"> <img
															class="media-object" width="120"
															src="${applicationInformation.logoUri}"
															alt="${applicationInformation.thirdPartyApplicationName}"
															title="${applicationInformation.thirdPartyApplicationName}" /></a>
														<div class="media-body">
															<h4 class="media-heading">
																<c:out
																	value="${applicationInformation.thirdPartyApplicationName}"
																	default="Not Specified" />
															</h4>
															<span class="nowrap"> <span class="lable-note">From</span>
																<a href="${applicationInformation.clientUri}"
																target="_new"><c:out
																		value="${applicationInformation.clientName}" /></a> <jsp:setProperty
																	property="time" name="dateValue"
																	value="${applicationInformation.published.time.time}" />
																<span class="lable-note"> Since</span> <fmt:formatDate
																	value="${dateValue}" pattern="MMM dd, yyyy"  timeZone="EST"/></span> <br />
															<span class="nowrap"> <span class="rating-input" app_id="${applicationInformation.id}" app_type="average">
																						<input type="number" class="rating" id="ratingValue" name="test" data-min="1" data-max="5" data-value="0" data-disabled="true">
																						</span>
															</span>
															<div class="commentsSection" app_id="${applicationInformation.id}">
																<span> <a id="viewComments"  href="javascript:void(0)" >View Comments</a></span>
																 <span> <a id="hideComments"  href="javascript:void(0)" style="display: none">Hide Comments</a></span>
																 <div id="allComments"  style="display: none" >
																 </div>
															</div>
															<!-- 
															</span> <span class="lable-note">Used by </span><span
																class="badge">1000+</span> </span>
 -->
															<dl>
																<dt>About the application</dt>
																<dd>
																	<c:out
																		value="${applicationInformation.thirdPartyApplicationDescription}" />
																	<br /> <span> <a id="morebtn" class="more"
																		data-toggle="collapse" data-parent="#accordion"
																		data-target="#more${vStatus.index}"
																		href="javascript:void(0)">View more</a></span>
																	<div id="more${vStatus.index}" style="display: none">
																		<ul>
																			<c:forEach items="${applicationInformation.scope}"
																				var="vscope">
																				<li><c:out value="${vscope}"></c:out></li>
																			</c:forEach>
																		</ul>
																		<span>Read our <c:choose>
																				<c:when
																					test="${not empty applicationInformation.tosUri}">
																					<a href="${applicationInformation.tosUri}"
																						target="_new">Terms of Service</a>
																				</c:when>
																				<c:when
																					test="${not empty applicationInformation.policyUri}"> and <a
																						href="${applicationInformation.policyUri}"
																						target="_new">Privacy Policy</a>
																				</c:when>
																			</c:choose>.

																		</span>
																	</div>
																</dd>
															</dl>

														</div>
													</div>
												</td>

												<td valign="middle" style="vertical-align: middle"><span><c:if
															test="${not empty dcapplicationInformation}">
															<a class="btn btn-primary"
																title="This will take you to vendor's website."
																href="<c:url value='/RetailCustomer/ScopeSelectionList'/>?ThirdPartyID=${applicationInformation.clientId}">Authorize
																<span class="glyphicon glyphicon-new-window"></span>
															</a>
															

														</c:if></span></td>


											</tr>
										</c:forEach>
									</tbody>

								</table>
							</div>

						</div>
					</section>
				</div>

			</div>
		</div>

		<jsp:include page="../../tiles/footer.jsp" />
	</div>
</body>
<jsp:include page="../../gatracking.jsp" />
</html>
