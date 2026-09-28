import 'dart:io';

import 'package:edfapg_sdk/edfapg_sdk.dart';
import 'package:flutter/material.dart';

const _apiKey = '';
const _apiPassword = '';
const _applePayMerchantId = 'merchant.your.merchantid';

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

  if (_apiKey.isEmpty || _apiPassword.isEmpty) {
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Set your EdfaPay API key and password in main.dart.'),
      ),
    );
    return;
  }

  if (_applePayMerchantId == 'merchant.your.merchantid') {
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Set your Apple Pay merchant ID in main.dart.'),
      ),
    );
    return;
  }

  await EdfaPgSdk.instance.config(
    key: _apiKey,
    password: _apiPassword,
    enableDebug: false,
  );
  if (!context.mounted) return;

  final order = EdfaPgSaleOrder(
    id: 'apple-${DateTime.now().microsecondsSinceEpoch}',
    amount: 0.11,
    description: 'SDK sample Apple Pay order',
    currency: 'SAR',
  );
  final payer = EdfaPgPayer(
    firstName: 'Kashif',
    lastName: 'User',
    address: 'Street 1',
    country: 'SA',
    city: 'Riyadh',
    zip: '12345',
    email: 'kashif+merchant1@edfapay.com',
    phone: '+15555555555',
    ip: '8.8.8.8',
  );

  EdfaApplePay()
      .setOrder(order)
      .setPayer(payer)
      .setApplePayMerchantID(_applePayMerchantId)
      .onAuthentication((_) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Authorizing Apple Pay...')),
        );
      })
      .onTransactionSuccess((response) {
        messenger.showSnackBar(
          SnackBar(content: Text('Payment successful: $response')),
        );
      })
      .onTransactionFailure((response) {
        messenger.showSnackBar(
          SnackBar(content: Text('Payment failed: $response')),
        );
      })
      .onError((error) {
        messenger.showSnackBar(
          SnackBar(content: Text('Payment error: $error')),
        );
      })
      .initialize(context);
}
