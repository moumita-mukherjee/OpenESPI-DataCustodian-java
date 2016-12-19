package org.energyos.espi.datacustodian.web.filter;

import java.util.Collection;



import org.energyos.espi.common.domain.User;
import org.energyos.espi.common.repositories.UserRepository;
import org.energyos.espi.common.service.DefaultLoginService;
import org.energyos.espi.common.utils.SHA1PasswordEncoder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.jaas.DefaultJaasAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.util.StringUtils;

public class SimpleOAuthAuthenticationProvider extends
		DefaultJaasAuthenticationProvider {

	@Autowired
	private DefaultLoginService userService;
	
	@Autowired
	private UserRepository userRepository;

	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {

		String userName = authentication.getName();
		String password = (String) authentication.getCredentials();		
	
		//UserDetails user = userService.loadUserByUsername(userName);
		System.err.println(" :::: User Name :::: "+userName +" :::: Password :::: "+password);
		if(StringUtils.isEmpty(userName)) {
			throw new AuthenticationServiceException("Not login");
		}
		User user=userRepository.findByUsername(userName);
		System.err.println(" :::: User :::: "+user);
		if (StringUtils.isEmpty(password) ||user == null || !user.getUsername().equalsIgnoreCase(userName)) {
			throw new BadCredentialsException("Username not found.");
		}
		
		
		String encodePassword = new SHA1PasswordEncoder().encodePassword(
				password, user.getSalt());
		
		

		if (!password.equals(user.getPassword())) {
			if (!encodePassword.equals(user.getPassword())) {
				throw new BadCredentialsException("Wrong password.");
			}
		}

		Collection<? extends GrantedAuthority> authorities = user
				.getAuthorities();

		return new UsernamePasswordAuthenticationToken(user, password,
				authorities);

		
	}

	public boolean supports(Class<?> authentication) {		
		return true;

	}
}
