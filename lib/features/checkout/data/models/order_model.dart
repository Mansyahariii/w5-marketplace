import 'package:equatable/equatable.dart';

// ─── OrderStatus sesuai backend ───────────────────────────────────────────────
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.pending,
    );
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:    return 'Menunggu';
      case OrderStatus.processing: return 'Diproses';
      case OrderStatus.shipped:    return 'Dikirim';
      case OrderStatus.delivered:  return 'Selesai';
      case OrderStatus.cancelled:  return 'Dibatalkan';
    }
  }
}

// ─── OrderItem (snapshot produk saat checkout) ────────────────────────────────
class OrderItemModel extends Equatable {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id:          (json['ID'] ?? json['id'] ?? 0) as int,
      orderId:     (json['order_id'] ?? 0) as int,
      productId:   (json['product_id'] ?? 0) as int,
      productName: (json['product_name'] ?? '') as String,
      price:       (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity:    (json['quantity'] ?? 1) as int,
      subtotal:    (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [id, productId, quantity];
}

// ─── Order ────────────────────────────────────────────────────────────────────
class OrderModel extends Equatable {
  final int id;
  final int userId;
  final OrderStatus status;
  final double totalAmount;
  final String shippingAddress;
  final String notes;
  final List<OrderItemModel> items;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.shippingAddress,
    required this.notes,
    required this.items,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id:              (json['ID'] ?? json['id'] ?? 0) as int,
      userId:          (json['user_id'] ?? 0) as int,
      status:          OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      totalAmount:     (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      shippingAddress: (json['shipping_address'] ?? '') as String,
      notes:           (json['notes'] ?? '') as String,
      items:           rawItems.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      createdAt:       DateTime.tryParse(json['CreatedAt'] ?? json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, userId, status];
}
