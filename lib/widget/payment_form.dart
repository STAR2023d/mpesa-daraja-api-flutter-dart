// lib/widgets/payment_form.dart
import 'package:daraja/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentForm extends StatelessWidget {
  const PaymentForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);

    return Form(
      key: provider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Phone Number Field
          TextFormField(
            controller: provider.phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '07XXXXXXXXX',
              prefixIcon: const Icon(Icons.phone_android),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.phone,
            validator: provider.validatePhoneNumber,
          ),
          const SizedBox(height: 16),

          // Amount Field
          TextFormField(
            controller: provider.amountController,
            decoration: InputDecoration(
              labelText: 'Amount (KES)',
              hintText: '100',
              prefixIcon: const Icon(Icons.money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            validator: provider.validateAmount,
          ),
          const SizedBox(height: 16),

          // Reference Field (Optional)
          TextFormField(
            controller: provider.referenceController,
            decoration: InputDecoration(
              labelText: 'Reference (Optional)',
              hintText: 'Order #123',
              prefixIcon: const Icon(Icons.receipt),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () => provider.processPayment(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: provider.isLoading
                  ? const LoadingAnimationWidget()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_open),
                        SizedBox(width: 8),
                        Text(
                          'Pay with M-Pesa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple loading animation widget
class LoadingAnimationWidget extends StatelessWidget {
  const LoadingAnimationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ),
        const SizedBox(width: 12),
        const Text('Processing...'),
      ],
    );
  }
}
