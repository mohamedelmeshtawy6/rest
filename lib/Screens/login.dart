import 'package:flutter/material.dart';
import 'package:rest/Screens/signup.dart';
import 'package:rest/Screens/note.dart';
import 'package:rest/constant/validation_with_mixin.dart';
import 'package:rest/restapi/curd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rest/restapi/link_api.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Login extends StatefulWidget {
  static const String routeName = 'login page';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with ValidationMixin,Curd {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _keyOnForm = GlobalKey();
  late SharedPreferences sharedPreferences;
  bool obsecure=true;

  loggIn(BuildContext context) async {
    if (_keyOnForm.currentState!.validate()) {
      sharedPreferences = await SharedPreferences.getInstance();
      var response = await postRequest(linkLogin, {
        "email": email.text,
        "password": password.text,
      });

      if (response['status'] == "success") {
        sharedPreferences.setString('id', response['data']['id'].toString());
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(Notes.routeName);
        }
      } else {
        if (context.mounted) {
          AwesomeDialog(
              context: context,
              title: "ERROR",
              dialogType: DialogType.error,
              body: const SizedBox(

                child: Text(' email or password not correct'),
              )).show();
        }
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _keyOnForm,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/login.jpg'),
                  ),

                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: email,
                              validator: (email) {
                                if (isEmailValid(email!)) {
                                  return null;
                                } else {
                                  return "email can not be less than 10 letter";
                                }
                              },
                              decoration: const InputDecoration(

                                  filled: true,
                                  hintText: 'email',
                                  prefixIcon: Icon(Icons.account_circle,
                                      color: Colors.lightGreen)),
                            ))
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: password,
                            obscureText: obsecure,
                            validator: (password) {
                              if (isPasswordValid(password!)) {
                                return null;
                              } else {
                                return "password can not be less than 8 letter";

                              }
                            },
                            decoration:  InputDecoration(
                                hintText: 'password',
                                suffix:obsecure? IconButton(icon:const Icon(Icons.hide_source,color: Colors.lightGreen,),onPressed: (){setState(() {
                                  obsecure=false;
                                });},):IconButton(icon:const Icon(Icons.face,color: Colors.lightGreen),onPressed: (){setState(() {
                                  obsecure=true;
                                });}),
                                prefixIcon: const Icon(Icons.password,
                                    color: Colors.lightGreen)),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RawMaterialButton(
                      fillColor: Colors.green,
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await loggIn(context);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(' I don\'t have account'),
                      Card(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                Signup.routeName,
                              );
                            },
                            child: const Text('signup')),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}
