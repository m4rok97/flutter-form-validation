import 'package:flutter/material.dart';
import 'package:formvalidation/bloc/provider.dart';
import 'package:formvalidation/models/product_model.dart';
import 'package:formvalidation/providers/products_providers.dart';
import 'package:formvalidation/providers/products_providers.dart';

class HomePage extends StatelessWidget {
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Home'),
      ),
      body: _createProductList(),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'product'));
  }

  Widget _createProductList() {
    return FutureBuilder(
        future: productsProvider.loadProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _createProduct(context, snapshot.data[index]);
                });
          }

          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ));
        });
  }

  Widget _createProduct(BuildContext context, ProductModel product) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productsProvider.deleteProduct(product);
      },
      // child: ListTile(
      //   title: Text('${product.title} - ${product.value}'),
      //   subtitle: Text('${product.available}'),
      //   onTap: () {
      //     Navigator.pushNamed(context, 'product', arguments: product);
      //   },
      // ),
      child: Card(
        child: Column(
          children: [
            (product.urlPhoto == null)
                ? Image(image: AssetImage('assets/214 no-image.png'))
                : FadeInImage(
                    placeholder: AssetImage('assets/214 jar-loading.gif'),
                    image: NetworkImage(product.urlPhoto),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text('${product.available}'),
              onTap: () {
                Navigator.pushNamed(context, 'product', arguments: product);
              },
            )
          ],
        ),
      ),
    );
  }
}
