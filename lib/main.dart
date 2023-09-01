import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign_up_log_in_firebase/screens/Tasks_screen.dart';
import 'package:sign_up_log_in_firebase/screens/sign_in.dart';

void main() async {
  //jub hum app ko firebase ky sat connct krty hy tu yahan py hum app initialize karty hy
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<bool> _checkLogin() async {
    //in 3eno lino main initialization howa hy
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: _checkLogin(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return TaskListScreen();
              } else if (snapshot.data == false) {
                return SignInScreen();
              }
              else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}
