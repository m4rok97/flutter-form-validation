import 'package:flutter/material.dart';
import 'package:formvalidation/bloc/products_bloc.dart';
import 'package:formvalidation/bloc/provider.dart';
import 'package:formvalidation/models/product_model.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Home'),
      ),
      body: _createProductList(productsBloc),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'product'));
  }

  Widget _createProductList(ProductsBloc productsBloc) {
    return StreamBuilder(
        stream: productsBloc.productStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _createProduct(
                      context, snapshot.data[index], productsBloc);
                });
          }

          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ));
        });
  }

  Widget _createProduct(
      BuildContext context, ProductModel product, ProductsBloc productsBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productsBloc.deleteProduct(product);
      },
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
