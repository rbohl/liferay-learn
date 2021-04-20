package com.acme.e3q3.web.internal.configuration;

import aQute.bnd.annotation.metatype.Meta;

// ends up in platform > third party by default
//@ExtendedObjectClassDefinition(category = "third-party")
@Meta.OCD(
	id = "com.acme.e3q3.web.internal.configuration.MessageDisplayConfiguration"
)
public interface MessageDisplayConfiguration {

	@Meta.AD(required = false)
	public String fontColor();

	@Meta.AD(required = false)
	public String fontFamily();

	@Meta.AD(required = false)
	public int fontSize();

}