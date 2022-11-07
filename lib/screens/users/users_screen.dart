import 'package:flutter/material.dart';
import 'package:flutter_graphql/models/user_model.dart';
import 'package:flutter_graphql/providers/user_provider.dart';
import 'package:flutter_graphql/screens/users/create_user_screen.dart';
import 'package:flutter_graphql/screens/users/user_detail_screen.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // final String readUsers = """
  //   query {
  //     users {
  //       id
  //       name
  //       created_at
  //     }
  //   }
  // """;
  double? scrolledUnderElevation = 3;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Users List"),
  //       scrolledUnderElevation: scrolledUnderElevation,
  //       shadowColor: Theme.of(context).colorScheme.shadow,
  //       actions: [
  //         IconButton(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const CreateUserScreen())
  //             );
  //           },
  //           tooltip: "Create New User",
  //           icon: const Icon(Icons.add)
  //         )
  //       ],
  //     ),
  //     body: SafeArea(
  //       child: Query(
  //         options: QueryOptions(
  //           document: gql(readUsers),
  //         ),
  //         builder: (result, {refetch, fetchMore}) {
  //           if (result.isLoading) {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }

  //           if (result.hasException) {
  //             return Text(result.exception.toString());
  //           }

  //           List users = result.data!['users'];

  //           return SingleChildScrollView(
  //             child: ListView.builder(
  //               physics: const BouncingScrollPhysics(),
  //               shrinkWrap: true,
  //               itemCount: users.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   leading: Text(users[index]['id']),
  //                   title: Text(users[index]['name']),
  //                   trailing: Text(users[index]['created_at']),
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => UserDetailScreen(id: users[index]['id'])
  //                       )
  //                     );
  //                   },
  //                 );
  //               },
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((timeStamp) => afterBuildFunction(context));
  }

  Future<void> afterBuildFunction(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false)
        .getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateUserScreen())
              );
            },
            tooltip: "Create New User",
            icon: const Icon(Icons.add)
          )
        ],
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, value, child) {

            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator()
              );
            }

            return SingleChildScrollView(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: value.users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(value.users[index].id),
                    title: Text(value.users[index].name),
                    trailing: Text(value.users[index].createdAt),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(id: value.users[index].id)
                        )
                      );
                    },
                  );
                }
              )
            );
          },
        ),
      ),
    );
  }
}
