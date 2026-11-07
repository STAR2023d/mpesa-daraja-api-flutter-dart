class PaymentModel {
  final String phoneNumber;
  final int amount;
  final String accountReference;
  final String transactionDesc;
  final DateTime timestamp;

  PaymentModel({
    required this.phoneNumber,
    required this.amount,
    required this.accountReference,
    required this.transactionDesc,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'amount': amount,
      'accountReference': accountReference,
      'transactionDesc': transactionDesc,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      phoneNumber: json['phoneNumber'],
      amount: json['amount'],
      accountReference: json['accountReference'],
      transactionDesc: json['transactionDesc'],
    );
  }
}