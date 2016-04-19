<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<head>
    <meta charset="utf-8">
    <title>FestivalHydro</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <script type="text/javascript">
    	apiBaseUrl = "${apiBaseUrl}";
    	cmsSection = "${cmsSection}";
    	siteBaseUrl = "${corporateBaseUrl}";
    </script>

			
	<!-- Latest compiled and minified CSS -->	                      
	<link href="<c:url value='/resources/css/bootstrap/3.1.1/bootstrap.min.css' />" rel="stylesheet" type="text/css"/>
	<!-- Optional theme -->
	<link href="<c:url value='/resources/css/bootstrap/3.1.1/bootstrap-theme.min.css' />" rel="stylesheet" type="text/css"/>
    <link href="<c:url value='/resources/css/application.css?v=${buildVersion}' />" rel="stylesheet" type="text/css"/>
    <link href="<c:url value='/resources/css/eternicode/datepicker3.css?v=${buildVersion}' />" rel="stylesheet" type="text/css"/>
    <link href="<c:url value='/resources/css/myaccount/fancybox.css?v=${buildVersion}' />" rel="stylesheet" type="text/css"/>
    <link href="<c:url value='/resources/css/myaccount/overlays.css?v=${buildVersion}' />" rel="stylesheet" type="text/css"/>    
  	
  	
  	<!-- Added for footer -->
  	<link href="<c:url value='/resources/css/footer.css?v=${buildVersion}' />" rel="stylesheet" type="text/css"/>

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
    <script src="<c:url value='/resources/js/html5shiv.js'/>"></script>
    <![endif]-->

	<!-- Latest compiled and minified JavaScript -->	
	<script src="<c:url value='/resources/js/bootstrap/3.1.1/bootstrap.min.js'/>"></script>
	
	
    <script src="<c:url value='/resources/js/jquery.min.js'/>"></script>
    
    <!--  For footer accordion in the menu -->
	<script src="<c:url value='/resources/js/jquery.main.js?v=${buildVersion}'/>"></script>
     
    <script src="/resources/js/eternicode/bootstrap-datepicker.js"></script>
    
    <!--  US DatePicker calendar 
    <script src="<c:url value='/resources/js/bootstrap-datetimepicker.pt-US.js'/>"></script>
    -->
    <script src="<c:url value='/resources/js/application.js?v=${buildVersion}'/>"></script>
    <script src="<c:url value='/resources/js/rating.js?v=${buildVersion}'/>"></script>
    
	<script src="<c:url value='/resources/js/bootstrap-tooltip.js'/>"></script>
	<script src="<c:url value='/resources/js/bootstrap-confirmation.js'/>"></script>
	<script src="<c:url value='/resources/js/bootstrap-dropdown.js'/>"></script>
	<script src="<c:url value='/resources/js/bootstrap-tab.js'/>"></script>
	<script src="<c:url value='/resources/js/bootstrap-modal.js'/>"></script>

	<script src="<c:url value='/resources/js/bootstrap-rating-input.min.js'/>"></script>
	

    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="<c:url value='/resources/ico/apple-touch-icon-144-precomposed.png'/>">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="<c:url value='/resources/ico/apple-touch-icon-114-precomposed.png'/>">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="<c:url value='/resources/ico/apple-touch-icon-72-precomposed.png'/>">
    <link rel="apple-touch-icon-precomposed" href="<c:url value='/resources/ico/apple-touch-icon-57-precomposed.png'/>">
    <link rel="shortcut icon" href="<c:url value='/resources/ico/favicon.png'/>">
    
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/jquery.xml2json.js'/>"></script>    
    <!--[if lte IE 8]><script language="javascript" type="text/javascriptsrc="<c:url value='/resources/js/charting/excanvas.min.js'/>"></script><![endif]-->
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.resize.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.time.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.stack.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.categories.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.axislabels.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.tooltip.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.animator.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.growing.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.crosshair.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.selection.js'/>"></script>
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/charting/jquery.flot.navigate.js'/>"></script>
	
	
		
	<script language="javascript" type="text/javascript" src="<c:url value='/resources/js/jquery.xml2json.js'/>"></script>

</head>
