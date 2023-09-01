import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sign_up_log_in_firebase/screens/Tasks_screen.dart';

class AddTasksScreen extends StatelessWidget {
   AddTasksScreen({Key? key}) : super(key: key);
   var addTasks = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: (
        Column(
          children: [
           TextField(
             controller: addTasks,
             decoration: InputDecoration(
               hintText: ('enter Task'),
               enabledBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(18),
               ),
               focusedBorder: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(18),
               )
             ),
           )   ,
           const SizedBox(height: 20,),
           ElevatedButton(
               onPressed: ()async{
               var tasks = addTasks.text;
               if(tasks.isEmpty){
                 Fluttertoast.showToast(msg: 'plz enter the task');
                 return;
               }
               //is ke wajah sy hum user koi access karty hy
               User? user = FirebaseAuth.instance.currentUser;
               if(user == null){
                 return;
               }
               //real time database ka path show krta hy ky kahan py wo data store karna hy
               final databaseReference = FirebaseDatabase.instance.ref();
               String? key = databaseReference
                   .child('tasks')
                   .child(user.uid)
                   .push().key;
               try{
                 await databaseReference.child('tasks').child(user.uid).child(key!).set({
                   'nodeId':key,
                   'taskName':tasks,
                   'dt':DateTime.now().millisecondsSinceEpoch,
                 });
                 Fluttertoast.showToast(msg: 'Task Added');
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                   return TaskListScreen();
                 }));
               }catch(e){
                 Fluttertoast.showToast(msg: 'Something Went Wrong');
               }
               },
               child: const Text('Add Tasks'))
          ],
        )
        ),
      ),
    );
  }
}
