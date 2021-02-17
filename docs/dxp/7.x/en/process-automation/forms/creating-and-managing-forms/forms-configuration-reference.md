# Forms Configuration Reference

Here's an overview of all the Forms configurations so you can quickly find a configuration you need.

## Forms Options

You can export and import forms between Sites. To access the _Export / Import_ menu, navigate to _Site Administration_ &rarr; _Content and Data_  &rarr; _Forms_. Click the ![Options](../../../images/icon-options.png) icon in the upper right then _Export / Import_.

![You can export or import forms.](./forms-configuration-reference/images/01.png)

See [Exporting and Importing Forms](./exporting-and-importing-forms.md) and [Importing and Exporting Pages and Content](../../../site-building/building-sites/importing-exporting-pages-and-content.md) to learn more.

## Form Settings

Each form has its own Settings menu.

To access the Settings menu, choose the desired form (for example, _Guest Survey Feedback_). Click the ![Options](../../../images/icon-options.png) icon in the upper right then _Settings_.

### Form Options

![Clicking the Form Options contains these settings.](./forms-configuration-reference/images/02.png)

| Field | Description |
| --- | --- |
| Require User Authentication | Requires sign in before submitting the form |
| CAPTCHA | Requires answering CAPTCHA questions when submitting the form |
| Save Answers Automatically | Saves answers to the form automatically |
| Redirect URL on Success | Specifies a redirect URL once the form is submitted successfully. |
| Select a Storage Type | Sets JSON as the default storage type; not editable. |
| Select a [Workflow](../sharing-forms-and-managing-submissions/using-forms-with-a-workflow.md) | Select a workflow definition to review the form submission; workflow is deactivated by default. |

### Email Notifications

Here you can configure the Forms app to send a notification email each time a form entry is submitted. You should set up a mail server first; see [Connecting to a Mail Server](../../../installation-and-upgrades/setting-up-liferay/configuring-mail/connecting-to-a-mail-server.md) to learn more.

![You can add notifications to a form.](./forms-configuration-reference/images/03.png)

| Field | Description |
| --- | --- |
| From Name | The sender's name; this could be the Site name, the form name, or anything else informative to the recipient. |
| From Address | The sender's email address; You can use `noreply@example.com` to prevent recipients from replying. |
| To Address | The recipient's email address (e.g., `test@example.com`) |
| Subject | An informative subject line tells the recipient what happened. |

To learn more, see [Configuring Form Notifications](../sharing-forms-and-managing-submissions/configuring-form-notifications.md).

## Form Widget Configuration

You can configure the _Form_ widget deployed to a Site Page. To access the _Configuration_ menu, click the ![Options](../../../images/icon-app-options.png) icon next to the widget title &rarr; _Configuration_.

### Setup

Here you can choose the desired Form to be used in this widget.

![Select the desired form to be used in this widget.](./forms-configuration-reference/images/04.png)

### Sharing

Here you can embed this application on other platforms besides DXP.

![Select the desired platform where the Forms app can be embedded in.](./forms-configuration-reference/images/05.png)

### Scope

Here you can change the widget's scope from Global, Site, or Page.

![Select the desired scope for the Form Widget.](./forms-configuration-reference/images/06.png)

## Instance Settings

There are several ways Forms can be configured across an Instance.

1. Go to the _Global Menu_ (![global icon](../../../images/icon-applications-menu.png)) &rarr; _Control Panel_.
1. Click _Instance Settings_.

    ![Access Instance Settings from the Control Panel.](./forms-configuration-reference/images/09.png)

1. Click _Forms_ under the _Content and Data_ section.

    ![Configure Forms in the Instance Settings menu.](./forms-configuration-reference/images/07.png)

| Field | Description |
| --- | --- |
| Auto-save Interval | Sets the value in minutes to auto-save a form; setting 0 disables auto-save. |
| CSV Export | Determines whether administrators can download Form Entries as CSVs. |
| Default Display View | Sets how the Forms are displayed in the search container. |

## System Settings

There are several system-wide Forms configurations.

1. Go to the _Global Menu_ (![global icon](../../../images/icon-applications-menu.png)) &rarr; _Control Panel_.
1. Click _System Settings_.
1. Click _Forms_ under the _Content and Data_ section.

### System Scope

You can configure the _Form Navigator_ under the _System Scope_. Click _Add_ to add a new _Configuration Entry_.

![You can configure Form Navigator.](./forms-configuration-reference/images/10.png)

| Field | Description |
| --- | --- |
| Form Navigator ID | Enter the Form Navigator ID |
| Form Navigator Entry Keys | Enter the entry key; if they are multiple keys, use comma separated lists. |

### Site Scope

Use the Site Scope settings to manage each Form's behavior. These are the similar to those in Instance Settings.

![You can configure System-wide Forms settings.](./forms-configuration-reference/images/08.png)

| Field | Description |
| --- | --- |
| Autosave Interval | Sets the value in minutes to auto-save a form; setting 0 disables auto-save. |
| CSV Export | Determines whether administrators can download Form Entries as CSVs. |
| Default Display View | Sets how the Forms are displayed in the search container. |

## Additional Information

* [Forms Permissions Reference](./forms-permissions-reference.md)
