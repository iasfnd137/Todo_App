import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sign_up_log_in_firebase/screens/Tasks_screen.dart';
import 'package:sign_up_log_in_firebase/screens/sign_up.dart';
class SignInScreen extends StatefulWidget {
   SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
class _SignInScreenState extends State<SignInScreen> {
   var emailController = TextEditingController();

   var passwordController = TextEditingController();

   bool passwordObsecure = true;

   // signInWithGoogle ()async{
   //    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
   //
   //    GoogleSignInAuthentication googleAuth =await googleUser!.authentication;
   //
   //    AuthCredential credential = GoogleAuthProvider.credential(
   //      idToken: googleAuth.idToken,
   //      accessToken: googleAuth.accessToken
   //    );
   //
   //    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
   //    print(userCredential.user?.displayName);
   //
   //
   // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('SignIn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'email',
                prefixIcon: Icon(Icons.email),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: passwordController,
              obscureText: passwordObsecure,
              decoration: InputDecoration(
                hintText: 'password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      passwordObsecure = !passwordObsecure;
                    });
                  },
                  icon: Icon(passwordObsecure? Icons.visibility_off: Icons.visibility,),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: ()async{
               var email = emailController.text;
               var password = passwordController.text;
               if(email.isEmpty || password.isEmpty){
                 Fluttertoast.showToast(msg: 'please filled all the filed');
                 return;
               }
               ProgressDialog pD = ProgressDialog(
                   context,
                   title: Text('SignIn'),
                   message: Text('please wait')

               );
               pD.show();
               try {
                 FirebaseAuth auth = FirebaseAuth.instance;
                 UserCredential userCredential = await auth.signInWithEmailAndPassword(
                     email: email,
                     password: password,
                 );
                 pD.dismiss();
                 if(userCredential.user != null){
                   Fluttertoast.showToast(msg: 'SignIn Successfully');
                   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                     return TaskListScreen();
                   }));
                   pD.dismiss();
                 }
                 else{
                   Fluttertoast.showToast(msg: 'Failed');
                 }
               } on FirebaseAuthException catch (e) {
                 if(e.code=='invalid-email'){
                   Fluttertoast.showToast(msg: 'Wrong email');
                 return;
                 }
                 if(e.code =='wrong-password'){
                   Fluttertoast.showToast(msg: 'plz provide valid Password');
                 return;
                 }
                 if(e.code == 'user-not-found'){
                   Fluttertoast.showToast(msg: 'User not found');
                 return;
                 }
               }
               },
                child: const Text('SignIn')),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('If you don`t have account please?'),
                TextButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                    return SignUpScreen();
                  }));
                }, child:Text('SignUp',style: TextStyle(decoration: TextDecoration.underline),))
              ],
            )
          ],
        ),
      ),
    );
  }
}
