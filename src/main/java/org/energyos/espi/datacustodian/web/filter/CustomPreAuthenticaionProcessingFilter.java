package org.energyos.espi.datacustodian.web.filter;

import java.util.Collection;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.energyos.espi.common.service.DefaultLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;

public class CustomPreAuthenticaionProcessingFilter extends
		AbstractPreAuthenticatedProcessingFilter {

	@Autowired
	private DefaultLoginService userService;

	public int getOrder() {
		// TODO Auto-generated method stub
		return 0;
	}

	protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
		System.err.println("in filter getPreAuthenticatedPrincipal==" + request);
		Authentication auth = (Authentication) validateCookies(request);
		if (auth != null) {
			return auth.getPrincipal();
		}
		return "";
	}

	protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
		Authentication auth = (Authentication) validateCookies(request);
		if (auth != null) {
			return auth.getCredentials();
		}
		return "";
	}

	protected Object validateCookies(HttpServletRequest request) {
		System.err.println("in filter validateCookies==" + request);
		Cookie[] cookies = request.getCookies();
		System.err.println(" :::: in filter validateCookies size :::: " + cookies.length);
		String userLoginToken = null;
		String cookieValues = null;
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				
				
				System.err.println(" ::: cookie max age ::: " + cookie.getMaxAge());

				if (cookie.getName().equalsIgnoreCase("JSESSIONID")) {
					//System.out.println("cookie.getValue()" + cookie.getValue());
				}
				if (cookie.getName().contains("user-token")) {
					System.err.println(" :::: name check :::: " + cookie.getName());
					cookieValues = cookie.getValue();
				}
			}
		}
		userLoginToken = cookieValues;
		//userLoginToken = "59558def-f01b-4eaa-ab83-3853b96d6d8b";
		System.err.println("in filter validateCookies==" + request);
		
		System.err.println(" :::: userLoginToken after set :::: " + userLoginToken);
		Authentication auth = null;
		UserDetails user =null;
		
		if (StringUtils.isNotEmpty(userLoginToken)) {
			try {
				
				user = userService.findByOauthToken(userLoginToken);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (user != null) {  
				Collection<? extends GrantedAuthority> authorities = user
						.getAuthorities();

				auth = new PreAuthenticatedAuthenticationToken(user,
						user.getPassword(), authorities);
				//needs to be deleted 
				String userName = auth.getName();
				String password = (String) auth.getCredentials();

				//System.out.println("userName using oauth=" + userName+ "==password==" + password);
				//needs to be deleted 

			}
		}
		return auth;

	}

}