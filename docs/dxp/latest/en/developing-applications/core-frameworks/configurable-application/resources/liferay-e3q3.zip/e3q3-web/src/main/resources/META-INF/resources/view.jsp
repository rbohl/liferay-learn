<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %><%@
taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %><%@
taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %><%@
taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="com.acme.e3q3.web.internal.configuration.MessageDisplayConfiguration" %>

<%@ page import="com.liferay.petra.string.StringPool" %><%@
page import="com.liferay.portal.kernel.util.Validator" %>

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%
MessageDisplayConfiguration messageDisplayConfiguration =
	(MessageDisplayConfiguration)
	renderRequest.getAttribute(MessageDisplayConfiguration.class.getName());
String fontFamily = StringPool.BLANK;
String fontColor = StringPool.BLANK;
String fontSize = StringPool.BLANK;

// remove logic from the JSP: 
// set defaults in the configuration class instead of doing this
if (messageDisplayConfiguration != null) {
	fontFamily = portletPreferences.getValue("fontFamily", messageDisplayConfiguration.fontFamily());
	fontColor = portletPreferences.getValue("fontColor", messageDisplayConfiguration.fontColor());
	fontSize = portletPreferences.getValue("fontSize", String.valueOf(messageDisplayConfiguration.fontSize()));
}
%>

<!-- remove logic from the JSP -->
<c:choose>
	<c:when test='<%= Validator.isNull(fontFamily) && Validator.isNull(fontColor) && (Validator.isNull(fontSize) || fontSize.equals("0")) %>'>
		<liferay-ui:message
			key="font-family-size-and-color-not-configured-please-configure-first"
		/>
	</c:when>
	<c:otherwise>
		<p style="font-family: <%= fontFamily %>; color: <%= fontColor %>; font-size: <%= fontSize %>pt;">
			<liferay-ui:message
				key="e3q3-porlet-welcome"
			/>
		</p>
	</c:otherwise>
</c:choose>