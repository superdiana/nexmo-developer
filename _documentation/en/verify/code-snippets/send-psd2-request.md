---
title: Send PSD2 code
navigation_weight: 2
---

# Send PSD2 code

The Payment Services Directive (PSD2) is a standard that expects financial institutions to do second-factor or step-up authentication with their users before a payment is approved. Verify API provides this functionality - the first step is to send a PSD2 request to the user's number, specifying the payee and amount that the payment is for.

Replace the following variables in the sample code with your own values:

Name | Description
--|--
`NEXMO_API_KEY` | Your Nexmo [API key](https://developer.nexmo.com/concepts/guides/authentication#api-key-and-secret)
`NEXMO_API_SECRET` | Your Nexmo [API secret](https://developer.nexmo.com/concepts/guides/authentication#api-key-and-secret)
`RECIPIENT_NUMBER` | The phone number to verify
`PAYEE_NAME` | Included in the message to describe who the payment will be paid to
`AMOUNT` | How much the payment is for


```code_snippets
source: '_examples/verify/send-psd2-request
```

The Verify API returns a `request_id`. Use this to identify a specific verification request in subsequent calls to the API, such as when making a [check request](/verify/code-snippets/check-verify-request) to see if the user provided the correct code.

