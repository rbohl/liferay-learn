package com.acme.e3q3.web.internal.portlet;

import com.acme.e3q3.web.internal.configuration.MessageDisplayConfiguration;

import com.liferay.portal.configuration.metatype.bnd.util.ConfigurableUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import java.io.IOException;

import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Modified;

@Component(
	configurationPid = "com.acme.e3q3.web.internal.configuration.MessageDisplayConfiguration",
	property = {
		"com.liferay.portlet.display-category=category.sample",
		"javax.portlet.display-name=E3Q3 Portlet",
		"javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.resource-bundle=content.Language"
	},
	service = Portlet.class
)
public class E3Q3Portlet extends MVCPortlet {

	@Override
	public void render(
			RenderRequest renderRequest, RenderResponse renderResponse)
		throws IOException, PortletException {

		renderRequest.setAttribute(
			MessageDisplayConfiguration.class.getName(),
			_messageDisplayConfiguration);

		super.doView(renderRequest, renderResponse);
	}

	@Activate
	@Modified
	protected void activate(Map<Object, Object> properties) {
		_messageDisplayConfiguration = ConfigurableUtil.createConfigurable(
			MessageDisplayConfiguration.class, properties);
	}

	private volatile MessageDisplayConfiguration _messageDisplayConfiguration;

}