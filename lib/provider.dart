import 'dart:convert';
import 'package:fl_megamenu/category_menu_model.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert' show Utf8Decoder, json, jsonEncode, utf8;

class PlatanitosNodeProvider {
  // Categorias JSON
  Future<List<CategoryMenuModel>?> getCategoriesMenuList() async {
    try {
      const baseUrl =
          'https://phaphut45mexuz.s3.amazonaws.com/jsons/categoryListCloudSearch.json.part_00000';
      final uri = Uri.parse(baseUrl);

      final http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        // final decodeData = json.decode(response.body);
        // return {
        //   "status": decodeData["status"],
        //   "data": decodeData["data"],
        // };
        final decodeData =
            json.decode(const Utf8Decoder().convert(response.bodyBytes));
        if (decodeData != null) {
          List<CategoryMenuModel> listCategoryMenuModel =
              List<CategoryMenuModel>.empty(growable: true);

          decodeData.forEach((key, value) {
            CategoryMenuModel categoryMenuModel =
                CategoryMenuModel.fromJson(value);
            listCategoryMenuModel.add(categoryMenuModel);
          });
          return listCategoryMenuModel;
        }
      } else {
        throw Exception('Failed to load data ${response.statusCode}');
      }
    } catch (e) {
      print('getBenefitsPointsLevels: An error occurred $e');
      return null;
    }
    return null;
  }
}
