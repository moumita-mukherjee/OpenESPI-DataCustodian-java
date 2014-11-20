$(function() {
	unwrapHtml=function (html) {
		return html.replace("<html>", "").replace("</html>","").replace("<body>", "").replace("</body>", "")
	};
	filterPage=function (data, query) {
		if (data.body)
			return data.body;
		for (var p in data) {
			if (data[p].name == query)
				return data[p].body;
		}
		return "";
	};
    $(".navbar button.btn-navbar").on("click", function() {
        var $nav = $(".nav-collapse");
        if($nav.hasClass("in")) {
            $nav.css("height", "0px").removeClass("in");
        } else {
            $nav.css("height", "auto").addClass("in");
        }
    });
    $(document).ready(function(){
    	if (typeof CmsCache == 'undefined')
    		CmsCache = {};
    	$("*[srckey]").each(function() { 
    		var content = $(this), srckey = content.attr("srckey");
    		if (CmsCache[srckey])
    		{
	    		content.html(filterPage(CmsCache[srcKey], srckey));
	    		content.find("img[src]").each(function(){
	    			var img = $(this), src = img.attr("src");
	    			if (!/^(http|https)/.test(src))
	    				img.attr("src", siteBaseUrl + src)		    				
	    		});
	    		content.find("a[href]").each(function(){
	    			var a = $(this), href = a.attr("href");
	    			if (!/^(http|https)/.test(href))
	    				a.attr("href", siteBaseUrl + href)		    				
	    		});
    		}
    		else
    		{
		    	$.ajax({
				    url: apiBaseUrl + "/api/v1/content/staticpage?field=name&query=" + srckey + "&section="+cmsSection,
				    type: 'GET',
				    crossDomain: true,
				    dataType: 'json',
				    headers: {"authorization" : "bearer -dt01"},
				    success: function(data) {
				    	CmsCache[srckey] = data;
			    		content.html(filterPage(data, srckey));
			    		content.find("img[src]").each(function(){
			    			var img = $(this), src = img.attr("src");
			    			if (!/^(http|https)/.test(src))
			    				img.attr("src", siteBaseUrl + src)		    				
			    		});
			    		content.find("a[href]").each(function(){
			    			var a = $(this), href = a.attr("href");
			    			if (!/^(http|https)/.test(href))
			    				a.attr("href", siteBaseUrl + href)		    				
			    		});
				    }
				});
    		}
    	});
    	
    });
});