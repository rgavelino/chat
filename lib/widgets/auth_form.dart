import 'dart:io';

import 'package:chat/models/auth_data.dart';
import 'package:chat/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData authData) onSubmit;

  AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final AuthData _authData = AuthData();

  _submit() {
    bool isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_authData.image == null && _authData.isSignup) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text('Precisamos de ua foto'),
      //   backgroundColor: Theme.of(context).errorColor,
      // ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Precisamos de uma foto',
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));

      return;
    }

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  void _handlePickedImage(File image) {
    _authData.image = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    if (_authData.isSignup) UserImagePicker(_handlePickedImage),
                    if (_authData.isSignup)
                      TextFormField(
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        key: ValueKey('name'),
                        initialValue: _authData.name,
                        decoration: InputDecoration(labelText: 'Nome'),
                        onChanged: (value) => _authData.name = value,
                        validator: (value) {
                          if (value == null || value.trim().length < 4)
                            return 'Nome deve ter no mínimo 4 caracteres';
                          return null;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      decoration: InputDecoration(labelText: 'E-mail'),
                      onChanged: (value) => _authData.email = value,
                      validator: (value) {
                        if (value == null || !value.contains('@'))
                          return 'Digite um email válido';
                        return null;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Senha'),
                      onChanged: (value) => _authData.password = value,
                      validator: (value) {
                        if (value == null || value.trim().length < 7)
                          return 'Senha deve ter no mínimo 7 caracteres';
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    RaisedButton(
                      child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar'),
                      onPressed: _submit,
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(_authData.isLogin
                          ? 'Criar uma nova conta?'
                          : 'Já possui uma conta?'),
                      onPressed: () {
                        setState(() {
                          _authData.toggleMode();
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
