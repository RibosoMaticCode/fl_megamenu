// To parse this JSON data, do
//
//     final categoryMenuModel = categoryMenuModelFromJson(jsonString);

import 'dart:convert';

CategoryMenuModel categoryMenuModelFromJson(String str) =>
    CategoryMenuModel.fromJson(json.decode(str));

String categoryMenuModelToJson(CategoryMenuModel data) =>
    json.encode(data.toJson());

class CategoryMenuModel {
  CategoryMenuModel({
    this.description,
    this.idTaxonomiesTerms,
    this.taxonomyTerm,
    this.count,
    this.children,
    this.isExpanded,
    this.icon,
  });

  String? description;
  String? idTaxonomiesTerms;
  String? taxonomyTerm;
  int? count;
  Map? children;
  bool? isExpanded;
  String? icon;

  factory CategoryMenuModel.fromJson(Map<String, dynamic> json) =>
      CategoryMenuModel(
        description: json["description"],
        idTaxonomiesTerms: json["id_taxonomies_terms"],
        taxonomyTerm: json["taxonomy_term"],
        count: json["count"],
        children: json["children"] as Map,
        isExpanded: false,
        icon: json["icon"] ?? json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "id_taxonomies_terms": idTaxonomiesTerms,
        "taxonomy_term": taxonomyTerm,
        "count": count,
        "children": children,
        "isExpaneded": isExpanded,
        "icon": icon,
      };
}
