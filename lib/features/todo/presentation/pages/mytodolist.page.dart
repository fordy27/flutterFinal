import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_to_do_list/features/auth/model/auth.model.dart';
import 'package:my_to_do_list/features/todo/model/todo.model.dart';
import 'package:my_to_do_list/features/todo/presentation/pages/addtodo.page.dart';
import 'package:my_to_do_list/features/auth/repository/auth.repository.dart';
import 'package:my_to_do_list/features/todo/repository/todo.repository.dart';

class MyTodoListPage extends StatefulWidget {
  final AuthModel authModel;

  const MyTodoListPage({super.key, required this.authModel});
  @override
  State<MyTodoListPage> createState() => _MyTodoListPageState();
}

class _MyTodoListPageState extends State<MyTodoListPage> {
  bool isLoading = false;
  late AuthRepository authRepository;
  late ScaffoldMessengerState _snackbar;
  late TodoRepository todoRepository;
  List<TodoModel> todolist = [];

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    todoRepository = TodoRepository();
    getTodoList();
  }

  void getTodoList() {
    setState(() => isLoading = true);
    todoRepository.getTodoList(widget.authModel.userId).then((value) {
      setState(() {
        isLoading = false;
        todolist = value;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      _snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    _snackbar = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("My Todo List"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              authRepository.logout().then((value) {
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              }).catchError((e) {
                setState(() {
                  isLoading = false;
                });
                _snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
              });
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              for (var todo in todolist)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddTodoPage(
                          authModel: widget.authModel,
                          todoModel: todo,
                        ),
                      ),
                    ).then((value) {
                      getTodoList();
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15), // Fixed padding typo
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(todo.description), // Display todo's description
                          Checkbox(
                              value: todo.status,
                              onChanged: (val) {
                                setState(() {
                                  todoRepository.updateStatus(
                                      todo.id, status ?? false);
                                  // Update the completion status of the task
                                  todo.status = val ??
                                      false; // Update the status of the todo
                                  // Call a function to update the status in your repository/database
                                  // todoRepository.updateTodoStatus(todo.id, newValue);
                                });
                              }), // Display todo's completion status
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTodoPage(
                authModel: widget.authModel,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
