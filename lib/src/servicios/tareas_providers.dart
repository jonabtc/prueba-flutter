import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_flutter/src/models/list_model.dart';

class TareasProviedr {
  
  final String _url = 'https://flutter-prueba-e5ba2.firebaseio.com';
  Future<bool> crearTarea(ListModel listModel, http.Client client) async {
    final url = "$_url/tareas.json";
    final resp = await client.post(url, body: listModelToJson(listModel));
    return true;
  }

  Future<List<ListModel>> cargarTareas(bool isRealizado, http.Client client) async {
    final url = '$_url/tareas.json';
    final resp = await client.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ListModel> tareas = new List();
    if (decodedData == null) return [];
    decodedData.forEach((id, tarea) {
      final tareaTemp = ListModel.fromJson(tarea);
      tareaTemp.id = id;
      if (tareaTemp.realizado == isRealizado) tareas.add(tareaTemp);
    });
    return tareas;
  }

  Future<bool> borrarTarea(String id, http.Client client) async {
    final url = '$_url/tareas/$id.json';
    await client.delete(url);
    return true;
  }

  Future<bool> editarTarea(ListModel listModel, http.Client client) async {
    final url = "$_url/tareas/${listModel.id}.json";
    final resp = await client.put(url, body: listModelToJson(listModel));
    return true;
  }
}
