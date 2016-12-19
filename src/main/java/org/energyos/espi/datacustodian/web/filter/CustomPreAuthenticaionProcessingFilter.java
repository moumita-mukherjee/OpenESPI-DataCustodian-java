package org.energyos.espi.datacustodian.web.filter;

import java.util.Collection;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;



import org.energyos.espi.common.service.DefaultLoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.util.StringUtils;

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
		if(request.getRequestURI().indexOf("/login")>=0) {
			System.err.println("getPreAuthenticatedPrincipal :: login request");
			return "";
		}
		Authentication auth = (Authentication) validateCookies(request);
		System.err.println("in filter getPreAuthenticatedPrincipal==auth " + auth);
		if (auth != null) {
			return auth.getPrincipal();
		}
		return "";
	}

	protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
		if(request.getRequestURI().indexOf("/login")>=0) {
			System.err.println("getPreAuthenticatedCredentials :: login request");
			return null;
		}
		Authentication auth = (Authentication) validateCookies(request);
		if (auth != null) {
			return auth.getCredentials();
		}
		return "";
	}

	protected Object validateCookies(HttpServletRequest request) {
		System.err.println("in filter validateCookies==" + request);
		Cookie[] cookies = request.getCookies();

		String userLoginToken = null;
		String cookieValues = null;
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equalsIgnoreCase("JSESSIONID")) {
					//System.out.println("cookie.getValue()" + cookie.getValue());
				}
				if (cookie.getName().contains("user-token")) {
					cookieValues = cookie.getValue();
					System.err.println(" :::: name check :::: " + cookie.getName() +" "+cookieValues);
				}
			}
		}
		userLoginToken = cookieValues;
		System.err.println(" :::: userLoginToken after set :::: " + userLoginToken);
		Authentication auth = null;
		
		if (StringUtils.isEmpty(userLoginToken)) {
			request.getSession().setAttribute("postLoginURL",request.getQueryString()==null ? request.getRequestURL().toString():request.getRequestURL().toString()+"?"+request.getQueryString());
			
			System.err.println(" :::: userLoginToken after set :::: " + request.getRequestURL());
			System.err.println(" :::: userLoginToken after set :::: " + request.getRequestURI());
			System.err.println(" :::: userLoginToken after set :::: " + request.getQueryString());
		}

		
		if (!StringUtils.isEmpty(userLoginToken)) {
			UserDetails user =null;
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