class Invoice {
  late String customerName;
  late String mobile;
  late List<String> productName;
  late List<double> price;
  late String date;
  late String? invoiceId;
  Invoice(
      {this.invoiceId,
      required this.customerName,
      required this.mobile,
      required this.productName,
      required this.price,
      required this.date});
}
