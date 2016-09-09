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

package org.energyos.espi.datacustodian.web;

import java.security.Principal;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class DefaultController extends BaseController {

	@RequestMapping(Routes.DEFAULT)
	public String defaultAfterLogin(HttpServletRequest request,
			Principal principal) {

			try {
			if (request.isUserInRole(User.ROLE_CUSTODIAN)) {
				return "redirect:/custodian/home";
			} else if (request.isUserInRole(User.ROLE_USER)) {
				if (currentCustomer(principal) == null) {
					return "/customer/nongbhome";
				}

				return "redirect:/RetailCustomer/"
						+ currentCustomer(principal).getId() + "/home";
			}
		} catch (Exception ignore) {		
			return "redirect:/login";
		}
		return "redirect:/home";

	}
	@RequestMapping(value = "/dmd", method = RequestMethod.GET)
	public String downloadMyDatawithToken(HttpServletRequest request,Principal principal) {
		
		if (request.isUserInRole(User.ROLE_USER)) {
			if (currentCustomer(principal) == null) {
				return "/customer/nongbhome";
			}

			return "redirect:/RetailCustomer/"
					+ currentCustomer(principal).getId() + "/dmd";
		}
		return "redirect:"+request.getContextPath()+"/site/#!/login";
		
	}
	@RequestMapping(value = "/cmd", method = RequestMethod.GET)
	public String connectMyDatawithToken(HttpServletRequest request,Principal principal) {
		
		if (request.isUserInRole(User.ROLE_USER)) {
			if (currentCustomer(principal) == null) {
				return "/customer/nongbhome";
			}

			return "redirect:/RetailCustomer/"
					+ currentCustomer(principal).getId() + "/cmd";
		}
		return "redirect:https://dev.londonhydro.com/site/#!/login";
		
	}
}