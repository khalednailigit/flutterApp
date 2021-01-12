import 'package:flutter/material.dart';
import 'package:flutterapp/utils/extensions.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController, _passwordController;
  FocusNode _emailFocusNode, _passwordFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              autofocus: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (email) {
                if (email.isEmpty) {
                  return "Email is required";
                } else if (!email.trim().isValidEmail()) {
                  return "Email is not valid";
                }
                return null;
              },
              onFieldSubmitted: (email) {
                if (_emailFocusNode.hasFocus) _emailFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              onSaved: (email) {
                _emailController.text = _emailController.text.trim();
              },
            ),
            TextFormField(
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: (password) {
                if (password.isEmpty) {
                  return "Password is required";
                }
                return null;
              },
              onFieldSubmitted: (password) {
                if (_passwordFocusNode.hasFocus) _passwordFocusNode.unfocus();
                validateAndSignIn();
              },
            )
          ],
        ),
      ),
    );
  }

  void validateAndSignIn() {
    if (_formKey.currentState.validate()) {
      print("login");
    }
  }
}
