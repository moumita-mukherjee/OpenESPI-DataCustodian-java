<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
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
			<div class="panel">
				<div class="holder">
					<ul>
						<li class="mobile"><a href="#">Back to home</a></li>
						<li><a href="/site/myaccount/../#/contact_us">Contact Us</a></li>
						<security:authorize access="isAuthenticated()">
                        <li class="alt"><a id="logout" class="my-london-hydro" href="<c:url value='/logout.do'/>">Logout</a></li>
                    </security:authorize>
<security:authorize access="isAnonymous()">
                        <li class="active alt"><a id="login" class="my-london-hydro" href="<c:url value='/login?formorigin=greenButton'/>">Login</a></li>
                    </security:authorize>
					</ul>
				</div>
			</div>
			<div data-alert-bar alertmessage="ErrorService.errorMessage"></div>
			<div data-success-bar alertmessage="ErrorService.successMessage"></div>
			<div class="section">
				<div class="holder" data-ng-controller="SearchController">
					<h1 class="logo"><a href="/site/myaccount/..">London Hydro</a></h1>
					<a href="/site/myaccount/.." class="back">&lt; Back to home</a>
					<a href="#" class="btn-menu">menu</a>
					<form class="search-form"  data-ng-submit="search();">
						<fieldset>
							<legend class="hide">search form</legend>
							<input type="text" placeholder="How can we help you today?" title="How can we help you today?" data-ng-model="searchKey" />
							<input type="submit" value="submit" />
						</fieldset>
					</form>
				</div>
			</div>
		</header>

<!--<div class="navbar navbar-inverse ">
    <div class="navbar-inner">
        <div class="container">
            <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="brand" href="<c:url value='/home'/>"><img src="<c:url value='/resources/ico/favicon.png'/>" width="20"/>&nbsp;Data Custodian</a>
           
            <div class="nav-collapse collapse">
                <ul class="nav">
                    <security:authorize access="isAuthenticated()">
                        <li class="active"><a id="logout" href="<c:url value='/logout.do'/>">Logout</a></li>
                        <li><a id="profile" href="">Welcome: ${currentCustomer.firstName} ${currentCustomer.lastName}</a></li>                        
                    </security:authorize>
                    <security:authorize access="isAnonymous()">
                        <li class="active"><a id="login" href="<c:url value='/login'/>">Login</a></li>
                    </security:authorize>
                </ul>
            </div>
        </div>
    </div>
</div>-->

<aside id="slide-menu" class="sidebar" >
<nav class="ng-scope">
	<ul class="menu" >
		<li><a href="<c:url value='/custodian/home'/>" class="ico5">Data Custodian Home</a></li>
		<security:authorize access="isAuthenticated()"> 
		<li><a id="logout" href="<c:url value='/logout.do'/>" class="ico5">Logout</a></li>
                <li><a id="profile" href="" class="ico5">Welcome: ${currentCustomer.firstName} ${currentCustomer.lastName}</a></li>
		</security:authorize>
                <security:authorize access="isAnonymous()">
                <li><a id="login" href="<c:url value='/login'/>" class="ico5">Login</a></li>
                </security:authorize>
	</ul>
</nav>
</aside>
