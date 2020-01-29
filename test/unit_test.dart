
import 'package:prueba_flutter/src/bloc/validators.dart';
import 'package:test/test.dart';


void main(){
  
  test('prueba de match correo FALSE', (){    
    var result = Validators.matchMail('asdfasdfgmail.com');    
    expect(result, false);
  });

  test('prueba de match correo TRUE', (){    
    var result = Validators.matchMail('asdfasdf@gmail.com');    
    expect(result, true );
  });

  test('password FALSE', (){    
    var result = Validators.acceptedPass('12345');    
    expect(result, false);
  });

  test('password TRUE', (){    
    var result = Validators.acceptedPass('123456');    
    expect(result, true );
  });
  

}