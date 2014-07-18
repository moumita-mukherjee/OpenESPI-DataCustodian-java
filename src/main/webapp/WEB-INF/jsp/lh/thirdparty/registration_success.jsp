<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<jsp:include page="../tiles/head.jsp" />

<body>

	<jsp:include page="../tiles/header.jsp" />


	<div id="main">
		<div class="container">
			<div class="content">
				<section class="content-container">
					<div class="heading big">
						<h1>Registration Confirmation</h1>
					</div>

					<div class="balance-section">Thank you for the registration.
						London Hydro representative will contact you to authorize your
						registration. After the the authorization, London Hydro retail
						customer will able to select your application. Important details:

						To modify your registration follow the below step.</div>
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3>Details of Your Registration</h3>
						</div>
						<div class="panel-body">
							<table class="table">
								<tr>
									<td style="border: none !important">
										<div class="control-group">
											<label>Client Id</label>
											<div>
												<span class="label label-default"><c:out
														value="${appInformation.clientId}"></c:out> </span> <br>
												<p>Client id is required during OAuth authorrization
													process. Your application need to provide client id and
													client secret as authentication credential during
													authrization process.</p>
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
												<p>
													Client id is required during OAuth authorization process.
													Your application need to provide client id and client
													secret as authentication credential during authorization
													process.<b>Take a note of this data. Never shared to
														anyone.</</b>
												</p>
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
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3>Details of London Hydro Data Custodian</h3>
						</div>
						<div class="panel-body">
							<dl>
								<dt>London Hydro DataCustodian ID</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.dataCustodianId}" />
									</span>
								</dd>
								<dt>Supported Scope</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.scope}" />
									</span>
									<div>
										<dl>
											<c:forEach items="${datacustodian.scope}" var="vscope">
												<dt>
													<c:out value="${vscope.scope}" />
												</dt>
												<dd>
													<c:out value="${vscope.description}" />
												</dd>
											</c:forEach>
										</dl>
									</div>
								</dd>
								<dt>Authorization Server</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.authorizationServerUri}"
											default="Not Defined" />
									</span>
								</dd>
								<dt>Authorization Server -> Registration End Point</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.authorizationServerRegistrationEndpoint}"
											default="Not Defined" />
									</span>
								</dd>
								<dt>Authorization Server -> Authorization End Point</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.authorizationServerAuthorizationEndpoint}"
											default="Not Defined" />
									</span>
								</dd>
								<dt>Authorization Server -> Token Generation URI</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.authorizationServerTokenEndpoint}"
											default="Not Defined" /></span>
								</dd>
								<dt>London Hydro -> Bulk Request URI</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.dataCustodianBulkRequestURI}"
											default="Not Defined" /></span>
								</dd>
								<dt>London Hydro -> Resource End Point</dt>
								<dd>
									<span class="label label-default"> <c:out
											value="${datacustodian.dataCustodianResourceEndpoint}"
											default="Not Defined" /></span>
								</dd>
							</dl>


						</div>
					</div>
				</section>

			</div>
		</div>
		<jsp:include page="../tiles/footer.jsp" />

	</div>
</body>
</html>
