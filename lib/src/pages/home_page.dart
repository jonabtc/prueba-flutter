import 'package:flutter/material.dart';
import 'package:prueba_flutter/src/models/list_model.dart';
import 'package:prueba_flutter/src/servicios/tareas_providers.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListModel listModel = new ListModel();
  final tareasProvider = new TareasProviedr();

  bool isSelected = false;

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
            child: _listaCompletas(),
          )
        ],
      ),
    );
  }

  Widget _listaIncompletas() {
    return FutureBuilder(
      future: tareasProvider
          .cargarTareas(false, new http.Client()), // false si la tarea aun no se completa
      builder: (BuildContext context, AsyncSnapshot<List<ListModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            key: ValueKey(this),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              final item = snapshot.data[index];

              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    if (direction == DismissDirection.endToStart) {
                      tareasProvider.borrarTarea(item.id, new http.Client());
                    }

                    if (direction == DismissDirection.startToEnd) {
                      _editar(context, item);
                    }
                  });
                },
                background: Container(
                  color: Colors.red,
                ),
                child: ListTile(
                  title: Text(item.titulo),
                  trailing: Checkbox(
                    value: item.realizado,
                    onChanged: (valor) {
                      item.realizado = valor;
                      setState(() {
                        
                        tareasProvider.editarTarea(item, new http.Client());
                      });
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _listaCompletas() {
    return FutureBuilder(
      future: tareasProvider
          .cargarTareas(true, new http.Client()), // true si las tareas estan realizadas
      builder: (BuildContext context, AsyncSnapshot<List<ListModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      tareasProvider.borrarTarea(item.id, new http.Client());
                    });
                  },
                  child: ListTile(
                    title: Text(item.titulo),
                    trailing: Checkbox(value: true, onChanged: (valor) {}),
                  ),
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
                          listModel.titulo = _tareaIngresada;
                          listModel.realizado = false;
                          tareasProvider.crearTarea(listModel, new http.Client());
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

  // Widget _listaIncompletas() {
  //   return ListView.builder(
  //     key: ValueKey(this),
  //     itemCount: _tareasIncompletas.length,
  //     itemBuilder: (BuildContext context, int index) {

  //       final item = _tareasIncompletas[index];

  //       return Dismissible(

  //         key: UniqueKey(),
  //         onDismissed: (direction){
  //           setState(() {
  //             if(direction == DismissDirection.endToStart){
  //               _tareasIncompletas.removeAt(index);
  //               _checkBoxBlock.removeAt(index);
  //             }
  //             if(direction == DismissDirection.startToEnd){
  //               _editar(context, index);
  //             }
  //           });
  //         },
  //         background: Container(color: Colors.red,),
  //         child: ListTile(
  //         title: Text('$item'),
  //         trailing: Checkbox(
  //           value: _checkBoxBlock[index],
  //           onChanged: (valor){
  //             setState(() {
  //             _checkBoxBlock[index] = valor;
  //             if(valor){
  //               _tareasCompletas.add(_tareasIncompletas[index]);
  //               _checkBoxBlock.removeAt(index);
  //               _tareasIncompletas.removeAt(index);
  //             }
  //           });
  //           },
  //         ),
  //         ),
  //       );
  //     },
  //   addAutomaticKeepAlives: true,
  //   );
  // }

  // _listaCompletas(tareas) {
  //   return ListView.builder(
  //       itemCount: tareas.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         final item = _tareasCompletas[index];

  //         return Dismissible(
  //           key: UniqueKey(),
  //           background: Container(
  //             color: Colors.red,
  //           ),
  //           onDismissed: (direction) {
  //             setState(() {
  //               _tareasCompletas.removeAt(index);
  //             });
  //           },
  //           child: ListTile(
  //             title: Text('$item'),
  //             trailing: Checkbox(value: true, onChanged: (valor) {}),
  //           ),
  //         );
  //       });
  // }

  _editar(BuildContext context, ListModel item) {
    String tarea = item.titulo;

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              title: Text('Tarea'),
              content:
                  Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                          item.titulo = tarea;
                          tareasProvider.editarTarea(item, new http.Client());
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
              ]));
        });
  }

//   _agregar(BuildContext context) {
//     String _tareaIngresada = '';

//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Tarea'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 TextField(
//                   keyboardType: TextInputType.text,
//                   onChanged: (valor) => setState(() {
//                     _tareaIngresada = valor;
//                   }),
//                 ),
//                 Row(
//                   children: <Widget>[
//                     FlatButton(
//                       child: Text('Guardar'),
//                       onPressed: () {
//                         setState(() {
//                           _tareasIncompletas.add(_tareaIngresada);
//                           _checkBoxBlock.add(false);
//                           Navigator.pop(context);
//                         });
//                       },
//                     ),
//                     FlatButton(
//                       child: Text('Cancelar'),
//                       onPressed: () {
//                         setState(() {
//                           Navigator.pop(context);
//                         });
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           );
//         });
//   }
// }
}
