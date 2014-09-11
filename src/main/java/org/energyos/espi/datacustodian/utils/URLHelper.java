package org.energyos.espi.datacustodian.utils;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.energyos.espi.common.domain.ApplicationInformationScope;

public class URLHelper {

	public static String newScopeParams(ApplicationInformationScope[] scopes) {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < scopes.length; i++) {
			if (i > 0) sb.append("&");
			sb.append("scope=" + scopes[i].getScope());
		}
		return sb.toString();
	}

	public static String newScopeParams(String[] scopes) {
		StringBuilder sb = new StringBuilder();
		int i = 0;
		for (String scope : scopes) {
			if (i > 0) sb.append("&");
			sb.append("scope=" + scope);
			i++;
		}
		return sb.toString();
	}

	public static String newScopeParams(Set<ApplicationInformationScope> scopes) {
		StringBuilder sb = new StringBuilder();
		int i = 0;
		for (ApplicationInformationScope scope : scopes) {
			if (i > 0) sb.append("&");
			sb.append("scope=" + scope.getScope());
			i++;
		}
		return sb.toString();
	}

	public static List<String> toScopeList(Set<ApplicationInformationScope> scopes) {
		List<String> sb = new ArrayList<String>();
		int i = 0;
		for (ApplicationInformationScope scope : scopes) {
			sb.add(scope.getScope());
		}
		return sb;
	}
}
