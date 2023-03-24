import 'package:rest/Screens/note.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:rest/restapi/curd.dart';
import 'package:rest/restapi/link_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNote extends StatefulWidget {
  static const String routename = 'addnotespage';

  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with Curd {
  late SharedPreferences sharedPreferences;

  final GlobalKey<FormState> _key = GlobalKey();

  final ImagePicker ins = ImagePicker();

  File? file;

  TextEditingController title = TextEditingController();

  TextEditingController content = TextEditingController();

  addnote(BuildContext context) async {
    if (file == null) {
      return AwesomeDialog(
              context: context,
              body: const SizedBox(
                width: 300,
                height: 200,
                child: Text('chosse file first'),
              ),
              dialogType: DialogType.error,
              title: "Warn")
          .show();
    }
    if (_key.currentState!.validate()) {
      sharedPreferences = await SharedPreferences.getInstance();
      var response = await postRequestWithFile(
          linkadd,
          {
            "title": title.text,
            "content": content.text,
            "iduser": sharedPreferences.getString("id"),
          },
          file!);
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/backGroundLog.jpg'),
                    opacity: .2,
                    fit: BoxFit.fill)),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                      color: Colors.black38,
                      child: TextFormField(
                        controller: title,
                        maxLines: 1,
                        maxLength: 30,
                        validator: (data) {
                          if (data!.length >= 31 || data.length <= 1) {
                            return "title can not be more than 30 letter or less than 2";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.grey,
                            prefixIcon: Icon(Icons.note_add)),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                      color: Colors.black38,
                      child: TextFormField(
                        controller: content,
                        maxLength: 300,
                        maxLines: 4,
                        validator: (data) {
                          if (data!.length <= 9 || data.length >= 301) {
                            return "content can not be lass than 10 more than 300 letter";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Content',
                            filled: true,
                            fillColor: Colors.grey,
                            prefixIcon: Icon(Icons.note_add)),
                      )),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                                height: 200,
                                child: Column(
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          var response = await ins.pickImage(
                                              source: ImageSource.camera);
                                          file = File(response!.path);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text("FROM CAMERA")),
                                    TextButton(
                                        onPressed: () async {
                                          var response = await ins.pickImage(
                                              source: ImageSource.gallery);

                                          file = File(response!.path);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text("FROM GALLERY"))
                                  ],
                                ),
                              ));
                    },
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      var response = await addnote(context);
                      if (response != null) {
                        if (response["status"] == "success") {
                          if (context.mounted) {
                            Navigator.of(context)
                                .pushReplacementNamed(Notes.routeName);
                          }
                        } else if (response["status"] == "failed") {}
                      }
                    },
                    elevation: 10,
                    shape: const Border(
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black)),
                    fillColor: const Color(0xff2C55A1),
                    child: const Text('ADD NOTE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
