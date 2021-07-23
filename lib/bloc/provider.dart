import 'package:flutter/material.dart';
import 'package:formvalidation/bloc/login_bloc.dart';
import 'package:formvalidation/bloc/products_bloc.dart';
import 'package:formvalidation/providers/products_providers.dart';
export 'package:formvalidation/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  final loginBlock = new LoginBloc();
  final productBloc = new ProductsBloc();

  static Provider _instance;

  factory Provider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new Provider._internal(
        key: key,
        child: child,
      );
    }
    return _instance;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBlock;
  }

  static ProductsBloc productsBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .productBloc;
  }
}
