package com.acme.a3c9.dynamic.data.mapping.form.field.type.internal;

import com.liferay.dynamic.data.mapping.form.field.type.BaseDDMFormFieldType;
import com.liferay.dynamic.data.mapping.form.field.type.DDMFormFieldType;
import com.liferay.frontend.js.loader.modules.extender.npm.NPMResolver;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

@Component(
	property = {
		"ddm.form.field.type.description=a3c9-field-type-description",
		"ddm.form.field.type.display.order:Integer=10",
		"ddm.form.field.type.group=customized",
		"ddm.form.field.type.icon=control-panel",
		"ddm.form.field.type.label=a3c9-field-type-label",
		"ddm.form.field.type.name=a3c9"
	},
	service = DDMFormFieldType.class
)
public class A3C9DDMFormFieldType extends BaseDDMFormFieldType {

	@Override
	public String getModuleName() {
		return _npmResolver.resolveModuleName(
			"dynamic-data-mapping-form-field-type-a3c9/A3C9.es");
	}

	@Override
	public String getName() {
		return "a3c9";
	}

	@Override
	public boolean isCustomDDMFormFieldType() {
		return true;
	}

	@Reference
	private NPMResolver _npmResolver;

}
