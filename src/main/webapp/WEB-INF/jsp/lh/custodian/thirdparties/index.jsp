<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
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
<style>
table.bor {
	border: 1px soldi red;
}

table.bor td {
	border: 1px soldi red !important;
}
</style>


<body>

	<script type="text/javascript">
		$(function() {
			$("form input[type=radio]").on(
					"click",
					function() {
						$("input[name=Third_party_URL]").val(
								$(this).data("third-party-url"));
						$("input[type=submit]").removeAttr("disabled");
					});
		});
		$('table').on('click', 'tr', function(e) {
			$('table').find('tr.highlight').removeClass('highlight');
			$(this).addClass('highlight');
		});

		$(function() {
			$('[data-toggle="confirmation"]').confirmation({
				singleton : true
			});
		});
	</script>

	<jsp:include page="../../tiles/header.jsp" />


	<div id="main">
		<div class="container">
			<jsp:include page="../../tiles/custodian/leftmenu.jsp" />
			<div class="content">
				<section class="content-container">

					<div class="heading big">
						<h1>Applications</h1>
					</div>
					<div class="well well-lg"></div>
					<div class="well well-lg">
						<form method="POST"
							action="<c:url value='/custodian/${currentCustomer.id}/ThirdPartyList'/>">

							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<colgroup width="75%">
									<colgroup width="10%">
									<thead>
										<tr>
											<th></th>
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
																	value="${dateValue}" pattern="MMM dd, yyyy" /></span> <br />
															<span class="nowrap"> <span
																class="glyphicon glyphicon-star-empty" data-value="1"></span><span
																class="glyphicon glyphicon-star-empty" data-value="2"></span><span
																class="glyphicon glyphicon-star-empty" data-value="3"></span><span
																class="glyphicon glyphicon-star-empty" data-value="4"></span><span
																class="glyphicon glyphicon-star-empty" data-value="5"></span>
															</span> <span class="lable-note">Used by </span><span
																class="badge">1000+</span> </span>

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
																				<li><c:out value="${vscope.description}"></c:out></li>
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
												<td><fmt:formatDate
														value="${applicationInformation.published.time}"
														pattern="MMM dd, yyyy HH:mm" /></td>
												<td><strong><c:choose>
															<c:when test="${applicationInformation.authorized}">
																<i class="icon-ok-sign"></i>Authorized
														</c:when>
															<c:otherwise>
																<i class=" icon-remove-sign"></i>Authorization
																Pending
														</c:otherwise>
														</c:choose></strong></td>
												<td><a class="btn btn-default"
													href="<c:url value='/custodian/${applicationInformation.id}/show' />">Manage
												</a></td>


											</tr>
										</c:forEach>
									</tbody>
									<tfoot>
										<tr>
											<td colspan="3"><input type="hidden"
												name="Third_party_URL" /></td>
										</tr>
									</tfoot>
								</table>
							</div>

							<div class="table-responsive">
								<table class="table table-striped table-hover">
									<colgroup width="30px">
									<colgroup width="100px">
									<thead>
										<tr>

											<th></th>
											<th></th>
											<th></th>
											<th></th>
											<th></th>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="applicationInformation"
											items="${applicationInformationList}">
											<tr>
												<td><a
													href="<c:url value='/custodian/${applicationInformation.id}/show' />"><c:out
															value="${applicationInformation.thirdPartyApplicationName}" /></a></td>
												<td><span> <img alt="logo" width="120"
														height="40" class="img-rounded-2"
														src="${applicationInformation.logoUri}"
														title="${applicationInformation.clientName}" /> <br>
												</span><span><c:out
															value="${applicationInformation.clientName}" /> </span></td>
												<td><span><c:out
															value="${applicationInformation.thirdPartyApplicationDescription}" /><br></span>
													<span>Read our <c:choose>
															<c:when test="${not empty applicationInformation.tosUri}">
																<a href="${applicationInformation.tosUri}" target="_new">Terms
																	of Service</a>
															</c:when>
															<c:when
																test="${not empty applicationInformation.policyUri}"> and <a
																	href="${applicationInformation.policyUri}"
																	target="_new">Privacy Policy</a>
															</c:when>
														</c:choose>.
												</span></td>
												<td><fmt:formatDate
														value="${applicationInformation.published.time}"
														pattern="MMM dd, yyyy HH:mm" /></td>
												<td><strong><c:choose>
															<c:when test="${applicationInformation.authorized}">
																<i class="icon-ok-sign"></i>Authorized
														</c:when>
															<c:otherwise>
																<i class=" icon-remove-sign"></i>Authorization
																Pending
														</c:otherwise>
														</c:choose></strong></td>
												<td><a class="btn btn-default"
													href="<c:url value='/custodian/${applicationInformation.id}/show' />">Manage
												</a></td>
											</tr>
										</c:forEach>
									</tbody>
									<tfoot>
										<tr>
											<td colspan="6"><input type="hidden"
												name="Third_party_URL" /></td>
										</tr>
									</tfoot>
								</table>
							</div>
							<div></div>
						</form>

					</div>
				</section>
			</div>


		</div>
		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
