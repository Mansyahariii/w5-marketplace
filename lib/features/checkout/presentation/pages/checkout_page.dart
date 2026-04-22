import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_router.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey        = GlobalKey<FormState>();
  final _addressCtrl    = TextEditingController();
  final _notesCtrl      = TextEditingController();

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _processCheckout(
    CartProvider cart,
    CheckoutProvider checkout,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await checkout.checkout(
      shippingAddress: _addressCtrl.text.trim(),
      notes:           _notesCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      // Kosongkan cart lokal juga (backend sudah handled)
      await cart.clearCart();
      if (!mounted) return;
      _showSuccessDialog(checkout.lastOrder?.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(checkout.error ?? 'Checkout gagal'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showSuccessDialog(int? orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 52,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (orderId != null)
              Text(
                'Order #$orderId',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 6),
            Text(
              'Terima kasih sudah berbelanja.\nPesanan Anda sedang diproses.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.dashboard,
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Kembali ke Beranda'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart     = context.watch<CartProvider>();
    final checkout = context.watch<CheckoutProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Keranjang kosong'))
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── Ringkasan Pesanan ────────────────────────
                          _SectionHeader(
                            icon: Icons.receipt_long_outlined,
                            title: 'Ringkasan Pesanan',
                            subtitle: '${cart.totalItems} item',
                          ),
                          const SizedBox(height: 12),
                          ...cart.items.map(
                            (item) => _CheckoutItemTile(
                              name:     item.product?.name ?? 'Produk #${item.productId}',
                              imageUrl: item.product?.imageUrl ?? '',
                              price:    item.product?.price ?? 0,
                              quantity: item.quantity,
                              subTotal: item.subTotal,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ─── Detail Biaya ─────────────────────────────
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _PriceRow(
                                  label: 'Subtotal',
                                  value: cart.totalPrice,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(height: 1),
                                ),
                                _PriceRow(
                                  label:     'Ongkos Kirim',
                                  value:     0,
                                  valueText: 'Gratis',
                                  valueColor: Colors.green,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(height: 1),
                                ),
                                _PriceRow(
                                  label:      'Total Pembayaran',
                                  value:      cart.totalPrice,
                                  isBold:     true,
                                  labelColor: AppColors.textPrimary,
                                  valueColor: AppColors.primaryDark,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ─── Form Pengiriman ──────────────────────────
                          _SectionHeader(
                            icon:     Icons.local_shipping_outlined,
                            title:    'Informasi Pengiriman',
                            subtitle: 'Wajib diisi',
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alamat Pengiriman',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _addressCtrl,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan alamat lengkap pengiriman...',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                      child: Icon(Icons.location_on_outlined, size: 20),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.all(14),
                                  ),
                                  validator: (v) => (v?.trim().isEmpty ?? true)
                                      ? 'Alamat pengiriman wajib diisi'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Catatan (opsional)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _notesCtrl,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    hintText: 'Contoh: Tolong jangan diketuk, dll.',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(bottom: 22),
                                      child: Icon(Icons.notes_outlined, size: 20),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.all(14),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),

                  // ─── Bottom: Tombol Bayar ─────────────────────────────
                  _buildCheckoutButton(cart, checkout),
                ],
              ),
            ),
    );
  }

  Widget _buildCheckoutButton(CartProvider cart, CheckoutProvider checkout) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Rp ${_formatPrice(cart.totalPrice)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: checkout.isLoading
                  ? null
                  : () => _processCheckout(cart, checkout),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: checkout.isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Bayar Sekarang',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckoutItemTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final double subTotal;

  const _CheckoutItemTile({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.subTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 55,
              height: 55,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 55,
                height: 55,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${_formatPrice(price)} × $quantity',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rp ${_formatPrice(subTotal)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final String? valueText;
  final Color? valueColor;
  final Color? labelColor;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueText,
    this.valueColor,
    this.labelColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = valueText ??
        'Rp ${value.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (m) => '${m[1]}.',
            )}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: labelColor ?? AppColors.textSecondary,
          ),
        ),
        Text(
          displayText,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
