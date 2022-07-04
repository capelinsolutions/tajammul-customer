import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tajammul_customer_app/Environments/Environment.dart';

import 'loginUserCredentials.dart';

LoginUserCredentials loginUserCredentials = LoginUserCredentials();

class GraphQLConfiguration {
  static final queryDefault = Policies(
    fetch: FetchPolicy.networkOnly,
  );
  static final watchQueryDefault = Policies(
    fetch: FetchPolicy.networkOnly,
  );
  static final mutateDefault = Policies(
    fetch: FetchPolicy.networkOnly,
  );

  String? _baseUrl;
  Link? _httpLink;
  ValueNotifier<GraphQLClient>? client;

  GraphQLConfiguration() {
    _baseUrl = Environment().config?.apiHost;
    _httpLink = HttpLink(_baseUrl!);
    client = ValueNotifier(
      GraphQLClient(
        link: _httpLink!,
        defaultPolicies: DefaultPolicies(
          watchQuery: watchQueryDefault,
          query: queryDefault,
          mutate: mutateDefault,
        ),
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
      ),
    );
  }

  //set headers
  Future<void> setHeaders() async {
    await loginUserCredentials.getCurrentUser();
    print(loginUserCredentials.getToken());
    Link? _link = HttpLink(
      _baseUrl!,
      defaultHeaders: {
        'Authorization': 'Bearer ${loginUserCredentials.getToken()}',
      },
    );
    _httpLink = _link;
  }

//set client of graphql
  GraphQLClient clientToQuery() {
    return GraphQLClient(
      defaultPolicies: DefaultPolicies(
        watchQuery: watchQueryDefault,
        query: queryDefault,
        mutate: mutateDefault,
      ),
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
      link: _httpLink!,
    );
  }

//print graphql url
  String? getGraphQLUrl() {
    return _baseUrl;
  }
}
