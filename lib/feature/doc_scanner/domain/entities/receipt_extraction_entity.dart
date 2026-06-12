class ReceiptExtractionEntity {
  final String? restaurantName;
  final String? date;
  final double? amount;
  final String? currency;

  const ReceiptExtractionEntity({
    this.restaurantName,
    this.date,
    this.amount,
    this.currency,
  });
}
