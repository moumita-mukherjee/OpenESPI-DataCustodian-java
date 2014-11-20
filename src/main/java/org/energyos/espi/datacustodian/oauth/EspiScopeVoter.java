/*
 * Copyright 2002-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.energyos.espi.datacustodian.oauth;

import java.util.Collection;
import java.util.Collections;
import java.util.Set;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.common.exceptions.InsufficientScopeException;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.OAuth2Request;
import org.springframework.security.oauth2.provider.vote.ScopeVoter;

public class EspiScopeVoter extends ScopeVoter {
	
	private String scopePrefix = "SCOPE_";

	private String denyAccess = "DENY_OAUTH";

	private boolean throwException = true;
	
	public int vote(Authentication authentication, Object object, Collection<ConfigAttribute> attributes) {

		System.err.print(" called...."+authentication);
		int result = ACCESS_ABSTAIN;

		if (!(authentication instanceof OAuth2Authentication)) {
			return result;

		}

		for (ConfigAttribute attribute : attributes) {
			if (denyAccess.equals(attribute.getAttribute())) {
				return ACCESS_DENIED;
			}
		}

		OAuth2Request clientAuthentication = ((OAuth2Authentication) authentication).getOAuth2Request();

		for (ConfigAttribute attribute : attributes) {
			if (this.supports(attribute)) {
				result = ACCESS_DENIED;

				Set<String> scopes = clientAuthentication.getScope();

				System.err.print(" scopes...."+scopes);
				if(scopes==null) {
					return ACCESS_GRANTED;
				}
				for (String scope : scopes) {
					if (attribute.getAttribute().toUpperCase().equals((scopePrefix + scope).toUpperCase())) {
						return ACCESS_GRANTED;
					}
				}
				if (result == ACCESS_DENIED && throwException) {
					InsufficientScopeException failure = new InsufficientScopeException(
							"Insufficient scope for this resource", Collections.singleton(attribute.getAttribute()
									.substring(scopePrefix.length())));
					throw new AccessDeniedException(failure.getMessage(), failure);
				}
			}
		}

		return result;
	}
}
