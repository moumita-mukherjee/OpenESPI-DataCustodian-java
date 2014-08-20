$(function() {

	$(document).ready(function(){    	
		$('#authorizations > tbody  > tr').each(function() { 
    		var content = $(this), appId = content.attr("app_id");
    		var loginId =  content.attr("current_login_id");
	    	$.ajax({
	    		url: apiBaseUrl + "/api/v1/public/"+loginId+"/rating?appId="+appId,
			    type: 'GET',
			    crossDomain: true,
			    dataType: 'json',
			    headers: {"authorization" : "bearer -dt01"},
			    success: function(data) {
			    	$('#ratingValue').val(data);
			    }
			});
    	});
    	
    });

    $(".rating-input").on("click", function() {
    	var content = $(this), appId = content.attr("app_id");
    	var type = content.attr("app_type");
    	if(type)
    		return;
    	var rating =content.find("#ratingValue").val();
    	var loginId =  content.attr("current_login_id");
    	$.ajax({
		    url: apiBaseUrl + "/api/v1/public/"+loginId+"/rating?appId="+appId+"&rating="+rating,
		    type: 'POST',
		    crossDomain: true,
		    dataType: 'json',
		    headers: {"authorization" : "bearer -dt01"},
		    success: function(data) {}
		});
    	 
    });
    
    $(".comments-input").each(function() {
    	var content = $(this);
    	content.find("#commentsLink").on("click", function(e) {
    		content.find(".commentBox").show();
    		content.find("#commentsHideLink").show();
    		content.find("#commentsLink").hide();
   	 });
    	content.find("#commentsHideLink").on("click", function(e) {
    		content.find(".commentBox").hide();
    		content.find("#commentsHideLink").hide();
    		content.find("#commentsLink").show();
   	 });
    	 content.find("#saveComment").on("click", function(e) {
    		   
 	    	var  appId =  $(this).attr("app_id");
 	    	var comment =content.find("#comments").val();
 	    	var loginId =   $(this).attr("current_login_id");
 	    	$.ajax({
 			    url: apiBaseUrl + "/api/v1/public/"+loginId+"/comment?appId="+appId+"&comment="+comment,
 			    type: 'POST',
 			    crossDomain: true,
 			    dataType: 'json',
 			    headers: {"authorization" : "bearer -dt01"},
 			    success: function(data) {}
 			});
 	    	content.find(".commentBox").hide();
    		content.find("#commentsHideLink").hide();
    		content.find("#commentsLink").show();
       	 });
   });
    
    
    
    $(".commentsSection").each(function() {
		var content = $(this);
      	 content.find("#viewComments").on("click", function(e) {
   
	    	var  appId = content.attr("app_id");

	    	$.ajax({
			    url: apiBaseUrl + "/api/v1/public/comments?appId="+appId,
			    type: 'GET',
			    crossDomain: true,
			    dataType: 'json',
			    headers: {"authorization" : "bearer -dt01"},
			    success: function(data) {
			    	if(data){
			    		var innerHTML ='<ul>';
			    		$.each( data, function( index, value ){
			    		   innerHTML = innerHTML + "<li>" + value+"</li>";
			    		});
			    		innerHTML = innerHTML +"</ul>";
			    		content.find("#allComments")
			    		  .html(innerHTML);
			    	}
			    }
			});
	    	content.find("#allComments").show();
	    	content.find("#viewComments").hide();
	    	content.find("#hideComments").show();
      	 });
      	content.find("#hideComments").on("click", function(e) {
      		content.find("#allComments").hide();
	    	content.find("#viewComments").show();
	    	content.find("#hideComments").hide();
      	 });
    });
    
    
});