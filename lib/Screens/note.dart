import 'package:flutter/material.dart';
import 'package:rest/Screens/add_note.dart';
import 'package:rest/Screens/login.dart';
import 'package:rest/Screens/note_show.dart';
import 'package:rest/Screens/edit_note.dart';
import 'package:rest/restapi/curd.dart';
import 'package:rest/restapi/link_api.dart';
import 'package:rest/constant/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notes extends StatefulWidget {
  static const String routeName = 'notes page';
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with Curd {
  late SharedPreferences sharedPreferences;

  getNote() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var response = await postRequest(
        linkview, {"id": "${sharedPreferences.getString("id")}"});
    return response;
  }

  deleteNote(String noteId, String noteImage) async {
    await postRequest(linkdelete, {"id": noteId, "imageName": noteImage});
  }

  signout() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(Login.routeName);
    }
  }

  Drawer drawer(BuildContext context) {
    return Drawer(
        width: MediaQuery.of(context).size.width * .6,
        // backgroundColor: const Color.fromARGB(255, 136, 206, 206),
        child: Column(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            child: DrawerHeader(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black45,
                    ),
                    Text("mohamed",
                        style: TextStyle(
                          color: Colors.black,
                        ))
                  ],
                )),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * .7,
              child: ListView(
                children: [
                  RawMaterialButton(
                    fillColor: Colors.grey,
                    child: const Text(
                      "layout",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  RawMaterialButton(
                    fillColor: Colors.grey,
                    child: const Text(
                      "color",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  RawMaterialButton(
                    fillColor: Colors.grey,
                    child: const Text(
                      "setting",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  RawMaterialButton(
                    fillColor: Colors.grey,
                    child: const Text(
                      "sign out",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await signout();
                    },
                  )
                ],
              ))
        ]));
  }

  GridView grideViewShow(AsyncSnapshot<dynamic> snapshot) {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data['data'].length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              await deleteNote(snapshot.data['data'][index]["id"].toString(),
                  snapshot.data['data'][index]["note_image"].toString());
            },
            child: GridNotes(
              model1: Model.fromJson(snapshot.data['data'][index]),
              noteIndex: snapshot.data['data'][index],
              titleNote: snapshot.data['data'][index]["note_title"],
              contentNote: snapshot.data['data'][index]["note_content"],
            ),
          );
        });
  }

  ListView listViewShow(AsyncSnapshot<dynamic> snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data['data'].length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) async {
              await deleteNote(snapshot.data['data'][index]["id"].toString(),
                  snapshot.data['data'][index]["note_image"].toString());
            },
            child: ListNotes(
              model1: Model.fromJson(snapshot.data['data'][index]),
              noteIndex: snapshot.data['data'][index],
              titleNote: snapshot.data['data'][index]["note_title"],
              contentNote: snapshot.data['data'][index]["note_content"],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
        ),
        drawer: drawer(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddNote.routename);
          },
          backgroundColor: Colors.lightGreen,
          child: const Icon(Icons.add),
        ),
        backgroundColor: Colors.grey,
        body: ListView(
          children: [
            FutureBuilder(
                future: getNote(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['status'] == 'failed') {
                      return const Text('no notes');
                    }
                    return listViewShow(snapshot);
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('loading');
                  } else {
                    return const Text('error in internet');
                  }
                }),
          ],
        ));
  }
}

class ListNotes extends StatelessWidget {
  final String titleNote;
  final String contentNote;
  final dynamic noteIndex;
  final Model model1;

  const ListNotes(
      {super.key,
      required this.titleNote,
      required this.contentNote,
      required this.noteIndex,
      required this.model1});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ShowNote(
            notedata: noteIndex,
          );
        }));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.network(
                    fit: BoxFit.cover,
                    height: 80,
                    '$linkimageserver/${model1.noteImage}')),
            Expanded(
              flex: 2,
              child: ListTile(
                subtitle: Text("${model1.noteContent}"),
                title: Text(titleNote),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNote(
                        datalist: noteIndex,
                      );
                    }));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridNotes extends StatelessWidget {
  final String titleNote;
  final String contentNote;
  final dynamic noteIndex;
  final Model model1;

  const GridNotes(
      {super.key,
      required this.titleNote,
      required this.contentNote,
      required this.noteIndex,
      required this.model1});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ShowNote(
            notedata: noteIndex,
          );
        }));
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                flex: 1,
                child: Card(
                    child: Text(titleNote,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold)))),
            Expanded(flex: 4, child: Text("${model1.noteContent}")),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNote(
                        datalist: noteIndex,
                      );
                    }));
                  },
                ),
                IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return EditNote(
                        datalist: noteIndex,
                      );
                    }));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
