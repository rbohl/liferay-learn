package com.acme.e3q3.web.internal.configuration;

import aQute.bnd.annotation.metatype.Meta;

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