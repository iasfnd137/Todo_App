
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sign_up_log_in_firebase/screens/sign_in.dart';
import 'package:sign_up_log_in_firebase/screens/sign_up.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 250,),
            Center(child: ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                return const SignUpScreen();
              }));
            }, child: const Text('SignUp'))),
            const SizedBox(
              height: 10,
            ),
            Center(child: ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                return SignInScreen();
              }));
            }, child: const Text(' SignIn '))),
          ],
        ),
      ),
    );
  }
}
