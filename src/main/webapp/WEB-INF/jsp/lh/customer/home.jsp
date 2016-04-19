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

<jsp:include page="../tiles/head.jsp" />
<c:set var="menu" scope="session" value="home" />
<body onload="initOpenCloseFooter()">
	<div id="wrapper">
		<jsp:include page="../tiles/header.jsp" />

		<div id="main">
			<div class="container">
				<jsp:include page="../tiles/customer/leftmenu.jsp" />
				<div class="content">
					<section class="content-container">
						<div class="balance-section">
							<article class="post-box">
								<div class="text-container">
									<div data-ng-bind-html-unsafe="content.body" class="ng-binding"
										srckey="educateme">
										<!--

<img alt="educateme" width="100%" src="https://www.londonhydro.com/site/binaries/content/gallery/londonhydrohippo/corporate/residential/landing-page/educateme.png">
<p>&nbsp;</p>

<p>&nbsp;</p>
<h1>What is Green Button Connect My Data? </h1>
<p>Green Button Connect My Data is a new feature that is being adopted by
utilities across North America. By using your smart meter, the Green Button
Connect My Data feature lets you access and share your electricity information
securely with apps or websites that can provide you with more interesting ways
to understand your electricity consumption and provide you with interactive ways
to manage it.</p>
<br/>
<h1>What is Green Button Download My Data? </h1>
<p>Green Button Download My Data allows you to download your energy data
securely in a variety of computer-friendly formats including excel and csv
spreadsheets. Your energy is available in hourly, daily, weekly, and monthly
increments, or coincides with your billing cycle when meter readings are
scheduled. Your information may be securely downloaded within your MyLondonHydro
online account portal at any time.
</p>
<p>Using the Green Button Connect My Data feature ensures that "The customer is
always in charge!" Yes, that means <u>you</u> the customer, can decide when and
with whom you share your information and for how long. You can decide at any
point in time that you do not want to participate with an application and can
stop sharing your information with that application at that time.</p>
<br/>
<h2>Join Our Pilot </h2>
<p>We are piloting the Green Button Connect My Data feature within your
MyLondonHydro online account portal, which will now allow you to authorize and
share your energy use information securely with applications (apps) of your
choice that are specially designed for residential or business use. To get
started you will need to have access to your MyLondonHydro online account portal
to enable the transfer of your energy use data to the third party app. Once you
give your consent to the app(s), you can get your information from London Hydro
and provide valuable insights, feedback and in some cases, even reward points,
that will help you better understand your electricity consumption and manage
your bills.</p>

<p>All of these solutions are&nbsp;<strong>FREE</strong> for the entire duration of
the pilot. Sign up for MyLondonHydro if you are interested in
participating.<a href="https://www.londonhydro.com/site/#!/residential/content?page=let-me-participate"><strong>Learn
more...</strong></a></p>

<p>&nbsp;</p>
<h2>What are the benefits?&nbsp; </h2>
<p>Green Button Connect My Data allows you to better understand, manage and
ultimately conserve your electricity. By using these innovative and interactive
solutions, you will be able, for example, to see your energy consumption on a
more regular basis, compare yourself to benchmarks, set your own conservation
goals or even enter electricity conservation contests.</p>

<p>&nbsp;</p>
<h2>Follow us on Twitter&nbsp; </h2>
<p>
<a href="@londonhydro"><img alt="twitter" width="10%" src="https://www.londonhydro.com/site/binaries/content/gallery/londonhydrohippo/corporate/residential/landing-page/twitterapp.png">
</a></p>

<p>We now have a Twitter account and will send you weekly tweets updating you on
the Green Button pilot. Additionally, you can monitor all of your app activities
on our Green Button micro-site, located within your MyLondonHydro online account
portal.&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

<p>&nbsp;</p>

-->
									</div>
								</div>
							</article>

						</div>
					</section>
				</div>

			</div>
		</div>
		<jsp:include page="../tiles/footer.jsp" />
	</div>
</body>
</html>