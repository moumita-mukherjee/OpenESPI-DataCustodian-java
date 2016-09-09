package org.energyos.espi.datacustodian.web.filter;

import java.util.Collection;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.vote.AffirmativeBased;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;

@SuppressWarnings("deprecation")

public class SimpleToeknBased extends AffirmativeBased {
	public void decide(Authentication authentication, Object object, Collection<ConfigAttribute> configAttributes)
			 {	
		try{		
		super.decide(authentication, object, configAttributes);
		}catch(Exception e)
		{
			throw new BadCredentialsException("Access Not Authorized");
		}
		

	}
}
