<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
		$('table').on('click', 'tr', function(e) {
			$('table').find('tr.highlight').removeClass('highlight');
			$(this).addClass('highlight');
		});
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
						<h1>Applications</h1>
					</div>
					<div class="balance-section ">


						<article>
							<p>Below are the GreenButton apps supplied by different
								application vender. You may provide authorization to one or more
								application listed to be monitor your Electricity usage in your
								mobile device. On click of "Next" button page will be redirected
								to respective application provider webpage to initiate the
								authorization flow.</p>
						</article>
						<div class="well well-lg">
							<form method="POST"
								action="<c:url value='/RetailCustomer/${currentCustomer.id}/ThirdPartyList'/>">
								<div class="table-responsive">
									<table class="table table-striped table-hover">
										<colgroup width="30px">
										<colgroup width="100px">
										<thead>
											<tr>
												<th></th>
												<th></th>
												<th></th>
											</tr>
										</thead>
										<caption align="right">
											<table align="right">
												<tr>
													<td>View By</td>
												</tr>
											</table>
										</caption>
										<tbody>
											<c:forEach var="applicationInformation"
												items="${applicationInformationList}">
												<tr>
													<td><span> <img alt="logo" width="120"
															height="40" class="img-rounded-2"
															src="${applicationInformation.logoUri}"
															title="${applicationInformation.thirdPartyApplicationName}" /></span><a
														href="#" data-toggle="tooltip" data-placement="left"
														title="${applicationInformation.scope}"><c:out
																value="${applicationInformation.thirdPartyApplicationName}" /></a>
														<br /> <span><c:out
																value="${applicationInformation.thirdPartyApplicationDescription}" /><br></span>
														<span><a href="#">View More</a></span>
														<ul>
															<c:forEach items="${applicationInformation.scope}"
																var="vscope">
																<li><c:out value="${vscope.description}"></c:out></li>
															</c:forEach>
														</ul> <span>Read our <c:choose>
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
													</span></td>
													<td><c:out
															value="${applicationInformation.clientName}" /></td>
													<td valign="middle"><c:if
															test="${not empty dcapplicationInformation}">
															<a class="btn btn-primary"
																href="<c:url value='${applicationInformation.thirdPartyScopeSelectionScreenURI}'/>?DataCustodianID=${dcapplicationInformation.dataCustodianId}&scope=${applicationInformation.scopeQueryString}">Continue<span
																class="glyphicon glyphicon-new-window"></span></a>
														</c:if></td>


												</tr>
											</c:forEach>
										</tbody>

									</table>
								</div>
								<div></div>
							</form>

						</div>
					</div>
				</section>
			</div>

		</div>
		<jsp:include page="../../tiles/footer.jsp" />

	</div>

</body>
</html>
