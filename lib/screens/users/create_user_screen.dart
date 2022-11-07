import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_graphql/providers/user_provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final String createUser = """
  mutation createUser (\$name: String!, \$email: String!, \$password: String!) {
    createUser(name: \$name, email: \$email, password: \$password) {
      id
      name
      email
    }
  }
  """;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New User"),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text("Name"),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    label: Text("Password"),
                    filled: true,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Consumer<UserProvider>(
                  builder: (context, value, child) {
                    return ElevatedButton(onPressed: () {
                      value.createUser(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                      ).then((value) => Navigator.pop(context));
                    }, child: const Text("Submit"));
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}