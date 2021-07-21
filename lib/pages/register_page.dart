import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formvalidation/bloc/provider.dart';
import 'package:formvalidation/providers/user_provider.dart';
import 'package:formvalidation/utils/utils.dart';

class RegisterPage extends StatelessWidget {
  final userProvider = new UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _createBackground(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _createBackground(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final purpleBackground = Container(
      height: screenHeight * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0),
      ])),
    );

    final circle = Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.05),
            borderRadius: BorderRadius.circular(100)));

    return Stack(
      children: [
        purpleBackground,
        Positioned(
          child: circle,
          top: -40,
          left: -30,
        ),
        Positioned(
          child: circle,
          bottom: -50,
          right: -10,
        ),
        Positioned(
          child: circle,
          top: 90,
          right: 30,
        ),
        Positioned(
          child: circle,
          bottom: 120,
          left: -20,
        ),
        Positioned(
          child: circle,
          bottom: -50,
          left: -20,
        ),
        Center(
          child: Container(
            padding: EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Icon(
                  Icons.person_pin_circle,
                  color: Colors.white,
                  size: 100,
                ),
                Text(
                  'Login Page',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 200,
            ),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 30),
            margin: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  spreadRadius: 3)
            ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: [
                Text(
                  'Register',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 60),
                _createEmail(bloc),
                SizedBox(height: 30),
                _createPassword(bloc),
                SizedBox(height: 30),
                _createButton(bloc),
              ],
            ),
          ),
          FlatButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('login'),
              child: Text('Are you already register? Login')),
          SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _createEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.deepPurple,
                  ),
                  hintText: 'example@email.com',
                  labelText: 'Email',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.changeEmail,
            ));
      },
    );
  }

  Widget _createButton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Container(child: Text('Send')),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                elevation: 0,
                color: Colors.deepPurple,
                textColor: Colors.white,
                onPressed:
                    snapshot.hasData ? () => _register(bloc, context) : null));
      },
    );
  }

  Widget _createPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock_outline,
                    color: Colors.deepPurple,
                  ),
                  labelText: 'Password ',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.changePassword,
            ));
      },
    );
  }

  _register(LoginBloc bloc, BuildContext context) async {
    Map<String, dynamic> info =
        await userProvider.newUser(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.of(context).pushReplacementNamed('home');
    } else {
      showAlert(context, info['message']);
    }
  }
}
