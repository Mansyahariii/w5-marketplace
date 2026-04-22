import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_client.dart';
import '../models/order_model.dart';

abstract class OrderRepository {
  Future<OrderModel> checkout({
    required String shippingAddress,
    String notes,
  });
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10});
  Future<OrderModel> getOrderById(int orderId);
}

class OrderRepositoryImpl implements OrderRepository {
  final _dio = DioClient.instance;

  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String notes = '',
  }) async {
    final response = await _dio.post(
      ApiConstants.checkout,
      data: {
        'shipping_address': shippingAddress,
        'notes': notes,
      },
    );
    return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      ApiConstants.orders,
      queryParameters: {'page': page, 'limit': limit},
    );
    final rawData = response.data['data'] as List<dynamic>? ?? [];
    return rawData
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    final response = await _dio.get('${ApiConstants.orders}/$orderId');
    return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
