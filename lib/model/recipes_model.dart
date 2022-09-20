// To parse this JSON data, do
//
//     final recipesModel = recipesModelFromJson(jsonString);

import 'dart:convert';

List<RecipesModel> recipesModelFromJson(String str) => List<RecipesModel>.from(
    json.decode(str).map((x) => RecipesModel.fromJson(x)));

String recipesModelToJson(List<RecipesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecipesModel {
  RecipesModel({
    this.calories,
    this.carbos,
    this.country,
    this.description,
    this.difficulty,
    this.fats,
    this.headline,
    this.id,
    this.image,
    this.name,
    this.proteins,
    this.thumb,
    this.time,
    this.favorite,
  });

  String? calories;
  String? carbos;
  String? country;
  String? description;
  int? difficulty;
  String? fats;
  String? headline;
  String? id;
  String? image;
  String? name;
  String? proteins;
  String? thumb;
  String? time;
  String? favorite;

  factory RecipesModel.fromJson(Map<String, dynamic> json) => RecipesModel(
        calories: json["calories"] == null ? null : json["calories"],
        carbos: json["carbos"] == null ? null : json["carbos"],
        country: json["country"] == null ? null : json["country"],
        description: json["description"] == null ? null : json["description"],
        difficulty: json["difficulty"] == null ? null : json["difficulty"],
        fats: json["fats"] == null ? null : json["fats"],
        headline: json["headline"] == null ? null : json["headline"],
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        name: json["name"] == null ? null : json["name"],
        proteins: json["proteins"] == null ? null : json["proteins"],
        thumb: json["thumb"] == null ? null : json["thumb"],
        time: json["time"] == null ? null : json["time"],
        favorite: json["favorite"] == null ? null : json["favorite"],
      );

  Map<String, dynamic> toJson() => {
        "calories": calories == null ? null : calories,
        "carbos": carbos == null ? null : carbos,
        "country": country == null ? null : country,
        "description": description == null ? null : description,
        "difficulty": difficulty == null ? null : difficulty,
        "fats": fats == null ? null : fats,
        "headline": headline == null ? null : headline,
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "name": name == null ? null : name,
        "proteins": proteins == null ? null : proteins,
        "thumb": thumb == null ? null : thumb,
        "time": time == null ? null : time,
        "favorite": favorite == null ? null : favorite,
      };
}
