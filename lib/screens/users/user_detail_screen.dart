import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/user_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserDetailScreen extends StatefulWidget {
  final String id;
  const UserDetailScreen({super.key, required this.id});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  @override
  Widget build(BuildContext context) {

    const String readUser = """
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
    """;

    const String deleteUser = """
    mutation deleteUser(\$userId: ID!) {
      deleteUser(id: \$userId) {
        id
      }
    }
    """;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Mutation(
            options: MutationOptions(
              document: gql(deleteUser),
              onCompleted: (data) {
                if (data!['deleteUser'] != null) {
                  Navigator.pop(context);
                }
              },
            ),
            builder: (runMutation, result) {
              return IconButton(
                onPressed: () {
                  runMutation({
                    'userId': widget.id
                  });
                },
                icon: const Icon(Icons.delete)
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Query(
          options: QueryOptions(
            document: gql(readUser),
            variables: {
              'userId': widget.id
            }
          ),
          builder: (result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            User user = User.fromJson(result.data!['user']);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${user.id}'),
                    const SizedBox(height: 10,),
                    Text('Name: ${user.name}'),
                    const SizedBox(height: 10,),
                    Text('Email: ${user.email}'),
                    const SizedBox(height: 10,),
                    Text('Created At: ${user.createdAt}'),
                    const SizedBox(height: 10,),
                    Text('Updated At: ${user.updatedAt}'),
                    const SizedBox(height: 10,), 
                    const Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10,), 
                    const Text('Posts: -'),
                    const SizedBox(height: 10,),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: user.posts.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Text(user.posts[index].id),
                        title: Text(user.posts[index].name),
                        trailing: Text(user.posts[index].createdAt),
                        onTap: () {},
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}