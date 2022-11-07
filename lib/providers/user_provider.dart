import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_graphql/models/user_model.dart';
import 'package:flutter_graphql/common/constants/endpoint.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserProvider with ChangeNotifier {
  bool isLoading = false;

  List<User> users = []; 

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

        if (result.data!['users'] != null) {
          users.add(User.fromJson(result.data!['createUser']));
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