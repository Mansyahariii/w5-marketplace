import 'package:flutter/material.dart';
import 'package:market_place/features/dashboard/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>();

    return MaterialApp(
      home: Scaffold(
        body: switch (product.status) {
          // Tampilkan spinner saat loading
          ProductStatus.loading || ProductStatus.initial => const Center(
            child: CircularProgressIndicator(),
          ),

          // Tampilkan pesan error + tombol retry
          ProductStatus.error => Center(
            child: Column(
              children: [
                Text(product.error ?? 'Error'),
                ElevatedButton(
                  onPressed: () => product.fetchProducts(),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),

          // Tampilkan grid produk
          ProductStatus.loaded => GridView.builder(
            itemCount: product.products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (_, i) => _ProductCard(product: product.products[i]),
          ),
        },
      ),
    );
  }
}
