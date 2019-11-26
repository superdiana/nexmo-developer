---
title: Create a Client SDK RTC Application
description: In this step you learn how to create a Client SDK Application with RTC capabilities.
---

# Create a Client SDK RTC Application

You now need to create a Nexmo application. In this example you create an application with [RTC capabilities](/application/overview#capabilities).

1) First create your project directory if you've not already done so.

2) Change into the project directory you've just created.

3) Create a Nexmo application [interactively](/application/nexmo-cli#interactive-mode). The following command enters interactive mode:

``` shell
nexmo app:create
```

4) Type in your application name, such as "In-app Call". Press Enter to continue.

5) You can now select your application capabilities using the arrow keys and then pressing spacebar to select the capabilities your application needs. For the purposes of this tutorial select only RTC capabilities using the arrow keys and spacebar to select. Once the RTC radio button has been highlighted press Enter to continue.

6) For "Use the default HTTP methods?" press Enter to select the default.

7) For " RTC Event URL" enter `https://example.ngrok.io/webhooks/rtc`. You will need to ammend the URL to match your local testing set up. See [Testing with Ngrok](/concepts/guides/testing-with-ngrok) for more details.

8) For "Public Key path" press Enter to select the default. If you want to use your own public-private key pair please refer to [this documentation](/application/nexmo-cli#creating-an-application-with-your-own-public-private-key-pair).

9) For "Private Key path" type in `private.key` and press Enter.

The application is then created.

The file `.nexmo-app` is created in your project directory. This file contains the Nexmo Application ID and the private key. A private key file `private.key` is also created.

Creating an application and capabilities are covered in detail in the [documentation](/application/overview).
