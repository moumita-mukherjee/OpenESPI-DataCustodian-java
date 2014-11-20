<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<security:authorize access="isAuthenticated()">
	<aside id="slide-menu" class="sidebar">
		<div class="section" data-accordionBind="side-nav">
			<div class="slide-menu active">
				<h2>
					<a href="javascript:void(0);" class="btnclose-sidenav">GreenButton</a>
				</h2>
				<div class="slide">
					<div class="area">
						<ul class="list">

							<li><a id="profile" href="" class="ico5">Welcome:
									${currentUser.firstName} ${currentUser.lastName}</a></li>

						</ul>
					</div>
					<nav class="ng-scope">
						<ul class="menu">
							<li><a href="<c:url value='/custodian/home'/>" class="ico5">Home</a></li>
							<security:authorize access="isAuthenticated()">
								<li><a href="<c:url value='/custodian/retailcustomers'/>"
									class="ico5">Customer List</a></li>
								<li><a href="<c:url value='/custodian/upload'/>"
									class="ico5">Upload</a></li>
								<li><a href="<c:url value='/custodian/oauth/tokens'/>"
									class="ico5">OAuth Token Management</a></li>
								<li><a href="<c:url value='/espi/1_1/NotifyThirdParty'/>"
									class="ico5">Notify Third Party</a></li>
								<li><a
									href="<c:url value='/custodian/${currentCustomer.id}/ThirdPartyList'/>"
									class="ico5">GreenButton Apps</a></li>
							</security:authorize>
						</ul>
					</nav>
				</div>
			</div>
		</div>

	</aside>
</security:authorize>
