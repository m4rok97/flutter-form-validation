import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/models/product_model.dart';
import 'package:formvalidation/providers/products_providers.dart';
import 'package:formvalidation/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productProvider = new ProductsProvider();
  final _imagePicker = new ImagePicker();

  bool _uploading = false;
  ProductModel product = new ProductModel();
  File photo;

  @override
  Widget build(BuildContext context) {
    final productData = ModalRoute.of(context).settings.arguments;

    if (productData != null) {
      product = productData;
    }

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text('Product'),
          actions: [
            IconButton(
                icon: Icon(Icons.photo_size_select_actual),
                onPressed: _selectPhoto),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _takePhoto,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _showPhoto(),
                    _createName(),
                    _createPrice(),
                    _createButton(),
                    _createAvailable()
                  ],
                ),
              )),
        ));
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Enter the name of the product';
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Price'),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Only numbers';
        }
      },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Available'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.available = value;
      }),
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Save'),
      icon: Icon(Icons.save),
      onPressed: _uploading ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() {
      _uploading = true;
    });

    if (photo != null) {
      product.urlPhoto = await productProvider.uploadImage(photo);
    }

    if (product.id == null) {
      productProvider.createProduct(product);
    } else {
      productProvider.editProduct(product);
    }

    _showSnackBar('The product was saved');

    setState(() {
      _uploading = false;
    });

    // Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepPurple,
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showPhoto() {
    if (product.urlPhoto != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/214 jar-loading.gif'),
        image: NetworkImage(product.urlPhoto),
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image(
      image: AssetImage(photo?.path ?? 'assets/214 no-image.png'),
      height: 300,
      fit: BoxFit.cover,
    );
  }

  void _selectPhoto() async {
    _processPhoto(ImageSource.gallery);
  }

  void _takePhoto() async {
    _processPhoto(ImageSource.camera);
  }

  void _processPhoto(ImageSource imageSource) async {
    final pickedFile = await _imagePicker.getImage(source: imageSource);

    photo = new File(pickedFile.path);

    if (photo != null) {
      product.urlPhoto = null;
    }

    setState(() {});
  }
}
