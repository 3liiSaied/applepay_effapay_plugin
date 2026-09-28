# EdfaPay Apple Pay sample

This Flutter sample keeps `edfapay_pg_plugin` for EdfaPay SDK initialization
and adds a small local iOS platform-channel bridge to call
`EdfaApplePaySheet.canMakePayments()` and `present(...)` from the native SDK.
The checkout button opens the native Apple Pay sheet without requiring the app
to supply a token.

Set `_apiKey`, `_merchantIdentifier`, the sample payer details, and result URLs
in `lib/main.dart`. Configure the Apple Pay capability and matching merchant ID
for the iOS target in Xcode. The native bridge lives in
`packages/edfapay_apple_pay_sheet/ios/`.
