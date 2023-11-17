import 'package:flutter/material.dart';
import 'package:my_to_do_list/core/guard.dart';
import 'package:my_to_do_list/features/auth/model/auth.model.dart';
import 'package:my_to_do_list/features/auth/presentation/widgets/authbuttonwidget.page.dart';
import 'package:my_to_do_list/features/todo/model/todo.model.dart';
import 'package:my_to_do_list/features/todo/repository/todo.repository.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key, required this.authModel, this.todoModel});
  final AuthModel authModel;
  final TodoModel? todoModel;

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late TodoRepository todoRepository;
  late ScaffoldMessengerState _snackbar;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isUpdate = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    todoRepository = TodoRepository();
    isUpdate = widget.todoModel != null;

    if (isUpdate) {
      titleController.text = widget.todoModel?.title ?? '';
      descriptionController.text = widget.todoModel?.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _snackbar = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: isUpdate ? const Text('Update Todo') : const Text('Add ToDo'),
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              color: const Color.fromARGB(
                  255, 6, 2, 124), // Set the background color here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 100.0,
                        color: Color.fromARGB(255, 1, 28, 49),
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "Enter Title",
                          labelText: "Title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (String? value) {
                          return Guard.validateTitle(value, 'Title');
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: "Enter Description",
                          labelText: "Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (String? value) {
                          return Guard.validateDescription(
                              value, 'Description');
                        },
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16.0),
                      Visibility(
                        visible: !isUpdate,
                        child: AuthButtonWidget(
                          buttonText: 'Submit', // Text for the button
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              // Navigate back to the MyTodoListPage
                              setState(() {
                                isLoading = true;
                              });
                              todoRepository
                                  .createTodo(
                                      titleController.text,
                                      descriptionController.text,
                                      widget.authModel.userId)
                                  .then((value) {
                                setState(() {
                                  isLoading = false;
                                });
                                _snackbar.showSnackBar(const SnackBar(
                                    content: Text('Todo has been created')));
                                Navigator.pop(context);
                              }).catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                                _snackbar.showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              });
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ),
                      Visibility(
                        visible: isUpdate,
                        child: Column(
                          children: [
                            AuthButtonWidget(
                              buttonText: 'Update',
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                todoRepository
                                    .updateTodo(
                                  titleController.text,
                                  descriptionController.text,
                                  widget.todoModel!.id,
                                )
                                    .then(
                                  (value) {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    _snackbar.showSnackBar(
                                      const SnackBar(
                                        content: Text('Todo has been updated'),
                                      ),
                                    );
                                    //
                                    Navigator.pop(context);
                                  },
                                ).catchError((e) {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  _snackbar.showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                    ),
                                  );
                                });
                              },
                              child: const Text('Update'),
                            ),
                            AuthButtonWidget(
                              buttonText: 'Delete',
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });

                                todoRepository
                                    .deleteTodo(widget.todoModel!.id)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _snackbar.showSnackBar(
                                    const SnackBar(
                                        content: Text('Todo has been deleted')),
                                  );
                                  Navigator.pop(context);
                                }).catchError((e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  _snackbar.showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                });
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
