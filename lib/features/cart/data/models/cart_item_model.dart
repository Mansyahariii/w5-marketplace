import 'package:equatable/equatable.dart';
import '../../../dashboard/data/models/product_model.dart';

// ─── CartItem dari backend (gorm.Model → punya ID sendiri di DB) ─────────────
class CartItemModel extends Equatable {
  final int id;          // cart_item.ID di database
  final int userId;
  final int productId;
  final int quantity;
  final ProductModel? product; // di-embed dari relasi backend

  const CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  double get subTotal => (product?.price ?? 0) * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id:        (json['ID'] ?? json['id'] ?? 0) as int,
      userId:    (json['user_id'] ?? 0) as int,
      productId: (json['product_id'] ?? 0) as int,
      quantity:  (json['quantity'] ?? 1) as int,
      product:   json['product'] != null
          ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, productId, quantity];
}

// ─── CartResponse dari GET /v1/cart ──────────────────────────────────────────
class CartResponse {
  final List<CartItemModel> items;
  final int totalItems;
  final double totalPrice;

  const CartResponse({
    required this.items,
    required this.totalItems,
    required this.totalPrice,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return CartResponse(
      items:      rawItems.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      totalItems: (json['total_items'] ?? 0) as int,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
