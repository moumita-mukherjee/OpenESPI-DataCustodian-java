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

package org.energyos.espi.datacustodian.web.customer;

import static org.energyos.espi.datacustodian.utils.URLHelper.newScopeParams;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.energyos.espi.common.domain.ApplicationInformation;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.repositories.UsagePointDetailRepository;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.datacustodian.utils.UsagePointHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ScopeSelectionController extends BaseController {

	@Autowired
	private ApplicationInformationService applicationInformationService;

	@Autowired
	private UsagePointService usagePointService;

	@Autowired
	private UsagePointDetailRepository usagePointDetailRepository;

	@ModelAttribute
	public List<UsagePoint> usagePoints(Principal principal) {
		List<UsagePoint> usagePoints = usagePointService.findAllByRetailCustomer(currentCustomer(principal));
		populateExternalDetail(currentUser(principal).getCustomerId(), usagePoints);
		return usagePoints;
	}

	//@Secured("ROLE_USER_X'")
	@RequestMapping(value = Routes.DATA_CUSTODIAN_SCOPE_SELECTION_SCREEN, method = RequestMethod.GET)
	public String scopeSelection(HttpServletRequest request, String[] scopes,
			@RequestParam("ThirdPartyID") String thirdPartyClientId, ModelMap model, Principal principal,
			HttpSession sessionObj) {	
		ApplicationInformation thirdParty = applicationInformationService.findByClientId(thirdPartyClientId);
		List<UsagePoint> usagePoints = usagePoints(principal);

		if (usagePoints.size() == 1) {
			sessionObj.setAttribute("usagePointId", usagePoints.get(0).getId());

			return "redirect:" + thirdParty.getThirdPartyScopeSelectionScreenURI() + "?"
					+ newScopeParams(thirdParty.getScope()) + "&DataCustodianID=" + thirdParty.getDataCustodianId();
		} else {
			model.put("thirdParty", thirdParty);
			model.put("usagePoints", usagePoints);

			return "/customer/cmd/scope_selection";
		}
		
	}

	@RequestMapping(value = Routes.DATA_CUSTODIAN_SCOPE_SELECTION_SCREEN, method = RequestMethod.POST)
	public String scopeSelectionConfirm(HttpServletRequest request, String[] scopes,
			@RequestParam("ThirdPartyID") String thirdPartyClientId, @RequestParam("usage_point") Long usagePointId,
			ModelMap model, Principal principal, HttpSession sessionObj) {
		ApplicationInformation thirdParty = applicationInformationService.findByClientId(thirdPartyClientId);

		System.err.println("usagePointId .." + usagePointId);

		sessionObj.setAttribute("usagePointId", usagePointId);
		return "redirect:" + thirdParty.getThirdPartyScopeSelectionScreenURI() + "?"
				+ newScopeParams(thirdParty.getScope()) + "&DataCustodianID=" + thirdParty.getDataCustodianId();

	}

	private List<UsagePoint> populateExternalDetail(String customerId, List<UsagePoint> usagePoints) {
		try {
			UsagePointHelper.populateExternalDetail(usagePoints,
					usagePointDetailRepository.findAllByRetailCustomerId(customerId));
		} catch (EmptyResultDataAccessException ignore) {

		}
		return usagePoints;
	}

	public void setApplicationInformationService(ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}

	public void setUsagePointService(UsagePointService usagePointService) {
		this.usagePointService = usagePointService;
	}

	public void setUsagePointDetailRepository(UsagePointDetailRepository usagePointDetailRepository) {
		this.usagePointDetailRepository = usagePointDetailRepository;
	}
}