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
						<h1>Registration</h1>
					</div>

					<div class="balance-section">
						<p>
							If your application is already registered and you would like to
							view/edit the details. Click <a href="#"
								onclick="$('#searchform').toggle()"> Edit</a>
						</p>
						<div id="searchform" style="display: none">
							<form:form method="POST"
								action="/DataCustodian/thirdparty/registrationfind"
								commandName="appInformationSearchForm">

								<div class="panel panel-default">
									<div class="panel-body">
										<div class="alert">
											<c:out value="${appInformationSearchForm.error}" />
										</div>
										<table class="table">

											<tr>
												<td style="border: none !important">
													<div class="control-group">
														<form:label path="clientId" class="control-label">Client Id</form:label>
														<div>
															<form:input path="clientId" type="text"
																class="form-control" id="clientId"
																placeholder="Enter Your Client Id" />
														</div>
													</div>
												</td>
												<td style="border: none !important">
													<div class="control-group">
														<form:label path="clientSecret" class="control-label">Client Secret</form:label>
														<div>
															<form:password path="clientSecret" class="form-control"
																id="clientSecret" placeholder="Enter Password" />
														</div>
													</div>
												</td>
												<td style="border: none !important">

													<div class="control-group">
														<div class="controls">
															<input type="submit" name="create"
																class="btn btn-primary" value="GO" />
														</div>
													</div>
												</td>
											</tr>

										</table>
									</div>
								</div>

							</form:form>
						</div>

						<c:if test="${appInformationSearchForm.error!=null}">
							<script type="text/javascript">
								$('#searchform').show();
							</script>
						</c:if>
						

						<form:form method="POST"
							action="/DataCustodian/thirdparty/registration"
							commandName="appInformation">
							
							<form:errors path="*" cssClass="alert" />
							<br>
							
							<div class="panel panel-default">
								<div class="panel-heading">
									<h4>About your Organization</h4>
								</div>
								<div class="panel-body">
									<table class="table table-condensed">
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="clientName" class="control-label">Your Organization Name</form:label>
													<div>
														<form:input path="clientName" type="text"
															class="form-control" id="clientName"
															placeholder="Enter SelectionScreenURI" />
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="clientUri" class="control-label">Organization Public Website
												</form:label>
													<div class="control-group form-inline">
														<form:input path="clientUri" type="text"
															class="form-control" id="clientUri"
															placeholder="Enter clientUri" />
														<button type="button" class="btn btn-info">Check</button>

													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="logoUri" class="control-label">Organization Logo</form:label>
													<div>
														<div class="input-group">
															<span class="input-group-addon"> <img
																id="tpimgrui" width="32" src="${appInformation.logoUri}" />
															</span>
															<form:input path="logoUri" type="text"
																class="form-control" id="logoUri"
																placeholder="Enter logo_uri"
																onblur="$('#tpimgrui').attr('src',$('#logoUri').val())" />

														</div>
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="contacts" class="control-label">Contact Email
													</form:label>
													<div>
														<form:input path="contacts" type="textarea"
															class="form-control" id="contacts"
															placeholder="Enter Email" />
													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyPhone" class="control-label">Contact Number
													</form:label>
													<div>
														<form:input path="thirdPartyPhone" type="text"
															class="form-control" id="thirdPartyPhone"
															placeholder="Enter Phone" />
													</div>
												</div>
											</td>
										</tr>



									</table>
								</div>
							</div>


							<div class="panel panel-default">
								<div class="panel-heading">
									<h4>About The Application</h4>
								</div>
								<div class="panel-body">
									<table class="table">
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyApplicationName"
														class="control-label">Application Name</form:label>
													<div>
														<form:input path="thirdPartyApplicationName" type="text"
															class="form-control" id="thirdPartyApplicationName"
															placeholder="Enter thirdPartyApplicationName" />
													</div>
												</div>
											</td>



										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyApplicationDescription">Description or your application</form:label>

													<div>
														<form:textarea path="thirdPartyApplicationDescription"
															type="textarea" class="form-control"
															placeholder="Enter description" />

													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyApplicationDescription">Application Type</form:label>

													<div>
														<form:select path="thirdPartyApplicationType"
															class="form-control">
															<form:option value="1" label="SmartPhone App" />
															<form:option value="2"
																label="Vendor Hosted analytics web portal" />
															<form:option value="3" label="Desktop Application" />
														</form:select>

													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyApplicationDescription">Application Type</form:label>

													<div>

														<table>
															<tr>
																<td><form:checkbox path="thirdPartyApplicationUse"
																		value="1" label="Ad-hoc request and one-off use" /></td>
															</tr>
															<tr>
																<td><form:checkbox path="thirdPartyApplicationUse"
																		value="2"
																		label="Add-hoc request and data stored for further analysis" />
																</td>
															</tr>
															<tr>
																<td><form:checkbox path="thirdPartyApplicationUse"
																		value="4"
																		label="Ongoing requests on schedule basis and data stored for ongoing analysis" />
																</td>
															</tr>
															<tr>
																<td><form:checkbox path="thirdPartyApplicationUse"
																		value="4"
																		label="A subscription request to receive EUI data as per a requested schedule" />
																</td>
															</tr>
															<tr>
																<td>
														</table>

													</div>
												</div>
											</td>

										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="clientId" class="control-label">Client Id
													</form:label>
													<a class="btn" href="#"><i class="icon-star"></i></a>

													<div class="control-group form-inline">
														<form:input path="clientId" type="text"
															class="form-control" id="clientId"
															placeholder="Enter Your Client Id" />

														<button type="button" class="btn btn-default">Another</button>
														<form:errors path="clientId" cssClass="alert"  />

													</div>
												</div>
												<p>This id will be used to as credential for all request
													to our server for getting status, customer usage data etc.</p>

											</td>
										</tr>


										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="tosUri" class="control-label">Provide Web Location of Terms of Services</form:label>
													<div class="control-group form-inline">
														<form:input path="tosUri" type="text" class="form-control"
															id="tosUri" placeholder="Enter Tos URI" />
														<button type="button" class="btn btn-info">Check</button>

													</div>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group ">
													<form:label path="policyUri" class="control-label">Provide Web location of Policy</form:label>
													<div class="control-group form-inline">
														<form:input path="policyUri" type="text"
															class="form-control" id="policyUri"
															placeholder="Enter Policy URI" />
														<button type="button" class="btn btn-info">Check</button>

													</div>
												</div>
											</td>
										</tr>
									</table>
								</div>
							</div>

							<div class="panel panel-default">
								<div class="panel-heading">
									<h4>Application Technical Detail</h4>
								</div>
								<div class="panel-body">
									<table class="table">



										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyScopeSelectionScreenURI"
														class="control-label">Scope Selection ScreenURI</form:label>
													<div class="control-group  form-inline">

														<form:input path="thirdPartyScopeSelectionScreenURI"
															type="text" class="form-control"
															id="thirdPartyScopeSelectionScreenURI"
															placeholder="Enter ScopeSelectionScreenURI" />

														<button type="button" class="btn btn-info">Check</button>

													</div>


													<p>URI for selection of scope for authroring usage
														data. e.g.
														https://localhost:8090/ThirdParty/RetailCustomer/ScopeSelection</p>
												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyUserPortalScreenURI"
														class="control-label">Application User Home Page</form:label>
													<div class="control-group form-inline">
														<form:input path="thirdPartyUserPortalScreenURI"
															type="text" class="form-control"
															id="thirdPartyUserPortalScreenURI"
															placeholder="Enter UserPortalScreenURI" />
														<button type="button" class="btn btn-info">Check</button>
													</div>
													<p>Home page of third party application.</p>

												</div>
											</td>
										</tr>
										<tr>
											<td style="border: none !important">
												<div class="control-group">
													<form:label path="thirdPartyNotifyUri"
														class="control-label">NotifyUri</form:label>
													<div class="control-group form-inline">
														<form:input path="thirdPartyNotifyUri" type="text"
															class="form-control" id="thirdPartyNotifyUri"
															placeholder="Enter NotifyUri" />
														<button type="button" class="btn btn-info">Check</button>

													</div>

													<p>URI for notification of asynchronous data transfer.
														e.g.
														https://localhost:8090/ThirdParty/espi/1_1/Notification</p>
												</div>
											</td>
										</tr>

									</table>
								</div>
							</div>

							<p>
								<input type="submit" name="create" class="btn btn-primary"
									value="Submit" />
								<button type="reset" class="btn btn-default">Clear</button>
							</p>
						</form:form>
					</div>
				</section>

			</div>
		</div>
		<jsp:include page="../tiles/footer.jsp" />

	</div>
</body>
</html>
