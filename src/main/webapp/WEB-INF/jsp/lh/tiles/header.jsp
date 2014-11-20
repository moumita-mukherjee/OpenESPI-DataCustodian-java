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

<header id="header">
	<div class="lh-panel">
		<div class="holder">
			<ul>
				<li class="mobile"><a href="https://www.londonhydro.com/site">Back
						to home</a></li>
				<li><a href="https://www.londonhydro.com/site/#!/contact_us">Contact
						Us</a></li>
				<security:authorize access="isAuthenticated()">
					<li class="alt"><a id="logout" class="my-london-hydro"
						href="<c:url value='/logout.do'/>">Logout</a></li>
				</security:authorize>
				<security:authorize access="isAnonymous()">
					<li class="active alt"><a id="login" class="my-london-hydro"
						href="<c:url value='/login'/>">Login</a></li>
				</security:authorize>
			</ul>
		</div>
	</div>
	<div data-alert-bar alertmessage="ErrorService.errorMessage"></div>
	<div data-success-bar alertmessage="ErrorService.successMessage"></div>
	<div class="section">
		<div class="holder " data-ng-controller="SearchController">
			<h1 class="logo">
				<a href="/site/myaccount/..">London Hydro</a>
			</h1>




		</div>
	</div>
</header>