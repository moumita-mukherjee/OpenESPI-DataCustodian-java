package org.energyos.espi.datacustodian.oauth;

import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.persistence.NoResultException;

import org.energyos.espi.common.domain.ApplicationInformation;
import org.energyos.espi.common.domain.Authorization;
import org.energyos.espi.common.domain.DateTimeInterval;
import org.energyos.espi.common.domain.IdentifiedObject;
import org.energyos.espi.common.domain.RetailCustomer;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.Subscription;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.domain.User;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.common.service.AuthorizationService;
import org.energyos.espi.common.service.ResourceService;
import org.energyos.espi.common.service.SubscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.oauth2.common.DefaultOAuth2AccessToken;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.security.oauth2.common.util.OAuth2Utils;
import org.springframework.security.oauth2.provider.ClientDetails;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.OAuth2Request;
import org.springframework.security.oauth2.provider.client.JdbcClientDetailsService;
import org.springframework.security.oauth2.provider.token.TokenEnhancer;
import org.springframework.transaction.annotation.Transactional;

public class EspiTokenEnhancer implements TokenEnhancer {

	@Autowired
	private ApplicationInformationService applicationInformationService;

	@Autowired
	private SubscriptionService subscriptionService;

	@Autowired
	private ResourceService resourceService;

	@Autowired
	private AuthorizationService authorizationService;

    @Transactional (rollbackFor= {javax.xml.bind.JAXBException.class}, 
                noRollbackFor = {javax.persistence.NoResultException.class, org.springframework.dao.EmptyResultDataAccessException.class })

    @Override
    public OAuth2AccessToken enhance(OAuth2AccessToken accessToken, OAuth2Authentication authentication) {
    	
		DefaultOAuth2AccessToken result = new DefaultOAuth2AccessToken(accessToken);

		System.err.printf("EspiTokenEnhancer: OAuth2Request Parameters = %s\n", authentication.getOAuth2Request().getRequestParameters());

		String clientId = authentication.getOAuth2Request().getClientId();
		ApplicationInformation ai = null;
		
		// Confirm Application Information record exists for ClientID requesting an access token		
		try {			
			ai = applicationInformationService.findByClientId(clientId);

		} catch (NoResultException | EmptyResultDataAccessException e){
			System.out.printf("\nEspiTokenEnhancer: ApplicationInformation record not found!\n"
					+ "OAuth2Request Parameters = %s\n", authentication.getOAuth2Request().getRequestParameters() + " client_id = " + clientId);			
			throw new AccessDeniedException(String.format("No client with requested id: %s", clientId));	
		}		
			
			Map<String, String> requestParameters = authentication.getOAuth2Request().getRequestParameters();
			String grantType = requestParameters.get(OAuth2Utils.GRANT_TYPE);
			grantType = grantType.toLowerCase();
		OAuth2Request oAuth2Request = authentication.getOAuth2Request();
		Long usagePointId = 0l;		
		if (oAuth2Request.getExtensions() != null && oAuth2Request.getExtensions().containsKey("usagepoint")) {
			usagePointId = (Long) oAuth2Request.getExtensions().get("usagepoint");
		}
		
		long currentTimeSec=System.currentTimeMillis()/1000;
		long daysec=24 * 3600l;
		long estoffsetsec=5*3600l;
		long minutesec=60 ;
		currentTimeSec=(currentTimeSec/daysec)*daysec+estoffsetsec;
		long authPeriod=daysec * 365l;
		Date authorizationEndDate=null;
		if (oAuth2Request.getExtensions() != null && oAuth2Request.getExtensions().containsKey("authorizationEndDate")) {
			authorizationEndDate = (Date) oAuth2Request.getExtensions().get("authorizationEndDate");
			if(authorizationEndDate!=null) { 
				authPeriod=((authorizationEndDate.getTime()/(1000*daysec))*daysec)-currentTimeSec+daysec-minutesec;
			}						
		}
		if(authPeriod<daysec) {
			authPeriod=daysec;
		}
		System.err.println(" authorizationEndDate " + authorizationEndDate);
		System.err.println(" authPeriod " + authPeriod);
		// Is this a "client_credentials" access token grant_type request?
		if (grantType.contentEquals("client_credentials")) {
			// Processing a "client_credentials" access token grant_type request.

			Authorization authorization = authorizationService.createAuthorization(null, result.getValue());  			
			result.getAdditionalInformation().put("authorizationURI", ai.getDataCustodianResourceEndpoint() + Routes.DATA_CUSTODIAN_AUTHORIZATION.replace("espi/1_1/resource/", "").replace("{authorizationId}", authorization.getId().toString()));

            if (!(accessToken.getScope().equals(ai.getScope()))) {
				System.out.printf("\nEspiTokenEnhancer: Incorrect client_credentials based access token request Scope value!\n"
						+ "OAuth2Request Parameters = %s\n", authentication.getOAuth2Request().getRequestParameters() + " client_id = " + clientId + " scope = " + accessToken.getScope());			
				throw new AccessDeniedException(String.format("No client with requested id: %s", clientId));			
			}
			// Update Data Custodian authorization structure
			ClientDetails clintDtl = clientDetailsService.loadClientByClientId(authentication.getOAuth2Request()
					.getClientId());
			authorization.setApplicationInformation(applicationInformationService.findByClientId((String) clintDtl
					.getAdditionalInformation().get("client_id")));

			authorization.setThirdParty(authentication.getOAuth2Request().getClientId());
			authorization.setAccessToken(accessToken.getValue());
			authorization.setTokenType(accessToken.getTokenType());
			authorization.setExpiresIn((long) accessToken.getExpiresIn());
			authorization.setAuthorizedPeriod(new DateTimeInterval(authPeriod, currentTimeSec));
			authorization.setPublishedPeriod(new DateTimeInterval(authPeriod, currentTimeSec));

			if (accessToken.getRefreshToken() != null) {
				authorization.setRefreshToken(accessToken.getRefreshToken().toString());
			}

			// Remove "[" and "]" surrounding Scope in accessToken structure
			authorization.setScope(accessToken.getScope().toString().substring(1, (accessToken.getScope().toString().length()-1)));

			// set the authorizationUri
			authorization.setAuthorizationURI(ai.getDataCustodianResourceEndpoint() + Routes.DATA_CUSTODIAN_AUTHORIZATION.replace("espi/1_1/resource", "").replace("{authorizationId}", authorization.getId().toString()));

			// Determine resourceURI value based on Client's Role
			Set<String> role = AuthorityUtils.authorityListToSet(authentication.getAuthorities());

			if (role.contains("ROLE_DC_ADMIN")) {
				authorization.setResourceURI(ai.getDataCustodianResourceEndpoint() + "/");

			} else {
				if (role.contains("ROLE_TP_ADMIN")) {
					authorization.setResourceURI(ai.getDataCustodianResourceEndpoint() + Routes.BATCH_BULK_MEMBER.replace("espi/1_1/resource", "").replace("{bulkId}", "**"));

				} else {
					if (role.contains("ROLE_UL_ADMIN")) {
						authorization.setResourceURI(ai.getDataCustodianResourceEndpoint() + Routes.BATCH_UPLOAD_MY_DATA.replace("espi/1_1/resource", "").replace("{retailCustomerId}", "**"));
					}
				}
			}

			authorization.setUpdated(new GregorianCalendar());
			authorization.setStatus("1"); 	// Set authorization record status as "Active"
			authorizationService.merge(authorization);

		} else if (grantType.contentEquals("authorization_code")) {

			try {
				// Is this a refresh_token grant_type request?
				Authorization authorization = authorizationService.findByRefreshToken(result.getRefreshToken().getValue());

				// Yes, update access token
				authorization.setAccessToken(accessToken.getValue());
				authorizationService.merge(authorization);

			} catch (NoResultException | EmptyResultDataAccessException e) {
				// No, process as initial access token request

				// Create Subscription and add resourceURI to /oath/token response
				Subscription subscription = subscriptionService.createSubscription(authentication,usagePointId);   
				result.getAdditionalInformation().put("resourceURI", ai.getDataCustodianResourceEndpoint() + Routes.BATCH_SUBSCRIPTION.replace("espi/1_1/resource/", "").replace("{subscriptionId}", subscription.getId().toString()));        

				// Create Authorization and add authorizationURI to /oath/token response        
				Authorization authorization = authorizationService.createAuthorization(subscription, result.getValue());           
				result.getAdditionalInformation().put("authorizationURI", ai.getDataCustodianResourceEndpoint() + Routes.DATA_CUSTODIAN_AUTHORIZATION.replace("espi/1_1/resource/", "").replace("{authorizationId}", authorization.getId().toString()));        	

				// Update Data Custodian subscription structure
				subscription.setAuthorization(authorization);
				subscription.setUpdated(new GregorianCalendar());
				subscriptionService.merge(subscription);

				RetailCustomer retailCustomer = ((User) authentication.getPrincipal()).getRetailCustomer();

				// link in the usage points associated with this subscription
				System.err.println("Linking with usagepoint----@ESPITokenEnhancer" + usagePointId);
				if (usagePointId > 0) {
					UsagePoint up = resourceService.findById(usagePointId, UsagePoint.class);
					up.setSubscription(subscription);
					resourceService.persist(up); // maybe not needed??
				} else {
					List<IdentifiedObject> usagePointIds = resourceService.findAllIdsByXPath(retailCustomer.getId(),UsagePoint.class);
					Iterator<IdentifiedObject> it = usagePointIds.iterator();
					while (it.hasNext()) {
						UsagePoint up = resourceService.findById(it.next().getId(), UsagePoint.class);
						up.setSubscription(subscription);
						resourceService.persist(up);  // maybe not needed??
					}
				}

				// Update Data Custodian authorization structure
				authorization.setApplicationInformation(applicationInformationService.findByClientId(authentication.getOAuth2Request().getClientId()));
				authorization.setThirdParty(authentication.getOAuth2Request().getClientId());
				authorization.setRetailCustomer(retailCustomer);
				authorization.setAccessToken(accessToken.getValue());
				authorization.setTokenType(accessToken.getTokenType());
				authorization.setExpiresIn((long) accessToken.getExpiresIn());

				if (accessToken.getRefreshToken() != null) {
					authorization.setRefreshToken(accessToken.getRefreshToken().toString());
				}

				// Remove "[" and "]" surrounding Scope in accessToken structure
				authorization.setScope(accessToken.getScope().toString().substring(1, (accessToken.getScope().toString().length()-1)));
				authorization.setAuthorizationURI(ai.getDataCustodianResourceEndpoint() + Routes.DATA_CUSTODIAN_AUTHORIZATION.replace("espi/1_1/resource/", "").replace("{authorizationId}", authorization.getId().toString()));
				authorization.setResourceURI(ai.getDataCustodianResourceEndpoint() + Routes.BATCH_SUBSCRIPTION.replace("espi/1_1/resource/", "").replace("{subscriptionId}", subscription.getId().toString()));
				authorization.setUpdated(new GregorianCalendar());
				authorization.setStatus("1"); 	// Set authorization record status as "Active"
				authorization.setSubscription(subscription);
				authorization.setAuthorizedPeriod(new DateTimeInterval(authPeriod, currentTimeSec));
				authorization.setPublishedPeriod(new DateTimeInterval(authPeriod, currentTimeSec));

				authorizationService.merge(authorization);
			}

		} else if (grantType.contentEquals("password")) {
		
			result = passwordBasedTokenEnhancer(clientId,accessToken,authentication,usagePointId,authPeriod, currentTimeSec);
			

		} else {

			System.out.printf("EspiTokenEnhancer: Invalid Grant_Type processed by Spring Security OAuth2 Framework:\n"
					+ "OAuth2Request Parameters = %s\n", authentication.getOAuth2Request().getRequestParameters());
			throw new AccessDeniedException(String.format("Unsupported ESPI OAuth2 grant_type"));
		}

		return result;
   }
   private DefaultOAuth2AccessToken passwordBasedTokenEnhancer(String clientId,OAuth2AccessToken accessToken,OAuth2Authentication authentication,Long usagePointId,Long authPeriod,long currentTimeSec) {
	 			
		 DefaultOAuth2AccessToken result = new DefaultOAuth2AccessToken(accessToken); 
		
		ApplicationInformation ai = applicationInformationService.findByClientId(clientId);
		Subscription subscription = subscriptionService.createSubscription(authentication,usagePointId);   
		result.getAdditionalInformation().put("resourceURI", ai.getDataCustodianResourceEndpoint() + Routes.BATCH_SUBSCRIPTION.replace("espi/1_1/resource/", "").replace("{subscriptionId}", subscription.getId().toString()));        

		
		Authorization authorization = authorizationService.createAuthorization(subscription, result.getValue());           
		result.getAdditionalInformation().put("authorizationURI", ai.getDataCustodianResourceEndpoint() + Routes.DATA_CUSTODIAN_AUTHORIZATION.replace("espi/1_1/resource/", "").replace("{authorizationId}", authorization.getId().toString()));        	
		
		subscription.setAuthorization(authorization);
		subscription.setUpdated(new GregorianCalendar());
		subscriptionService.merge(subscription);
		
		RetailCustomer retailCustomer = ((User) authentication.getPrincipal()).getRetailCustomer();
		
			List<IdentifiedObject> usagePointIds = resourceService.findAllIdsByXPath(retailCustomer.getId(),UsagePoint.class);
			Iterator<IdentifiedObject> it = usagePointIds.iterator();
			while (it.hasNext()) {
				UsagePoint up = resourceService.findById(it.next().getId(), UsagePoint.class);
				up.setSubscription(subscription);
				resourceService.persist(up);  
			}
		
		
		authorization.setApplicationInformation(applicationInformationService.findByClientId(authentication.getOAuth2Request().getClientId()));
		authorization.setThirdParty(authentication.getOAuth2Request().getClientId());
		authorization.setRetailCustomer(retailCustomer);
		authorization.setAccessToken(accessToken.getValue());
		authorization.setTokenType(accessToken.getTokenType());
		authorization.setExpiresIn((long) accessToken.getExpiresIn());
		
		if (accessToken.getRefreshToken() != null) {
			authorization.setRefreshToken(accessToken.getRefreshToken().toString());
		}
		
		
		authorization.setScope(accessToken.getScope().toString().substring(1, (accessToken.getScope().toString().length()-1)));
		authorization.setAuthorizationURI(ai.getDataCustodianResourceEndpoint() + Routes.DATA_CUSTODIAN_AUTHORIZATION.replace("espi/1_1/resource/", "").replace("{authorizationId}", authorization.getId().toString()));
		authorization.setResourceURI(ai.getDataCustodianResourceEndpoint() + Routes.BATCH_SUBSCRIPTION.replace("espi/1_1/resource/", "").replace("{subscriptionId}", subscription.getId().toString()));
		authorization.setUpdated(new GregorianCalendar());
		authorization.setStatus("1"); 	// Set authorization record status as "Active"
		authorization.setSubscription(subscription);
		authorization.setAuthorizedPeriod(new DateTimeInterval(authPeriod, currentTimeSec));
		authorization.setPublishedPeriod(new DateTimeInterval(authPeriod, currentTimeSec));
		
		authorizationService.merge(authorization);	
		return result;
		
	   
   }
   
   public void setApplicationInformationService(ApplicationInformationService applicationInformationService) {
        this.applicationInformationService = applicationInformationService;
   }

   public ApplicationInformationService getApplicationInformationService () {
        return this.applicationInformationService;
   }
   public void setSubscriptionService(SubscriptionService subscriptionService) {
        this.subscriptionService = subscriptionService;
   }

   public SubscriptionService getSubscriptionService () {
        return this.subscriptionService;
   }
   public void setResourceService(ResourceService resourceService) {
        this.resourceService = resourceService;
   }

   public ResourceService getResourceService () {
        return this.resourceService;
   }
   public void setAuthorizationService(AuthorizationService authorizationService) {
        this.authorizationService = authorizationService;
   }

	public AuthorizationService getAuthorizationService() {
		return this.authorizationService;
	}
	
	/* LH customization starts here */
	@Autowired
	private JdbcClientDetailsService clientDetailsService;

	public JdbcClientDetailsService getClientDetailsService() {
		return clientDetailsService;
	}

	public void setClientDetailsService(JdbcClientDetailsService clientDetailsService) {
		this.clientDetailsService = clientDetailsService;
	}

}
