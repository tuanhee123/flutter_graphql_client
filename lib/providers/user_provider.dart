import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_graphql/models/user_model.dart';
import 'package:flutter_graphql/common/constants/endpoint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProvider with ChangeNotifier {
  bool isLoading = false;

  List<User> users = [];
  User currentUser = User.empty();

  final EndPoint _point = EndPoint();

  Future<void> getUsers() async {
    try {
      isLoading = true;
      notifyListeners();

      // get data via graphql
      ValueNotifier<GraphQLClient> client = _point.getClient();
      await client.value.query(
        QueryOptions(
          document: gql("""
            query {
              users {
                id
                name
                created_at
              }
            }
          """),
        )
      ).then((result) async {
        users = [];

        if (result.data!['users'] is List) {
          for (int i = 0; i < result.data!['users'].length; i++) {
            users.add(User.fromJson(result.data!['users'][i]));
          }
        }
      });

      isLoading = false;
      notifyListeners();
    } catch (e) {
      inspect(e.toString());
    }
  }

  Future<void> createUser(String name, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      ValueNotifier<GraphQLClient> client = _point.getClient();
      await client.value.mutate(
        MutationOptions(
          document: gql("""
          mutation createUser (\$name: String!, \$email: String!, \$password: String!) {
            createUser(name: \$name, email: \$email, password: \$password) {
              id
              name
              email
              created_at
              updated_at
            }
          }
          """),
          variables: {
            'name': name,
            'email': email,
            'password': password,
          }
        )
      ).then((result) async {
        inspect(result.data);

        if (result.data!['createUser'] != null) {
          users.add(User.fromJson(result.data!['createUser']));
        }
      });

      isLoading = false;
      notifyListeners();
    } catch (e) {
      inspect(e.toString());
    }
  }

  Future<void> getUser(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      ValueNotifier<GraphQLClient> client = _point.getClient();
      await client.value.query(
        QueryOptions(
          document: gql("""
          query readUser(\$userId: ID!) {
            user (id: \$userId) {
              id
              name
              email
              created_at
              updated_at
              posts {
                id
                name
                created_at
              }
            }
          }
          """),
          variables: {
            "userId": id,
          }
        )
      ).then((result) async {
        inspect(result.data);

        if (result.data != null) {
          currentUser = User.fromJson(result.data!['user']);
        }
      });

      isLoading = false;
      notifyListeners();
    } catch (e) {
      inspect(e.toString());
    }
  }

  Future<void> deleteUser(int id) async  {
    try {
      isLoading = true;
      notifyListeners();

      ValueNotifier<GraphQLClient> client = _point.getClient();
      await client.value.mutate(
        MutationOptions(
          document: gql("""
          mutation deleteUser(\$userId: ID!) {
            deleteUser(id: \$userId) {
              id
            }
          }
          """),
          variables: {
            "userId": id,
          }
        )
      ).then((result) async {

        if (result.data != null) {
          getUsers();
        }

      });

      isLoading = false;
      notifyListeners();
    } catch (e) {
      inspect(e.toString());
    }
  }

  // _clearData() {
    
  // }
}