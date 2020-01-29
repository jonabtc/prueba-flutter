import 'dart:async';

class Validators {
  static bool matchMail(String email) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(email) ? true : false;
  }

  static bool acceptedPass(String password) => (password.length >= 6) ? true : false;

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) => matchMail(email) ? sink.add(email) : sink.addError('Correo incorrecto'));

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) => acceptedPass(password) ? sink.add(password) : sink.addError('La contraseña debe contener más de 6 carácteres'));
}
