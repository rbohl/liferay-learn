# Upgrading Liferay Commerce

This article documents how to upgrade Liferay Commerce to the latest Commerce version. Store administrators should consider regularly updating to the latest available product version to receive bug fixes and new features.

## Upgrading the Base DXP Version

If administrators are upgrading both DXP and Commerce, upgrade DXP 7.1 to 7.2 first. To learn more about the DXP upgrade process:

* [Upgrade Overview](https://learn.liferay.com/dxp/7.x/en/installation-and-upgrades/upgrading-liferay-dxp/upgrade-basics/upgrade-overview.html)

Once DXP has been successfully upgraded from 7.1 to 7.2, follow the steps below to upgrade Liferay Commerce.

Alternately, administrators can chose to upgrade just Liferay Commerce.

## Upgrading Commerce

Liferay Commerce provides a seamless upgrade process to the latest version. Users can perform either one of the following:

* From 1.1.x to 2.1.x
* From 2.0.x to 2.1.x

```tip::
   Upgrading from 1.1.x to 2.1.x does **not** require an incremental upgrade to 2.0.x.
```

### Apply the Latest Fix Pack

> Subscribers

Before upgrading Liferay Commerce, update Liferay Digital Experience Platform (DXP) to the latest available fix pack release. For example, if upgrading to Liferay Commerce Enterprise 2.0.6 - upgrading Liferay DXP to Fix Pack 14 is required. The latest fix pack releases are available from [Help Center](https://customer.liferay.com/downloads).

Fix Packs are applied to a Liferay DXP installation using the Liferay Patching Tool. See [Using the Patching Tool](https://help.liferay.com/hc/articles/360018176551-Using-the-Patching-Tool) and [Configuring the Patching Tool](https://help.liferay.com/hc/articles/360018176611-Configuring-the-Patching-Tool) for more information.

Next, apply the fix pack. See [Installing Patches](https://help.liferay.com/hc/en-us/articles/360028810512-Installing-Patches) for more information. If Liferay DXP was [installed manually](https://help.liferay.com/hc/articles/360017896672-Installing-Liferay-DXP-Manually-) (for example, on WebLogic), see [Installing Patches on the Liferay DXP 7.1 WAR](https://help.liferay.com/hc/articles/360018176651-Installing-patches-on-the-Liferay-DXP-7-1-WAR).

To verify Fix Pack installation do the following:

1. Navigate to the `${liferay.home}/patching-tool` folder.

1. Verify that the fix pack has been applied by executing the following:
    * Linux/Unix: `./patching-tool.sh info`
    * Windows: `patching-tool info`

    ```
    Detailed patch list:
       [ -] dxp-12-7110 :: Currently not installed; Won't be installed: dxp-14 contains the fixes included in this one :: Built for LIFERAY
       [*I] dxp-14-7110 :: Installed; Will be installed. :: Built for LIFERAY
    ```

Fix Packs are cumulative in nature and include all previously release fix packs. After patching, remove Liferay DXP's cache of deployed code by deleting the contents of the `${liferay.home}/work` folder. See the next section on how to remove other stale data.

### Download and Deploy

1. Download the latest Liferay Commerce.

    * Commerce Enterprise is available from [Help Center](https://customer.liferay.com/downloads?p_p_id=com_liferay_osb_customer_downloads_display_web_DownloadsDisplayPortlet&_com_liferay_osb_customer_downloads_display_web_DownloadsDisplayPortlet_productAssetCategoryId=118190997&_com_liferay_osb_customer_downloads_display_web_DownloadsDisplayPortlet_fileTypeAssetCategoryId=118191001).
    * Commerce Community is available from the [Liferay Commerce Community Download Page](https://www.liferay.com/downloads-community)

1. Deploy the `LPKG` to the `${liferay.home}/deploy` folder.To learn more about deploying applications to Liferay DXP, see [Installing Apps](https://learn.liferay.com/dxp/7.x/en/system-administration/installing-and-managing-apps/installing-apps.html).

1. Verify that the messages similar to those shown below appear in the application server console:

    ```
    Processing Liferay Commerce Enterprise x.x.x.lpkg
    ```

    ```
    The portal instance needs to be restarted to complete the installation of file:/../../liferay-commerce-enterprise-1.1.6/osgi/marketplace/Liferay%20Commerce%20-%20API.lpkg
    ```

    ```
    The portal instance needs to be restarted to complete the installation of file:/../../liferay-commerce-enterprise-1.1.6/osgi/marketplace/Liferay%20Commerce%20-%20Impl.lpkg
    ```

1. Shut down the application server.

### Clear Stale Data and Verify the Upgrade Process

1. Delete the `${liferay.home}/osgi/state` folder. To learn more about OSGi folders, see [Installing Apps](https://learn.liferay.com/dxp/7.x/en/system-administration/installing-and-managing-apps/installing-apps.html).
1. Start the application server.
1. Verify that the the upgrade process has begun by looking for messages similar to this in your application server console logs:

    ```
    Upgrading com.liferay.commerce.account.internal.upgrade.v1_2_0.CommerceAccountGroupCommerceAccountRelUpgradeProcess
    Completed upgrade process com.liferay.commerce.account.internal.upgrade.v1_2_0.CommerceAccountGroupCommerceAccountRelUpgradeProcess in 24 ms
    Upgrading com.liferay.commerce.account.internal.upgrade.v1_2_0.CommerceAccountGroupRelUpgradeProcess
    Completed upgrade process com.liferay.commerce.account.internal.upgrade.v1_2_0.CommerceAccountGroupRelUpgradeProcess in 8 ms
    Upgrading com.liferay.commerce.account.internal.upgrade.v1_2_0.CommerceAccountGroupUpgradeProcess
    Completed upgrade process com.liferay.commerce.account.internal.upgrade.v1_2_0.CommerceAccountGroupUpgradeProcess in 12 ms
    Upgrading com.liferay.commerce.account.internal.upgrade.v1_3_0.CommerceAccountNameUpgradeProcess
    Starting com.liferay.portal.kernel.upgrade.UpgradeProcess#alter
    Completed com.liferay.portal.kernel.upgrade.UpgradeProcess#alter in 40 ms
    Completed upgrade process com.liferay.commerce.account.internal.upgrade.v1_3_0.CommerceAccountNameUpgradeProcess in 60 ms
    Starting com.liferay.portal.upgrade.internal.index.updater.IndexUpdaterUtil#updateIndexes#Updating database indexes for com.liferay.commerce.account.service
    Dropping stale indexes
    Adding indexes
    ```

    ```
    Verifying com.liferay.commerce.product.internal.verify.CommerceCatalogServiceVerifyProcess
    Starting com.liferay.commerce.product.internal.verify.CommerceCatalogServiceVerifyProcess#verifyMasterCommerceCatalog
    Completed com.liferay.commerce.product.internal.verify.CommerceCatalogServiceVerifyProcess#verifyMasterCommerceCatalog in 2 ms
    Completed verification process com.liferay.commerce.product.internal.verify.CommerceCatalogServiceVerifyProcess in 7 ms
    1 theme for admin-theme is available for use
    1 theme for classic-theme is available for use
    1 theme for minium-theme is available for use
    ```

The Liferay Commerce instance has been upgraded.

### Execute Post-Upgrade Reindex

After upgrading from to the latest version, execute a full search reindex.

To execute a search reindex:

1. Navigate to the _Control Panel_ → _Configuration_ → _Search_.
1. Click _Execute_ next to _Reindex all search indexes_.
1. Wait for the reindex to finish.
1. Navigate to the _Control Panel_ → _Commerce_ → _Products_.
1. Verify all the products are displayed again.

Once reindexing is complete, the upgraded Liferay Commerce instance is ready for use.

## Additional Information

* [Installing Apps](https://learn.liferay.com/dxp/7.x/en/system-administration/installing-and-managing-apps/installing-apps.html)
* [Liferay Commerce Fix Delivery Method](../get-help/commerce-enterprise-support/liferay-commerce-fix-delivery-method.md)
