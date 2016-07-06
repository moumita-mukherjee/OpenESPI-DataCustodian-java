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
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.energyos.espi.common.domain.ApplicationInformation;
import org.energyos.espi.common.domain.Authorization;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.repositories.UsagePointDetailRepository;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.common.service.AuthorizationService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.datacustodian.utils.UsagePointHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@PreAuthorize("hasRole('ROLE_USER')")
public class ScopeSelectionController extends BaseController {

    @Autowired
    private ApplicationInformationService applicationInformationService;

    @RequestMapping(value = Routes.DATA_CUSTODIAN_SCOPE_SELECTION_SCREEN, method = RequestMethod.GET)
	public String scopeSelection(HttpServletRequest request, String[] scopes,
			@RequestParam("ThirdPartyID") String thirdPartyClientId, ModelMap model, Principal principal,
			HttpSession sessionObj) {
		ApplicationInformation thirdParty = applicationInformationService.findByClientId(thirdPartyClientId);


		List<UsagePoint> usagePoints = usagePoints(principal);
		
		List<UsagePoint> applicableUsagePoints = new ArrayList<UsagePoint>(4);
		for (int i = usagePoints.size() - 1; i >= 0; i--) {
			if(usagePoints.get(i).isCompatibleWithScope(thirdParty.getScopeArray())) {
				applicableUsagePoints.add(usagePoints.get(i));
			}
		}

		List<Authorization> authorizations = authorizationService.findAllActiveByRetailCustomerId(currentCustomer(
				principal).getId());
		
		
		boolean isAuthorized = false;
		if (authorizations != null && !authorizations.isEmpty()) {
			for (int i = applicableUsagePoints.size() - 1; i >= 0; i--) {
				isAuthorized = false;
				for (int x = authorizations.size() - 1; x >= 0; x--) {
					for (int y = authorizations.get(x).getSubscription().getUsagePoints().size() - 1; y >= 0; y--) {
						if (authorizations.get(x).getApplicationInformation().getId().equals(thirdParty.getId()) && applicableUsagePoints
								.get(i)
								.getServiceCategory()
								.getKind()
								.equals(authorizations.get(x).getSubscription().getUsagePoints().get(y)
										.getServiceCategory().getKind())) {
							applicableUsagePoints.remove(i);
							isAuthorized = true;
							break;

						}
					}
					if (isAuthorized) {
						break;
					}
				}
			}
		}

		if(("DC-APP").equals(thirdParty.getKind()))	{
			//Datacustodian acts as thirdparty sandbox
			model.put("thirdParty", thirdParty);
			model.put("authorization", authorizations);
			model.put("usagePoints", usagePoints);			
			model.put("retailCustomerId",(currentCustomer(principal).getId()));
			return "/customer/authorizedThirdParties/authorization";			
			
		}else if (applicableUsagePoints.size() == 1) {
			sessionObj.setAttribute("usagePointId", applicableUsagePoints.get(0).getId());

			return "redirect:" + thirdParty.getThirdPartyScopeSelectionScreenURI() + "?"
					+ newScopeParams(applicableUsagePoints.get(0).filterCompatibleWithScope(thirdParty.getScopeArray())) + "&DataCustodianID=" + thirdParty.getDataCustodianId();
		} else {
			model.put("thirdParty", thirdParty);
			model.put("usagePoints", applicableUsagePoints);

			return "/customer/cmd/scope_selection";
		}

	}




	public void setApplicationInformationService(ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}

	/* LH customization starts here */
	@Autowired
	private AuthorizationService authorizationService;
	
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
	public void setUsagePointService(UsagePointService usagePointService) {
		this.usagePointService = usagePointService;
	}

	public void setUsagePointDetailRepository(UsagePointDetailRepository usagePointDetailRepository) {
		this.usagePointDetailRepository = usagePointDetailRepository;
	}
	private List<UsagePoint> populateExternalDetail(String customerId, List<UsagePoint> usagePoints) {
		try {
			UsagePointHelper.populateExternalDetail(usagePoints,
					usagePointDetailRepository.findAllByRetailCustomerId(customerId));
		} catch (EmptyResultDataAccessException ignore) {

		}
		return usagePoints;
	}
	@RequestMapping(value = Routes.DATA_CUSTODIAN_SCOPE_SELECTION_SCREEN, method = RequestMethod.POST)
	public String scopeSelectionConfirm(HttpServletRequest request, String[] scopes,
			@RequestParam("ThirdPartyID") String thirdPartyClientId, @RequestParam("usage_point") Long usagePointId,
			ModelMap model, Principal principal, HttpSession sessionObj) {
		ApplicationInformation thirdParty = applicationInformationService.findByClientId(thirdPartyClientId);
		UsagePoint usagePoint=usagePointService.findById(currentCustomer(principal).getId(), usagePointId);

		sessionObj.setAttribute("usagePointId", usagePointId);
		return "redirect:" + thirdParty.getThirdPartyScopeSelectionScreenURI() + "?"
				+ newScopeParams(usagePoint.filterCompatibleWithScope(thirdParty.getScopeArray())) + "&DataCustodianID=" + thirdParty.getDataCustodianId();

	}	
}