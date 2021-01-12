import 'package:flutter/material.dart';
import 'package:flutterapp/ui/home/home_provider.dart';
import 'package:flutterapp/ui/home/home_screen.dart';
import 'package:flutterapp/ui/singin/signin_provider.dart';
import 'package:flutterapp/utils/extensions.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _emailController, _passwordController;
  FocusNode _emailFocusNode, _passwordFocusNode;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
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
              SizedBox.fromSize(
                size: Size.fromHeight(8.0),
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
              ),
              SizedBox.fromSize(
                size: Size.fromHeight(16.0),
              ),
              if (context.watch<SignInProvider>().loginStatus !=
                  AuthStatus.Loading)
                RaisedButton(
                  onPressed: () {
                    validateAndSignIn();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              if (context.watch<SignInProvider>().loginStatus ==
                  AuthStatus.Loading)
                Center(
                  child: CircularProgressIndicator(),
                )
            ],
          ),
        ),
      ),
    );
  }

  void validateAndSignIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final value = await Provider.of<SignInProvider>(context, listen: false)
          .signIn(
              email: _emailController.text, password: _passwordController.text);
      if (Provider.of<SignInProvider>(context, listen: false).loginStatus ==
          AuthStatus.LoggedIn) {
        Navigator.of(context)
          ..pop()
          ..push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => HomeProvider(),
                child: HomeScreen(),
              ),
            ),
          );
      } else if (Provider.of<SignInProvider>(context, listen: false)
              .loginStatus ==
          AuthStatus.AuthError) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please validate your credential"),
        ));
      }
    }
  }
}
