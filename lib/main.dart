import 'package:flutter/material.dart';
import 'package:rest/Screens/login.dart';
import 'package:rest/Screens/note_show.dart';
import 'package:rest/Screens/signup.dart';
import 'package:rest/Screens/note.dart';
import 'package:rest/Screens/edit_note.dart';
import 'Screens/add_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences _preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _preferences = await SharedPreferences.getInstance();

//start the app
  runApp(const Setting());
}

class Setting extends StatelessWidget {
  const Setting({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
        bodyLarge: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        bodyMedium: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 15, color: Colors.brown),
        bodySmall: TextStyle(
            fontWeight: FontWeight.normal, fontSize: 15, color: Colors.red),
      )),
      initialRoute: _preferences.getString("id") != null
          ? Notes.routeName
          : Login.routeName,
      title: 'Setting',
      routes: {
        Login.routeName: (context) => const Login(),
        Signup.routeName: (context) => const Signup(),
        Notes.routeName: (context) => const Notes(),
        AddNote.routename: (context) => const AddNote(),
        EditNote.routename: (context) => const EditNote(),
        ShowNote.routeName: (context) => const ShowNote(),
      },
    );
  }
}
