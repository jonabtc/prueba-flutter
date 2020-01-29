import 'dart:convert';

ListModel listModelFromJson(String str) => ListModel.fromJson(json.decode(str));

String listModelToJson(ListModel data) => json.encode(data.toJson());

class ListModel {
    String id;
    String titulo;
    bool realizado;

    ListModel({
        this.id,
        this.titulo = '',
        this.realizado = false,
    });

    factory ListModel.fromJson(Map<String, dynamic> json) => ListModel(
        id          : json["id"],
        titulo      : json["titulo"],
        realizado   : json["realizado"],
    );

    Map<String, dynamic> toJson() => {
        "titulo"    : titulo,
        "realizado" : realizado,
    };
}

