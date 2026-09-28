# EdfaPay Apple Pay sample

This Flutter sample uses `edfapg_sdk`'s `EdfaApplePay` integration to present
the native Apple Pay sheet from the checkout button. The matching Swift sample
is native iOS code and cannot be called directly from Dart; the package's
`EdfaApplePay` builder is its Flutter-facing equivalent.

Before testing, set `_apiKey`, `_apiPassword`, and `_applePayMerchantId` in
`lib/main.dart`, and replace the sample order and payer details. Configure the
Apple Pay capability and merchant identifier for the iOS target in Xcode.
Apple Pay is iOS-only. This Flutter wrapper exposes success, failure, and error
callbacks; it does not expose the Swift snippet's `canMakePayments()` or
`onCancelled` callbacks.
