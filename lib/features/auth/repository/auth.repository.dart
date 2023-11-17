import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_to_do_list/features/auth/model/auth.model.dart';

class AuthRepository {
  ///declaration
  late Client client;
  late Account account;
  late FlutterSecureStorage secureStorage;

  AuthRepository() {
    ///initialize
    client = Client();

    ///set endpoint and projectID
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6538f23edeb02ee68314')
        .setSelfSigned(status: true);

    ///initialize account and inject client object
    account = Account(client);

    //initialize securestorage
    secureStorage = FlutterSecureStorage();
  }

  Future<void> register(String email, String password) async {
    await account.create(userId: ID.unique(), email: email, password: password);
  }

  Future<AuthModel> login(String email, String password) async {
    ///create seassion using email
    final Session session = await account.createEmailSession(
      email: email,
      password: password,
    );

    ///save seassion id in secure storage
    await secureStorage.write(key: 'SESSION_ID', value: session.$id);

    ///get user details
    final User user = await account.get();

    ///return authmodel object
    return AuthModel(userId: user.$id, email: user.email);
  }

  Future<AuthModel?> autologin() async {
    /// Find session id from secure storage
    String? sessionId = await secureStorage.read(key: 'SESSION_ID');

    /// if session id is null then return null
    if (sessionId == null) return null;

    /// get session using session id
    await account.getSession(
      sessionId: sessionId,
    );

    /// get user details
    final User user = await account.get();
    print('User ID: ${user.$id}');

    /// return authmodel object
    return AuthModel(userId: user.$id, email: user.email);
  }

  Future<void> logout() async {
    /// Find session id from secure storage
    String? sessionId = await secureStorage.read(key: 'SESSION_ID');

    ///if sessionID is null then return null
    if (sessionId == null) return;

    ///delete session from appwrite
    await account.deleteSession(
      sessionId: sessionId,
    );

    ///delete sessionid from securestorage
    await secureStorage.delete(key: 'SESSION_ID');
  }
}
