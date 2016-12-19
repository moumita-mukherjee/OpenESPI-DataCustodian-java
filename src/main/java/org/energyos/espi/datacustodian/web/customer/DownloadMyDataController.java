/*
 * Copyright 2013,2014 EnergyOS.org
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package org.energyos.espi.datacustodian.web.customer;

import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.repositories.UsagePointDetailRepository;
import org.energyos.espi.common.service.ExportService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.common.utils.ExportFilter;
import org.energyos.espi.datacustodian.utils.UsagePointHelper;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun.syndication.io.FeedException;

@Controller
public class DownloadMyDataController extends BaseController {

	@Autowired
	private UsagePointService usagePointService;

	@Autowired
	private UsagePointDetailRepository usagePointDetailRepository;

	@Autowired
	private ExportService exportService;

	public void setExportService(ExportService exportService) {
		this.exportService = exportService;
	}

	/*
	 * 
	 * @ModelAttribute public List<UsagePoint> usagePoints1(Principal principal)
	 * { List<UsagePoint> usagePoints = usagePointService
	 * .findAllByRetailCustomer(currentCustomer(principal));
	 * populateExternalDetail(currentUser(principal).getCustomerId(),
	 * usagePoints); return usagePoints; }
	 */

	@RequestMapping(value = "/RetailCustomer/{retailCustomerId}/UsagePoint/{usagePointId}/dmd", method = RequestMethod.GET, produces = "application/atom+xml")
	@ResponseBody
	public void download_member(HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long usagePointId, @RequestParam Map<String, String> params, Principal principal)
			throws IOException, FeedException {

		response.addHeader("Content-Disposition", "attachment; filename=GreenButtonDownload.xml");
		response.addHeader("Content-Type", "application/octet-stream");
		try {
			exportService.exportUsagePointFull(0L, usagePointId, currentCustomer(principal).getId(),
					response.getOutputStream(), new ExportFilter(params));

		} catch (Exception e) {
			e.printStackTrace(System.err);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}

	}

	@RequestMapping(value = "/RetailCustomer/{retailCustomerId}/dmd", method = RequestMethod.GET)
	public String index(@PathVariable Long retailCustomerId, ModelMap model, Principal principal) {

		List<UsagePoint> usagePoints = usagePointService.findAllByRetailCustomer(currentCustomer(principal).getId());
		populateExternalDetail(currentUser(principal).getCustomerId(), usagePoints);

		model.put("usagePoints", usagePoints);

		HashMap<String, List<UsagePoint>> usagePointListGroupByAccount = new HashMap<String, List<UsagePoint>>();
		List<String> accountList = new ArrayList<String>();
		List<UsagePoint> list = null;
		for (UsagePoint up : usagePoints) {
			if (up.getUsagePointDetail() != null) {
				String key = up.getUsagePointDetail().getAccountId();
				if (usagePointListGroupByAccount.containsKey(key)) {
					list = usagePointListGroupByAccount.get(key);
				} else {
					list = new ArrayList<UsagePoint>();
					usagePointListGroupByAccount.put(key, list);
					accountList.add(key);
				}
				list.add(up);
			}
		}
		model.put("accountList", accountList);
		model.put("usagePointListGroupByAccount", usagePointListGroupByAccount);

		HashMap<Long, List<UsagePoint>> usagePointListGroupByService = new HashMap<Long, List<UsagePoint>>();
		List<Long> serviceKindList = new ArrayList<Long>();
		List<UsagePoint> list2 = null;
		for (UsagePoint up : usagePoints) {
			if (up.getUsagePointDetail() != null) {
				Long key = up.getServiceCategory().getKind();

				if (usagePointListGroupByService.containsKey(key)) {
					list2 = usagePointListGroupByService.get(key);
				} else {
					list2 = new ArrayList<UsagePoint>();
					usagePointListGroupByService.put(key, list2);
					serviceKindList.add(key);
				}
				list2.add(up);
			}
		}
		model.put("serviceKindList", serviceKindList);
		model.put("usagePointListGroupByService", usagePointListGroupByService);

		return "/customer/dmd/index";
	}

	private List<UsagePoint> populateExternalDetail(String customerId, List<UsagePoint> usagePoints) {
		try {
			UsagePointHelper.populateExternalDetail(usagePoints,
					usagePointDetailRepository.findAllByRetailCustomerId(customerId));
		} catch (EmptyResultDataAccessException ignore) {

		}
		return usagePoints;
	}

	public void setUsagePointService(UsagePointService usagePointService) {
		this.usagePointService = usagePointService;
	}

	public void setUsagePointDetailRepository(UsagePointDetailRepository usagePointDetailRepository) {
		this.usagePointDetailRepository = usagePointDetailRepository;
	}

}