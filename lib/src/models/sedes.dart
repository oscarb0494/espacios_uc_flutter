// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

SedeModel sedeModelFromJson(String str) => SedeModel.fromJson(json.decode(str));

String sedeModelToJson(SedeModel data) => json.encode(data.toJson());

class SedeModel {

    String id;
    String nombre;

    SedeModel({
        this.id = '',
        this.nombre = '',
    });

    factory SedeModel.fromJson(Map<String, dynamic> json) => SedeModel(
        id         : json["id"],
        nombre     : json["nombre"]
    );

    Map<String, dynamic> toJson() => {
        //"id"         : id,
        "nombre": nombre
    };
}