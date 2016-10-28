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

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.stream.StreamSource;

import org.energyos.espi.common.domain.Customer;
import org.energyos.espi.common.domain.CustomerAccount;
import org.energyos.espi.common.domain.CustomerAgreement;
import org.energyos.espi.common.domain.EndDevice;
import org.energyos.espi.common.domain.IdentifiedObject;
import org.energyos.espi.common.domain.Routes;
import org.energyos.espi.common.domain.ServiceLocation;
import org.energyos.espi.common.domain.ServiceSupplier;
import org.energyos.espi.common.domain.Subscription;
import org.energyos.espi.common.domain.UsagePoint;
import org.energyos.espi.common.models.atom.FeedType;
import org.energyos.espi.common.models.atom.LinkType;
import org.energyos.espi.common.service.CustomerAccountService;
import org.energyos.espi.common.service.CustomerAgreementService;
import org.energyos.espi.common.service.CustomerService;
import org.energyos.espi.common.service.EndDeviceService;
import org.energyos.espi.common.service.ExportService;
import org.energyos.espi.common.service.ImportService;
import org.energyos.espi.common.service.ResourceService;
import org.energyos.espi.common.service.ServiceLocationService;
import org.energyos.espi.common.service.ServiceSupplierService;
import org.energyos.espi.common.service.SubscriptionService;
import org.energyos.espi.common.service.UsagePointService;
import org.energyos.espi.common.utils.ExportFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.sun.syndication.io.FeedException;

@RestController
public class CustomerRESTController {
	private Logger log = LoggerFactory.getLogger(CustomerRESTController.class);

	@Autowired
	private ExportService exportService;

	@Autowired
	private ResourceService resourceService;

	@Autowired
	private EndDeviceService endDeviceService;

	@Autowired
	private CustomerService customerService;

	@Autowired
	private CustomerAccountService customerAccountService;

	@Autowired
	private CustomerAgreementService customerAgreementService;

	@Autowired
	private ServiceLocationService serviceLocationService;
	
	@Autowired
	private ServiceSupplierService serviceSupplierService;

	@Autowired
	private SubscriptionService subscriptionService;
	
	@Autowired
	private UsagePointService usagePointService;

	@Autowired
	private org.energyos.espi.common.service.RetailCustomerUnmarshallService retailCustomerUnmarshallService;

	@Autowired
	@Qualifier("atomMarshaller")
	private Jaxb2Marshaller marshaller;

	@ExceptionHandler(Exception.class)
	@ResponseStatus(HttpStatus.BAD_REQUEST)
	public void handleGenericException() {
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void show(HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerDetails(retailCustomerId, customerId,
					response.getOutputStream(), new ExportFilter(params));
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}


	@RequestMapping(value = Routes.GET_RETAIL_CUSTOMER_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void batchCustomerDetails(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long subscriptionId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			Subscription subscription = subscriptionService
					.findById(subscriptionId);

			Long retailCustomerId = subscription.getRetailCustomer().getId();
			exportService.exportCustomerDetailsForBatch(retailCustomerId,
					response.getOutputStream(), new ExportFilter(params));
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountForCustomer(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerAccountDetails(retailCustomerId,
					customerId, response.getOutputStream(), new ExportFilter(params));
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_SPECIFIC_ACCOUNT_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showSpecificAccountForCustomer(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId, @PathVariable Long accountId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerSpecificAccountDetails(
					retailCustomerId, customerId, accountId,
					response.getOutputStream(), new ExportFilter(params));
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_AGREEMENT_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementsForCustomer(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId, @PathVariable Long accountId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerAccountAgreementDetails(
					retailCustomerId, customerId, accountId,
					response.getOutputStream(), new ExportFilter(params));

		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_SPECIFIC_AGREEMENT_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showSpecificAccountAgreementsForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long accountId,
			@PathVariable Long customerAgreementId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerAccountSpecificAgreementDetails(
					retailCustomerId, customerId, accountId,
					customerAgreementId, response.getOutputStream(),
					new ExportFilter(params));
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_AGREEMENT_SERVICE_LOCATION_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementServiceLocationsForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerAccountAgreementServiceLocationDetails(
					retailCustomerId, customerId, customerAccountId,
					customerAgreementId, response.getOutputStream(),
					new ExportFilter(params));
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_AGREEMENT_SPECIFIC_SERVICE_LOCATION_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementSpecifcServiceLocationForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService
					.exportCustomerAccountAgreementSpecificServiceLocationDetails(
							retailCustomerId, customerId, customerAccountId,
							customerAgreementId, serviceLocationId,
							response.getOutputStream(),
							new ExportFilter(params));

		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_AGREEMENT_SERVICE_SUPPLIER_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementServiceSuppliersForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerAccountAgreementServiceSupplierDetails(
					retailCustomerId, customerId, customerAccountId,
					customerAgreementId, response.getOutputStream(),
					new ExportFilter(params));

		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_AGREEMENT_SPECIFIC_SERVICE_SUPPLIER_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementSpecifcServiceSupplierForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceSupplierId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService
					.exportCustomerAccountAgreementSpecificServiceSupplierDetails(
							retailCustomerId, customerId, customerAccountId,
							customerAgreementId, serviceSupplierId,
							response.getOutputStream(),
							new ExportFilter(params));

		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	
	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_ENDDEVICE_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementServiceLocationEndDeviceForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long accountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {

		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService.exportCustomerAccountAgreementServiceLocationEndDeviceDetails(
					retailCustomerId, customerId, accountId,
					customerAgreementId, serviceLocationId,
					response.getOutputStream(), new ExportFilter(params));

		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.RETAIL_CUSTOMER_ACCOUNT_SPECIFIC_ENDDEVICE_INFORMATION, method = RequestMethod.GET, produces = "application/atom+xml")
	public void showAccountAgreementServiceLocationSpecificEndDeviceForCustomer(
			HttpServletRequest request, HttpServletResponse response,
			@PathVariable Long retailCustomerId, @PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId,
			@PathVariable Long endDeviceId,
			@RequestParam Map<String, String> params) throws IOException,
			FeedException {
		response.setContentType(MediaType.APPLICATION_ATOM_XML_VALUE);
		try {
			exportService
					.exportCustomerAccountAgreementServiceLocationSpecificEndDeviceDetails(
							retailCustomerId, customerId, customerAccountId,
							customerAgreementId, serviceLocationId,
							endDeviceId, response.getOutputStream(),
							new ExportFilter(params));

		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}



	@RequestMapping(value = Routes.DELETE_SPECIFIC_CUSTOMER, method = RequestMethod.DELETE)
	public void deleteCustomer(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId) throws IOException,FeedException {
		try{
			customerService.deleteById(customerId);
	} catch (Exception e) {
		log.warn("Exception", e);
		response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	}
		
	}

	@RequestMapping(value = Routes.DELETE_SPECIFIC_CUSTOMER_ACCOUNT, method = RequestMethod.DELETE)
	public void deleteCustomerAccount(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@PathVariable Long customerAccountId) throws IOException,FeedException {
		try {
			customerAccountService.deleteById(customerAccountId);
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.DELETE_SPECIFIC_CUSTOMER_AGREEMENT, method = RequestMethod.DELETE)
	public void deleteCustomerAgreement(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId) throws IOException,FeedException {
		try {
			customerAgreementService.deleteById(customerAgreementId);
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.DELETE_SPECIFIC_SERVICE_LOCATION, method = RequestMethod.DELETE)
	public void deleteServiceLocation(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId) throws IOException,FeedException {
		try {
			serviceLocationService.deleteById(serviceLocationId);
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	@RequestMapping(value = Routes.DELETE_SPECIFIC_SERVICE_SUPPLIER, method = RequestMethod.DELETE)
	public void deleteServiceSupplier(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceSupplierId) throws IOException,FeedException {
		try {
			serviceSupplierService.deleteById(serviceSupplierId);
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	
	@RequestMapping(value = Routes.DELETE_SPECIFIC_ENDDEVICE_INFORMATION, method = RequestMethod.DELETE)
	public void deleteEndDevice(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId,
			@PathVariable Long endDeviceId) throws IOException,FeedException {
		try {
			endDeviceService.deleteById(endDeviceId);
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	

	
	@RequestMapping(value = Routes.POST_CUSTOMER, method = RequestMethod.POST, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void createCustomer(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@RequestBody String customerXML) throws IOException {
		try {
			Customer customer = null;
			InputStream is = null;
			is = new ByteArrayInputStream(customerXML.getBytes());

			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);
			for (IdentifiedObject identifiedObject : ibList) {
				customer = (Customer) identifiedObject;
			}
			if (customer != null) {
				customer.setUUID(UUID.randomUUID());
				customer.setRetailCustomerId(retailCustomerId);
				customerService.createCustomer(customer);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.POST_CUSTOMER_ACCOUNT, method = RequestMethod.POST, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void createCustomerAccount(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@RequestBody String customerAccountXML) throws IOException {
		try {
			CustomerAccount custAcc = null;
			InputStream is = null;
			is = new ByteArrayInputStream(customerAccountXML.getBytes());

			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);
			for (IdentifiedObject identifiedObject : ibList) {
				custAcc = (CustomerAccount) identifiedObject;
			}
			if (custAcc != null) {
				custAcc.setUUID(UUID.randomUUID());
				Customer customer= customerService.findById(customerID);
				custAcc.setCustomer(customer);
				customerAccountService.createCustomerAccount(custAcc);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.POST_CUSTOMER_AGREEMENT, method = RequestMethod.POST, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void createCustomerAgreement(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@RequestBody String customerAgreementXML) throws IOException {

		try {
			CustomerAgreement custAgreement = null;
			InputStream is = null;
			is = new ByteArrayInputStream(customerAgreementXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				custAgreement = (CustomerAgreement) identifiedObject;
			}
			if (custAgreement != null) {
				CustomerAccount customerAccount= customerAccountService.findById(customerAccountID);
				custAgreement.setCustomerAccount(customerAccount);
				custAgreement.setUUID(UUID.randomUUID());
				customerAgreementService.createCustomerAgreement(custAgreement);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.POST_SERVICE_LOCATION, method = RequestMethod.POST, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void createServiceLocation(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@PathVariable Long customerAgreementID,
			@RequestBody String serviceLocationXML) throws IOException {
		try {
			ServiceLocation serviceLocation = null;
			InputStream is = null;
			is = new ByteArrayInputStream(serviceLocationXML.getBytes());

			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				serviceLocation = (ServiceLocation) identifiedObject;
			}
			if (serviceLocation != null) {
				CustomerAgreement custAgreement= customerAgreementService.findById(customerAgreementID);
				serviceLocation.setCustomerAgreement(custAgreement);
				serviceLocation.setUUID(UUID.randomUUID());
				serviceLocationService.createServiceLocation(serviceLocation);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			
		}
	}
	
	
	@RequestMapping(value = Routes.POST_SERVICE_SUPPLIER, method = RequestMethod.POST, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void createServiceSupplier(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@PathVariable Long customerAgreementID,
			@RequestBody String serviceSupplierXML) throws IOException {
		try {
			ServiceSupplier serviceSupplier = null;
			InputStream is = null;
			is = new ByteArrayInputStream(serviceSupplierXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				serviceSupplier = (ServiceSupplier) identifiedObject;
			}
			if (serviceSupplier != null) {
				CustomerAgreement custAgreement= customerAgreementService.findById(customerAgreementID);
				serviceSupplier.setCustomerAgreement(custAgreement);
				serviceSupplier.setUUID(UUID.randomUUID());
				serviceSupplierService.createServiceSupplier(serviceSupplier);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			
		}
	}
	
	
	@RequestMapping(value = Routes.POST_ENDDEVICE_INFORMATION, method = RequestMethod.POST, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void createEndDevice(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId,
			@RequestBody String endDeviceXML) throws IOException {
		try {
			EndDevice endDevice = null;
			InputStream is = null;
			is = new ByteArrayInputStream(endDeviceXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				endDevice = (EndDevice) identifiedObject;
			}
			if (endDevice != null) {
				ServiceLocation serviceLocation = serviceLocationService.findById(serviceLocationId);
				endDevice.setServiceLocation(serviceLocation);
				endDevice.setUUID(UUID.randomUUID());
				endDeviceService.createEndDevice(endDevice);;
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.PUT_CUSTOMER, method = RequestMethod.PUT, consumes = MediaType.TEXT_PLAIN_VALUE)
	@ResponseBody
	public void mergeCustomer(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID, @RequestBody String customerEntry)
			throws IOException {
		try {
			Customer customer=null;
			InputStream is = new ByteArrayInputStream(customerEntry.getBytes());
			List<IdentifiedObject> customerList = retailCustomerUnmarshallService.unmarshall(is);
			for (IdentifiedObject customerObject : customerList) {
				customer=(Customer) customerObject;
			}
			if (customer != null) {
				customer.setId(customerID);
				customerService.mergeCustomer(customer);
				log.info("Successful");
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.PUT_CUSTOMER_ACCOUNT, method = RequestMethod.PUT, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void mergeCustomerAccount(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@RequestBody String customerAccountXML) throws IOException {
		try {
			CustomerAccount custAcc = null;
			InputStream is = null;
			is = new ByteArrayInputStream(customerAccountXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				custAcc = (CustomerAccount) identifiedObject;
			}
			if (custAcc != null) {
				log.info("--CustomerAccount Details--" + custAcc.getName());
				custAcc.setId(customerAccountID);
				customerAccountService.mergeCustomerAccount(custAcc);
			}
			
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.PUT_CUSTOMER_AGREEMENT, method = RequestMethod.PUT, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void mergeCustomerAgreement(HttpServletRequest request,
			HttpServletResponse response,@PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@PathVariable Long customerAggreementID,
			@RequestBody String customerAgreementXML) throws IOException {
		try {
			CustomerAgreement custAgreement = null;
			InputStream is = null;
			is = new ByteArrayInputStream(customerAgreementXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				custAgreement = (CustomerAgreement) identifiedObject;
			}
			if (custAgreement != null) {
				custAgreement.setId(customerAggreementID);
			customerAgreementService.mergeCustomerAgreement(custAgreement);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.PUT_SERVICE_LOCATION, method = RequestMethod.PUT, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void mergeServiceLocation(HttpServletRequest request,
			HttpServletResponse response,@PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@PathVariable Long customerAgreementID,
			@PathVariable Long serviceLocationID,
			@RequestBody String serviceLocationXML) throws IOException {
		try {
			ServiceLocation serviceLocation = null;
			InputStream is = null;
			is = new ByteArrayInputStream(serviceLocationXML.getBytes());

			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);
			for (IdentifiedObject identifiedObject : ibList) {
				serviceLocation = (ServiceLocation) identifiedObject;
			}
			if (serviceLocation != null) {
				serviceLocation.setId(serviceLocationID);
				serviceLocationService.mergeServiceLocation(serviceLocation);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}
	
	
	@RequestMapping(value = Routes.PUT_SERVICE_SUPPLIER, method = RequestMethod.PUT, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void mergeServiceSupplier(HttpServletRequest request,
			HttpServletResponse response,@PathVariable Long retailCustomerId,
			@PathVariable Long customerID,
			@PathVariable Long customerAccountID,
			@PathVariable Long customerAgreementID,
			@PathVariable Long serviceSupplierID,
			@RequestBody String serviceSupplierXML) throws IOException {
		try {
			ServiceSupplier serviceSupplier = null;
			InputStream is = null;
			is = new ByteArrayInputStream(serviceSupplierXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);
			for (IdentifiedObject identifiedObject : ibList) {
				serviceSupplier = (ServiceSupplier) identifiedObject;
			}
			if (serviceSupplier != null) {
				serviceSupplier.setId(serviceSupplierID);
				serviceSupplierService.mergeServiceSupplier(serviceSupplier);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	@RequestMapping(value = Routes.PUT_ENDDEVICE_INFORMATION, method = RequestMethod.PUT, consumes = MediaType.TEXT_PLAIN_VALUE)
	public void mergeEndDevice(HttpServletRequest request,
			HttpServletResponse response,@PathVariable Long retailCustomerId,
			@PathVariable Long customerId,
			@PathVariable Long customerAccountId,
			@PathVariable Long customerAgreementId,
			@PathVariable Long serviceLocationId,
			@PathVariable Long endDeviceId,
			@RequestBody String endDeviceXML) throws IOException {
		try {
			EndDevice endDevice = null;
			InputStream is = null;
			is = new ByteArrayInputStream(endDeviceXML.getBytes());
			List<IdentifiedObject> ibList = retailCustomerUnmarshallService
					.unmarshall(is);

			for (IdentifiedObject identifiedObject : ibList) {
				endDevice = (EndDevice) identifiedObject;
			}
			if (endDevice != null) {
				endDevice.setId(endDeviceId);
				endDeviceService.mergeEndDevice(endDevice);
			}
		} catch (Exception e) {
			log.warn("Exception", e);
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	public ExportService getExportService() {
		return this.exportService;
	}

	// --------------------------------------------------------------------
	

	
	
}
