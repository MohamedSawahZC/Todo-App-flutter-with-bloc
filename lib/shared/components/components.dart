import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/shared/cubit/cubit.dart';


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String value)? onSubmit,
  Function(String value)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String? Function(String? value)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged : onSubmit,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        border: OutlineInputBorder(),
      ),
    );


//Build Task item here

Widget buildTaskItem(Map model,context)=> Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
  child:   Padding(

    padding: EdgeInsets.all(20),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40,

          child: Text(

            "${model['time']}",

            style: TextStyle(

                fontSize: 13

            ),

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            mainAxisSize: MainAxisSize.min,

            children: [

              Text("${model['title']}",



                style: TextStyle(

                fontWeight: FontWeight.bold,

                fontSize: 25,





              ),

              ),

              Text(

                "${model['date']}",

                style: TextStyle(

                  color: Colors.grey,

                ),

              )

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            },

            icon: Icon(

            Icons.check_box,

              color: Colors.green,

          ),

          ),

        IconButton(

          onPressed: (){

            AppCubit.get(context).updateData(status: 'archive', id: model['id']);

          },

          icon: Icon(

            Icons.archive,

            color: Colors.black45,

          ),

        ),



      ],

    ),

  ),
);


Widget tasksBuilder({
  required List<Map> tasks,
})=>ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=>ListView.separated(
    itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index)=>Padding(
      padding: EdgeInsetsDirectional.only(start:20.0,),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
);
