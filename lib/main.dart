import 'dart:io';

import 'package:edfapay_pg_plugin/edfapay_pg_sdk.dart';
import 'package:edfapay_apple_pay_sheet/edfapay_apple_pay_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _apiKey = 'YOUR_X_API_KEY';
const _baseUrl = 'YOUR_EDFAPAY_STAGING_BASE_URL';
const _merchantIdentifier = 'merchant.your.merchantid';
bool _sdkInitialized = false;
bool _paymentInProgress = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdfaPay Apple Pay Sample',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CheckoutPage(),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 64),
                const SizedBox(height: 24),
                Text(
                  'Complete your purchase',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: SAR 1.00',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: () => _payWithApplePay(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Apple Pay',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _payWithApplePay(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);

  if (!Platform.isIOS) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Apple Pay is available on iOS only.')),
    );
    return;
  }

  if (_apiKey == 'YOUR_X_API_KEY' ||
      _baseUrl == 'YOUR_EDFAPAY_STAGING_BASE_URL' ||
      _merchantIdentifier == 'merchant.your.merchantid') {
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          'Set your EdfaPay staging credentials, base URL, and Apple Pay merchant ID in main.dart.',
        ),
      ),
    );
    return;
  }

  if (_paymentInProgress) {
    messenger.showSnackBar(
      const SnackBar(content: Text('An Apple Pay payment is already in progress.')),
    );
    return;
  }

  _paymentInProgress = true;
  try {
    if (!_sdkInitialized) {
      await EdfaPgSdk.initialize(apiKey: _apiKey, baseUrl: _baseUrl);
      _sdkInitialized = true;
    }
    if (!context.mounted) return;

    if (!await EdfaApplePaySheet.canMakePayments()) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Apple Pay is unavailable on this device.'),
        ),
      );
      return;
    }
    if (!context.mounted) return;

    final response = await EdfaApplePaySheet.present(
      merchantIdentifier: _merchantIdentifier,
      countryCode: 'SA',
      currencyCode: 'SAR',
      merchantName: 'Your Store',
      orderId: 'apple-${DateTime.now().microsecondsSinceEpoch}',
      amount: 1.00,
      description: 'SDK sample Apple Pay order',
      firstName: 'ali',
      lastName: 'User',
      address: 'Street 1',
      payerCountry: 'SA',
      city: 'Riyadh',
      zip: '12345',
      email: 'ali@edfapay.com',
      phone: '+15555555555',
      ip: '8.8.8.8',
      successUrl: 'https://your-success-url',
      failureUrl: 'https://your-failure-url',
    );
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          response['status'] == 'success'
              ? 'Payment successful.'
              : response['status'] == 'cancelled'
                  ? 'Payment cancelled.'
                  : 'Payment failed: ${response['error'] ?? response}',
        ),
      ),
    );
  } on PlatformException catch (error) {
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text('Payment error: ${error.message ?? error.code}')),
    );
  } on MissingPluginException catch (error) {
    if (!context.mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text('Apple Pay bridge unavailable: $error')),
    );
  } finally {
    _paymentInProgress = false;
  }
}
