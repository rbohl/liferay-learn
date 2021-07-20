import com.liferay.headless.delivery.client.resource.v1_0.UPPERCASEResource;

public class UPPERCASE_DELETE_ById {

	/**
	 * java -classpath .:* -DlowerCASEId=1234 UPPERCASE_DELETE_ById
	 */
	public static void main(String[] args) throws Exception {
		UPPERCASEResource.Builder builder =
			UPPERCASEResource.builder();

		UPPERCASEResource lowerCASEResource = builder.authentication(
			"test@liferay.com", "test"
		).build();

		lowerCASEResource.deleteUPPERCASE(
			Long.valueOf(System.getProperty("lowerCASEId")));
	}

}