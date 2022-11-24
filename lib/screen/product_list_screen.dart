import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_lesson/model/product.dart';
import 'package:http_lesson/screen/product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [];
  bool _loading = false;

  @override
  void initState() {
    _fetchProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Builder(builder: (context) {
        if (_loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_products.isEmpty) {
          return const Center(
            child: Text('No Product'),
          );
        }

        return ListView.separated(
          itemBuilder: (context, i) {
            final product = _products[i];
            return ListTile(
              title: Text(product.title),
              subtitle: Text('${product.brand} - ${product.category}'),
              trailing: Text('${product.price}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: product),
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, i) => const Divider(),
          itemCount: _products.length,
        );
      }),
    );
  }

  Future<void> _fetchProduct() async {
    _loading = true;
    await Future.delayed(const Duration(seconds: 2));
    final url = Uri.parse('https://dummyjson.com/products');
    final response = await http.get(url);
    final bodyString = response.body;
    final body = jsonDecode(bodyString);
    final productsList = body['products'] as List;
    final productClean = productsList
        .map<Product>((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    _products.addAll(productClean);
    _loading = false;
    setState(() {});
  }
}
