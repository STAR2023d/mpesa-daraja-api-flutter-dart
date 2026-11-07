import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../services/mpesa_services.dart';

class PaymentProvider extends ChangeNotifier {
  final _mpesaService = MpesaService();

  // Form controllers
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final referenceController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // State variables
  bool _isLoading = false;
  String? _lastResponse;
  final List<PaymentModel> _transactions = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get lastResponse => _lastResponse;
  List<PaymentModel> get transactions => _transactions;

  // Validators
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    String formatted = MpesaService.formatPhoneNumber(value);
    if (!MpesaService.isValidPhoneNumber(formatted)) {
      return 'Enter valid phone (format: 254XXXXXXXXX)';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = int.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Enter valid amount greater than 0';
    }
    if (amount < 10) {
      return 'Minimum amount is 10 KES';
    }
    return null;
  }

  // Process payment
  // Process payment
  Future<void> processPayment(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Format phone number
      String formattedPhone = MpesaService.formatPhoneNumber(
        phoneController.text,
      );

      // Create payment model
      final payment = PaymentModel(
        phoneNumber: formattedPhone,
        amount: int.parse(amountController.text),
        accountReference: referenceController.text.isEmpty
            ? 'TestPayment'
            : referenceController.text,
        transactionDesc: 'Test transaction',
      );

      // Initiate STK Push
      final response = await _mpesaService.initiateSTKPush(payment);

      _lastResponse = response.body.toString();

      // Save transaction if successful
      if (response.status) {
        _transactions.insert(0, payment);
      }

      // ✅ THE FIX: Check if the widget tree still contains this context
      // before attempting to render the UI dialog.
      if (!context.mounted) return;

      // Show result to user
      _showResultDialog(context, response.status, response.body.toString());
    } catch (e) {
      // ✅ THE FIX: Check context mounting state if an exception is thrown during the await gap
      if (!context.mounted) return;

      _showResultDialog(context, false, 'Error: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showResultDialog(BuildContext context, bool success, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(success ? 'Success' : 'Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            if (success) ...[
              const SizedBox(height: 16),
              const Text(
                'Check your phone for STK prompt and enter PIN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    amountController.dispose();
    referenceController.dispose();
    super.dispose();
  }
}
