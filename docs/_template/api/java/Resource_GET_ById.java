import com.liferay.headless.delivery.client.dto.v1_0.UPPERCASE;
import com.liferay.headless.delivery.client.resource.v1_0.UPPERCASEResource;

public class UPPERCASE_GET_ById {

	/**
	 * java -classpath .:* -DlowerCASEId=1234 UPPERCASE_GET_ById
	 */
	public static void main(String[] args) throws Exception {
		UPPERCASEResource.Builder builder =
			UPPERCASEResource.builder();

		UPPERCASEResource lowerCASEResource = builder.authentication(
			"test@liferay.com", "test"
		).build();

		UPPERCASE lowerCASE =
			lowerCASEResource.getUPPERCASE(
				Long.valueOf(System.getProperty("lowerCASEId")));

		System.out.println(lowerCASE);
	}

}