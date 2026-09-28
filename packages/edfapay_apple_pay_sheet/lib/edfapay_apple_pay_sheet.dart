import 'package:flutter/services.dart';

class EdfaApplePaySheet {
  EdfaApplePaySheet._();

  static const _channel = MethodChannel('edfapay_apple_pay_sheet');

  static Future<bool> canMakePayments() async {
    return await _channel.invokeMethod<bool>('canMakePayments') ?? false;
  }

  static Future<Map<String, Object?>> present({
    required String merchantIdentifier,
    required String countryCode,
    required String currencyCode,
    required String merchantName,
    required String orderId,
    required double amount,
    required String description,
    required String firstName,
    required String lastName,
    required String address,
    required String payerCountry,
    required String city,
    required String zip,
    required String email,
    required String phone,
    required String ip,
    required String successUrl,
    required String failureUrl,
  }) async {
    final response = await _channel.invokeMapMethod<String, Object?>(
      'present',
      {
        'merchantIdentifier': merchantIdentifier,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
        'merchantName': merchantName,
        'order': {
          'id': orderId,
          'amount': amount,
          'currency': currencyCode,
          'description': description,
        },
        'payer': {
          'firstName': firstName,
          'lastName': lastName,
          'address': address,
          'country': payerCountry,
          'city': city,
          'zip': zip,
          'email': email,
          'phone': phone,
          'ip': ip,
        },
        'successUrl': successUrl,
        'failureUrl': failureUrl,
      },
    );
    if (response == null) {
      throw PlatformException(
        code: 'invalid_response',
        message: 'Apple Pay returned no result.',
      );
    }
    return response;
  }
}
