import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_graphql/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  final String id;
  const UserDetailScreen({super.key, required this.id});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((_) => afterBuildFunction(context));
  }

  Future<void> afterBuildFunction(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false)
        .getUser(int.parse(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async => await value
                  .deleteUser(int.parse(widget.id))
                  .then((value) {
                    Navigator.pop(context);

                    inspect('something error');
                  }),
                icon: const Icon(Icons.delete),
              )
            ],
          ),
          body: SafeArea(
            child: (value.isLoading)
              ? const Center(
                child: CircularProgressIndicator(),
              ) 
              : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('ID: ${value.currentUser.id}'),
                    const SizedBox(height: 10,),
                    Text('Name: ${value.currentUser.name}'),
                    const SizedBox(height: 10,),
                    Text('Email: ${value.currentUser.email}'),
                    const SizedBox(height: 10,),
                    Text('Created At: ${value.currentUser.createdAt}'),
                    const SizedBox(height: 10,),
                    Text('Updated At: ${value.currentUser.updatedAt}'),
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
                      itemCount: value.currentUser.posts.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: Text(value.currentUser.posts[index].id),
                        title: Text(value.currentUser.posts[index].name),
                        trailing: Text(value.currentUser.posts[index].createdAt),
                        onTap: () {},
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}