# Running Liferay for the First Time

Once you've [installed Liferay DXP](./installing-a-liferay-tomcat-bundle.md#installing) and [configured a database](./configuring-a-database.md) for it, Liferay DXP is ready to run.

## Start Liferay DXP

1. Run the startup script bundled with your application server. Tomcat bundle example:

    ```bash
    ./liferay-dxp-version/tomcat-version/bin/startup.sh
    ```

    ```note::
       By default, DXP writes log files to ``[Liferay Home]/logs``
    ```

    The Setup Wizard appears in your web browser at `http://localhost:8080`.

    ![On completing startup, DXP launches a web browser that displays the Basic Configuration page.](./running-liferay-for-the-first-time/images/01.png)

2. Set your portal's *Name*, *Default Language* and *Time Zone*.

3. Set the *Administrator User* first name, last name, and email address.

4. In the *Database* section, click *Change* to display the database form.

    ```warning::
       DO NOT use HSQL in production-grade Liferay DXP instances.
    ```

    ![The Setup Wizard's database form lets you specify the database you created for DXP.](./running-liferay-for-the-first-time/images/02.png)

5. Specify your database.

| Field | Description |
| --- | --- |
| *Database Type* | Select the database type to connect to |
| *JDBC URL* | Update the path to the database that you have created for Liferay DXP |
| *User Name* | Database user name |
| *Password* | Database user password |

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6\. Regarding *Sample Data*: If you're creating a production-grade DXP instance or otherwise don't need the data, leave the sample data field unselected. The sample data includes Users, Sites, and Organizations for demonstration purposes.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7\. Click *Finish Configuration*.

The Setup Wizard stores your configuration values in a `portal-setup-wizard.properties` file in your [Liferay Home](../reference/liferay-home.md).

If you have a Liferay DXP Enterprise subscription, DXP requests your activation key. See [Activating Liferay DXP](../setting-up-liferay-dxp/activating-liferay-dxp.md).

Lastly DXP prompts you to restart your server.

## Restart the Server

Restart your server using the shutdown and startup scripts bundled with your application server. Tomcat example commands:

### Shutdown

```bash
./liferay-dxp-version/tomcat-version/bin/shutdown.sh
```

### Startup

```bash
./liferay-dxp-version/tomcat-version/bin/startup.sh
```

DXP initializes using the database and portal configuration values you specified in the Setup Wizard. The DXP home page appears at `http://localhost:8080`.

![Once you've configured DXP and restarted the server, the DXP home page appears and is ready for you to sign in!](./running-liferay-for-the-first-time/images/03.png)

Congratulations! You have launched your on premises Liferay DXP instance.

## Next Steps

You can [sign in as your administrator user](../../getting-started/introduction-to-the-admin-account.md) and start [building a solution on DXP](../../building-solutions-on-dxp/README.md). Or you can explore [additional Liferay DXP setup](../setting-up-liferay-dxp/setting-up-liferay-dxp.md) topics:

* [Installing and Managing Apps](../../system-administration/installing-and-managing-apps/getting-started/installing-and-managing-apps.md)
* [Accessing Plugins During a Trial Period](../../system-administration/installing-and-managing-apps/installing-apps/accessing-ee-plugins-during-a-trial-period.md)
* [Installing a Search Engine](../../using-search/installing-and-upgrading-a-search-engine/introduction-to-installing-a-search-engine.md)
* [Securing Liferay DXP](../securing-liferay/introduction-to-securing-liferay.md)
* [Clustering for High Availability](../setting-up-liferay-dxp/clustering-for-high-availability/clustering-for-high-availability.md)
