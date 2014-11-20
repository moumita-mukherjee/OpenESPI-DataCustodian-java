package org.energyos.espi.datacustodian.bean;

public class ApplicationInfromationForm {
	private String clientId;

	public String getClientId() {
		return clientId;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	private String clientSecret;

	public String getClientSecret() {
		return clientSecret;
	}

	public void setClientSecret(String clientSecret) {
		this.clientSecret = clientSecret;
	}

	private String error = null;

	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}
}
