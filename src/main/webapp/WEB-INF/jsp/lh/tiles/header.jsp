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
<script>
function myFunction() {
	$("nav").toggleClass("in");
}
</script>

<header id="header">
	<div class="lh-panel">
		<div class="holder">
			<ul>
				<li class="mobile"><a href="http://www.festivalhydro.com/site">Back
						to home</a></li>
				<li><a href="http://www.festivalhydro.com/site/#!/contact_us" target="_new">Contact
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
				<a href="http://www.festivalhydro.com/site">London Hydro</a>
			</h1>	
				<c:if test="${currentCustomer!=null}">		
		<button class="navbar-toggle collapsed" type="button" data-toggle="collapse" data-target="#bs-navbar" onclick="myFunction()"> 
		<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> 
		</button>
		</c:if>
		</div>	
		<c:if test="${currentCustomer!=null}">
		<nav id="bs-navbar" class="navbar-collapse collapse"> 
		<ul class="nav navbar-nav"> 
		<security:authorize access="isAuthenticated()">
							<li class="${menu=='home'?'active':''}"><a id="menuconectMyData" class="icon-home"
								href="<c:url value='/RetailCustomer/${currentCustomer.id}/home'/>">
									Home </a></li>
							<li class="${menu=='cmd'?'active':''}"><a id="menuconectMyData" class="icon-cmd" 
								href="<c:url value='/RetailCustomer/${currentCustomer.id}/cmd'/>">
									Connect<br /> My Data
							</a></li>
							<li class="${menu=='dmd'?'active':''}"><a id="menudownloadMyData" class="icon-dmd"
								href="<c:url value='/RetailCustomer/${currentCustomer.id}/dmd'/>">
									Download<br /> My Data
							</a></li>
							<li class="${menu=='feedback'?'active':''}" style="display: none;"><a id="menudownloadMyData" class="icon-feedback"
								href="<c:url value='/RetailCustomer/${currentCustomer.id}/feedback'/>">
									Your Feedback </a></li>
		</security:authorize>
		 </ul>		   
		 </nav>	
		 </c:if>	 
		 
		  </div>


		</div>
	
</header>