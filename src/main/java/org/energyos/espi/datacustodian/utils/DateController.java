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

package org.energyos.espi.datacustodian.utils;

import java.text.SimpleDateFormat;
import java.util.Calendar;

public class DateController {

	// 2014-05-06T13:36:02.000Z
	private SimpleDateFormat sdf = new SimpleDateFormat(
			"yyyy-MM-dd'T'HH:mm:ss'Z'");

	public String getDayBegin() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return sdf.format(c.getTime());
	}

	public String getPreviousdayBegin() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH) - 1);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return sdf.format(c.getTime());
	}

	public String getDayEnd() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.HOUR, 24);
		c.set(Calendar.MINUTE, 0);
		return sdf.format(c.getTime());
	}

	public String getWeekBegin() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_WEEK, 0);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return sdf.format(c.getTime());
	}

	public String getWeekEnd() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_WEEK, 6);
		c.set(Calendar.HOUR, 24);
		c.set(Calendar.MINUTE, 0);
		return sdf.format(c.getTime());
	}

	public String getMonthBegin() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_MONTH, 1);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return sdf.format(c.getTime());
	}

	public String getNow() {
		Calendar c = Calendar.getInstance();
		return sdf.format(c.getTime());
	}

	public long getDayBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}

	public long getPreviousdayBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_MONTH, c.get(Calendar.DAY_OF_MONTH) - 1);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}

	public long getDayEndUtc() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.HOUR, 24);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}

	public long getWeekBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_WEEK, 0);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}

	public long getWeekEndUtc() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_WEEK, 6);
		c.set(Calendar.HOUR, 24);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}

	public long getMonthBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.set(Calendar.DAY_OF_MONTH, 1);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}
	
	public long getThreeMonthBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -3);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}
	public long getSixMonthBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -6);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}
	public long getTwelveMonthBeginUtc() {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, -12);
		c.set(Calendar.HOUR, 0);
		c.set(Calendar.MINUTE, 0);
		return c.getTimeInMillis() / 1000;
	}

	public long getNowUtc() {
		Calendar c = Calendar.getInstance();
		return c.getTimeInMillis() / 1000;
	}
}