import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

      body: switch (product.status) {
        ProductStatus.loading || ProductStatus.initial => const Center(
          child: CircularProgressIndicator(),
        ),

        ProductStatus.error => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(product.error ?? 'Error'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: product.fetchProducts,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),

        ProductStatus.loaded => GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: product.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, i) {
            final p = product.products[i];

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Center(child: Text(p.name, textAlign: TextAlign.center)),
            );
          },
        ),
      },
    );
  }
}
