
import 'package:flutter/foundation.dart';
import 'package:flutter_graphql/common/constants/env.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EndPoint {
  ValueNotifier<GraphQLClient> getClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: HttpLink(endpointURL),
        cache: GraphQLCache(),
      )
    );

    return client;
  }
}