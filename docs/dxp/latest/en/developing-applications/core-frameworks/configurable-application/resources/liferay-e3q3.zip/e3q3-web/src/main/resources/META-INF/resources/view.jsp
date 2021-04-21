<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<p
	style="font-family: <%= request.getAttribute("fontFamily") %>; color: <%= request.getAttribute("fontColor") %>; font-size: <%= request.getAttribute("fontSize") %>pt;"
>
	<liferay-ui:message key="e3q3-porlet-welcome" />
</p>