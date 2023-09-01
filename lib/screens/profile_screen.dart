import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sign_up_log_in_firebase/screens/Tasks_screen.dart';

import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? image;
  bool showLocalImage = false;
  UserModel? userModel;
  User? user;
  DatabaseReference? userRef;

  _getUserDetails() async {
    if (userRef != null) {
      userRef!.once().then((dataSnapshot) {
        print(dataSnapshot.snapshot.value as Map);
        userModel = UserModel.fromMap(
            Map<String, dynamic>.from(dataSnapshot.snapshot.value as Map));
        setState(() {});
      });
    }
  }

  _pickImageGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    //single statemant main hamry sat bracket ke zarort nai hoti
    if (xFile == null) return;

    final tempImage = File(xFile.path);
    image = tempImage;
    showLocalImage = true;
    setState(() {});

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: Text('Uploading !!!'),
      message: Text('Please wait'),
    );
    progressDialog.show();
    // upload to firebase storage

    var fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    UploadTask uploadTask = FirebaseStorage.instance.ref().child(fileName).putFile(image!);
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    print(imageUrl);
    // update user in realtime database
    if (userRef != null) {
      userRef!.update({'profileImage': imageUrl});
    }

    progressDialog.dismiss();
  }

  _pickImageCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (xFile == null) return;

    final tempImage = File(xFile.path);
    image = tempImage;
    showLocalImage = true;
    setState(() {});
  }
  @override
  void initState() {
    super.initState();

    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userRef =
          FirebaseDatabase.instance.reference().child('users').child(user!.uid);
    }
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Profile'),
        ),
        body: userModel == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            SizedBox(height: 20,),
            Container(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 120,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.blue,
                    child: ClipOval(
                      child: showLocalImage == true
                          ? Image.file(
                        image!,
                        width: 115,
                        height: 115,
                        fit: BoxFit.fill,
                      )
                          : Image.network(
                        userModel!.profileImage == ''?
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnme6H9VJy3qLGvuHRIX8IK4jRpjo_xUWlTw&usqp=CAU'
                            : userModel!.profileImage.toString(),
                        width: 120,
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        _pickImageGallery();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () {
                                        _pickImageCamera();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                  )
                ],
              ),
            ),
            //we i place here

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Member Since: ${getHumanReadableDate(userModel!.dt)}'),
                    Divider(height: 2,color: Colors.blue,),
                    SizedBox(height: 20,),
                    Text('FullName: ${userModel!.name}'),
                    Divider(height: 2,color: Colors.blue,),
                    SizedBox(height: 20,),
                    Text('Email: ${userModel!.email}'),
                    Divider(height: 2,color: Colors.blue,),
                  ],
                ),
              ),
            ),
            ElevatedButton(onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                return TaskListScreen();
              }));
            }, child: Text('Save'))
          ],
        ),
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd-MMM-yyy').format(dateTime);
  }
}

