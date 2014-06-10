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
						<h1>GreenButton Apps</h1>
					</div>
					<div class="well well-lg">
						<article>
							<p>Below are the GreenButton apps supplied by different
								application vender. You may provide authorization to one or more
								application listed to be monitor your Electricity usage in your
								mobile device. On click of "Next" button page will be redirected
								to respective application provider webpage to initiate the
								authorization flow.</p>
						</article>
					</div>
					<div class="well well-lg">
						<form method="POST"
							action="<c:url value='/custodian/${currentCustomer.id}/ThirdPartyList'/>">
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
