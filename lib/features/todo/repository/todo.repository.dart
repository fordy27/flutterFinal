import 'package:appwrite/appwrite.dart';
import 'package:my_to_do_list/features/todo/model/todo.model.dart';

class TodoRepository {
  ///declaration
  late Client client;
  late Databases databases;

  TodoRepository() {
    ///initialize
    client = Client();

    ///set endpoint and projectID
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6538f23edeb02ee68314')
        .setSelfSigned(status: true);

    databases = Databases(client);
  }

  Future<List<TodoModel>> getTodoList(String userId) async {
    ///get documents from appwrite
    final docs = await databases.listDocuments(
        databaseId: '654b685053861a263977',
        collectionId: '6557d414d0ed29392a25',
        queries: [Query.equal('createdby', userId)]);

    final List<TodoModel> result = [];

    ///loop documents and convert to todomodel
    for (int i = 0; i < docs.documents.length; i++) {
      ///get specific document
      final document = docs.documents[i];

      ///convert to todomodel
      final todoModel = TodoModel(
        id: document.$id,
        title: document.data['title'],
        description: document.data['description'],
        status: document.data['status'],
        createdby: document.data['createdby'],
      );

      ///add to result list
      result.add(todoModel);
    }

    ///return todomodel list
    return result;
  }

  Future<void> createTodo(
      String title, String description, String userID) async {
    await databases.createDocument(
      databaseId: '654b685053861a263977',
      collectionId: '6557d414d0ed29392a25',
      documentId: ID.unique(),
      data: {
        'title': title,
        'description': description,
        'createdby': userID,
      },
    );
  }

  Future<void> updateTodo(
      String title, String description, String todoId) async {
    await databases.updateDocument(
      databaseId: '654b685053861a263977',
      collectionId: '6557d414d0ed29392a25',
      documentId: todoId,
      data: {
        'title': title,
        'description': description,
      },
    );
  }

  Future<void> updateStatus(bool status, String todoId) async {
    await databases.updateDocument(
      databaseId: '654b685053861a263977',
      collectionId: '6557d414d0ed29392a25',
      documentId: todoId,
      data: {
        'status': status,
      },
    );
  }

  Future<void> deleteTodo(String todoId) async {
    await databases.deleteDocument(
      databaseId: '654b685053861a263977',
      collectionId: '6557d414d0ed29392a25',
      documentId: todoId,
    );
  }
}
