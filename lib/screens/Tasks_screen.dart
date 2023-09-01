//int state hum ny yahan is liye use kiya hy ky jo porany task hy wo initailze kary of disply kary inate satet thb he one time call hota hy jub app first time run hota hyy
//onvalue lisinting karta hy jo koei node ya data lisnig kr raha hy ab koei chnge ho raha hy ya data ko edit kr traha hy wo onvalue karta hy
//event ka mtlb hy k ak banda login ho gaya or task add kiya is sub proses ko event kahty hy
//jub data hum get karty hy to hum model use karngy agar hum api firebase ya y Jh AY BI data aaccess karngy to model use karonga
//noid ky zariye hum delt and update karty hy isi liye model main laty hy
//as jahan py use karngy usko type cast kahty hy
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:sign_up_log_in_firebase/screens/add_tasks_screen.dart';
import 'package:sign_up_log_in_firebase/screens/profile_screen.dart';
import 'package:sign_up_log_in_firebase/screens/sign_in.dart';
import 'package:sign_up_log_in_firebase/screens/update_screen.dart';
import '../models/task_model.dart';
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  //task k liye humy user chiye hota hy
  User? user;
  //task database main save krta ho isi liye databaserefrence liya hy
  DatabaseReference? taskRef;
  @override
  void initState() {
    //initialize user jo login wala user hota hy usy current user kehty hy
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      taskRef = FirebaseDatabase.instance.reference().child('tasks').child(user!.uid);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskList'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                return ProfileScreen();
              }));

            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: (){
              showDialog(
                //barrierdismis ka mtlb hy k agar hamry pass alirt dilog show ho jaiye or hum screen py kahi bi click kary tu wo wasy he rahy ga aghar false ho to remove nahi hoga agar true ho tu ghaib ho jaiga
                  barrierDismissible: false,
                  context: context,
                  builder: (ctx){
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text('Are you sure to delete?'),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: const Text('No')),
                        TextButton(onPressed: ()async{
                          try{
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx){
                              return SignInScreen();
                            }));

                          }catch(e){
                            print(e.toString());
                            Fluttertoast.showToast(msg: 'Failed');
                          }
                        }, child: const Text('Yes'))

                      ],
                    );
                  }
              );



            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            return AddTasksScreen();
          }));

        },
        child: const Icon(Icons.add),
      ),
      //streambuilder hum ny use kiya hy data get karny k liyr
      body: StreamBuilder(
        //stream hamry sat pora deta hy
       //onvalue hamry sat leansting krraha hy
        stream: taskRef != null ? taskRef!.onValue : null,
        builder: (context, snap) {
          //snap main data check krna or snap main eror chck krna
          if (snap.hasData && !snap.hasError) {
            //jo sinup sy lay kar task add krny ka procees hota hy usko hum ak event kahty hy
            //event firbasedatbase sy arha hy
            var event = snap.data as DatabaseEvent;
            print(event.toString());
            //yahn py hunm data snshot ko de dety hy
            //event value ko pass kar diya
            var snshot = event.snapshot.value;
            //jub hamry sat koei task add na ho ya data na ho tu ye msg show kary ga
            if( snshot == null ){
              return const Center(child: Text('No tasks yet'));
            }
            //data get in map isi liye hum ny map liya hy or phir map ko list main diya hy
            //jub hum task add karty hy wo map main bhjty hy isi liye hum ny map use kiya hy yahan
            Map<String, dynamic> map = Map<String, dynamic>.from(snshot as Map);
            print(map.toString());
            var tasks = <TaskModel>[];
         //lop is liyew lagya hy q k hamry sat multiple value hy
            //map.value is liye likah hy k humy value chiye
            for (var taskMap in map.values) {
              tasks.add(TaskModel.fromMap(Map<String, dynamic>.from(taskMap)));
            }
            print(tasks.length);

            return ListView.builder(
              shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  TaskModel taskObject = tasks[index];

                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0,top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.purple.shade100,
                    ),
                    child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(taskObject.taskName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                SizedBox(height: 20,),
                                Text(getHumanReadableDate(taskObject.dt),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                IconButton(onPressed: ()async{
                                  if(taskRef !=null){
                                    showDialog(
                                      //barrierdismis ka mtlb hy k agar hamry pass alirt dilog show ho jaiye or hum screen py kahi bi click kary tu wo wasy he rahy ga aghar false ho to remove nahi hoga agar true ho tu ghaib ho jaiga
                                      barrierDismissible: false,
                                        context: context,
                                        builder: (ctx){
                                          return AlertDialog(
                                            title: const Text('Confirmation'),
                                            content: const Text('Are you sure to delete?'),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();
                                              }, child: const Text('No')),
                                              TextButton(onPressed: ()async{
                                                try{
                                                  Navigator.of(context).pop();
                                                  await taskRef!.child(taskObject.nodeId).remove();

                                                }catch(e){
                                                  print(e.toString());
                                                  Fluttertoast.showToast(msg: 'Failed');
                                                }
                                              }, child: const Text('Yes'))

                                            ],
                                          );
                                        }
                                        );
                                  }

                                }, icon: const Icon(Icons.delete)),
                                IconButton(onPressed: (){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                   return UpdateScreen(taskModel: taskObject);
                                 }));

                                },icon: const Icon(Icons.edit),),

                              ],
                            ),
                          )
                        ]),
                  );
                });
          } else {
            return const Center(
              child: Text('No Task Added Yet'),
            );
          }
        },
      ),
    );
  }
  String getHumanReadableDate(int dt) {
    //from ka matlb utana hy kahan sy utrana hy milisecond sy utana hy datetime
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
  }
}

