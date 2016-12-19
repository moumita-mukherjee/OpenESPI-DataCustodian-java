/*
 * Copyright 2013 EnergyOS.org
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package org.energyos.espi.datacustodian.web;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.energyos.espi.common.domain.Routes;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(Routes.LOGIN)
public class LoginController {


	private String loginEndPoint="/site/#!/login";
	private Properties reverseMap = new Properties();
	
    @RequestMapping(method = RequestMethod.GET)
    public String index(HttpServletRequest request,HttpServletResponse response) {
    	
    	reverseMap.put("https://londonhydro-espi-dev.appspot.com","https://dev.londonhydro.com/greenbutton");
    	System.err.println(" :::: Request Object postLoginURL :::: "+request.getSession().getAttribute("postLoginURL"));
    	try {
    		String postLoginURL =(String)request.getSession().getAttribute("postLoginURL");
    		if(postLoginURL!=null) {
    			postLoginURL=reverseMap(postLoginURL,reverseMap);
    			String redirectURI = loginEndPoint+(loginEndPoint.indexOf("?")>0? "&":"?")+"r=" + java.net.URLEncoder.encode(postLoginURL,"UTF-8");
    			response.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
    			response.setHeader("Location", redirectURI); 
    		}
        } catch (UnsupportedEncodingException ignore) {
        }
        return "/login";
    } 
    private String reverseMap(String url,Properties reverseMap) {
    	for(Object key: reverseMap.keySet()) {
    		url=url.replaceAll((String)key, reverseMap.getProperty((String)key));
    	}
    	return url;
    }
}