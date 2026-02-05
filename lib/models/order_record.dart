class OrderRecord {
  final String id;
  final String status;
  final double totalAmount;
  final DateTime? createdAt;

  const OrderRecord({
    required this.id,
    required this.status,
    required this.totalAmount,
    this.createdAt,
  });

  factory OrderRecord.fromMap(Map<String, dynamic> map) {
    final rawId = map['id'];
    final rawTotal = map['total_amount'];
    final rawCreated = map['created_at'];
    return OrderRecord(
      id: rawId == null ? '' : rawId.toString(),
      status: (map['status'] ?? 'pending').toString(),
      totalAmount: rawTotal is num
          ? rawTotal.toDouble()
          : double.tryParse(rawTotal?.toString() ?? '') ?? 0,
      createdAt: rawCreated == null
          ? null
          : DateTime.tryParse(rawCreated.toString()),
    );
  }
}
