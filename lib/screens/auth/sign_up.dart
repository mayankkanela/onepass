import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onepass/providers/user_provider.dart';
import 'package:onepass/utils/constants.dart';
import 'package:onepass/utils/utility.dart' as Utils;
import 'package:provider/provider.dart';

class SignUp extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _confirmController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dw = Utils.displayWidth(context) / 100;
    final dh = Utils.displayHeight(context) / 100;
    return SafeArea(
        child: Scaffold(
      appBar: _appBar(dw, dh),
      body: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dh * 1)),
            margin: EdgeInsets.only(top: dh * 3, left: dw * 5, right: dw * 5),
            child: Form(
              key: _formKey,
              child: Container(
                width: dw * 100,
                padding: EdgeInsets.all(dh * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Enter your email",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: dh * 2.4,
                      ),
                    ),
                    SizedBox(
                      height: dh * 2,
                    ),
                    TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) =>
                          Utils.emptyOrNullStringValidator(text),
                      decoration: InputDecoration(
                          hintText: "ex: jondoe@example.com",
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(dh * 1))),
                    ),
                    SizedBox(
                      height: dh * 2,
                    ),
                    Text(
                      "Enter password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: dh * 2.4,
                      ),
                    ),
                    SizedBox(
                      height: dh * 2,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      validator: (text) =>
                          Utils.emptyOrNullStringValidator(text),
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "********",
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(dh * 1))),
                    ),
                    SizedBox(
                      height: dh * 2,
                    ),
                    Text(
                      "Confirm password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: dh * 2.4,
                      ),
                    ),
                    SizedBox(
                      height: dh * 2,
                    ),
                    TextFormField(
                      controller: _confirmController,
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty)
                          return "Cannot be Empty!";
                        else if (_passwordController.text.isEmpty ||
                            _passwordController.text != text)
                          return "Passwords do not match";
                        return null;
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "********",
                          labelText: "Confirm password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(dh * 1))),
                    ),
                    SizedBox(
                      height: dh * 2,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black)),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).pushReplacementNamed(
                                    Constants.ROUTE_SIGN_IN);
                              },
                            text: "Sign In",
                            style: TextStyle(color: Colors.blue))
                      ])),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(dh * 2),
            margin: EdgeInsets.only(top: dh * 2),
            child: FlatButton(
                onPressed: () => _createUser(context),
                color: Colors.blue,
                padding: EdgeInsets.all(dh * 2),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(dh * 1)),
                child: Text(
                  "SignUp",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: dh * 2.4,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    ));
  }

  AppBar _appBar(double dw, double dh) {
    return AppBar(
      title: Text("SignUp"),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue,
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(dh * 3),
              bottomRight: Radius.circular(dh * 3))),
    );
  }

  _createUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final res = await Provider.of<UserProvider>(context, listen: false)
          .signUp(_emailController.text, _passwordController.text);
      if (res) {
        Navigator.of(context).pushReplacementNamed(Constants.ROUTE_HOME);
      }
    }
  }
}
