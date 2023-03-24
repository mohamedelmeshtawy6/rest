import 'package:flutter/material.dart';
import 'package:rest/Screens/login.dart';
import 'package:rest/restapi/curd.dart';
import 'package:rest/constant/validation_with_mixin.dart';
import 'package:rest/restapi/link_api.dart';

class Signup extends StatefulWidget  {
  static const String routeName = 'signup page';


   const Signup({ super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with ValidationMixin,Curd {
  final GlobalKey<FormState> _key = GlobalKey();

  final TextEditingController user = TextEditingController();

  final TextEditingController mail = TextEditingController();

  final TextEditingController password = TextEditingController();

  bool obsecure=true;

   signUp(BuildContext context) async {
    if (_key.currentState!.validate()) {
      var response = await postRequest(linkSignup, {
        "username": user.text,
        "email": mail.text,
        "password": password.text,
      });

      if (response['status'] == "success") {
        if (context.mounted) {
          Navigator.of(context).pushNamed(Login.routeName);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('images/signup.jpg'),
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                              textAlign: TextAlign.center,

                              controller: user,
                          validator: (username) {
                            if (isUserNameValid(username!))
                             { return null;}
                             else
                              {return "user name can not be less than 2 letter";}

                          },
                          decoration: const InputDecoration(
                              filled: true,
                              hintText: '   user name',
                              prefixIcon: Icon(
                                Icons.accessibility_new,
                                color: Colors.lightGreen,
                              )),
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
                          controller: mail,
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
                                prefixIcon:const  Icon(Icons.password,
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
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        await signUp(context);
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(' I have account'),
                      Card(
                        child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                Login.routeName,
                              );
                            },
                            child: const Text('Login')),
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
