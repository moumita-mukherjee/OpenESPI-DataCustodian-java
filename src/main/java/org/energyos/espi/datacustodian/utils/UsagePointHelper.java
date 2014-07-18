package org.energyos.espi.datacustodian.utils;

import java.util.HashMap;
import java.util.List;

import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.domain.UsagePointDetail;

public class UsagePointHelper {

	public static List<UsagePoint> populateExternalDetail(
			List<UsagePoint> usagePoints,
			List<UsagePointDetail> usagePointDetails) {
		if (usagePoints == null || usagePointDetails == null) {
			return usagePoints;
		}

		HashMap<String, UsagePointDetail> map = new HashMap<String, UsagePointDetail>();
		if (usagePointDetails != null && usagePointDetails.size() > 0) {
			for (UsagePointDetail up : usagePointDetails) {
				if (up != null && up.getSelfHref() != null) {
					map.put(up.getSelfHref(), up);
				}
			}
		}
		if (usagePoints != null && usagePoints.size() > 0) {
			for (UsagePoint up : usagePoints) {				
				if (map.containsKey(up.getSelfLink().getHref())) {
					up.setUsagePointDetail(map.get(up.getSelfLink().getHref()));
				}else {
					System.err.println( " Contextual details of usage point not found "+up.getSelfLink().getHref());
				}
			}
		}
		return usagePoints;
	}

}
