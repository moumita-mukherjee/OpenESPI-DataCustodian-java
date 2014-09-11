package org.energyos.espi.datacustodian.web.customer;

import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import org.energyos.espi.common.domain.Authorization;
import org.energyos.espi.common.domain.DateTimeInterval;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.repositories.UsagePointDetailRepository;
import org.energyos.espi.common.service.AuthorizationService;
import org.energyos.espi.common.service.SubscriptionService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.datacustodian.utils.UsagePointHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.provider.token.DefaultTokenServices;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthorizedThirdPartiesController extends BaseController {
	private final SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
	@Autowired
	private AuthorizationService authorizationService;

	@Autowired
	private SubscriptionService subscriptionService;

	@Autowired
	private UsagePointService usagePointService;

	@Autowired
	private DefaultTokenServices defaultTokenServices;

	public void setDefaultTokenServices(DefaultTokenServices defaultTokenServices) {
		this.defaultTokenServices = defaultTokenServices;
	}

	@Autowired
	private UsagePointDetailRepository usagePointDetailRepository;

	@RequestMapping(value = Routes.AUTHORIZED_THIRD_PARTIES, method = RequestMethod.GET)
	public String index(ModelMap model, Authentication principal) {
		// RetailCustomer currentCustomer = currentCustomer(principal);
		model.put("authorizationList",
				authorizationService.findAllByRetailCustomerId(currentCustomer(principal).getId()));
		return "/customer/authorizedThirdParties/index";
	}

	@RequestMapping(value = Routes.AUTHORIZED_THIRD_PARTIES_MEMBER, method = RequestMethod.GET)
	public String show(@PathVariable Long retailCustomerId, @PathVariable Long authorizationId, ModelMap model,
			Principal principal) {

		Authorization authorization = authorizationService.findById(retailCustomerId, authorizationId);

		if (authorization.getSubscription() != null) {
			populateExternalDetail(currentUser(principal).getCustomerId(), authorization.getSubscription()
					.getUsagePoints());
		}
		model.put("authorization", authorization);

		List<UsagePoint> usagePoints = usagePointService.findAllByRetailCustomer(currentCustomer(principal).getId());
		removeFromList(usagePoints, authorization.getSubscription().getUsagePoints());
		populateExternalDetail(currentUser(principal).getCustomerId(), usagePoints);
		model.put("usagePoints", usagePoints);

		return "/customer/authorizedThirdParties/show";
	}

	@RequestMapping(value = Routes.AUTHORIZED_THIRD_PARTIES_MEMBER, method = RequestMethod.PUT)
	public String create(@PathVariable Long retailCustomerId, @PathVariable Long authorizationId, ModelMap model) {

		return "/customer/authorizedThirdParties/show";
	}

	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/RetailCustomer/{retailCustomerId}/AuthorizedThirdParties/{authorizationId}/UsagePoint/{usagePointId}/delete", method = RequestMethod.GET)
	public String deleteUsagePoint(@PathVariable(value = "retailCustomerId") Long retailCustomerId,
			@PathVariable(value = "authorizationId") Long authorizationId,
			@PathVariable(value = "usagePointId") Long usagePointId, ModelMap model, Principal principal) {

		Authorization authorization = authorizationService.findById(retailCustomerId, authorizationId);

		if (authorization.getSubscription() != null) {
			List<UsagePoint> usagePoints = authorization.getSubscription().getUsagePoints();
			for (int i = usagePoints.size() - 1; i >= 0; i--) {
				if (usagePoints.get(i).getId().equals(usagePointId)) {
					usagePoints.remove(i);
					break;
				}
			}

			subscriptionService.merge(authorization.getSubscription());

			populateExternalDetail(currentUser(principal).getCustomerId(), authorization.getSubscription()
					.getUsagePoints());
		}
		model.put("authorization", authorization);

		List<UsagePoint> usagePoints = usagePointService.findAllByRetailCustomer(currentCustomer(principal).getId());
		removeFromList(usagePoints, authorization.getSubscription().getUsagePoints());
		populateExternalDetail(currentUser(principal).getCustomerId(), usagePoints);
		model.put("usagePoints", usagePoints);
		return "/customer/authorizedThirdParties/show";
	}

	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/RetailCustomer/{retailCustomerId}/AuthorizedThirdParties/{authorizationId}/UsagePoint/{usagePointId}/add", method = RequestMethod.GET)
	public String addUsagePoint(@PathVariable(value = "retailCustomerId") Long retailCustomerId,
			@PathVariable(value = "authorizationId") Long authorizationId,
			@PathVariable(value = "usagePointId") Long usagePointId, ModelMap model, Principal principal) {

		Authorization authorization = authorizationService.findById(retailCustomerId, authorizationId);
		UsagePoint usagePoint = usagePointService.findById(retailCustomerId, usagePointId);

		if (authorization.getSubscription() != null) {
			authorization.getSubscription().getUsagePoints().add(usagePoint);

			subscriptionService.merge(authorization.getSubscription());

			populateExternalDetail(currentUser(principal).getCustomerId(), authorization.getSubscription()
					.getUsagePoints());
		}
		model.put("authorization", authorization);

		List<UsagePoint> usagePoints = usagePointService.findAllByRetailCustomer(currentCustomer(principal).getId());
		removeFromList(usagePoints, authorization.getSubscription().getUsagePoints());
		populateExternalDetail(currentUser(principal).getCustomerId(), usagePoints);
		model.put("usagePoints", usagePoints);

		return "/customer/authorizedThirdParties/show";
	}

	@SuppressWarnings("deprecation")
	@RequestMapping(value = Routes.AUTHORIZED_THIRD_PARTIES_MEMBER, method = RequestMethod.POST)
	public String update(@PathVariable(value = "retailCustomerId") Long retailCustomerId,
			@PathVariable(value = "authorizationId") Long authorizationId,
			@RequestParam(value = "revoke", required = false) String revoke,
			@RequestParam(value = "authorization_end_date", required = false) String authorizationEndDate,
			ModelMap model, Principal principal) {

		Authorization authorization = authorizationService.findById(retailCustomerId, authorizationId);

		if (revoke != null && !"".equals(revoke)) {
			boolean bStatus = defaultTokenServices.revokeToken(authorization.getAccessToken());
			if (bStatus) {
				authorization.setStatus("0");
				authorizationService.merge(authorization);
			}
		} else {
			try {
				Date newdate = sdf.parse(authorizationEndDate);
				newdate.setHours(23);
				newdate.setMinutes(59);
				newdate.setSeconds(59);
				long duration = newdate.getTime() - authorization.getAuthorizedPeriod().getStart();
				if (duration > 0) {
					DateTimeInterval dt = new DateTimeInterval();
					dt.setStart(authorization.getAuthorizedPeriod().getStart());
					dt.setDuration(duration);
					authorization.setUpdated(new GregorianCalendar());
					authorization.setAuthorizedPeriod(dt);
					authorizationService.merge(authorization);
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		if (authorization.getSubscription() != null) {
			populateExternalDetail(currentUser(principal).getCustomerId(), authorization.getSubscription()
					.getUsagePoints());
		}
		model.put("authorization", authorization);

		List<UsagePoint> usagePoints = usagePointService.findAllByRetailCustomer(currentCustomer(principal).getId());
		removeFromList(usagePoints, authorization.getSubscription().getUsagePoints());
		populateExternalDetail(currentUser(principal).getCustomerId(), usagePoints);
		model.put("usagePoints", usagePoints);
		return "/customer/authorizedThirdParties/show";
	}

	private void removeFromList(List<UsagePoint> usagePoints, List<UsagePoint> usagePoints2) {
		for (int i = usagePoints.size() - 1; i >= 0; i--) {
			for (int j = usagePoints2.size() - 1; j >= 0; j--) {
				if (usagePoints.get(i).getId().equals(usagePoints2.get(j).getId())) {
					usagePoints.remove(i);
					break;
				}
			}
		}
	}

	private List<UsagePoint> populateExternalDetail(String customerId, List<UsagePoint> usagePoints) {
		try {
			UsagePointHelper.populateExternalDetail(usagePoints,
					usagePointDetailRepository.findAllByRetailCustomerId(customerId));
		} catch (EmptyResultDataAccessException ignore) {

		}
		return usagePoints;
	}

	/*
	 * @RequestMapping(method = RequestMethod.POST) public String
	 * selectThirdParty(@RequestParam("Third_party") Long thirdPartyId,
	 * 
	 * @RequestParam("Third_party_URL") String thirdPartyURL) {
	 * /*ApplicationInformation applicationInformation =
	 * applicationInformationService.findById(thirdPartyId); return "redirect:"
	 * + thirdPartyURL + "?" +
	 * URLHelper.newScopeParams(applicationInformation.getScope()) +
	 * "&DataCustodianID=" + applicationInformation.getDataCustodianId(); }
	 */

	/*
	 * public void
	 * setApplicationInformationService(ApplicationInformationService
	 * applicationInformationService) { /*this.applicationInformationService =
	 * applicationInformationService; }
	 */

	public void setUsagePointDetailRepository(UsagePointDetailRepository usagePointDetailRepository) {
		this.usagePointDetailRepository = usagePointDetailRepository;
	}

	public void setAuthorizationService(AuthorizationService authorizationService) {
		this.authorizationService = authorizationService;
	}

	public void setSubscriptionService(SubscriptionService subscriptionService) {
		this.subscriptionService = subscriptionService;
	}

	public void setUsagePointService(UsagePointService usagePointService) {
		this.usagePointService = usagePointService;
	}

}
