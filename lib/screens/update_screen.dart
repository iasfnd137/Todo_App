import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_up_log_in_firebase/models/task_model.dart';

class UpdateScreen extends StatefulWidget {
  final TaskModel taskModel;
  const UpdateScreen({Key? key,required this.taskModel,}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}


class _UpdateScreenState extends State<UpdateScreen> {
  var taskNameController = TextEditingController();
  @override
  void initState(){
    //app run hony ky sat sat data utany k liye hum ny inite state lagaya hy
  taskNameController.text = widget.taskModel.taskName;
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Update Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                hintText: 'task Name',
                prefixIcon: Icon(Icons.add_comment),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: ()async{
              var taskName = taskNameController.text;
              if(taskName.isEmpty){
                Fluttertoast.showToast(msg: 'Please provide task name');
                return;
              }
              User? user = FirebaseAuth.instance.currentUser;
            if(user != null){
              var taskRef = FirebaseDatabase.instance.ref().child('tasks').child(user.uid);
              //jub dosry class sy hum kuch utaingy tu widget likhngy sat main
              await taskRef.child(widget.taskModel.nodeId).update({'taskName': taskName});
              Navigator.of(context).pop();

            }

            }, child: Text('Update'))
          ],
        ),
      ),
    );
  }
}
