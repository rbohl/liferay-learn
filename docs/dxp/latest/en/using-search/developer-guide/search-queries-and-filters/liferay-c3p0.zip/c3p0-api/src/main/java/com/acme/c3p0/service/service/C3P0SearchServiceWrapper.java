/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.acme.c3p0.service.service;

import com.liferay.portal.kernel.service.ServiceWrapper;

/**
 * Provides a wrapper for {@link C3P0SearchService}.
 *
 * @author Brian Wing Shun Chan
 * @see C3P0SearchService
 * @generated
 */
public class C3P0SearchServiceWrapper
	implements C3P0SearchService, ServiceWrapper<C3P0SearchService> {

	public C3P0SearchServiceWrapper(C3P0SearchService c3p0SearchService) {
		_c3p0SearchService = c3p0SearchService;
	}

	/**
	 * Returns the OSGi service identifier.
	 *
	 * @return the OSGi service identifier
	 */
	@Override
	public String getOSGiServiceIdentifier() {
		return _c3p0SearchService.getOSGiServiceIdentifier();
	}

	@Override
	public C3P0SearchService getWrappedService() {
		return _c3p0SearchService;
	}

	@Override
	public void setWrappedService(C3P0SearchService c3p0SearchService) {
		_c3p0SearchService = c3p0SearchService;
	}

	private C3P0SearchService _c3p0SearchService;

}