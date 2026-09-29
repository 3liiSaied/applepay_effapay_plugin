# EdfaPay Apple Pay sample

This Flutter sample keeps `edfapay_pg_plugin` for EdfaPay SDK initialization
and adds a small local iOS platform-channel bridge to call
`EdfaApplePaySheet.canMakePayments()` and `present(...)` from the native SDK.
The checkout button opens the native Apple Pay sheet without requiring the app
to supply a token.

Set `_apiKey`, `_baseUrl`, `_merchantIdentifier`, the sample payer details, and
result URLs in `lib/main.dart`. Use the staging base URL and credentials issued
by EdfaPay for tests; the production URL can charge real money. Configure the
Apple Pay capability and matching merchant ID for the iOS target in Xcode. The
native bridge lives in `packages/edfapay_apple_pay_sheet/ios/`.

The iOS dependencies use Swift Package Manager. Do not add a custom
`packages/edfapay_apple_pay_sheet/ios/Package.swift`; Flutter expects the
standard plugin layout (`ios/Classes/...`) and will generate the package graph
for you. On the Mac, from the project root, run:

```bash
flutter config --enable-swift-package-manager
flutter config --list
flutter pub get
flutter run
```

Confirm the SPM setting is enabled in the config output. There is no
`ios/Podfile` in this checkout, and `pod install` is not part of this project's
SPM setup.
