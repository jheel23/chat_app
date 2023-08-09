import 'package:chat_app/picker/user_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AuthWidget extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
  ) submitAuthFormFn;
  //CONSTRUCTOR-->
  AuthWidget(this.submitAuthFormFn, this.isLoading);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  var _dontCreateNewAccount = true;
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImage;
  void _storedImage(File image) {
    _userImage = image;
  }

  //SUBMIT FORM-->
  void _submitform() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); //<--CLOSES DEVICE KEYBOARD
    if (_userImage == null && !_dontCreateNewAccount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick a profile image.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      //trim()-->removes whitespace from the inputs(JUST A GOOD USER EXPERIENCE)
      widget.submitAuthFormFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImage!,
        _dontCreateNewAccount,
      );

      // Use those values to send our auth request ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shadowColor: Theme.of(context).primaryColor,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!_dontCreateNewAccount) USerImageProfile(_storedImage),
                TextFormField(
                  key: ValueKey('email'),
                  onSaved: (newValue) => _userEmail = newValue!,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@gmail.com')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (!_dontCreateNewAccount)
                  TextFormField(
                    key: ValueKey('username'),
                    onSaved: (newValue) => _userName = newValue!,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  onSaved: (newValue) => _userPassword = newValue!,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters long.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(3),
                        shadowColor: MaterialStateProperty.all(Colors.purple)),
                    onPressed: _submitform,
                    child: Text(_dontCreateNewAccount ? 'Login' : 'Sign Up'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _dontCreateNewAccount = !_dontCreateNewAccount;
                      });
                    },
                    child: Text(!_dontCreateNewAccount
                        ? 'I already have an Account!'
                        : 'Create new account'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
