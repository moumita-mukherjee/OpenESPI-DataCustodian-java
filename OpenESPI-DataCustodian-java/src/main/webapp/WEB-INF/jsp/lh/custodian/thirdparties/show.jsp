<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
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

<body>
	<script type="text/javascript">
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
						<h1>Third Party Application Detail</h1>
					</div>
					<div class="panel panel-default">
						<div class="panel-heading">
							<span style="white-space: nowrap;"> <img alt="logo" width="120"  class="img-rounded-2"
								src="${appInformation.logoUri}"
								title="${appInformation.clientName}" /> <c:out
									value="${appInformation.thirdPartyApplicationName}" />
							</span> <br /> <span> Register On : <fmt:formatDate
									value="${appInformation.published.time}"
									pattern="MMM dd, yyyy HH:mm" />
							</span>
						</div>

						<div class="panel-body">
							<table class="table">
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Client Id</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.clientId}"></c:out> </span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Client Secret</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.clientSecret}"></c:out> </span> <br>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>NotifyUri</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.thirdPartyNotifyUri}"
														default="Empty"></c:out> </span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>ThirdParty Selection ScreenURI</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.dataCustodianThirdPartySelectionScreenURI}"
														default="Empty"></c:out> </span>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Login Screen URI</label>
											<div>

												<span class="label label-default"><c:out
														value="${appInformation.thirdPartyLoginScreenURI}"
														default="Empty"></c:out> </span>

											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Scope Selection ScreenURI</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.thirdPartyScopeSelectionScreenURI}"
														default="Empty"></c:out> </span>

											</div>
										</div>
									</td>
								</tr>
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>User Portal ScreenURI</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.thirdPartyUserPortalScreenURI}"
														default="Empty"></c:out> </span>

											</div>
										</div>
									</td>
								</tr>


								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Redirect URI</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.redirectUri}" default="Empty"></c:out>
												</span>

											</div>
										</div>
									</td>
								</tr>




								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Token Endpoint Auth Method</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.tokenEndpointAuthMethod}"
														default="Empty"></c:out> </span>
											</div>
										</div>
									</td>
								</tr>


							</table>
						</div>
					</div>
					<div>
						<a class="btn
										btn-primary">Back</a>
						<c:choose>
							<c:when test="${appInformation.authorized}">
								<a class="btn
										btn-primary"
									data-href="<c:url value="/custodian/${appInformation.id}/unauthorize"/>"
									data-toggle="confirmation"
									data-title="Do you want to Un Authroize?">Revoke</a>
							</c:when>
							<c:otherwise>
								<a class="btn
										btn-primary"
									data-href="<c:url value="/custodian/${appInformation.id}/authorize"/>"
									data-toggle="confirmation"
									data-title="Do you want to Authroize?">Authorize</a>
							</c:otherwise>
						</c:choose>
					</div>
				</section>

			</div>
		</div>
		<jsp:include page="../../tiles/footer.jsp" />

	</div>
</body>
</html>
