import 'dart:convert';

import 'package:espacios_uc/horarios_recursos.dart';
import 'package:flutter/material.dart';
import 'package:espacios_uc/app_theme.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

class EspaciosPage extends StatefulWidget {
  final int id;

  EspaciosPage({required this.id});

  @override
  _EspacioPageState createState() => _EspacioPageState(id: this.id);
}

class _EspacioPageState extends State<EspaciosPage> {
  final int id;
  _EspacioPageState({required this.id});

  Map? data;
  List? espaciosData;

  getEspacios() async {
    http.Response response =
        await http.get(Uri.parse("http://127.0.0.1:3000/sede/getespacios/$id"));

    data = json.decode(response.body);
    setState(() {
      espaciosData = data!['sede'][0]['Espacios'];
      print(espaciosData);
    });

    debugPrint(response.body);
  }

  @override
  void initState() {
    super.initState();
    getEspacios();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Container(
      color: isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('espacios'),
            backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
            elevation: 0,
          ),
          backgroundColor:
              isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
          body: Stack(children: <Widget>[
            Center(
              child: ListView.builder(
                  itemCount: espaciosData == null ? 0 : espaciosData?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HorariosRecursosPage(id: int.parse("${espaciosData![index]["id"]}"))),
                          )
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "$index",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://res.cloudinary.com/universidaddecaldasflutter/image/upload/v1670993347/admisiones_1_bvflng.jpg"),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "${espaciosData![index]["nombre"]} ${espaciosData![index]["capacidad"]}",
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700),
                                  ))
                              //Text("${sedesData![index]["id"]}")
                            ]),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {},
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your feedback...'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
