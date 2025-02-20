import 'package:flutter/material.dart';
import 'http_service.dart';
import 'post_model.dart';

class ProductsPage extends StatelessWidget {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: httpService.getProducts(),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<Product> products = snapshot.data ?? [];

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
                return ProductCard(product: product);
              },
            );
          } else {
            return const Center(child: Text("No products found"));
          }
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("Harga: Rp${product.price}"),
            Text("Stok: ${product.stock}"),
            if (product.description != null && product.description!.isNotEmpty)
              Text("Deskripsi: ${product.description}"),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(product.name),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Harga: Rp${product.price}"),
                          Text("Stok: ${product.stock}"),
                          if (product.description != null &&
                              product.description!.isNotEmpty)
                            Text("Deskripsi: ${product.description}"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Tutup"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Detail"),
            ),
          ],
        ),
      ),
    );
  }
}