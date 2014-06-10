/*
 * Copyright 2013, 2014 EnergyOS.org
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

package org.energyos.espi.datacustodian.web.api;

import java.io.IOException;
import java.security.Principal;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.stream.StreamResult;

import org.energyos.espi.common.domain.AuthorizationStatus;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.User;
import org.energyos.espi.common.service.AuthorizationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun.syndication.io.FeedException;

@Controller
public class AuthorizationStatusRESTController {



	@Autowired
	AuthorizationService authorizationService;

	
	public void setAuthorizationService(AuthorizationService authorizationService) {
		this.authorizationService = authorizationService;
	}

	@Autowired
	@Qualifier("fragmentMarshaller")
	private Jaxb2Marshaller fragmentMarshaller;

	// ROOT RESTful Forms
	//
	public void setFragmentMarshaller(Jaxb2Marshaller fragmentMarshaller) {
		this.fragmentMarshaller = fragmentMarshaller;
	}

	@RequestMapping(value = Routes.ROOT_AUTHORIZATION_STATUS, method = RequestMethod.GET, produces = "application/atom+xml")
	@ResponseBody
	public void index(HttpServletResponse response,
			@RequestParam Map<String, String> params, Principal principal)
			throws IOException, FeedException {
		try {
			

			System.out.println("params " + params);
			System.out.println("principal " + principal);
			if (principal instanceof OAuth2Authentication) {
				OAuth2Authentication oAuth2Authentication = (OAuth2Authentication) principal;
				

				System.out.println("DTTTTTTTTTTTT "+((User)oAuth2Authentication.getPrincipal()).getId());
				
				System.out.println("DTTTTTTTTTTTT "+oAuth2Authentication.getOAuth2Request().getResourceIds());
				System.out.println("DTTTTTTTTTTTT "+oAuth2Authentication.getOAuth2Request().getRequestParameters());

				System.out.println("DTTTTTTTTTTTT "+oAuth2Authentication.getOAuth2Request().getClientId());

				System.out.println("DTTTTTTTTTTTT "+oAuth2Authentication.getOAuth2Request().getResourceIds());

				System.out.println("DTTTTTTTTTTTT "+oAuth2Authentication.getOAuth2Request().getExtensions());
				
				//authorizationService.findByAccessToken(refreshToken)
				AuthorizationStatus as = new AuthorizationStatus();
				
				StreamResult result = new StreamResult(response.getOutputStream());

				fragmentMarshaller.marshal(as, result);
				
			} else {
				response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			}


		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

}
