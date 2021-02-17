# Setting a Fixed Tax Rate

Liferay Commerce supports two types of tax calculations: fixed and by address. The fixed method applies the same rate to a product each time it is purchased, while the by address method applies only to buyers within a specified geographical region.

A fixed tax method sets rates for each tax category independently. The tax collected then depends on the tax category assigned to a product.

1. Go to the _Global Applications_ menu &rarr; _Commerce_ &rarr; _Channels_.
1. Click on the channel you are configuring a tax rate for. If you used an accelerator like Minium, a channel is created by default.
1. Scroll down to _Tax Calculations_.

    ![Setting a fixed tax rate](./setting-tax-rate-by-fixed-rate/images/03.png)

1. Click _Edit_ next to Fixed Tax Rate.
1. Slide the _Percentage_ and _Active_ toggles to _YES_.
1. Click _Save_.

Next, set the tax rate for the tax category:

1. Click the _Tax Rates_ tab.
1. Click the Add (![Add icon](../../images/icon-add.png)) button to add a Tax Rate for a Tax Category.
1. Select the desired Tax Category.
1. Enter the rate.

    ![Setting a fixed tax rate](./setting-tax-rate-by-fixed-rate/images/04.png)

1. Click _Submit_.

Your store will now collect a fixed rate for all orders that fall under this tax category.

To set a fixed tax rate:

## Commerce 2.1 and Below

1. Navigate to the _Control Panel_ &rarr; _Commerce_ &rarr; _Channels_.
1. Click on the channel you are configuring a tax rate for. If you used an accelerator like Minium, a channel is created by default.
1. Scroll down to _Tax Calculations_.

    ![Setting a fixed tax rate](./setting-tax-rate-by-fixed-rate/images/03.png)

1. Click _Edit_ next to Fixed Tax Rate.
1. Slide the _Percentage_ and _Active_ toggles to _YES_.
1. Click _Save_.

Next, set the tax rate for the tax category:

1. Click the _Tax Rates_ tab.
1. Click the Add (![Add icon](../../images/icon-add.png)) button to add a Tax Rate for a Tax Category.
1. Select the desired Tax Category.
1. Enter the rate.

    ![Setting a fixed tax rate](./setting-tax-rate-by-fixed-rate/images/04.png)

1. Click _Submit_.

Your store will now collect a fixed rate for all orders that fall under this tax category.

## Commerce 2.0 and Below

First, enable the _Fixed Tax Rate_ function:

1. Go to _Site Administration_ → _Commerce_ → _Settings_.
1. Click the _Taxes_ tab and then the _Tax Calculations_ sub-tab.
1. Click on _Fixed Tax Rate_.
1. Switch the _Percentage_ toggle to _YES_ if the tax should be defined as a percentage of the purchase price. Disable to define the tax as a fixed amount.
1. Switch the toggle to _YES_.

    ![Enabling fixed tax rates](./setting-tax-rate-by-fixed-rate/images/01.png)

1. Click _Save_.

Next, set the tax rate for the tax category:

1. Click the _Tax Rates_ sub-tab.
1. Enter the tax rate in the _Rate_ field for each tax category.

    ![Setting a tax rate](./setting-tax-rate-by-fixed-rate/images/02.png)

1. Click _Save_.

Your store will now collect a fixed rate for all orders that fall under this tax category.

## Additional Information

* [Setting Tax Rates by Address](./setting-tax-rate-by-address.md)
* [Creating Tax Categories](./creating-tax-categories.md)
