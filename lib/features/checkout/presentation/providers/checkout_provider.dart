import 'package:flutter/foundation.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/order_repository.dart';

enum CheckoutStatus { initial, loading, success, error }

class CheckoutProvider extends ChangeNotifier {
  final OrderRepository _repo;

  CheckoutProvider({OrderRepository? repo})
      : _repo = repo ?? OrderRepositoryImpl();

  // ─── State ────────────────────────────────────────────────
  CheckoutStatus _status  = CheckoutStatus.initial;
  String?        _error;
  OrderModel?    _lastOrder;

  List<OrderModel> _orders      = [];
  bool             _ordersLoaded = false;

  // ─── Getters ─────────────────────────────────────────────
  CheckoutStatus   get status       => _status;
  String?          get error        => _error;
  OrderModel?      get lastOrder    => _lastOrder;
  List<OrderModel> get orders       => List.unmodifiable(_orders);
  bool             get isLoading    => _status == CheckoutStatus.loading;
  bool             get ordersLoaded => _ordersLoaded;

  // ─── Checkout (POST /v1/orders/checkout) ─────────────────
  Future<bool> checkout({
    required String shippingAddress,
    String notes = '',
  }) async {
    _status = CheckoutStatus.loading;
    _error  = null;
    notifyListeners();

    try {
      final order = await _repo.checkout(
        shippingAddress: shippingAddress,
        notes: notes,
      );
      _lastOrder = order;
      _status    = CheckoutStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _error  = _parseError(e);
      _status = CheckoutStatus.error;
      notifyListeners();
      return false;
    }
  }

  // ─── Load riwayat order (GET /v1/orders) ─────────────────
  Future<void> loadMyOrders({int page = 1, int limit = 10}) async {
    _status = CheckoutStatus.loading;
    _error  = null;
    notifyListeners();

    try {
      _orders       = await _repo.getMyOrders(page: page, limit: limit);
      _ordersLoaded = true;
      _status       = CheckoutStatus.initial; // kembali ke idle setelah load
    } catch (e) {
      _error  = _parseError(e);
      _status = CheckoutStatus.error;
    }
    notifyListeners();
  }

  // ─── Reset untuk re-checkout ──────────────────────────────
  void reset() {
    _status    = CheckoutStatus.initial;
    _error     = null;
    _lastOrder = null;
    notifyListeners();
  }

  String _parseError(Object e) =>
      e.toString().replaceFirst('Exception: ', '');
}
