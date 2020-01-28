import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSelected = false;
  List<bool> _checkBoxBlock = [
    false,
    false
  ];
  List<String> _tareasIncompletas = [
      'Barrer',
      'Planchar'
    ];
    List _tareasCompletas = [
      'Botar basura',
      'Cocinar'
    ];


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _agregar(context),
          backgroundColor: Colors.red,
        ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 100.0),
            //margin: EdgeInsets.all(10.0),
            height: screenSize.height / 2.5,
            color: Colors.white54,
            child: _listaIncompletas(),
            
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            //margin: EdgeInsets.all(10.0),
            height: screenSize.height / 2.5,
            color: Colors.black12,
            child: _listaCompletas(_tareasCompletas),
            
          )
        ],
      ),
    );
  }

  Widget _listaIncompletas() {
    return ListView.builder(
      key: ValueKey(this),
      itemCount: _tareasIncompletas.length,
      itemBuilder: (BuildContext context, int index) {

        final item = _tareasIncompletas[index];

        return Dismissible(

          key: UniqueKey(),
          onDismissed: (direction){
            setState(() {
              if(direction == DismissDirection.endToStart){
                _tareasIncompletas.removeAt(index);
                _checkBoxBlock.removeAt(index);
              }
              if(direction == DismissDirection.startToEnd){
                _editar(context, index);
              }
            });
          },
          background: Container(color: Colors.red,),
          child: ListTile(
          title: Text('$item'),
          trailing: Checkbox(
            value: _checkBoxBlock[index],
            onChanged: (valor){
              setState(() {
              _checkBoxBlock[index] = valor;
              if(valor){
                _tareasCompletas.add(_tareasIncompletas[index]);
                _checkBoxBlock.removeAt(index);
                _tareasIncompletas.removeAt(index);             
              }
            });
            },
          ),
          ),
        );
      },
    addAutomaticKeepAlives: true,
    );
  }



  _listaCompletas(tareas) {
    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _tareasCompletas[index];

        return Dismissible(
          key : UniqueKey(),
          background: Container(color: Colors.red,),
          onDismissed: (direction){
            setState((){
              _tareasCompletas.removeAt(index);
            });
          },
          child: ListTile(
            title: Text('$item'),
            trailing: Checkbox(
              value:true,
              onChanged: (valor){}
                
                ),
          ),
            );
      }
      );
      
  }

    _editar(BuildContext context, int index){
      
      String tarea = _tareasIncompletas[index];

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){ 
          return AlertDialog(
            title: Text('Tarea'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (valor) => setState(() {
                    tarea = valor;
                  }),
                  decoration: InputDecoration(
                    hintText: tarea,
                  ),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Guardar'),
                      onPressed: () {
                        setState(() {
                          _tareasIncompletas[index] = tarea;
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    )
                  ],
                ),
              ]
          )
          );
          }
      );
    }

  _agregar(BuildContext context) {
    String _tareaIngresada = '';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Tarea'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (valor) => setState(() {
                    _tareaIngresada = valor;
                  }),
                ),
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: Text('Guardar'),
                      onPressed: () {
                        setState(() {
                          _tareasIncompletas.add(_tareaIngresada);
                          _checkBoxBlock.add(false);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
