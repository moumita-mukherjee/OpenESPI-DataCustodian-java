<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security"
	uri="http://www.springframework.org/security/tags"%>
<security:authorize access="isAuthenticated()">
	<aside id="slide-menu" class="sidebar">
		<div class="section" data-accordionBind="side-nav">
			<div class="slide-menu active">
				<div class="slide">


					<ul  class="list" style="width:100%;border-bottom:1px solid #cbcbcb;">
						<li>Welcome:</li>
						<li id="user-name">
							<div class="name ng-binding"><c:out value="${currentUser.firstName} ${currentUser.lastName}" /></div>
						</li>
						

					</ul>
					
					<c:if test="${currentCustomer!=null}">
					<nav class="ng-scope">
						<ul class="menu">
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
							<li class="${menu=='feedback'?'active':''}"><a id="menudownloadMyData" class="icon-feedback"
								href="<c:url value='/RetailCustomer/${currentCustomer.id}/feedback'/>">
									Your Feedback </a></li>

						</ul>
					</nav>
					</c:if>
				</div>
			</div>
		</div>

	</aside>
</security:authorize>
