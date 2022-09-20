import 'package:android_flutter_test/model/recipes_model.dart';
import 'package:http/http.dart' as http;

Future getReCipesFromApi() async {
  List<RecipesModel> recipes = [];
  try {
    var res = await http.get(Uri.parse(
        "https://hf-android-app.s3-eu-west-1.amazonaws.com/android-test/recipes.json"));
    if (res.statusCode == 200) {
      recipes = recipesModelFromJson(res.body);
    } else {
      recipes = [];
    }
  } catch (e) {
    // throw (e);
    print(e);
  }
  return recipes;
}
