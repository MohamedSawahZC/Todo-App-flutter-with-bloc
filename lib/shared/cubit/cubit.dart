import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../../modules/archive_tasks/archive_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit():super(AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);
  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archiveTasks=[];
  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];
  List<String> titles = [
    //
    'New Task',
    'Done Tasks',
    'Archived Tasks',
  ];

  // Method change index to Bottom Nav Bar

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

// Method create database
  void createDatabase()  {
    openDatabase(
      'todo.db', //Name of file for dataBase
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT )')
            .then((value) => {
          print("Table created"),
        })
            .catchError((error) {
          print("error${error.toString()}");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) => {
      database = value,
      emit(AppCreateDatabaseState()),
    });
  }


  //Method to insert data to Data Base

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title,time,date,status) VALUES("$title", "$time", "$date","new")')
          .then((value) => {
        emit(AppInsertDatabaseState()),
      getDataFromDatabase(database)
      }).catchError((error) {
        print('Error : ${error.toString()}');
      });
      return null;
    });
  }

  //Method to Get data to Data Base


  void getDataFromDatabase(database)  {
    newTasks= [];
    doneTasks=[];
    archiveTasks=[];

    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value) => {
      value.forEach((element){
        if(element['status']=='new'){
          newTasks.add(element);
        }
     if(element['status']=='done'){
       doneTasks.add(element);
     }
     else{
       archiveTasks.add(element);
     }
      }),
       emit(AppGetDatabaseState()),
     });
  }

  void updateData({
    required String status,
    required int id,
  }) async
  {
    database.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async
  {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value)
    {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }


  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
    required IconData icon,
}){
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}