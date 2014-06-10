/*
 * Copyright 2013 EnergyOS.org
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

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import org.energyos.espi.common.domain.MeterReading;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.service.ApplicationInformationService;
import org.energyos.espi.common.service.IntervalBlockService;
import org.energyos.espi.common.service.MeterReadingService;
import org.energyos.espi.datacustodian.bean.DatePeriodBean;
import org.energyos.espi.datacustodian.utils.DateUtil;
import org.energyos.espi.datacustodian.web.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping()
public class MeterReadingController extends BaseController {

	@Autowired
	protected MeterReadingService meterReadingService;

	@Autowired
	protected IntervalBlockService intervalBlockService;

	@Autowired
	private ApplicationInformationService applicationInformationService;

	//DJ 
	//@Transactional(readOnly = true)
	@RequestMapping(value = Routes.METER_READINGS_SHOW, method = RequestMethod.GET)
	public String show(@PathVariable Long retailCustomerId,
			@PathVariable Long usagePointId, @PathVariable Long meterReadingId,
			@RequestParam("usagetime-min") Long fromTime,
			@RequestParam("usagetime-max") Long toTime, ModelMap model) {
		// TODO need to walk the subtree to force the load (for now)

		Calendar c=Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		if (fromTime == 0) {
			Date d= c.getTime();
			fromTime = DateUtil.dayBegin(d).getTime()/1000;
			toTime = DateUtil.dayEnd(d).getTime()/1000;
		}
		MeterReading mr = meterReadingService.findById(retailCustomerId,
				usagePointId, meterReadingId);
		MeterReading newMeterReading = new MeterReading();
		if(mr!=null){
		newMeterReading.merge(mr);

		newMeterReading.setIntervalBlocks(intervalBlockService
				.findIntervalBlocksByPeriod(newMeterReading.getId(), fromTime,
						toTime));
		}
		/*
		 * Iterator<IntervalBlock> it = newMeterReading.getIntervalBlocks()
		 * .iterator(); while (it.hasNext()) { IntervalBlock temp = it.next();
		 * Iterator<IntervalReading> it1 = temp.getIntervalReadings()
		 * .iterator(); while (it1.hasNext()) { IntervalReading temp1 =
		 * it1.next(); temp1.getCost(); }
		 * 
		 * }
		 */

		DatePeriodBean dpb = new DatePeriodBean();
		dpb.setPrevUsagetimeMin((fromTime - DateUtil.MS_IN_DAY/1000));
		dpb.setPrevUsagetimeMax(fromTime);
		dpb.setNextUsagetimeMin(toTime);
		dpb.setNextUsagetimeMax((toTime + DateUtil.MS_IN_DAY/1000));


		model.put("meterReading", newMeterReading);
		model.put("dpb", dpb);

		model.put("meterReading", newMeterReading);
		return "/customer/meterreadings/show";
	}

	public void setMeterReadingService(MeterReadingService meterReadingService) {
		this.meterReadingService = meterReadingService;
	}

	public void setIntervalBlockService(
			IntervalBlockService intervalBlockService) {
		this.intervalBlockService = intervalBlockService;
	}

	public void setApplicationInformationService(
			ApplicationInformationService applicationInformationService) {
		this.applicationInformationService = applicationInformationService;
	}

}