import 'dart:async';

import 'package:prueba_flutter/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar datos del stream
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Observable.combineLatest2(emailStream, passwordStream, (e, p)=>true);

  // Insert in stream

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
  }  

}