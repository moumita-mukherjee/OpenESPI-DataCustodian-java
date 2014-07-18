package org.energyos.espi.datacustodian.web.thirdparty;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.energyos.espi.common.domain.ApplicationInformation;
import org.energyos.espi.common.domain.ApplicationInformationScope;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.datacustodian.bean.ApplicationInfromationForm;
import org.energyos.espi.datacustodian.utils.RandomString;
import org.energyos.espi.datacustodian.utils.URLHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.oauth2.provider.ClientDetails;
import org.springframework.security.oauth2.provider.NoSuchClientException;
import org.springframework.security.oauth2.provider.client.BaseClientDetails;
import org.springframework.security.oauth2.provider.client.JdbcClientDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class RegistrationController extends BaseController {

	@Autowired
	private ApplicationInformationService applicationInformationService;

	@Autowired
	private JdbcClientDetailsService clientDetailsService;

	public void setClientDetailsService(
			JdbcClientDetailsService clientDetailsService) {
		this.clientDetailsService = clientDetailsService;
	}

	private RandomString clientidRandomString = new RandomString(16);
	private RandomString secretRandomString = new RandomString(32);

	public void setApplicationInformationService(
			ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}

	// DJ 
	//@Transactional(rollbackFor = { ConstraintViolationException.class },
	// noRollbackFor = {
	// DJ javax.persistence.NoResultException.class,
	// DJ org.springframework.dao.EmptyResultDataAccessException.class })
	@RequestMapping(value = Routes.THIRD_PARTY_REGISTRATION, method = RequestMethod.POST)
	public String addAppInfo(
			@ModelAttribute("appInformation") ApplicationInformation appInfo,
			ModelMap model, BindingResult errors) {

		if (appInfo.getUUID() == null) {
			appInfo.setUUID(UUID.randomUUID());
		}
		if (appInfo.getClientSecret() == null
				|| "".equals(appInfo.getClientSecret())) {

			appInfo.setClientSecret(secretRandomString.nextString());
		}
		if (appInfo.getScope() == null || appInfo.getScope().size() == 0) {

			Set<ApplicationInformationScope> scopes = new HashSet<ApplicationInformationScope>();
			scopes.add(new ApplicationInformationScope(
					"FB=4_5_15;IntervalDuration=3600;BlockDuration=monthly;HistoryLength=13"));
			scopes.add(new ApplicationInformationScope(
					"FB=4_5_15;IntervalDuration=900;BlockDuration=monthly;HistoryLength=13"));
			appInfo.setScope(scopes);
		}
		try {
			ApplicationInformation existapp = applicationInformationService
					.findByClientId(appInfo.getClientId());
			if (existapp != null) {
				errors.rejectValue("clientId", "clientId.exists");
			}
		} catch (Exception ignore) {

		}
		if (!errors.hasErrors()) {
			applicationInformationService.persist(appInfo);

			if (clientDetailsService != null) {
				ClientDetails clientDetails = null;
				try {
					clientDetails = clientDetailsService
							.loadClientByClientId(appInfo.getClientId());
				} catch (NoSuchClientException ignore) {
				} catch (EmptyResultDataAccessException ignore) {

				}
				if (clientDetails == null) {
					List<String> authorizedGrantTypes = new ArrayList<String>();
					authorizedGrantTypes.add("authorization_code");
					authorizedGrantTypes.add("refresh_token");

					List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
					authorities.add(new GrantedAuthorityImpl("ROLE_USER"));

					BaseClientDetails bclientDetails = new BaseClientDetails();
					clientDetails = bclientDetails;
					bclientDetails.setClientId(appInfo.getClientId());
					bclientDetails.setClientSecret(appInfo.getClientSecret());
					bclientDetails.setAccessTokenValiditySeconds(3600);
					bclientDetails.setRefreshTokenValiditySeconds(3600);
					bclientDetails.setScope(URLHelper.toScopeList(appInfo
							.getScope()));
					bclientDetails
							.setAuthorizedGrantTypes(authorizedGrantTypes);
					bclientDetails.setAuthorities(authorities);
					clientDetailsService.addClientDetails(bclientDetails);
				} else {
					clientDetailsService.updateClientDetails(clientDetails);
				}
			}

			model.addAttribute("datacustodian",
					applicationInformationService.findById(1l));
			model.addAttribute("message", "success");
		}

		model.put("appInformationSearchForm", new ApplicationInfromationForm());
		if (errors.hasErrors()) {
			return "/thirdparty/registration";
		}
		return "/thirdparty/registration_success";

	}

	@RequestMapping(value = Routes.THIRD_PARTY_REGISTRATION_EDIT, method = RequestMethod.GET)
	public String openEdit(
			@ModelAttribute("appInformation") ApplicationInformation appInfo,
			ModelMap model) {

		model.put("appInformationSearchForm", new ApplicationInfromationForm());

		return "/thirdparty/registration";

	}

	@RequestMapping(value = "/thirdparty/registrationfind", method = RequestMethod.POST)
	public String findAppInfo(
			@ModelAttribute("appInformationSearchForm") ApplicationInfromationForm appInfoForm,
			ModelMap model) {

		ApplicationInformation appInfo = null;
		appInfoForm.setError(null);
		try {
			appInfo = applicationInformationService.findByClientId(appInfoForm
					.getClientId());
			if (!appInfo.getClientSecret()
					.equals(appInfoForm.getClientSecret())) {
				appInfoForm.setError("invalid password");
				appInfo = new ApplicationInformation();
			}
		} catch (EmptyResultDataAccessException ignore) {
			appInfoForm.setError("not found");
			appInfo = new ApplicationInformation();
		}

		model.put("appInformation", appInfo);

		return "/thirdparty/registration";
	}

	@RequestMapping(value = Routes.THIRD_PARTY_REGISTRATION, method = RequestMethod.GET)
	public String getAppInfo(
			@ModelAttribute("appInformation") ApplicationInformation appInfo,
			ModelMap model) {
		if (appInfo != null) {
			if (appInfo.getClientId() == null) {
				appInfo.setClientName("London Hydro");
				appInfo.setClientUri("wwww.xxxx.com");
				appInfo.setLogoUri("http://resources.goodcoins.ca/images/rewards/zfprewardslogo.png");

				appInfo.setClientId(clientidRandomString.nextString());
				appInfo.setClientSecret(secretRandomString.nextString());

				List<String> mails = new ArrayList<>();
				mails.add("test@abc.com");
				appInfo.setContacts(mails);
				appInfo.setThirdPartyPhone("519-661-5800");

				appInfo.setThirdPartyApplicationName("thirdparty");
				appInfo.setThirdPartyApplicationDescription("thirdparty");
				appInfo.setTosUri("http://localhost:8090/ThirdParty/tos.html");
				appInfo.setPolicyUri("http://localhost:8090/ThirdParty/privacy.html");

				appInfo.setThirdPartyLoginScreenURI("http://localhost:8090/ThirdParty/login");
				appInfo.setThirdPartyUserPortalScreenURI("http://localhost:8090/ThirdParty/home");
				appInfo.setThirdPartyScopeSelectionScreenURI("http://localhost:8090/ThirdParty/RetailCustomer/ScopeSelection");
				// Not required
				// appInfo.setRedirectUri("http://localhost:8090/ThirdParty/espi/1_1/OAuthCallBack");
				appInfo.setThirdPartyNotifyUri("http://localhost:8090/ThirdParty/espi/1_1/Notification");

			}
		}

		model.put("appInformationSearchForm", new ApplicationInfromationForm());
		return "/thirdparty/registration";
	}
}
