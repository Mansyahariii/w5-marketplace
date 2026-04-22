import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../models/cart_item_model.dart';

abstract class CartRepository {
  Future<CartResponse> getCart();
  Future<CartItemModel> addToCart({required int productId, required int quantity});
  Future<CartItemModel> updateItem({required int cartItemId, required int quantity});
  Future<void> removeItem(int cartItemId);
  Future<void> clearCart();
}

class CartRepositoryImpl implements CartRepository {
  final _dio = DioClient.instance;

  @override
  Future<CartResponse> getCart() async {
    final response = await _dio.get(ApiConstants.cart);
    return CartResponse.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CartItemModel> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final response = await _dio.post(
      ApiConstants.cart,
      data: {
        'product_id': productId,
        'quantity':   quantity,
      },
    );
    return CartItemModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<CartItemModel> updateItem({
    required int cartItemId,
    required int quantity,
  }) async {
    final response = await _dio.put(
      '${ApiConstants.cart}/$cartItemId',
      data: {'quantity': quantity},
    );
    return CartItemModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> removeItem(int cartItemId) async {
    await _dio.delete('${ApiConstants.cart}/$cartItemId');
  }

  @override
  Future<void> clearCart() async {
    await _dio.delete(ApiConstants.cart);
  }
}
