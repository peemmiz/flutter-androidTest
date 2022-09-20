import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:android_flutter_test/model/recipes_model.dart';
import 'package:android_flutter_test/services/recipes_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RecipesModel> recipeList = [];
  bool sortAz = false;

  @override
  void initState() {
    super.initState();
    getData();
    setState(() {
      //ทุกๆ 5 นาที ทำงานที่ loadDataFormApi()
      const oneSecond = const Duration(minutes: 5);
      new Timer.periodic(oneSecond, (Timer t) => loadDataFormApi());
    });
  }

  //loadDataFormApi โหลดข้อมูลจาก api แล้วเก็บข้อมูลไว้ในแอพ
  Future<void> loadDataFormApi() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    recipeList = await getReCipesFromApi();
    pref.setString("recipePref", json.encode(recipeList));
    log("work at loadDataFormApi");
    setState(() {});
  }

  //ทำงานเมื่อเปิดหน้าครั้งแรก
  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("recipePref") == null ||
        pref.get('recipePref') == null) {
      loadDataFormApi();
    } else {
      String json = pref.getString('recipePref')!;
      var tagObjsJson = jsonDecode(json) as List;
      recipeList =
          tagObjsJson.map((tagJson) => RecipesModel.fromJson(tagJson)).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              iconSize: 25,
              icon: Icon(Icons.sort_by_alpha_outlined),
              onPressed: () async {
                //เรียง List ตามตัวอักษรและจัดเก็บในแอพ
                SharedPreferences pref = await SharedPreferences.getInstance();
                if (sortAz) {
                  recipeList.sort((a, b) {
                    return -a.name!.compareTo(b.name!);
                  });
                  sortAz = false;
                } else {
                  recipeList.sort((a, b) {
                    return a.name!.compareTo(b.name!);
                  });
                  sortAz = true;
                }
                pref.setString("recipePref", json.encode(recipeList));
                setState(() {});
              })
        ],
      ),
      body: ListView.builder(
          itemCount: recipeList.length,
          itemBuilder: (context, index) {
            return listRecipeCard(recipeList[index], index);
          }),
    );
  }

  listRecipeCard(RecipesModel data, int index) {
    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(child: profileCircleAvatar(data.image.toString())),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name.toString().replaceAll("", "\u{200B}"),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        //เพิ่ม/ลบรายการโปรดและจัดเก็บในแอพ
                        if (data.favorite == null) {
                          data.favorite = "favorite recipe";
                        } else {
                          data.favorite = null;
                        }
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        recipeList[index].favorite = data.favorite;
                        pref.setString("recipePref", json.encode(recipeList));
                        setState(() {});
                      },
                      child: data.favorite == null
                          ? Text('add to favorite')
                          : Text('remove from favorite'),
                    ),
                  ],
                ),
              ),
              if (data.favorite != null)
                const Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
            ]),
          ]),
        ));
  }

  profileCircleAvatar(String img) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40,
        child: ClipRRect(
          child: Image.network(
            img,
            fit: BoxFit.cover,
            height: 200,
            width: 300,
          ),
          borderRadius: BorderRadius.circular(80),
        ));
  }
}
