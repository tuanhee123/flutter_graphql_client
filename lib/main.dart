import 'package:flutter/material.dart';
import 'package:flutter_graphql/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'screens/users/users_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Widget build(BuildContext context) {

  //   final httpLink = HttpLink(endpointURL);

  //   ValueNotifier<GraphQLClient> client = ValueNotifier(
  //       GraphQLClient(
  //           link: httpLink,
  //           cache: GraphQLCache()
  //       )
  //   );

  //   return GraphQLProvider(
  //     client: client,
  //     child: MaterialApp(
  //       title: 'Flutter Demo',
  //       theme: ThemeData(
  //         primarySwatch: Colors.blue,
  //         useMaterial3: true,
  //       ),
  //       home: const UsersScreen(),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (BuildContext context) => UserProvider()
        ),
      ],
      child: MaterialApp(
        title: "Graphql",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const UsersScreen(),
      ),
    );
  }
}
