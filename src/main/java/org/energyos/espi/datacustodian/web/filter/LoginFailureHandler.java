package org.energyos.espi.datacustodian.web.filter;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

public class LoginFailureHandler implements AuthenticationFailureHandler {

	public LoginFailureHandler() {
		System.err.println("LoginFailureHandler");
	}

	@Override
	public void onAuthenticationFailure(HttpServletRequest request,
			HttpServletResponse response, AuthenticationException exception)
			throws IOException, ServletException {
		
		System.err.println("invalid login");
		
		System.err.println(" :::: Request Object :::: " + request);
		
		System.err.println(" :::: Request Object ContextPath :::: "+ request.getContextPath());
		
		System.err.println(" :::: Request Object PathInfo :::: " + request.getPathInfo());
		
		System.err.println(" :::: Request Object LocalAddress :::: "+ request.getLocalAddr());
		
		System.err.println(" :::: Request Object RequestURI :::: "+ request.getRequestURI());
		
		System.err.println(" :::: Request Object QueryString :::: "+ request.getQueryString());
		
		System.err.println(" :::: Request Object Referer :::: "+ request.getHeader("Referer"));

	}

}