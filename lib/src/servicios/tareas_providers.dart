import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:prueba_flutter/src/models/list_model.dart';

class TareasProviedr {
  final String _url = 'https://flutter-prueba-e5ba2.firebaseio.com';

  Future<bool> crearTarea(ListModel listModel) async {
    final url = "$_url/tareas.json";

    final resp = await http.post(url, body: listModelToJson(listModel));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ListModel>> cargarTareas(bool isRealizado) async {
    final url = '$_url/tareas.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ListModel> tareas = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, tarea) {
      final tareaTemp = ListModel.fromJson(tarea);
      tareaTemp.id = id;
      if (tareaTemp.realizado == isRealizado) tareas.add(tareaTemp);
    });

    print(tareas);

    return tareas;
  }

  Future<int> borrarTarea(String id) async {
    final url = '$_url/tareas/$id.json';
    await http.delete(url);

    return 1;
  }

  Future<bool> editarTarea(ListModel listModel) async {
    final url = "$_url/tareas/${listModel.id}.json";

    final resp = await http.put(url, body: listModelToJson(listModel));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }
}
