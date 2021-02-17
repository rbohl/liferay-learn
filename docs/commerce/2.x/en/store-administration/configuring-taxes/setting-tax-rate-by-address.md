# Setting Tax Rates by Address

Liferay Commerce supports two types of tax calculations: fixed rates and by address. The fixed method applies the same rate to a product each time it is purchased, while the by address method applies only to buyers within a specified geographical region.

Calculating taxes by address sets rates for geographical areas independently. You can apply several by address rates to a single tax category. When a product from that category is purchased, the tax rate appropriate to the buyer’s location is used.

To set a tax rate by address:

1. Go to the _Global Applications_ menu &rarr; _Commerce_ &rarr; _Channels_.
1. Click on the channel you are configuring a tax rate for. If you used an accelerator like Minium, a channel is created by default.
1. Scroll down to _Tax Calculations_.

    ![Activate tax calculations by address](./setting-tax-rate-by-address/images/03.png)

1. Click _Edit_ next to By Address.
1. Slide the _Percentage_ and _Active_ toggles to _YES_.
1. Click _Save_.

Next, set the Tax Rate by Category and by Address:

1. Click _Tax Rate Settings_.
1. Select whether the taxed address is the Billing Address or the Shipping Address from the _Apply Tax to_ dropdown menu.
1. Click the Add (![Add icon](../../images/icon-add.png)) button to add a Tax Category.
1. Select the Tax Category (for example, _Holiday Special_).
1. Enter the following:

    * **Rate**: Your tax rate
    * **Country**: Applicable country
    * **Region**: Leave blank to apply to the whole country
    * **Zip**: Leave blank to apply to the whole country

    ![Activate tax calculations by address](./setting-tax-rate-by-address/images/04.png)

1. Click _Submit_.

Address specific tax rates are now configured.

![Activate tax calculations by address](./setting-tax-rate-by-address/images/05.png)

## Commerce 2.1 and Below

1. Navigate to the _Control Panel_ &rarr; _Commerce_ &rarr; _Channels_.
1. Click on the channel you are configuring a tax rate for. If you used an accelerator like Minium, a channel is created by default.
1. Scroll down to _Tax Calculations_.

    ![Activate tax calculations by address](./setting-tax-rate-by-address/images/03.png)

1. Click _Edit_ next to By Address.
1. Slide the _Percentage_ and _Active_ toggles to _YES_.
1. Click _Save_.

Next, set the Tax Rate by Category and by Address:

1. Click _Tax Rate Settings_.
1. Select whether the taxed address is the Billing Address or the Shipping Address from the _Apply Tax to_ dropdown menu.
1. Click the Add (![Add icon](../../images/icon-add.png)) button to add a Tax Category.
1. Select the Tax Category (for example, _Holiday Special_).
1. Enter the following:

    * **Rate**: Your tax rate
    * **Country**: Applicable country
    * **Region**: Leave blank to apply to the whole country
    * **Zip**: Leave blank to apply to the whole country

    ![Activate tax calculations by address](./setting-tax-rate-by-address/images/04.png)

1. Click _Submit_.

Address specific tax rates are now configured.

![Activate tax calculations by address](./setting-tax-rate-by-address/images/05.png)

## Commerce 2.0 and Below

To set a tax rate by address:

1. Go to _Site Administration_ → _Commerce_ → _Settings_.
1. Click the _Taxes_ tab and then the _Tax Calculations_ sub-tab.
1. Click _By Address_.
1. Switch the _Percentage_ toggle to _YES_ if you want the tax to be defined as a percentage of the purchase price. Leave the toggle disabled to define the tax as a fixed amount.
1. Switch the _Active_ toggle to _YES_.

    ![Enabling tax rates by address](./setting-tax-rate-by-address/images/01.png)

1. Click _Save_.

Next, set the Tax Rate by Category and by Address:

1. Click the _Tax Rate Settings_ sub-tab and then on the _Add Tax Rate Setting_ button.
1. Select the _Tax Category_ from the _Tax Category_ field.
1. Enter the tax rate in the _Rate_ field.
1. Select the country, region, enter the Zip code.

    ![Configuring tax rate settings](./setting-tax-rate-by-address/images/02.png)

1. Click _Save_.

Address specific tax rates are now configured.

## Additional Information

To designate a tax rate for a country, leave _Region_ and _Zip_ blank; to designate a tax rate for a region, leave _Zip_ blank.

If you assign multiple settings to a single tax category (but specify different geographical areas), the rate appropriate to the buyer’s location is used. If you assign both a by address rate and a fixed rate to a single tax category, both rates will be applied.

* [Setting Tax Rates by Fixed Rate](./setting-tax-rate-by-fixed-rate.md)
* [Creating Tax Categories](./creating-tax-categories.md)
