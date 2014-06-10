/*
 * Copyright 2006-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */
package org.energyos.espi.datacustodian.oauth;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.energyos.espi.common.domain.ApplicationInformation;
import org.energyos.espi.common.domain.ApplicationInformationScope;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.repositories.UsagePointDetailRepository;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.datacustodian.utils.UsagePointHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.oauth2.common.util.OAuth2Utils;
import org.springframework.security.oauth2.provider.AuthorizationRequest;
import org.springframework.security.oauth2.provider.ClientDetails;
import org.springframework.security.oauth2.provider.ClientDetailsService;
import org.springframework.security.oauth2.provider.approval.Approval;
import org.springframework.security.oauth2.provider.approval.Approval.ApprovalStatus;
import org.springframework.security.oauth2.provider.approval.ApprovalStore;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

/**
 * Controller for retrieving the model for and displaying the confirmation page
 * for access to a protected resource.
 * 
 * @author Ryan Heaton
 */
@Controller
@SessionAttributes("authorizationRequest")
public class AccessConfirmationController extends BaseController {

	@Autowired
	private ApplicationInformationService applicationInformationService;

	public void setApplicationInformationService(
			ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}

	@Autowired
	private UsagePointDetailRepository usagePointDetailRepository;

	public void setUsagePointDetailRepository(
			UsagePointDetailRepository usagePointDetailRepository) {
		this.usagePointDetailRepository = usagePointDetailRepository;
	}

	private ClientDetailsService clientDetailsService;

	private ApprovalStore approvalStore; // Spring Security OAuth2 2.0.0.M2
											// change

	@Autowired
	private UsagePointService usagePointService;

	public void setUsagePointService(UsagePointService usagePointService) {
		this.usagePointService = usagePointService;
	}

	@ModelAttribute
	public List<UsagePoint> usagePoints(Principal principal) {
		return usagePointService
				.findAllByRetailCustomer(currentCustomer(principal));
	}

	@RequestMapping(value = "oauth/confirm_access_continue", method = RequestMethod.POST)
	public ModelAndView getAccessConfirmationContinue(
			@RequestParam("usage_point") Long usagePointId,
			Map<String, Object> model, Principal principal) throws Exception {

		if (usagePointId >= 0) {
			model.put("usage_point", usagePointId);
		}
		return new ModelAndView("redirect:/oauth/confirm_access", model);
	}

	private List<UsagePoint> populateExternalDetail(String customerId,
			List<UsagePoint> usagePoints) {
		try {
			UsagePointHelper.populateExternalDetail(usagePoints,
					usagePointDetailRepository
							.findAllByRetailCustomerId(customerId));
		} catch (EmptyResultDataAccessException ignore) {

		}
		return usagePoints;
	}

	@RequestMapping(value = "/accessconfirm/setdate", method = RequestMethod.POST)
	public ModelAndView getAccessConfirmation1(
			@ModelAttribute("usage_point") Long usagePointId,
			@ModelAttribute("authorizationEndDate") String authorizationEndDate,
			Map<String, Object> model, Principal principal) throws Exception {
		System.out
				.println("POST  authorizationEndDate authorizationEndDate authorizationEndDate "
						+ usagePointId);

		System.out
				.println("POST  authorizationEndDate authorizationEndDate authorizationEndDate "
						+ authorizationEndDate);
		return getAccessConfirmation(usagePointId, model, principal);
	}

	@RequestMapping("/oauth/confirm_access")
	public ModelAndView getAccessConfirmation(
			@RequestParam(value = "usage_point", required = false) Long usagePointId,
			Map<String, Object> model, Principal principal) throws Exception {

		try {
		System.err
				.println(" authorizationEndDate authorizationEndDate authorizationEndDate "
						+ model.get("authorizationEndDate"));

		AuthorizationRequest clientAuth = (AuthorizationRequest) model
				.get("authorizationRequest");

		ClientDetails client = clientDetailsService
				.loadClientByClientId(clientAuth.getClientId());

		ApplicationInformation thirdParty = applicationInformationService
				.findByClientId(clientAuth.getClientId());

		ApplicationInformation datacustodian = applicationInformationService
				.findById(1l);
		model.put("auth_request", clientAuth);
		model.put("client", client);
		model.put("thirdParty", thirdParty);

		Map<String, String> scopes = new LinkedHashMap<String, String>();
		List<ApplicationInformationScope> scopeForApproval = new ArrayList<ApplicationInformationScope>();
		System.err.println("clientAuth.getScope() "+clientAuth.getScope());
		for (String scope : clientAuth.getScope()) {
			for (ApplicationInformationScope dcscope : datacustodian.getScope()) {
				if (dcscope.getScope().equals(scope)) {
					dcscope.setSelected(false);
					scopeForApproval.add(dcscope);
				}
			}
			scopes.put(OAuth2Utils.SCOPE_PREFIX + scope, "false"); // Spring
																	// Security
																	// OAuth2
																	// 2.0.0.M2
																	// change
		}
		for (Approval approval : approvalStore.getApprovals(
				principal.getName(), client.getClientId())) {
			if (clientAuth.getScope().contains(approval.getScope())) {
				scopes.put(
						OAuth2Utils.SCOPE_PREFIX + approval.getScope(),
						approval.getStatus() == ApprovalStatus.APPROVED ? "true"
								: "false");
			}
			for (ApplicationInformationScope dcscope : scopeForApproval) {
				if (approval.getScope().equals(dcscope.getScope())) {
					dcscope.setSelected(true);
				}
			}
		}
		model.put("scopeForApproval", scopeForApproval);
		model.put("scopes", scopes);
		model.put("scope", scopes.get(0));
		List<UsagePoint> usagePoints = null;
		if (usagePointId != null && usagePointId > 0) {
			// Long usagePointId=(Long)model.get("usage_point");
			UsagePoint up = usagePointService.findById(usagePointId);
			usagePoints = new ArrayList<UsagePoint>(1);
			usagePoints.add(up);
		} else {
			usagePoints = usagePoints(principal);
		}
		populateExternalDetail(currentUser(principal).getCustomerId(),
				usagePoints);

		if (usagePoints.size() == 1
				|| (usagePointId != null && usagePointId == 0)) {
			Date authEndDate=new Date((24*3600*1000*365l+ System.currentTimeMillis()));
			if (usagePointId != null && usagePointId > 0) {
				UsagePoint selectedUsagePoint = usagePoints.get(0);
				model.put("selectedUsagePoint", selectedUsagePoint);
				clientAuth.getExtensions().put("usagepoint",
						selectedUsagePoint.getId());				
			} else {
				model.put("selectedUsagePoints", usagePoints);
				clientAuth.getExtensions().put("usagepoint", 0l);
			}
			if (usagePoints.size() == 1) {
				// model.put("selectedUsagePoint", usagePoints.get(0));
			}
			clientAuth.getExtensions().put("authorizationEndDate",
					authEndDate);
			
			model.put("usagePointId", usagePointId);
			model.put("authorizationEndDate",authEndDate );
			model.remove("authorizationRequest");
			return new ModelAndView("/access_confirmation", model);
		}
		model.put("usagePointList", usagePoints);
		
		return new ModelAndView("/access_confirmation_multi_up", model);
		}catch(Exception ex) {
			ex.printStackTrace(System.err);
		}
		return new ModelAndView("/access_confirmation", model);  
	}

	@RequestMapping("oauth/error")
	public String handleError(Map<String, Object> model) throws Exception {
		// We can add more stuff to the model here for JSP rendering. If the
		// client was a machine then
		// the JSON will already have been rendered.
		model.put("message", "There was a problem with the OAuth2 protocol");
		System.err.println("There was a problem with the OAuth2 protocol");
		return "oauth_error";
	}

	public void setClientDetailsService(
			ClientDetailsService clientDetailsService) {
		this.clientDetailsService = clientDetailsService;
	}

	public void setApprovalStore(ApprovalStore approvalStore) {
		this.approvalStore = approvalStore;
	}

}
