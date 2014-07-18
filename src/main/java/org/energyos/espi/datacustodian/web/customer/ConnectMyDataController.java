package org.energyos.espi.datacustodian.web.customer;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.energyos.espi.common.domain.Authorization;
import org.energyos.espi.common.domain.Subscription;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.repositories.UsagePointDetailRepository;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.common.service.AuthorizationService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.datacustodian.utils.UsagePointHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/RetailCustomer/{retailCustomerId}/cmd")
public class ConnectMyDataController extends BaseController {

	@Autowired
	private ApplicationInformationService applicationInformationService;

	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private UsagePointService usagePointService;

	@Autowired
	private UsagePointDetailRepository usagePointDetailRepository;

	@ModelAttribute
	public List<UsagePoint> usagePoints(Principal principal) {
		List<UsagePoint> usagePoints = usagePointService
				.findAllByRetailCustomer(currentCustomer(principal));
		populateExternalDetail(currentUser(principal).getCustomerId(),
				usagePoints);
		// usagePointDetailRepository
		return usagePoints;
	}

	@RequestMapping(method = RequestMethod.GET)
	public String index(ModelMap model, Authentication principal) {

		List<Authorization> authorizationList = authorizationService
				.findAllActiveByRetailCustomerId(currentCustomer(principal)
						.getId());
		model.put("authorizationList", authorizationList);

		model.put(
				"subscriptionByApp",
				buildSubscriptionList(currentUser(principal).getCustomerId(),
						authorizationList));
		model.put("dcapplicationInformation",
				applicationInformationService.findById(1l));

		model.put("applicationInformationList",
				applicationInformationService.findAllThirdParties());
		return "/customer/cmd/index";
	}

	private HashMap<String, List<Subscription>> buildSubscriptionList(
			String customerId, List<Authorization> authList) {
		HashMap<String, List<Subscription>> subscriptionByApp = new HashMap<>();
		List<UsagePoint> usagePoints = new ArrayList<UsagePoint>();
		for (Authorization auth : authList) {
			for (UsagePoint up : auth.getSubscription().getUsagePoints()) {
				// load usage points
				usagePoints.add(up);
			}

			List<Subscription> subs = null;
			if (subscriptionByApp.containsKey(auth.getApplicationInformation()
					.getThirdPartyApplicationName())) {
				subs = subscriptionByApp.get(auth.getApplicationInformation()
						.getThirdPartyApplicationName());
			} else {
				subs = new ArrayList<Subscription>(4);
				subscriptionByApp.put(auth.getApplicationInformation()
						.getThirdPartyApplicationName(), subs);
			}
			subs.add(auth.getSubscription());

		}
		populateExternalDetail(customerId, usagePoints);
		return subscriptionByApp;

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

	public void setApplicationInformationService(
			ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}

	public void setAuthorizationService(
			AuthorizationService authorizationService) {
		this.authorizationService = authorizationService;
	}

	public void setUsagePointService(UsagePointService usagePointService) {
		this.usagePointService = usagePointService;
	}

	public void setUsagePointDetailRepository(
			UsagePointDetailRepository usagePointDetailRepository) {
		this.usagePointDetailRepository = usagePointDetailRepository;
	}
}
