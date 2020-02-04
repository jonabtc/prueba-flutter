import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prueba_flutter/src/models/list_model.dart';
import 'package:prueba_flutter/src/servicios/tareas_providers.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock with http.Client {}

void main() {
  http.Client client = MockClient();
  TareasProviedr tareasProviedr = TareasProviedr();

  when(client.get('https://flutter-prueba-e5ba2.firebaseio.com/tareas.json'))
      .thenAnswer((_) async => Future.value(http.Response(
          '''{"-LznLSrFbuMl5UZxArEF":{"realizado":false,"titulo":"tarea 1"},"-LznLWz_hQMbTKTT3kad":{"realizado":false,"titulo":"tarea 2"},"-LznLZT13kgbdy6RGeg1":{"realizado":true,"titulo":"tarea 3"}}''',
          200)));
  test("Carga de datos", () async {
    final tarea = await tareasProviedr.cargarTareas(false, client);
    final List<ListModel> resultado = [
      new ListModel(
          id: '-LznLSrFbuMl5UZxArEF', titulo: 'tarea 1', realizado: false),
      new ListModel(
          id: '-LznLWz_hQMbTKTT3kad', titulo: 'tarea 2', realizado: false),
      new ListModel(
          id: '-LznLZT13kgbdy6RGeg1', titulo: 'tarea 3', realizado: true)
    ];
    expect(tarea[0].id, resultado[0].id);
  });

  test("Eliminar datos", () async {

    final tarea = await tareasProviedr.borrarTarea('-LznLSrFbuMl5UZxArEF', client);
    expect(tarea, true);
  });
  
  test("Editar datos", () async {
    final listModel = new ListModel(id: '-LznLWz_hQMbTKTT3kad', titulo: 'tarea 2', realizado: false);
    final tarea = await tareasProviedr.editarTarea(listModel, client);
    expect(tarea, true);
  });
}
