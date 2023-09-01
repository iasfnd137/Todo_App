class TaskModel{
   String nodeId;
   String taskName;
   int dt;

  TaskModel(
  {
      required this.nodeId,
      required this.taskName,
      required this.dt
  }
      );
  //factory hamry sat access modifier hy
  factory TaskModel.fromMap(Map<String,dynamic>map){
    return TaskModel(
        nodeId:map ['nodeId'],
        taskName:map ['taskName'],
        dt:map ['dt'],
    );
  }
}
