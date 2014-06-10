package org.energyos.espi.datacustodian.bean;

public class DatePeriodBean {
	private long prevUsagetimeMin;
	public long getPrevUsagetimeMin() {
		return prevUsagetimeMin;
	}
	public void setPrevUsagetimeMin(long prevUsagetimeMin) {
		this.prevUsagetimeMin = prevUsagetimeMin;
	}
	public long getPrevUsagetimeMax() {
		return prevUsagetimeMax;
	}
	public void setPrevUsagetimeMax(long prevUsagetimeMax) {
		this.prevUsagetimeMax = prevUsagetimeMax;
	}
	public long getNextUsagetimeMin() {
		return nextUsagetimeMin;
	}
	public void setNextUsagetimeMin(long nextUsagetimeMin) {
		this.nextUsagetimeMin = nextUsagetimeMin;
	}
	public long getNextUsagetimeMax() {
		return nextUsagetimeMax;
	}
	public void setNextUsagetimeMax(long nextUsagetimeMax) {
		this.nextUsagetimeMax = nextUsagetimeMax;
	}
	private long prevUsagetimeMax;
	private long nextUsagetimeMin;
	private long nextUsagetimeMax;
}
