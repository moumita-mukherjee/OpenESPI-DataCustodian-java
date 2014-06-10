package org.energyos.espi.datacustodian.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

public class DateUtil {
	public final static String MAIL_DATE_FORMAT = "dd MMMMM yyyy";

	public final static String UI_DATE_FORMAT = "dd-MMM-yyyy";
	public final static String UI_DATETIME_FORMAT = "dd-MMM-yyyy HH:mm:ss";
	public final static String UI_TIME_FORMAT = "HH:mm:ss";
	public final static String UI_SHORTTIME_FORMAT = "HH:mm";

	public final static String UTIL_DATE_FORMAT = "dd/MM/yyyy";

	public final static String DATE_FORMAT_REPORT = "dd/MM/yyyy HH:mm:ss";

	public final static String SQL_DATE_FORMAT = "dd-MM-yyyy";
	public final static String DATE_FORMAT_YMD = "yyyy-MM-dd";

	public final static String SQL_DATETIME_FORMAT = "yyyyMMddHHmmss";

	public final static Date MIN_DATE = new Date(1, 1, 1);

	public final static Date MAX_DATE = new Date(2900, 1, 1);

	public final static long MS_IN_DAY = (24 * 60 * 60 * 1000);
	public final static long MS_IN_HOUR = (60 * 60 * 1000);
	public final static String[] SHORT_MONTHS = { "Jan", "Feb", "Mar", "Apr",
			"May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
	public final static String[] LONG_MONTHS = { "January", "February",
			"March", "April", "May", "June", "July", "August", "September",
			"October", "November", "December" };

	public static final String[] LONG_DAY_NAME = new String[] { "Monday",
			"Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
	public static final String[] SHORT_DAY_NAME = new String[] { "SUN", "MON",
			"TUE", "WED", "THU", "FRI", "SAT" };
	public static final String[] M_SHORT_DAY_NAME = new String[] { "MON",
			"TUE", "WED", "THU", "FRI", "SAT", "SUN" };

	public static final int[] DAYS_IN_MONTH = { 31, 28, 31, 30, 31, 30, 31, 31,
			30, 31, 30, 31 };

	private static SimpleDateFormat dateFormatter;
	private static SimpleDateFormat dateTimeFormatter;
	private static SimpleDateFormat timeFormatter;
	private static SimpleDateFormat shortTimeFormatter;

	public static int getMonthId(String name) {
		for (int i = 0; i < LONG_MONTHS.length; i++) {
			if (LONG_MONTHS[i].equalsIgnoreCase(name)) {
				return i;
			}
		}
		return 0;
	}

	public static String getShortDayName(Date d) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		int x = now.get(Calendar.DAY_OF_WEEK);
		return SHORT_DAY_NAME[x - 1];

	}

	public static int getWeekDayId(Date d) {
		Calendar now = Calendar.getInstance();
		now.clear();
		now.setTime(d);
		now.setFirstDayOfWeek(Calendar.MONDAY);
		int x = now.get(Calendar.DAY_OF_WEEK) - Calendar.MONDAY;

		System.out.println(d + "::::" + now + "::::"
				+ now.get(Calendar.DAY_OF_WEEK) + ":" + Calendar.MONDAY);
		if (x < 0) {
			x = x + 7;
		}
		return x;

	}

	public static String getShortMonthName(Date d) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		return SHORT_MONTHS[now.get(Calendar.MONTH)];

	}

	public static int getMonthId(Date d) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		return now.get(Calendar.MONTH);

	}

	public static String getDayName(Date d) {
		Calendar now = Calendar.getInstance();
		now.setTime(d);
		return LONG_DAY_NAME[now.get(Calendar.DAY_OF_WEEK) - 1];

	}

	public static void populateSWeekNames(Date d, ArrayList<String> rlist,
			int size) {
		if (rlist != null) {
			rlist.clear();
			int offset = size;
			if (offset <= 0) {
				Calendar now = Calendar.getInstance();
				now.setTime(d);
				offset = now.get(Calendar.DAY_OF_WEEK);
			}
			for (int i = 0; i < offset; i++) {
				rlist.add(SHORT_DAY_NAME[i]);
			}
		}
	}

	public static void populateWeekDates(Date d, ArrayList<Date> rlist, int size) {
		if (rlist != null) {
			Date wd = weekBegin(d);
			rlist.clear();
			for (int i = 0; i < size; i++) {
				rlist.add(wd);
				wd = DateUtil.addDaysToUtilDate(wd, 1);
			}
		}
	}

	public static ArrayList<Date> getWeekDates(Date d, int size) {
		ArrayList<Date> rlist = new ArrayList<Date>();

		Date wd = weekBegin(d);

		for (int i = 0; i < size; i++) {
			rlist.add(wd);
			wd = DateUtil.addDaysToUtilDate(wd, 1);
		}

		return rlist;
	}

	public static ArrayList<Date> getMonthDates(Date d, boolean future) {
		ArrayList<Date> rlist = new ArrayList<Date>();
		Date today = new Date();
		Date md = monthBegin(d);
		int size = DAYS_IN_MONTH[md.getMonth()];
		for (int i = 0; i < size; i++) {

			rlist.add(md);

			md = DateUtil.addDaysToUtilDate(md, 1);
			if (!future) {
				// for future dates
				if (md.getTime() > today.getTime()) {
					break;
				}
			}
		}

		return rlist;
	}

	public static int getDayNumber(Date d) {
		Date cwd = weekBegin();
		System.out.println((d.after(cwd)) + " getDayNumber " + d + " cwd "
				+ cwd);
		if (d.before(cwd)) {
			return 7;
		} else {
			Calendar now = Calendar.getInstance();
			// now.setTime(d);
			return now.get(Calendar.DAY_OF_WEEK);
		}

	}

	public static void main(String[] args) throws Exception {
		// System.out.println(getWeekFirstDatesOfMonth(new Date()));
		// System.out.println(Calendar.MONDAY);

		TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
		Date d = DateUtil.convertStringToUtilDate("01/01/2013");
		// Date wd = DateUtil.getWeekFirstDatesOfMonth(d);
		Date dt1 = new Date(2014, 0, 1, 23, 10);
		Date dt2 = new Date(2014, 0, 2, 0, 0);
		System.out.println(DateUtil.getDateDiffByDays(dt1, dt2));

	}

	public static ArrayList<Date> getYears(Date di, int x) {

		ArrayList<Date> list = new ArrayList<Date>(6);
		if (x > 0) {
			for (int i = 0; i < x; i++) {
				Date d = new Date(di.getTime());
				d.setYear(d.getYear() + i);
				list.add(d);
			}
		} else {
			for (int i = x + 1; i <= 0; i++) {
				Date d = new Date(di.getTime());
				d.setYear(d.getYear() + i);
				list.add(d);
			}

		}
		return list;
	}

	public static ArrayList<Date> getYears(int x) {

		ArrayList<Date> list = new ArrayList<Date>(6);
		if (x > 0) {
			for (int i = 0; i < x; i++) {
				Date d = new Date();
				d.setYear(d.getYear() + i);
				list.add(d);
			}
		} else {
			for (int i = x + 1; i <= 0; i++) {
				Date d = new Date();
				d.setYear(d.getYear() + i);
				list.add(d);
			}

		}
		return list;
	}

	public static List<Date> getTimePeriods(Date startDate, int hour) {
		int checkDate = startDate.getDate();

		List<Date> list = new ArrayList<Date>(6);
		Date wd = dayBegin(startDate);
		while (wd.getDate() == checkDate) {
			list.add(wd);
			wd = DateUtil.addHourToUtilDate(wd, hour);

		}
		return list;
	}

	public static Date getWeekFirstDate(Date startDate) {
		startDate = monthBegin(startDate);

		Calendar c = Calendar.getInstance();
		c.setTime(startDate);
		c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		Date wd = c.getTime();
		return wd;
	}

	public static List<Date> getWeekFirstDatesOfMonth(Date startDate) {
		startDate = monthBegin(startDate);
		int year = startDate.getYear();
		int checkMonth = startDate.getMonth();
		Calendar c = Calendar.getInstance();
		c.setTime(startDate);
		c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
		List<Date> list = new ArrayList<Date>(6);
		Date wd = c.getTime();
		System.out.println("wd.." + wd);
		while (wd.getMonth() == checkMonth || wd.getMonth() == checkMonth - 1
				|| (wd.getMonth() == 11 && checkMonth == 0)) {
			list.add(wd);
			wd = DateUtil.addDaysToUtilDate(wd, 7);

		}
		return list;
	}

	public static int getCurrentMonth() {
		Calendar cc = Calendar.getInstance();
		int m = cc.get(Calendar.MONTH);
		return m;
	}

	public static ArrayList<Date> getMonthListOfThisYearAsDate(Date d, int size) {
		ArrayList<Date> rlist = new ArrayList<Date>();

		Date md = yearBegin(d);

		for (int i = 0; i < size; i++) {
			md = new Date(d.getTime());
			md.setMonth(i);
			rlist.add(md);
		}
		return rlist;
	}

	public static Date dayEnd(Date d) {
		return new Date(dayBegin(d).getTime() + MS_IN_DAY);
	}

	public static Date dayEnd() {
		return dayEnd(null);
	}

	public static Date dayBegin(TimeZone tz) {
		Calendar c = Calendar.getInstance(tz);
		c.set(Calendar.HOUR_OF_DAY, 1);
		c.set(Calendar.MINUTE, 0);
		c.set(Calendar.SECOND, 0);
		c.set(Calendar.MILLISECOND, 0);
		return c.getTime();

	}

	public static Date dayBegin() {
		return dayBegin((Date) null);
	}

	public static Date dayBegin(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));

		r.setHours(5);
		r.setMinutes(0);
		r.setSeconds(0);

		return r;

	}

	public static Date weekBegin() {
		return weekBegin(null);
	}

	public static Date weekBegin(Date d) {
		Calendar c = Calendar.getInstance();
		c.clear();
		c.setTimeInMillis(d.getTime());
		c.setFirstDayOfWeek(Calendar.MONDAY);
		if (c.get(Calendar.DAY_OF_WEEK) < c.getFirstDayOfWeek()) {
			c.add(Calendar.DATE, -1); // Substract 1 day until first day
			// of week.
		}
		while (c.get(Calendar.DAY_OF_WEEK) > c.getFirstDayOfWeek()) {
			c.add(Calendar.DATE, -1); // Substract 1 day until first day
										// of week.
		}
		return c.getTime();

	}

	public static Date weekEnd(Date d) {
		Calendar c = Calendar.getInstance();
		c.clear();
		c.setTimeInMillis(d.getTime());
		c.setFirstDayOfWeek(Calendar.MONDAY);
		if (c.get(Calendar.DAY_OF_WEEK) < c.getFirstDayOfWeek()) {
			c.add(Calendar.DATE, -1); // Substract 1 day until first day
			// of week.
		}
		while (c.get(Calendar.DAY_OF_WEEK) > c.getFirstDayOfWeek()) {
			c.add(Calendar.DATE, -1); // Substract 1 day until first day
										// of week.
		}
		return new Date(c.getTime().getTime() + 7 * MS_IN_DAY);

	}

	public static Date yearEnd() {
		return yearEnd(null);
	}

	public static Date yearBegin() {
		return yearBegin(null);
	}

	public static Date monthBegin() {
		return monthBegin(null);
	}

	public static Date prevMonthBegin() {
		return prevMonthBegin(null);
	}

	public static Date prevMonthEnd() {
		return prevMonthEnd(null);
	}

	public static Date monthBegin(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));

		r.setDate(1);
		r.setHours(0);
		r.setMinutes(0);
		r.setSeconds(0);

		return r;

	}

	public static Date prevMonthBegin(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));
		// to be checked for 0
		r.setMonth(r.getMonth() - 1);
		r.setDate(0);
		r.setHours(0);
		r.setMinutes(0);
		r.setSeconds(0);

		return r;

	}

	public static Date yearBegin(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));
		r.setMonth(0);
		r.setDate(0);
		r.setHours(0);
		r.setMinutes(0);
		r.setSeconds(0);

		return r;

	}

	public static Date yearEnd(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));
		r.setMonth(11);
		r.setDate(31);
		r.setHours(23);
		r.setMinutes(59);
		r.setSeconds(59);

		return r;

	}

	public static Date monthEnd() {
		return monthEnd(null);
	}

	public static Date monthEnd(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));
		r.setDate(DAYS_IN_MONTH[r.getMonth()]);// to be check for specific month
		r.setHours(23);
		r.setMinutes(59);
		r.setSeconds(59);

		return r;

	}

	public static Date prevMonthEnd(Date d) {
		Date r = (d == null ? new Date() : new Date(d.getTime()));
		r.setMonth(r.getMonth() - 1);// to be check for specific month
		r.setDate(DAYS_IN_MONTH[r.getMonth()]);// to be check for specific month
		r.setHours(23);
		r.setMinutes(59);
		r.setSeconds(59);

		return r;

	}

	public static Date monthBegin(int mth) {
		Date r = new Date();
		r.setMonth(mth);
		r.setDate(0);
		r.setHours(0);
		r.setMinutes(0);
		r.setSeconds(0);

		return r;

	}

	public static Date monthEnd(int mth) {
		Date r = new Date();
		r.setMonth(mth);
		r.setDate(DAYS_IN_MONTH[r.getMonth()]);// to be check for specific month
		r.setHours(23);
		r.setMinutes(59);
		r.setSeconds(59);

		return r;

	}

	public static Date toDayNight() {
		Date d = new Date();
		d.setHours(23);
		d.setMinutes(59);
		d.setSeconds(59);
		return d;
	}

	public static Date toDayMoring() {
		Date d = new Date();
		d.setHours(0);
		d.setMinutes(0);
		d.setSeconds(0);
		return d;
	}

	public static Date getDateAfter(int days) {
		Date formatedUtilDate = null;
		SimpleDateFormat df = new SimpleDateFormat(UTIL_DATE_FORMAT);
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, days);
		String strDate = df.format(cal.getTime());

		try {
			formatedUtilDate = convertStringToUtilDate(strDate);
		} catch (ParseException e) {
		}

		return formatedUtilDate;
	}

	private static boolean checkStringFormat(String stringToBeChecked,
			String dateFormat) throws ParseException {
		boolean flag = false;
		if (stringToBeChecked != null && dateFormat != null) {
			try {

				if (dateFormat.equalsIgnoreCase(UI_DATE_FORMAT)) {
					new SimpleDateFormat(UI_DATE_FORMAT)
							.parse(stringToBeChecked);
					flag = true;
				} else if (dateFormat.equalsIgnoreCase(UTIL_DATE_FORMAT)) {
					new SimpleDateFormat(UTIL_DATE_FORMAT)
							.parse(stringToBeChecked);
					flag = true;
				} else if (dateFormat.equalsIgnoreCase(SQL_DATE_FORMAT)) {
					new java.sql.Date(new SimpleDateFormat(SQL_DATE_FORMAT)
							.parse(stringToBeChecked).getTime());
					flag = true;
				} else {
					new SimpleDateFormat(dateFormat).parse(stringToBeChecked);
					flag = true;
				}

			} catch (ParseException pe) {
				throw new ParseException("Got " + stringToBeChecked + " when "
						+ dateFormat + " format was expected", 0);
			}

		} else
			throw new ParseException("Cann't parse null string", 0);

		return flag;
	}

	/**
	 * Converting String to java.util.Date object
	 * 
	 * @param strDate
	 * @return java.util.Date object
	 * @throws java.text.ParseException
	 * @since
	 */
	public static Date convertStringToUtilDate2(String strDate)
			throws ParseException {

		Date formatedUtilDate = null;
		if (checkStringFormat(strDate, SQL_DATE_FORMAT)) {
			dateFormatter = new SimpleDateFormat(SQL_DATE_FORMAT);
			formatedUtilDate = dateFormatter.parse(strDate);
		}

		return formatedUtilDate;
	}

	public static Date convertStringToUtilDate(String strDate)
			throws ParseException {
		Date formatedUtilDate = null;
		SimpleDateFormat dateFormatter = new SimpleDateFormat(UTIL_DATE_FORMAT);
		formatedUtilDate = dateFormatter.parse(strDate);

		return formatedUtilDate;
	}

	public static Date convertStringToUtilDateTime(String strDate)
			throws ParseException {
		Date formatedUtilDate = null;
		SimpleDateFormat dateFormatter = new SimpleDateFormat(
				DATE_FORMAT_REPORT);
		formatedUtilDate = dateFormatter.parse(strDate);

		return formatedUtilDate;
	}

	public static Date convertMMDDYYYYStringToUtilDate(String strDate,
			TimeZone tz) {
		Date formatedUtilDate = null;
		try {
			SimpleDateFormat dateFormatter = new SimpleDateFormat("MM-dd-yyyy");
			dateFormatter.setTimeZone(tz);
			formatedUtilDate = dateFormatter.parse(strDate);
		} catch (Exception ignore) {

		}
		return formatedUtilDate;
	}

	public static Date convertStringToUtilDate(String strDate, String format)
			throws ParseException {
		Date formatedUtilDate = null;
		SimpleDateFormat dateFormatter = new SimpleDateFormat(format);
		formatedUtilDate = dateFormatter.parse(strDate);

		return formatedUtilDate;
	}

	public static Date convertStringToUtilDateYMD(String strDate)
			throws ParseException {

		Date formatedUtilDate = null;
		if (checkStringFormat(strDate, DATE_FORMAT_YMD)) {
			dateFormatter = new SimpleDateFormat(DATE_FORMAT_YMD);
			formatedUtilDate = dateFormatter.parse(strDate);
		}

		return formatedUtilDate;
	}

	public static Date getFirstUtilDateOfYear(int year) {
		Date formatedUtilDate = null;
		if (year <= 0) {
			formatedUtilDate = MIN_DATE;
		} else {

			dateFormatter = new SimpleDateFormat(UI_DATE_FORMAT);
			try {
				formatedUtilDate = dateFormatter.parse("1-Jan-" + year);
			} catch (ParseException e) {
				formatedUtilDate = MIN_DATE;
			}
		}
		return formatedUtilDate;
	}

	public static Date getLastUtilDateOfYear(int year) {
		Date formatedUtilDate = null;
		if (year <= 0) {
			formatedUtilDate = MAX_DATE;
		} else {
			dateFormatter = new SimpleDateFormat(UI_DATE_FORMAT);
			try {
				formatedUtilDate = dateFormatter.parse("31-Dec-" + year);
			} catch (ParseException e) {
				formatedUtilDate = MAX_DATE;
			}
		}
		return formatedUtilDate;
	}

	public static Date convertUIDateToUtilDate(String strDate)
			throws ParseException {

		Date formatedUtilDate = null;
		if (checkStringFormat(strDate, UI_DATE_FORMAT)) {
			dateFormatter = new SimpleDateFormat(UI_DATE_FORMAT);
			formatedUtilDate = dateFormatter.parse(strDate);
		}

		return formatedUtilDate;

	}

	public static Date convertUIDateToUtilDate(String strDate,
			boolean ignoreExeption) throws ParseException {

		Date formatedUtilDate = null;
		try {
			if (checkStringFormat(strDate, UI_DATE_FORMAT)) {
				dateFormatter = new SimpleDateFormat(UI_DATE_FORMAT);
				formatedUtilDate = dateFormatter.parse(strDate);
			}
		} catch (Exception ignore) {

		}

		return formatedUtilDate;

	}

	public static String convertUtilDateToStringYMD(Date date) {

		String uiDateString = null;
		try {
			if (date != null) {
				SimpleDateFormat dateFormatter = new SimpleDateFormat(
						DATE_FORMAT_YMD);
				uiDateString = dateFormatter.format(date);
			}
		} catch (Exception ignore) {

		}

		return uiDateString;
	}

	public static String convertUtilDateToUIDate(Date date) {

		String uiDateString = null;
		if (date != null) {
			dateFormatter = new SimpleDateFormat(UI_DATE_FORMAT);

			uiDateString = dateFormatter.format(date);
		}

		return uiDateString;
	}

	public static String convertUtilDateToUIDateTime(Date date, TimeZone tz) {

		String uiDateString = null;
		if (date != null) {
			if (dateTimeFormatter == null) {
				dateTimeFormatter = new SimpleDateFormat(UI_DATETIME_FORMAT);
				dateTimeFormatter.setTimeZone(tz);
			}

			uiDateString = dateTimeFormatter.format(date);
		}

		return uiDateString;
	}

	public static Date convertUITimeToUtilDate(String str, Date date,
			TimeZone tz) {
		if (str != null) {
			try {
				timeFormatter = new SimpleDateFormat(UI_TIME_FORMAT);
				timeFormatter.setTimeZone(tz);
				Date _d = timeFormatter.parse(str);
				if (date != null) {
					_d.setYear(date.getYear());
					_d.setMonth(date.getMonth());
					_d.setDate(date.getDate());
				}
				return _d;
			} catch (Exception ignore) {

			}
		}
		return null;
	}

	public static String convertUtilDateToUITime(Date date) {

		String uiDateString = null;
		if (date != null) {
			timeFormatter = new SimpleDateFormat(UI_TIME_FORMAT);

			uiDateString = timeFormatter.format(date);
		}

		return uiDateString;
	}

	public static String convertSecToUIHMS(int sec) {

		StringBuffer sb = new StringBuffer(7);
		int HH = (sec / 3600);
		sec = sec - (HH * 3600);
		int MM = (sec / 60);
		sec = sec - (MM * 60);

		if (HH > 0) {

			sb.append(HH);
			sb.append("h ");
		}

		if (MM > 0) {

			sb.append(MM);
			sb.append("m ");
		}
		if (sec > 0) {
			sb.append(sec);
			sb.append("s");
		}

		return sb.toString();
	}

	public static String convertMininuteToUIHM(int minute) {

		StringBuffer sb = new StringBuffer(7);
		int HH = (minute / 60);
		int MM = minute - (HH * 60);
		if (HH < 10) {
			sb.append("0");
		}
		sb.append(HH);
		sb.append(":");
		if (MM < 10) {
			sb.append("0");
		}
		sb.append(MM);

		return sb.toString();
	}

	public static Date convertUIShortTimeToUtilDate(String date) {

		Date uiDateString = null;
		try {
			if (date != null) {
				shortTimeFormatter = new SimpleDateFormat(UI_SHORTTIME_FORMAT);
				uiDateString = shortTimeFormatter.parse(date);
			}
		} catch (Exception ignore) {

		}

		return uiDateString;
	}

	public static Date convertUIShortTimeToUtilDate(String str, Date date) {
		if (str != null) {
			try {
				timeFormatter = new SimpleDateFormat(UI_SHORTTIME_FORMAT);
				Date _d = timeFormatter.parse(str);
				if (date != null) {
					_d.setYear(date.getYear());
					_d.setMonth(date.getMonth());
					_d.setDate(date.getDate());
				}
				return _d;
			} catch (Exception ignore) {

			}
		}
		return null;
	}

	public static String convertUtilDateToUIShortTime(Date date) {

		String uiDateString = null;
		if (date != null) {
			shortTimeFormatter = new SimpleDateFormat(UI_SHORTTIME_FORMAT);

			uiDateString = shortTimeFormatter.format(date);
		}

		return uiDateString;
	}

	public static String convertUtilDateToMailDate(Date date, String slocale)
			throws ParseException {

		String uiDateString = null;
		if (date != null) {
			Locale oLocale = new Locale(slocale);
			dateFormatter = new SimpleDateFormat(MAIL_DATE_FORMAT, oLocale);

			uiDateString = dateFormatter.format(date);
		}

		return uiDateString;
	}

	public static String convertUtilDateToReportDate(Date date) {
		String uiDateString = null;
		if (date != null) {
			try {
				dateFormatter = new SimpleDateFormat(DATE_FORMAT_REPORT);
				uiDateString = dateFormatter.format(date);
			} catch (Exception ignore) {
			}
		}
		return uiDateString;
	}

	public static Date convertDBDateToUtilDate(String strDate) {

		if (strDate == null || strDate.length() == 0)
			return null;
		Date formatedUtilDate = null;
		try {
			String tempDateStr = changeFormat(strDate, SQL_DATE_FORMAT,
					UTIL_DATE_FORMAT);
			if (checkStringFormat(tempDateStr, UTIL_DATE_FORMAT)) {

				formatedUtilDate = convertStringToUtilDate(tempDateStr);
			}
		} catch (ParseException e) {
			return null;
		}
		return formatedUtilDate;
	}

	public static String changeFormat(String strDate, String strFormatFrom,
			String strFormatTo) throws ParseException {

		String formattedStrDate = null;
		SimpleDateFormat tmpformatter = new SimpleDateFormat(strFormatFrom);
		Date tmpUtilDate = tmpformatter.parse(strDate);
		tmpformatter = new SimpleDateFormat(strFormatTo);

		formattedStrDate = tmpformatter.format(tmpUtilDate);

		return formattedStrDate;
	}

	public static Date getDateByFormat(String strDate, String strFormatFrom)
			throws ParseException {

		SimpleDateFormat tmpformatter = new SimpleDateFormat(strFormatFrom);
		Date tmpUtilDate = tmpformatter.parse(strDate);

		return tmpUtilDate;
	}

	public static long getTimeDiffInSec(Date from, Date to) {
		long retVal = 0;
		Float temp = 0.0f;
		if (from != null && to != null) {
			retVal = to.getTime() - from.getTime();
			temp = retVal / 1000f;
		}
		return temp.longValue();
	}

	public static long getDateDiffByDays(Date from, Date to) {
		long retVal = 0;
		Float temp = 0.0f;
		if (from != null && to != null) {
			retVal = to.getTime() - from.getTime();
			temp = retVal / 86400000f;
		}

		return temp.longValue();
	}

	public static int getDateDiffInCalendarDays(Date to, Date from, boolean abs) {
		if (from != null && to != null) {
			Calendar l_to = Calendar.getInstance();
			Calendar l_from = Calendar.getInstance();

			int mulf = 1;
			if (to.getTime() >= from.getTime()) {
				l_to.set(to.getYear(), to.getMonth(), to.getDate(), 24, 0, 0);
				l_from.set(from.getYear(), from.getMonth(), from.getDate(), 0,
						0, 0);
			} else {
				l_to.set(from.getYear(), from.getMonth(), from.getDate(), 24,
						0, 0);
				l_from.set(to.getYear(), to.getMonth(), to.getDate(), 0, 0, 0);
				mulf = -1;
			}

			int dayDiff = (int) Math.ceil((l_to.getTimeInMillis() - l_from
					.getTimeInMillis()) / MS_IN_DAY);
			// System.out.println(to+"....."+((l_to.getTimeInMillis() -
			// l_from.getTimeInMillis())%MS_IN_DAY));
			return (abs ? dayDiff : dayDiff * mulf);
		}
		return -1;
	}

	public static int getDateDiffInCalendarDays(Date to, Date from) {
		return getDateDiffInCalendarDays(to, from, true);
	}

	/**
	 * Converting String to java.sql.Date object
	 * 
	 * @param strDate
	 * @return java.sql.Date object
	 * @throws java.text.ParseException
	 * @since
	 */
	public static java.sql.Date convertStringToSqlDate(String strDate)
			throws ParseException {

		java.sql.Date sqlDate = null;
		java.util.Date utilDate = null;

		if (checkStringFormat(strDate, SQL_DATE_FORMAT)) {
			dateFormatter = new SimpleDateFormat(SQL_DATE_FORMAT);
			utilDate = dateFormatter.parse(strDate);
		}
		sqlDate = new java.sql.Date(utilDate.getTime());

		return sqlDate;
	}

	/**
	 * Converting java.util.Date object to String
	 * 
	 * @param date
	 * @return converted date as string
	 * @throws none.
	 * @since
	 */
	public static String convertUtilDateToString2(Date date) {
		String formattedDate = null;
		if (date != null) {
			dateFormatter = new SimpleDateFormat(SQL_DATE_FORMAT);
			formattedDate = dateFormatter.format(date);
		}
		return formattedDate;
	}

	public static String convertUtilDateToString(Date date) {

		String formattedDate = null;
		if (date != null) {
			dateFormatter = new SimpleDateFormat(UTIL_DATE_FORMAT);
			formattedDate = dateFormatter.format(date);
		}
		return formattedDate;
	}

	public static String convertUtilDateTimeToString(Date date) {

		String formattedDate = null;
		if (date != null) {
			dateFormatter = new SimpleDateFormat(SQL_DATETIME_FORMAT);
			formattedDate = dateFormatter.format(date);
		}
		return formattedDate;
	}

	/**
	 * Converting java.sql.Date object to String
	 * 
	 * @param date
	 * @return converted date as string
	 * @throws none.
	 * @since
	 */
	public static String convertSqlDateToString(java.sql.Date sqlDate) {
		String formattedDate = null;
		if (sqlDate != null) {
			Date utilDate = new java.sql.Date(sqlDate.getTime());
			dateFormatter = new SimpleDateFormat(SQL_DATE_FORMAT);

			formattedDate = dateFormatter.format(utilDate);
		}
		return formattedDate;
	}

	/**
	 * Retrieves time stamp of the provided sql date object
	 * 
	 * @param sqlDate
	 * @return time stamp
	 * @throws none.
	 * @since
	 */
	public static java.sql.Timestamp convertUtilDateToSqlTimestamp(Date utilDate) {

		java.sql.Timestamp sqlTimestamp = null;
		if (utilDate != null) {
			java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
			sqlTimestamp = new java.sql.Timestamp(sqlDate.getTime());
		}

		return sqlTimestamp;
	}

	public static java.sql.Date convertUtilDateToSqlDate(java.util.Date Dt)
			throws ParseException {
		java.sql.Date sqlDate = null;
		if (Dt != null)
			sqlDate = new java.sql.Date(Dt.getTime());

		return sqlDate;
	}

	public static java.sql.Timestamp getCurrSqlDateTime() throws ParseException {
		return convertUtilDateToSqlTimestamp(new java.util.Date(
				System.currentTimeMillis()));
	}

	public static java.util.Date addDaysToString(String strDate, int intOffset)
			throws ParseException {
		Calendar clndr = Calendar.getInstance();
		clndr.setTime(convertStringToUtilDate(strDate));
		clndr.add(Calendar.DATE, intOffset);

		return clndr.getTime();
	}

	public static String convertUtilDateToString(java.util.Date date,
			String strFormat) {
		SimpleDateFormat givenformatter = new SimpleDateFormat(strFormat);
		String formattedDate = givenformatter.format(date);

		return formattedDate;
	}

	public static java.util.Date addMonthToUtilDate(java.util.Date utilDate,
			long intOffset) {
		Calendar clndr = Calendar.getInstance();
		clndr.setTimeInMillis(utilDate.getTime()
				+ (intOffset * DAYS_IN_MONTH[utilDate.getMonth()] * MS_IN_DAY));

		return clndr.getTime();
	}

	public static java.util.Date addDaysToUtilDate(java.util.Date utilDate,
			long intOffset) {
		Calendar clndr = Calendar.getInstance();
		clndr.setTimeInMillis(utilDate.getTime() + (intOffset * MS_IN_DAY));

		return clndr.getTime();
	}

	public static java.util.Date addSecToUtilDate(java.util.Date utilDate,
			int intOffset) {

		return new Date(utilDate.getTime() + intOffset * 1000);
	}

	public static java.util.Date addMinToUtilDate(java.util.Date utilDate,
			int intOffset) {

		return new Date(utilDate.getTime() + intOffset * 60 * 1000);
	}

	public static java.util.Date addHourToUtilDate(java.util.Date utilDate,
			float intOffset) {
		return addHourToUtilDate(utilDate, intOffset, false);
	}

	public static java.util.Date addHourToUtilDate(java.util.Date utilDate,
			float intOffset, boolean sameDay) {
		Calendar clndr = Calendar.getInstance();
		clndr.setTimeInMillis(utilDate.getTime()
				+ (long) (intOffset * DateUtil.MS_IN_HOUR));
		if (sameDay) {
			Date dayEnd = dayEnd(utilDate);
			if (clndr.getTimeInMillis() > dayEnd.getTime()) {
				// goes beyond today
				clndr.setTimeInMillis(dayEnd.getTime());
			}
		}

		/*
		 * if (clndr.get(Calendar.AM_PM) == Calendar.PM) { if
		 * (clndr.get(Calendar.HOUR) + intOffset < 12) {
		 * clndr.add(Calendar.HOUR, intOffset); } else {
		 * clndr.set(Calendar.AM_PM, Calendar.PM); clndr.set(Calendar.HOUR, 11);
		 * clndr.set(Calendar.MINUTE, 59); clndr.set(Calendar.SECOND, 59); } }
		 * else { if (clndr.get(Calendar.HOUR) + intOffset >= 24) {
		 * clndr.set(Calendar.AM_PM, Calendar.PM); clndr.set(Calendar.HOUR, 11);
		 * clndr.set(Calendar.MINUTE, 59); clndr.set(Calendar.SECOND, 59);
		 * 
		 * } else if (clndr.get(Calendar.HOUR) + intOffset > 12) {
		 * clndr.set(Calendar.AM_PM, Calendar.PM); clndr.add(Calendar.HOUR,
		 * intOffset - 12); } else { clndr.add(Calendar.HOUR, intOffset); } }
		 */

		return clndr.getTime();
	}

	public static java.util.Date getCurrUtilDate() {
		return new java.util.Date(System.currentTimeMillis());
	}

	public static String getCurrWkStDate() throws ParseException {
		String strWkStDt = null;
		java.util.Date utilDt = new java.util.Date(System.currentTimeMillis());
		Calendar clndr = Calendar.getInstance();
		clndr.setTime(utilDt);

		int intSub = 0;

		if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY) {
			intSub = 0;
		} else if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.TUESDAY) {
			intSub = -1;
		} else if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.WEDNESDAY) {
			intSub = -2;
		} else if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY) {
			intSub = -3;
		} else if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
			intSub = -4;
		} else if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY) {
			intSub = -5;
		} else if (clndr.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
			intSub = -6;
		}

		utilDt = addDaysToUtilDate(utilDt, intSub);
		strWkStDt = convertUtilDateToString(utilDt);

		return strWkStDt;
	}

	public static long getDateDiffByMinutes(Date from, Date to) {
		long retVal = 0;
		Float temp = 0.0f;
		if (from != null && to != null) {
			retVal = to.getTime() - from.getTime();
			temp = retVal / 60000f;
		}

		return temp.longValue();
	}

	public static long getDateDiffBySec(Date from, Date to) {
		long retVal = 0;

		if (from != null && to != null) {
			retVal = (long) (to.getTime() / 1000)
					- (long) (from.getTime() / 1000);

		}

		return retVal;
	}

	public static Date convertDBDateStringToUtilDate(String strDate)
			throws ParseException {

		Date formatedUtilDate = null;
		String tempDateStr = changeFormat(strDate, SQL_DATE_FORMAT,
				UTIL_DATE_FORMAT);
		if (checkStringFormat(tempDateStr, UTIL_DATE_FORMAT)) {

			formatedUtilDate = convertStringToUtilDate(tempDateStr);
		}

		return formatedUtilDate;
	}

	public static long getUTCinSec(Date d) {
		return d.getTime() / 1000;
	}

	public static long getUTCinSec(Date d, int duration) {
		return (d.getTime() / 1000) + duration;
	}

	public static String getTodayDate() {
		String uiDateString = null;
		Date date = new Date();
		if (date != null) {
			dateFormatter = new SimpleDateFormat(UI_DATE_FORMAT);
			uiDateString = dateFormatter.format(date);
		}
		return uiDateString;
	}

	public static String getBandName(Date date, String type) {
		String key = "";
		if ("H".equalsIgnoreCase(type)) {
			key = String.valueOf(date.getYear())
					+ String.valueOf(date.getMonth())
					+ String.valueOf(date.getDate())
					+ String.valueOf(date.getHours());
		} else if ("D".equalsIgnoreCase(type)) {
			key = String.valueOf(date.getYear())
					+ String.valueOf(date.getMonth())
					+ String.valueOf(date.getDate());

		} else if ("W".equalsIgnoreCase(type)) {
			date = weekBegin(date);
			key = String.valueOf(date.getYear())
					+ String.valueOf(date.getMonth())
					+ String.valueOf(date.getDate());
		} else if ("M".equalsIgnoreCase(type)) {
			key = String.valueOf(date.getYear())
					+ String.valueOf(date.getMonth());
		} else if ("Q".equalsIgnoreCase(type)) {
			key = String.valueOf(date.getYear())
					+ String.valueOf(date.getMonth());
		} else if ("Y".equalsIgnoreCase(type)) {
			key = String.valueOf(date.getYear());

		}
		return key;

	}

	public static String getBandName(Date date, int bandSize) {
		int value = date.getHours() * 60 + date.getMinutes();
		int m = (int) (date.getMinutes() / bandSize);
		String key = date.getHours() + ":" + m;
		return key;
	}

	public static String formatHM(int h, int m) {
		String key = (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m;
		return key;
	}

	public static String getTimeBandName(Date date, int bandSize) {

		int h = date.getHours();
		int m = ((int) (date.getMinutes() / bandSize)) * bandSize;

		String key = (h < 10 ? "0" : "") + h + ":" + (m < 10 ? "0" : "") + m;
		return key;
	}

	public static boolean isSameDay(Date d1, Date d2) {
		return (d1.getYear() == d2.getYear() && d1.getMonth() == d2.getMonth() && d1
				.getDate() == d2.getDate());
	}

	public static boolean isSameDay(Date d1, Date d2, TimeZone zone) {
		if (zone == null) {
			return (d1.getYear() == d2.getYear()
					&& d1.getMonth() == d2.getMonth() && d1.getDate() == d2
					.getDate());
		} else {
			Calendar cal1 = Calendar.getInstance(zone);
			cal1.setTime(d1);
			Calendar cal2 = Calendar.getInstance(zone);
			cal2.setTime(d2);

			return (cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR)
					&& cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH) && cal1
						.get(Calendar.DAY_OF_MONTH) == cal2
					.get(Calendar.DAY_OF_MONTH));

		}
	}

	public static boolean isMidnight(Date d1, TimeZone zone) {
		if (zone == null) {
			return (d1.getHours() == 0 && d1.getHours() == 0 && d1.getMinutes() == 0);
		} else {
			Calendar cal1 = Calendar.getInstance(zone);
			cal1.setTime(d1);

			return (cal1.get(Calendar.HOUR_OF_DAY) == 0 && cal1
					.get(Calendar.MINUTE) == 0);

		}
	}

	public static boolean isWithinTime(Date t, Date t1, Date t2) {
		int s = t.getHours() * 3600 + t.getMinutes() * 60 + t.getSeconds();
		int s1 = t1.getHours() * 3600 + t1.getMinutes() * 60 + t1.getSeconds();
		int s2 = t2.getHours() * 3600 + t2.getMinutes() * 60 + t2.getSeconds();
		return (s >= s1 && s <= s2);
	}

	public static String getYMDKey(Date d) {
		if (d == null) {
			return "_";
		}
		return String.valueOf(d.getYear()) + String.valueOf(d.getMonth())
				+ String.valueOf(d.getDate());
	}

	public static String getYMWKey(Date d) {
		if (d == null) {
			return "_";
		}
		Date wd = DateUtil.weekBegin(d);
		int idx = DateUtil.getWeekDayId(d);
		return String.valueOf(wd.getYear()) + String.valueOf(wd.getMonth())
				+ String.valueOf(wd.getDate()) + "_" + String.valueOf(idx);
	}

	public static String getDateTimeKey(Date d) {
		if (d == null) {
			return "_";
		}
		return String.valueOf(d.getYear()) + String.valueOf(d.getMonth())
				+ String.valueOf(d.getDate()) + "_"
				+ String.valueOf(d.getHours()) + ":"
				+ String.valueOf(d.getMinutes());
	}

	public static Date parseDate(String ds) {
		Date d = null;
		try {
			try {
				long ts = Long.parseLong(ds);
				d = new Date(ts);
			} catch (NumberFormatException ne) {
				if (ds.length() == 10) {
					d = DateUtil.dayBegin(new SimpleDateFormat("yyyy-MM-dd")
							.parse(ds));
				} else {
					d = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(ds);
				}
			}
		} catch (Exception ignore) {
		}
		return d;
	}

	public static String formatDuration(int _v) {
		StringBuilder _ret = new StringBuilder();
		if (_v < 0) {
			_v = -1 * _v;
			_ret.append("-");
		}
		int _h = _v / 3600;
		if (_h > 0) {
			_v = _v - _h * 3600;
		}
		int _m = _v / 60;
		if (_m > 0) {
			_v = _v - _m * 60;
		}
		int _s = _v;

		if (_h > 0) {
			_ret.append(_h);
			_ret.append(" hr. ");
		}
		if (_m > 0) {
			_ret.append(_m);
			_ret.append(" min. ");
		}
		if (_s > 0) {
			_ret.append(_s);
			_ret.append(" sec.");
		}
		return _ret.toString();
	}

	public static boolean equalDate(Date d1, Date d2) {
		return (d1.getYear() == d2.getYear() && d1.getMonth() == d2.getMonth() && d1
				.getDate() == d2.getDate());
	}

	public static boolean equalDateTime(Date d1, Date d2) {
		// value is less than one minute
		return (Math.abs(d1.getTime() - d2.getTime()) <= 60000);
	}

	public static Date truncHour(Date d) {
		d.setHours(0);
		truncMin(d);
		return d;
	}

	public static Date truncMin(Date d) {
		d.setMinutes(0);
		truncSec(d);
		return d;
	}

	public static Date truncSec(Date d) {
		d.setSeconds(0);
		truncMilisec(d);
		return d;
	}

	public static Date truncMilisec(Date d) {
		d.setTime(d.getTime() / 1000 * 1000);
		return d;
	}

	public static Date toEST(Date d) {
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		c.setTime(d);
		c.add(Calendar.HOUR, -5);
		return c.getTime();
	}

	public static Date toUTC(Date d) {
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
		c.setTime(d);
		c.add(Calendar.HOUR, 5);
		return c.getTime();
	}

	public static Date localDate() {
		Calendar c = Calendar.getInstance(TimeZone.getTimeZone("EST"));
		return c.getTime();
	}
}
