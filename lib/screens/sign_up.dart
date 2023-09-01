import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sign_up_log_in_firebase/screens/sign_in.dart';

//realtime data base main nodes banty hy
//firebase database main collection banty hy

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool passwordObsecure = true;
  bool confirmPasswordObsecure = true;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
             decoration: InputDecoration(
               hintText: 'name',
               prefixIcon: Icon(Icons.person),
               enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(20),
               ),
               focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(20),
               ),
             ),
            ),
            SizedBox(height: 10,),
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
            SizedBox(height: 10,),
            TextField(
              controller: passwordController,
              obscureText: passwordObsecure,
              decoration: InputDecoration(
                hintText: 'password',
                prefixIcon: Icon(Icons.lock),
         suffixIcon: IconButton(
           icon: Icon(passwordObsecure? Icons.visibility_off : Icons.visibility,
                ),
              onPressed: () {
                setState(() {
                  passwordObsecure = !passwordObsecure;
                });
              }),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              controller: confirmPasswordController,
              obscureText: confirmPasswordObsecure,
              decoration: InputDecoration(
                hintText: 'confirmPassword',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      //use nor gate
                      confirmPasswordObsecure = !confirmPasswordObsecure;
                    });
                  },
                  icon: Icon(confirmPasswordObsecure? Icons.visibility_off: Icons.visibility,),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: ()async{
              var name = nameController.text;
              var email = emailController.text;
              var password = passwordController.text;
              var confirmPassword = confirmPasswordController.text;

              if(name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty ){
              Fluttertoast.showToast(msg: 'please filled All the textField');
              return;
              }
              if(password != confirmPassword){
                Fluttertoast.showToast(msg: 'Password dose not match');
                return;
              }
              if(password.length <= 6 && confirmPassword.length <=6){
                Fluttertoast.showToast(msg: 'your password must bi greater than six character');
                return;
              }
              ProgressDialog progressDialog = ProgressDialog(
                  context,
                  title: Text('Signing Up'),
                  message: Text('please wait'),
              );
              progressDialog.show();
              //request to firebase
            try {
              FirebaseAuth auth = FirebaseAuth.instance;
              UserCredential userCredential =await auth.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
              );
              User? user = userCredential.user;
              final databaseReference = FirebaseDatabase.instance.ref();
              databaseReference.child('users').child(user!.uid).set(
                  {
                    'uid':user.uid,
                    'name':name,
                    'email':email,
                    'password':password,
                    'dt':DateTime.now().millisecondsSinceEpoch,
                    'profileImage':'',

                  }
              );
              progressDialog.dismiss();
              if(userCredential.user != null){
                Fluttertoast.showToast(msg: 'SignUp Successfully');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                  return SignInScreen();
                }));
              }else{
                Fluttertoast.showToast(msg: 'Failed');
              }
            } on FirebaseAuthException catch (e) {
              if(e.code == "email-already-in-use"){
                Fluttertoast.showToast(msg: 'email already Exist');
              }
              progressDialog.dismiss();
              if(e.code == 'weak-password'){
                Fluttertoast.showToast(msg: 'plz provide strong Password');
              }
            }catch(e){
              Fluttertoast.showToast(msg: 'Something went wrong');
              progressDialog.dismiss();
            }
            }, child: Text('signUp')),
            Spacer(),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('If you have account please ?'),
                SizedBox(width: 5,),
                TextButton(onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                    return SignInScreen();
                  }));
                }, child:Text('SignIn',style: TextStyle(decoration: TextDecoration.underline),))
              ],
            )
          ],
        ),
      ),
    );
  }
}
