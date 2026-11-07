// lib/services/mpesa_service.dart
import 'package:flutter_mpesa_stk/flutter_mpesa_stk.dart';
import 'package:flutter_mpesa_stk/models/Mpesa.dart';
import 'package:flutter_mpesa_stk/models/MpesaResponse.dart';
import '../config/mpesa_config.dart';
import '../models/payment_model.dart';

class MpesaService {
  static final MpesaService _instance = MpesaService._internal();
  factory MpesaService() => _instance;
  MpesaService._internal();

  Future<MpesaResponse> initiateSTKPush(PaymentModel payment) async {
    try {
      // Initialize the M-Pesa STK service [citation:1][citation:3]
      final stkService = FlutterMpesaSTK(
        MpesaConfig.consumerKey,
        MpesaConfig.consumerSecret,
        MpesaConfig.stkPassword,
        MpesaConfig.businessShortCode,
        MpesaConfig.callbackUrl,
        MpesaConfig.defaultErrorMessage,
        env: MpesaConfig.environment,
      );

      // Execute STK Push [citation:1]
      final response = await stkService.stkPush(
        Mpesa(
          payment.amount,
          payment.phoneNumber,
          accountReference: payment.accountReference,
          transactionDesc: payment.transactionDesc,
        ),
      );

      return response;
    } catch (e) {
      return MpesaResponse(
        false,
        "Error: ${e.toString()}",
      );
    }
  }

  // Helper method to validate phone number [citation:2]
  static bool isValidPhoneNumber(String phone) {
    // Must start with 254 and be 12 digits total
    final RegExp phoneRegex = RegExp(r'^254[0-9]{9}$');
    return phoneRegex.hasMatch(phone);
  }

  // Helper method to format phone number
  static String formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    // If it starts with 0, replace with 254
    if (cleaned.startsWith('0')) {
      return '254${cleaned.substring(1)}';
    }
    // If it starts with 7, add 254
    else if (cleaned.startsWith('7')) {
      return '254$cleaned';
    }
    // If it's already in 254 format, return as is
    else if (cleaned.startsWith('254')) {
      return cleaned;
    }
    // Default - assume it needs 254 prefix
    return '254$cleaned';
  }
}