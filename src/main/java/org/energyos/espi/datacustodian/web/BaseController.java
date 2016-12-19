/*
 * Copyright 2013,2014 EnergyOS.org
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




import org.energyos.espi.common.domain.RetailCustomer;
import org.energyos.espi.common.domain.User;
import org.energyos.espi.common.service.RetailCustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;

@Controller
public class BaseController {
    @ModelAttribute("currentCustomer")
    public RetailCustomer currentCustomer(Principal principal) {
    	if(principal==null) {
    		return null;
    	}
    	try {
			User user = (User) ((Authentication) principal).getPrincipal();
			if (user.getRetailCustomer() == null) {
				System.err.println(" :::: User selfLink :::: "+user.getSelfLink());
				user.setRetailCustomer(retailCustomerService.findByLink(user.getSelfLink()));
			}
			System.err.println(" :::: RetailCustomer :::: "+user.getRetailCustomer());
			return user.getRetailCustomer();

		} catch (Exception e) {
			e.printStackTrace(System.err);
			throw new UsernameNotFoundException("User not found") ;  
			//return null;
		}
	}


	/* LH customization starts here */
	@Autowired
	private RetailCustomerService retailCustomerService;

	public void setRetailCustomerService(RetailCustomerService retailCustomerService) {
		this.retailCustomerService = retailCustomerService;
	}
	@ModelAttribute("currentUser")
	public User currentUser(Principal principal) {
		if(principal==null) {
    		return null;
    	}
		try {
			return (User) ((Authentication) principal).getPrincipal();
        	} catch (Exception e) {
        		e.printStackTrace(System.err);
    			throw   new UsernameNotFoundException("User not found") ;  
			//return null;
		}
	}
}
