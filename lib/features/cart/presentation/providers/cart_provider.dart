import 'package:flutter/foundation.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/cart_repository.dart';
import '../../../dashboard/data/models/product_model.dart';

enum CartStatus { initial, loading, loaded, error }

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;

  CartProvider({CartRepository? repo})
      : _repo = repo ?? CartRepositoryImpl();

  // ─── State ────────────────────────────────────────────────
  List<CartItemModel> _items    = [];
  CartStatus          _status   = CartStatus.initial;
  String?             _error;
  bool                _isMutating = false; // true saat sedang add/update/delete

  // ─── Getters ─────────────────────────────────────────────
  List<CartItemModel> get items       => List.unmodifiable(_items);
  CartStatus          get status      => _status;
  String?             get error       => _error;
  bool                get isLoading   => _status == CartStatus.loading;
  bool                get isMutating  => _isMutating;

  int    get totalItems => _items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice => _items.fold(0.0, (sum, i) => sum + i.subTotal);

  bool containsProduct(int productId) =>
      _items.any((i) => i.productId == productId);

  int quantityOf(int productId) {
    final idx = _items.indexWhere((i) => i.productId == productId);
    return idx != -1 ? _items[idx].quantity : 0;
  }

  // ─── Load Cart dari Backend ──────────────────────────────
  Future<void> loadCart() async {
    _status = CartStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final cartResponse = await _repo.getCart();
      _items  = cartResponse.items;
      _status = CartStatus.loaded;
    } catch (e) {
      _error  = _parseError(e);
      _status = CartStatus.error;
    }
    notifyListeners();
  }

  // ─── Tambah produk ke cart (API: POST /v1/cart) ──────────
  Future<void> addItem(ProductModel product) async {
    _isMutating = true;
    notifyListeners();

    try {
      final existingIdx = _items.indexWhere((i) => i.productId == product.id);
      final newQty = existingIdx != -1 ? _items[existingIdx].quantity + 1 : 1;

      if (existingIdx != -1) {
        // Update qty lewat PUT /v1/cart/:id
        final updated = await _repo.updateItem(
          cartItemId: _items[existingIdx].id,
          quantity:   newQty,
        );
        _items[existingIdx] = updated;
      } else {
        // Tambah baru lewat POST /v1/cart
        final newItem = await _repo.addToCart(
          productId: product.id,
          quantity:  1,
        );
        _items.add(
          CartItemModel(
            id:        newItem.id,
            userId:    newItem.userId,
            productId: newItem.productId,
            quantity:  newItem.quantity,
            product:   newItem.product ?? product, // inject dari param jika backend tidak embed
          ),
        );
      }
    } catch (e) {
      _error = _parseError(e);
    }

    _isMutating = false;
    notifyListeners();
  }

  // ─── Kurangi quantity (API: PUT /v1/cart/:id) ───────────
  Future<void> decreaseItem(int productId) async {
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx == -1) return;

    _isMutating = true;
    notifyListeners();

    try {
      if (_items[idx].quantity > 1) {
        final updated = await _repo.updateItem(
          cartItemId: _items[idx].id,
          quantity:   _items[idx].quantity - 1,
        );
        _items[idx] = CartItemModel(
          id:        updated.id,
          userId:    updated.userId,
          productId: updated.productId,
          quantity:  updated.quantity,
          product:   _items[idx].product, // pertahankan product embed
        );
      } else {
        await _repo.removeItem(_items[idx].id);
        _items.removeAt(idx);
      }
    } catch (e) {
      _error = _parseError(e);
    }

    _isMutating = false;
    notifyListeners();
  }

  // ─── Hapus item langsung (API: DELETE /v1/cart/:id) ──────
  Future<void> deleteItem(int productId) async {
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx == -1) return;

    _isMutating = true;
    notifyListeners();

    try {
      await _repo.removeItem(_items[idx].id);
      _items.removeAt(idx);
    } catch (e) {
      _error = _parseError(e);
    }

    _isMutating = false;
    notifyListeners();
  }

  // ─── Kosongkan cart (API: DELETE /v1/cart) ───────────────
  Future<void> clearCart() async {
    _isMutating = true;
    notifyListeners();

    try {
      await _repo.clearCart();
      _items.clear();
    } catch (e) {
      _error = _parseError(e);
    }

    _isMutating = false;
    notifyListeners();
  }

  // ─── Helpers ──────────────────────────────────────────────
  String _parseError(Object e) =>
      e.toString().replaceFirst('Exception: ', '');
}
