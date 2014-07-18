package org.energyos.espi.datacustodian.web.custodian;

import org.energyos.espi.common.domain.ApplicationInformation;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.datacustodian.utils.URLHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@PreAuthorize("hasRole('ROLE_CUSTODIAN')")
public class CustodianThirdPartyController extends BaseController {

	@Autowired
	private ApplicationInformationService applicationInformationService;

	@RequestMapping(value = Routes.THIRD_PARTY_LIST_CUSTODIAN, method = RequestMethod.GET)
	public String index(ModelMap model) {
		model.put("applicationInformationList",
				applicationInformationService.findAll());
		return "/custodian/thirdparties/index";
	}

	@RequestMapping(value = Routes.THIRD_PARTY_AUTHORIZE, method = RequestMethod.GET)
	public String authorizeThridParty(@PathVariable Long thirdPartyId,
			ModelMap model) {

		applicationInformationService.updateAuthroizeStatus(thirdPartyId, true);

		model.put("applicationInformationList",
				applicationInformationService.findAll());
		return "/custodian/thirdparties/index";
	}

	@RequestMapping(value = Routes.THIRD_PARTY_SHOW, method = RequestMethod.GET)
	public String showThridParty(@PathVariable Long thirdPartyId, ModelMap model) {

		applicationInformationService
				.updateAuthroizeStatus(thirdPartyId, false);

		model.put("appInformation",
				applicationInformationService.findById(thirdPartyId));
		return "/custodian/thirdparties/show";
	}

	@RequestMapping(value = Routes.THIRD_PARTY_UNAUTHORIZE, method = RequestMethod.GET)
	public String unAuthorizeThridParty(@PathVariable Long thirdPartyId,
			ModelMap model) {

		applicationInformationService
				.updateAuthroizeStatus(thirdPartyId, false);

		model.put("applicationInformationList",
				applicationInformationService.findAll());
		return "/custodian/thirdparties/index";
	}

	@RequestMapping(value = Routes.THIRD_PARTY_LIST_CUSTODIAN, method = RequestMethod.POST)
	public String selectThirdParty(
			@RequestParam("Third_party") Long thirdPartyId,
			@RequestParam("Third_party_URL") String thirdPartyURL) {
		ApplicationInformation applicationInformation = applicationInformationService
				.findById(thirdPartyId);
		return "redirect:" + thirdPartyURL + "?"
				+ URLHelper.newScopeParams(applicationInformation.getScope())
				+ "&DataCustodianID="
				+ applicationInformation.getDataCustodianId();
	}

	public void setApplicationInformationService(
			ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}
}
