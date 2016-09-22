/*
 * Copyright 2013, 2014 EnergyOS.org
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

package org.energyos.espi.datacustodian.web.api;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.energyos.espi.common.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.sun.syndication.io.FeedException;

@RestController
public class NotificationRESTController {

	@Autowired
	private NotificationService notificationService;

	public NotificationService getNotificationService() {
		return notificationService;
	}

	public void setNotificationService(NotificationService notificationService) {
		this.notificationService = notificationService;
	}

	@RequestMapping(value = "/job/Notify", method = RequestMethod.GET)
	@ResponseBody
	public void notifyAllApplications(HttpServletResponse response)
			throws IOException, FeedException {

		try {

			System.err.println(" ::: Notification call ::::: ");

			notificationService.notifyAllApps();

		} catch (Exception e) {
			System.err.println(" ::: Notification error is ::::: "
					+ e.getCause());

			System.err.println(" ::: Notification error is ::::: "
					+ e.getMessage());
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}

	}

	@RequestMapping(value = "/job/Notify/{applicationInformationId}", method = RequestMethod.GET)
	@ResponseBody
	public void notifyApplication(HttpServletResponse response,
			@PathVariable Long applicationInformationId) throws IOException,
			FeedException {

		try {

			notificationService.notify(applicationInformationId);

		} catch (Exception e) {

			System.err.println(" ::: Notification error is ::::: "
					+ e.getCause());

			System.err.println(" ::: Notification error is ::::: "
					+ e.getMessage());
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}

	}

}