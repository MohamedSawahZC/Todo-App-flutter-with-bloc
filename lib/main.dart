import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/components/bloc_observer.dart';

import 'layouts/home_layout.dart';

void main() {
  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  // constructor
  // build

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}