package org.energyos.espi.datacustodian.web.filter;

import java.security.Principal;
import java.util.HashSet;
import java.util.Set;

import org.springframework.security.authentication.jaas.AuthorityGranter;

public class CustomAuthorityGranter implements AuthorityGranter {

	public Set<String> grant(Principal principal) {
		//System.err.println("TestAuthorityGranter supports " );
		Set<String> grantedRoles = new HashSet<String>();
		grantedRoles.add("ROLE_USER");		
		return grantedRoles;
	}

}
