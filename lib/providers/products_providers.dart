import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/models/product_model.dart';
import 'package:formvalidation/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductsProvider {
  final String _url =
      'https://flutter-various-19dc3-default-rtdb.firebaseio.com';

  final _prefs = new UserPreferences();

  Future<bool> createProduct(ProductModel productModel) async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final response =
        await http.post(url, body: productModelToJson(productModel));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final response = await http.get(url);

    final List<ProductModel> products = [];

    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null) return [];

    if (decodedData['error'] != null) return [];

    decodedData.forEach((id, product) {
      final productTemp = ProductModel.fromJson(product);
      productTemp.id = id;
      products.add(productTemp);
    });
    print(products);
    return products;
  }

  Future<bool> deleteProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final response = await http.delete(url);

    print(json.decode(response.body));

    return true;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productModelToJson(product));

    print(json.decode(response.body));

    return true;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dc9z4ugqu/image/upload?upload_preset=utlrbk1h');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url); //image/jpg

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Something is wrong uploading the image');
      print(response.body);
      return null;
    }

    final responseData = json.decode(response.body);

    print(responseData['secure_url']);

    return responseData['secure_url'];
  }
}
