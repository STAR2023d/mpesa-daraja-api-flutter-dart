import 'package:flutter_dotenv/flutter_dotenv.dart';

class MpesaConfig {
  // Daraja API Credentials - Get these from your Daraja account dashboard
  static final String consumerKey = dotenv.env['DARAJA_CONSUMER_KEY'] ?? '';
  static final String consumerSecret =
      dotenv.env['DARAJA_CONSUMER_SECRET'] ?? '';
  static final String stkPassword = dotenv.env['DARAJA_PASSKEY'] ?? '';

  static const String businessShortCode = "174379";

  // Callback URL - For testing, use ngrok or tunneling service
  static const String callbackUrl =
      "https://karri-pneumatological-tonnishly.ngrok-free.dev";

  // Environment: "testing" for sandbox, "production" for live
  static const String environment = "testing";

  // Default message for errors
  static const String defaultErrorMessage =
      "Transaction failed. Please try again.";
}
