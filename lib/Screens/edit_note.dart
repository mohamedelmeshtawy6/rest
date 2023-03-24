import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:rest/Screens/note.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest/restapi/curd.dart';
import 'package:rest/restapi/link_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNote extends StatefulWidget {
  final dynamic datalist;
  const EditNote({super.key, this.datalist});
  static const String routename = 'editnotespage';

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> with Curd {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  late SharedPreferences sharedPreferences;
  var ins = ImagePicker();
  File? myfile;
  late Map response;
  saveediting(BuildContext context) async {
    if (_key.currentState!.validate()) {
      if (myfile == null) {
        response = await postRequest(linkedit, {
          "title": title.text,
          "content": content.text,
          "id": widget.datalist["id"].toString(),
          "imagename": widget.datalist["note_image"].toString(),
        });
      } else {
        response = await postRequestWithFile(
            linkedit,
            {
              "title": title.text,
              "content": content.text,
              "id": widget.datalist["id"].toString(),
              "imagename": widget.datalist["note_image"].toString(),
            },
            myfile!);
      }
      if (response['status'] == "success") {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(Notes.routeName);
        }
      }

      if (response['status'] == "failed") {
        if (context.mounted) {
          return AwesomeDialog(
                  context: context,
                  body: const SizedBox(
                    width: 300,
                    height: 200,
                    child: Text('failed'),
                  ),
                  dialogType: DialogType.error,
                  title: "Warn")
              .show();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    title.text = widget.datalist["note_title"];
    content.text = widget.datalist["note_content"];
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
                color: Color(0xff23bab0),
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
                        initialValue: widget.datalist['title'],
                        maxLines: 1,
                        maxLength: 30,
                        validator: (data) {
                          if (data!.length >= 31 || data.length <= 1) {
                            return "title can not be more than 30 letter or less than 2";
                          } else {
                            return null;
                          }
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
                        initialValue: widget.datalist['content'],
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
                                          myfile = File(response!.path);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text("FROM CAMERA")),
                                    TextButton(
                                        onPressed: () async {
                                          var response = await ins.pickImage(
                                              source: ImageSource.gallery);
                                          myfile = File(response!.path);
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
                      await saveediting(context);
                    },
                    elevation: 10,
                    shape: const Border(
                        top: BorderSide(color: Colors.black),
                        bottom: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black)),
                    fillColor: const Color(0xff2C55A1),
                    child: const Text('SAFE EDITE NOTE',
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
