import 'dart:convert';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tajammul_customer_app/Models/AddressData.dart';
import 'package:tajammul_customer_app/Models/CartProduct.dart';
import 'package:tajammul_customer_app/Models/Product.dart';
import 'package:tajammul_customer_app/Models/Service.dart';
import 'package:tajammul_customer_app/Models/Timings.dart';
import 'package:tajammul_customer_app/Models/users.dart';
import 'package:tajammul_customer_app/Services/GraphQLConfiguration.dart';
import 'package:tajammul_customer_app/Services/Queries.dart';
import 'package:tajammul_customer_app/Services/loginUserCredentials.dart';
import '../Models/Business.dart';
import '../UserConstant.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
LoginUserCredentials loginUserCredentials = LoginUserCredentials();

class ApiCalls {
  static GraphQLClient client = graphQLConfiguration.clientToQuery();

  //check either username is unique or not
  static Future<Map<String,String>?> isUniqueUser(String username) async {

    print(graphQLConfiguration.getGraphQLUrl());

    client=graphQLConfiguration.clientToQuery();

    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(
              Queries.isUsernameUnique),
          variables: {
            'username': username,
          },
          // pollInterval: Duration(milliseconds: 100)
        ),
      );
      if (result.hasException) {
        if(result.exception?.linkException?.originalException != null){
          Map<String,String> error = {
            "result": "Something went wrong please try again"
          } ;
          return error;
        }
        if(result.exception?.linkException is ServerException) {

          HttpLinkServerException exception = result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 400) {
            Map<String,String> error = {
              "result": "Something went wrong please try again"
            } ;
            return error;
          }
          if (exception.response.statusCode == 401) {
            Map<String,String> error = {
              "result": "Something went wrong please try again"
            } ;
            return error;
          }
        }
        if(result.exception?.graphqlErrors.isNotEmpty ?? false){
          Map<String,String> error = {
            "result": result.exception!.graphqlErrors[0].message
          } ;
          return error;
        }
      }
      if(result.data?['isUsernameUnique']!= null){
        if(!result.data?['isUsernameUnique']) {
          Map<String, String> success = {
            "result": "Username is already present"
          };
          return success;
        }
        else {
          Map<String, String> success = {
            "result": ""
          };
          return success;
        }
      }
    }
    catch (e) {
      Map<String,String> error = {
        "result": "Something went wrong please try again"
      } ;
      return error;
    }
    return null;
  }

  //check either email is unique or not
  static Future<Map<String,String>?> isUniqueEmail(String email) async {
    print(graphQLConfiguration.getGraphQLUrl());

    client=graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(
              Queries.isEmailUnique),
          variables: {
            'email': email,
          },
          //pollInterval: Duration(milliseconds: 100)
        ),
      );
      if (result.hasException) {
        if(result.exception?.linkException?.originalException != null){
          Map<String,String> error = {
            "result": "Something went wrong please try again"
          } ;
          return error;
        }
        if(result.exception?.linkException is ServerException) {

          HttpLinkServerException exception = result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 400) {
            Map<String,String> error = {
              "result": "Something went wrong please try again"
            } ;
            return error;
          }
          if (exception.response.statusCode == 401) {
            Map<String,String> error = {
              "result": "Something went wrong please try again"
            } ;
            return error;
          }

        }
        if(result.exception?.graphqlErrors.isNotEmpty ?? false){
          Map<String,String> error = {
            "result": result.exception!.graphqlErrors[0].message
          } ;
          return error;
        }
      }
      if(result.data?['isEmailUnique']!= null){
        if(!result.data?['isEmailUnique']) {
          Map<String, String> success = {
            "result": "Email is already present"
          };
          return success;
        }
        else {
          Map<String, String> success = {"result": ""};
          return success;
        }
      }
    }
    catch (e) {
      Map<String,String> error = {
        "result": "Something went wrong please try again"
      } ;
      return error;
    }
    return null;
  }

  //getUserPhoneNumber
  static Future<Map<String,String>?> getPhoneNumber(String username) async {

    log(graphQLConfiguration.getGraphQLUrl() ?? "" );

    client=graphQLConfiguration.clientToQuery();

    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(
              Queries.getPhoneNumberByUser),
          variables: {
            'user': username,
          },
        ),
      );
      if(result.hasException){
        if(result.exception?.linkException?.originalException != null){
          Map<String,String> error = {
            "error": "Something went wrong please try again"
          } ;
          return error;
        }
        if(result.exception?.linkException is ServerException) {

          HttpLinkServerException exception = result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String,String> error = {
              "error": "Session Expired"
            } ;
            return error;
          }
        }
        if(result.exception?.graphqlErrors.isNotEmpty ?? false){
          log("${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String,String> error = {
            "error": result.exception!.graphqlErrors[0].message
          } ;
          return error;
        }
      }
      if(result.data?['getPhoneNumberByUser']!= null){
        Map<String, String> success = {
          "success": result.data?['getPhoneNumberByUser']
        };
        return success;
      }
    }
    catch (e) {
      log(e.toString());
      Map<String,String> error = {
        "result": "Something went wrong please try again"
      } ;
      return error;
    }
    return null;
  }


  //getUserPhoneNumber
  static Future<String> forgotPassword(String password,String username) async {

    log(graphQLConfiguration.getGraphQLUrl() ?? "" );

    client=graphQLConfiguration.clientToQuery();

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(
              Queries.forgotPassword),
          variables: {
            'newPassword':password,
            'user': username,
          },
          // pollInterval: Duration(milliseconds: 100)
        ),
      );
      if (result.hasException) {
        log(result.exception.toString());
        return "Something went wrong please try again";
      }
      if(result.data?['forgotPassword']["status"] != 200) {
        if(result.data?['forgotPassword']["status"] == 400 ){
          return "Your old password can not be your new password";
        }
        return "Something went wrong please try again";
      }
      return "Password has been reset successfully";
    }
    catch (e) {
      log(e.toString());
      return  "Something went wrong please try again";
    }
  }

  //change password
  static Future<Map<String,String>?> changePassword(String newPassword,String currentPassword) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    log(graphQLConfiguration.getGraphQLUrl() ?? "" );
    await loginUserCredentials.getCurrentUser();
    await graphQLConfiguration.setHeaders();

    client=graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(
                Queries.changePassword),
            variables: {
              'newPassword': newPassword,
              'currentPassword': currentPassword,
            }
        ),
      );

      if(result.hasException){
        if(result.exception?.linkException?.originalException != null){
          Map<String,String> error = {
            "error": "Something went wrong please try again"
          } ;
          return error;
        }
        if(result.exception?.linkException is ServerException) {

          HttpLinkServerException exception = result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String,String> error = {
              "error": "Session Expired"
            } ;
            return error;
          }
        }
        if(result.exception?.graphqlErrors.isNotEmpty ?? false){
          log("${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String,String> error = {
            "error": result.exception!.graphqlErrors[0].message
          } ;
          return error;
        }
      }
      if(result.data?['changePassword'] != null){
        if(result.data?['changePassword']["status"] == 400){
          Map<String,String> error = {
            "error": "You have already used this password"
          } ;
          return error;
        }
        Map<String,String> userCredentials = {
          "username":loginUserCredentials.getUsername()!,
          "password":newPassword,
          "token":(loginUserCredentials.getToken())!,
        };
        preferences.setString("userCredentials", jsonEncode(userCredentials));
        Map<String,String> success = {
          "success": result.data?['changePassword']["message"]
        } ;
        return success;
      }
    }
    catch (e) {
      log(e.toString());
      Map<String,String> error = {
        "error": e.toString()
      } ;
      return error;
    }
    return null;
  }

//create user method
  static Future<String> createUser(String userName, String email, String password,String fName,String lName,String phoneNumber) async {

    client=graphQLConfiguration.clientToQuery();
    Map<String, dynamic> data= {
      "userName":userName,
      "email":email,
      "password":password,
      "name":
      {
        "firstName":fName,
        "lastName":lName
      },
      "phoneNumber":phoneNumber
    };
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(
                Queries.createUser),
            variables: {
              'userData': data,
            }
        ),
      );

      if (result.hasException) {
        return result.exception!.graphqlErrors[0].message;
      }
      if(result.data?['createUser']["status"] != 201) {
        if(result.data?['createUser']["status"] == 400 ){
          return result.data?['createUser']["message"];
        }
        return "Something went wrong";
      }
      return "Created";
    }
    catch (e) {
      log(e.toString());
      return  "Something went wrong please try again";
    }
  }

  //getCategories By Business
  static Future<Map<String, List<String>?>?> getCategoriesByBusiness(
      String businessId) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    List<String>? responseList = [];
    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(Queries.getCategoriesByBusiness),
            variables: {"businessId": businessId}
            //pollInterval: Duration(milliseconds: 100)
            ),
      );

      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          responseList.add("Something went wrong please try again");
          Map<String, List<String>> error = {"error": responseList};

          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            responseList.add("Session Expired");
            Map<String, List<String>> error = {"error": responseList};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          responseList.add("${result.exception?.graphqlErrors[0].message}");
          Map<String, List<String>> error = {"error": responseList};
          return error;
        }
      }
      if (result.data?['getCategoriesByBusiness'] != null) {
        responseList = List<String>.from(
            result.data?['getCategoriesByBusiness']["data"] as List);
        Map<String, List<String>> success = {"success": responseList};
        return success;
      }
    } catch (e) {
      print(e.toString());
      responseList?.add("Something went wrong please try again");
      Map<String, List<String>> error = {"error": responseList!};
      return error;
    }
    return null;
  }


  //get products by category in business
  static Future<Map<String, String>?> getProductsByCategoryInBusiness(
      String businessId,
      String categoryName,
      int pageNo,
      int noOfElements) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(Queries.getProductsByCategoryInBusiness),
            variables: {
              "businessId": businessId,
              "categoryName": categoryName,
              "pageNo": pageNo,
              "noOfElements": noOfElements,
            }
            //pollInterval: Duration(milliseconds: 100)
            ),
      );

      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['getProductsByCategoryInBusiness'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getProductsByCategoryInBusiness']
              ["data"]["products"]),
          "totalPages": (result.data?['getProductsByCategoryInBusiness']["data"]
                  ["totalPages"]
              .toString())!
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }


  //get search products in business
  static Future<Map<String, String>?> getSearchProductsInBusiness(
      String businessId, String productName) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    // try {
    QueryResult result = await client.query(
      QueryOptions(
          document: gql(Queries.getSearchProductsInBusiness),
          variables: {"businessId": businessId, "productName": productName}
          //pollInterval: Duration(milliseconds: 100)
          ),
    );

    if (result.hasException) {
      if (result.exception?.linkException?.originalException != null) {
        Map<String, String> error = {
          "error": "Something went wrong please try again"
        };
        return error;
      }
      if (result.exception?.linkException is ServerException) {
        HttpLinkServerException exception =
            result.exception?.linkException as HttpLinkServerException;

        if (exception.response.statusCode == 401) {
          Map<String, String> error = {"error": "Session Expired"};
          return error;
        }
      }
      if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
        print(
            "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
        Map<String, String> error = {
          "error": result.exception!.graphqlErrors[0].message
        };
        return error;
      }
    }
    if (result.data?['searchProductsInBusiness'] != null) {
      print(result.data?['searchProductsInBusiness']["data"]["productsList"]);
      Map<String, String> success = {
        "success": jsonEncode(
            result.data?['searchProductsInBusiness']["data"]["productsList"])
      };
      return success;
    }
    return null;
  }

  //get all services in business
  static Future<Map<String, String>?> getAllServicesInBusiness(
      String businessId, int pageNo, int noOfElements) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    // try {
    QueryResult result = await client.query(
      QueryOptions(
          document: gql(Queries.getAllServicesInBusiness),
          variables: {
            "businessId": businessId,
            "pageNo": pageNo,
            "noOfElements" : noOfElements
          }
      ),
    );

    if (result.hasException) {
      if (result.exception?.linkException?.originalException != null) {
        Map<String, String> error = {
          "error": "Something went wrong please try again"
        };
        return error;
      }
      if (result.exception?.linkException is ServerException) {
        HttpLinkServerException exception =
        result.exception?.linkException as HttpLinkServerException;

        if (exception.response.statusCode == 401) {
          Map<String, String> error = {"error": "Session Expired"};
          return error;
        }
      }
      if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
        print(
            "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
        Map<String, String> error = {
          "error": result.exception!.graphqlErrors[0].message
        };
        return error;
      }
    }
    if (result.data?['getAllServicesInBusiness'] != null) {
      print(result.data?['getAllServicesInBusiness']["data"]["services"]);
      Map<String,String> success = {
        "success":  jsonEncode(result.data?['getAllServicesInBusiness']["data"]["services"]),
        "totalPages":(result.data?['getAllServicesInBusiness']["data"]["totalPages"].toString())!
      };
      return success;
    }
    return null;
  }

  //get all services in business
  static Future<Map<String, String>?> searchServicesInBusiness(
      String businessId, String serviceName) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    // try {
    QueryResult result = await client.query(
      QueryOptions(
          document: gql(Queries.searchServicesInBusiness),
          variables: {
            "businessId": businessId,
            "ServiceName": serviceName,
          }
      ),
    );

    if (result.hasException) {
      if (result.exception?.linkException?.originalException != null) {
        Map<String, String> error = {
          "error": "Something went wrong please try again"
        };
        return error;
      }
      if (result.exception?.linkException is ServerException) {
        HttpLinkServerException exception =
        result.exception?.linkException as HttpLinkServerException;

        if (exception.response.statusCode == 401) {
          Map<String, String> error = {"error": "Session Expired"};
          return error;
        }
      }
      if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
        print(
            "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
        Map<String, String> error = {
          "error": result.exception!.graphqlErrors[0].message
        };
        return error;
      }
    }
    if (result.data?['searchServicesInBusiness'] != null) {
      print(result.data?['searchServicesInBusiness']["data"]["services"]);
      Map<String,String> success = {
        "success":  jsonEncode(result.data?['searchServicesInBusiness']["data"]["services"]),
      };
      return success;
    }
    return null;
  }

  //get slots of business services
  static Future<Map<String, String>?> getSlotsByBusinessAndService(
      String businessId, String serviceName,String date,String customerId) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    QueryResult result = await client.query(
      QueryOptions(
          document: gql(Queries.getSlotsByBusinessAndService),
          variables: {
            "businessId": businessId,
            "date" : date,
            "serviceName": serviceName,
            "customerId" : customerId
          }
      ),
    );

    if (result.hasException) {
      if (result.exception?.linkException?.originalException != null) {
        Map<String, String> error = {
          "error": "Something went wrong please try again"
        };
        return error;
      }
      if (result.exception?.linkException is ServerException) {
        HttpLinkServerException exception =
        result.exception?.linkException as HttpLinkServerException;

        if (exception.response.statusCode == 401) {
          Map<String, String> error = {"error": "Session Expired"};
          return error;
        }
      }
      if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
        print(
            "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
        Map<String, String> error = {
          "error": result.exception!.graphqlErrors[0].message
        };
        return error;
      }
    }
    if (result.data?['getSlotsByBusinessAndService'] != null) {
      print(result.data?['getSlotsByBusinessAndService']["data"]);
      Map<String,String> success = {
        "success":  jsonEncode(result.data?['getSlotsByBusinessAndService']["data"]),
      };
      return success;
    }
    return null;
  }

  //user login function
  static Future<String> signInUser(String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      var apiURL = 'http://ec2-3-233-214-217.compute-1.amazonaws.com:8081/oauth/token';
      Map<String, String> headers = {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('socol:topsecret')),
        'Content-Type': 'application/x-www-form-urlencoded'
      };
      Map<String, String> body = {
        "grant_type": "password",
        "username": username,
        "password": password,
      };
      var response =
          await http.post(Uri.parse(apiURL), headers: headers, body: body);
      if (response.statusCode == 400) {
        return "Invalid Credentials";
      }
      else if(response.statusCode == 401){
        return "Email/Username not Registered!";
      }
      else if (response.statusCode != 200) {
        return "Server error please try later";
      }
      else{
        List<dynamic>? typeOfUser = [USER_TYPE_CUSTOMER];
        Map<String, String> userCredentials = {
          "username": username,
          "password": password,
          "token": jsonDecode(response.body)["access_token"],
          "types": jsonEncode(typeOfUser)
        };
        preferences.setString("userCredentials", jsonEncode(userCredentials));

        return "Successfully Login";
      }
    } catch (e) {
      print(e.toString());
      return "Something went wrong please try again";
    }
  }

  //get all business for user
  static Future<Map<String, String>?> getAllBusiness() async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.getAllBusiness),
        ),
      );

      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;
          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['getAllBusiness'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getAllBusiness']["data"])
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //get all searches of shops in business
  static Future<Map<String, String>?> getBusinessByName(
      String businessName, int pageNo, int noOfElements) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    // try {
    QueryResult result = await client.query(
      QueryOptions(
          document: gql(Queries.getBusinessByName),
          variables: {
            "businessName": businessName,
            "pageNo": pageNo,
            "noOfElements" : noOfElements
          }
      ),
    );

    if (result.hasException) {
      if (result.exception?.linkException?.originalException != null) {
        Map<String, String> error = {
          "error": "Something went wrong please try again"
        };
        return error;
      }
      if (result.exception?.linkException is ServerException) {
        HttpLinkServerException exception =
        result.exception?.linkException as HttpLinkServerException;

        if (exception.response.statusCode == 401) {
          Map<String, String> error = {"error": "Session Expired"};
          return error;
        }
      }
      if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
        print(
            "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
        Map<String, String> error = {
          "error": result.exception!.graphqlErrors[0].message
        };
        return error;
      }
    }
    if (result.data?['getBusinessByName'] != null) {
      print(result.data?['getBusinessByName']["data"]);
      Map<String,String> success = {
        "success":  jsonEncode(result.data?['getBusinessByName']["data"]),
      };
      return success;
    }
    return null;
  }

  //get all services for user
  static Future<Map<String, String>?> getAllServices(int pageNo, int noOfElements) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.getAllServices),
          variables: {
            "pageNo": pageNo,
            "noOfElements": noOfElements
          },
          //pollInterval: Duration(milliseconds: 100)
        ),
      );

      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;
          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['getAllBusinessWhoOfferServices'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getAllBusinessWhoOfferServices']["data"]),
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //get all services for user
  static Future<Map<String, String>?> getShopByNameWhoProvideServices(int pageNo, int noOfElements,String businessName) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.getShopByNameWhoProvideServices),
          variables: {
            "pageNo": pageNo,
            "noOfElements": noOfElements,
            "businessName" : businessName
          },
          //pollInterval: Duration(milliseconds: 100)
        ),
      );

      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;
          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['getShopByNameWhoProvideServices'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getShopByNameWhoProvideServices']["data"]),
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //add addresses
  static Future<Map<String, String>> addAddress({required String userId, required Address input}) async {
    client = graphQLConfiguration.clientToQuery();
    await graphQLConfiguration.setHeaders();

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(Queries.addUserAddress),
            variables: {'userId': userId, 'addressInput': input}),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      Map<String, String> success = {
        "success": json.encode(result.data?["addUserAddress"]["data"]['addresses'])
      };
      return success;
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
  }

  //update address
  static Future<Map<String, String>> updateAddress(
      {required String userId,
      required Address input,
      required int index}) async {
    client = graphQLConfiguration.clientToQuery();
    await graphQLConfiguration.setHeaders();

    try {
      QueryResult result = await client.mutate(
        MutationOptions(document: gql(Queries.updateUserAddress), variables: {
          'userId': userId,
          'addressInput': input,
          'index': index
        }),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      Map<String, String> success = {
        "success": json.encode(result.data?["updateUserAddress"]["data"])
      };
      return success;
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
  }

  //delete address
  static Future<Map<String, String>> deleteAddress(
      {required String userId,
      required Address input,
      required int index}) async {
    client = graphQLConfiguration.clientToQuery();
    await graphQLConfiguration.setHeaders();

    try {
      QueryResult result = await client.mutate(
        MutationOptions(document: gql(Queries.deleteUserAddress), variables: {
          'userId': userId,
          'addressInput': input,
          'index': index
        }),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      Map<String, String> success = {
        "success": json.encode(result.data?["deleteUserAddress"]["data"]['addresses'])
      };
      return success;
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
  }

  //check either user has customer or business account
  static Future<Map<String, String>?> getUserById() async {
    print(graphQLConfiguration.getGraphQLUrl());
    await loginUserCredentials.getCurrentUser();
    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.getUserById),
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['getUserById'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getUserById'])
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //assign order to the vendor
  static Future<Map<String, String>?> createOrder(List<String> categories, List<CartProduct> cartProduct, Users user, int totalAmount, Address address, Business business) async {
    print(graphQLConfiguration.getGraphQLUrl());

    Map<String, dynamic> data = {
      "businessId": business.businessId,
      "address": address,
      "orderType": ORDER_TYPE_ONLINE,
      "categories": categories,
      "products": cartProduct,
      "customerName": json.encode(user.name),
      "email": user.email,
      "phoneNumber": user.phoneNumber,
      "totalAmount": totalAmount
    };

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(Queries.createOrder),
            variables: {
          'createOrderInput': data,
        }
            //pollInterval: Duration(milliseconds: 100)
            ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['createOrder'] != null) {
        if (result.data?['createOrder']["status"] == 201) {
          Map<String, String> success = {
            "success": result.data?['createOrder']["message"],
          };
          return success;
        } else {
          Map<String, String> error = {
            "error": result.data?['createOrder']["message"],
            "data": jsonEncode(result.data?["createOrder"]["data"]["products"])
          };
          return error;
        }
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //create service
  static Future<Map<String, String>?> createBookingServices(Business business,String userId,String date,Service service,int slotNumber,TimeObj timeObj,String totalAmount,String instructions,int rating) async {
    print(graphQLConfiguration.getGraphQLUrl());

    Map<String, dynamic> data = {
      "businessId": business.businessId,
      "slotNumber" : slotNumber,
      "date" : date,
      "serviceCartItems" : {
        "serviceName" : service.serviceName,
        "price" : service.price,
        "discount" : service.discount,
        "discountedPrice" : service.discountedPrice,
        "listImagePath" : service.listImagePath
      },
      "timeObj" : timeObj,
      "totalAmount" : totalAmount,
      "instructions" : instructions,
      "rating" : rating
    };

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(Queries.createBookingServices),
            variables: {
              "userId": userId,
              'CreateBookingInput': data,
            }
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['createBookingServices'] != null) {
        if (result.data?['createBookingServices']["status"] == 201) {
          Map<String, String> success = {
            "success": result.data?['createBookingServices']['message'],
          };
          return success;
        }
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //add to wishlist
  static Future<Map<String, String>?> addProductInWishList(Business business,String userID,Product product,String categoryName) async {
    print(graphQLConfiguration.getGraphQLUrl());

    Map<String, dynamic> data = {
      "businessId": business.businessId,
      "product": product
    };

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(Queries.addToWishlist),
            variables: {
              "userID": userID,
              "categoryName" : categoryName,
              'AddProductInFavList': data
            }
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['addProductInWishList'] != null) {
        if (result.data?['addProductInWishList']["status"] == 201) {
          Map<String, String> success = {
            "success": result.data?['addProductInWishList']["data"],
          };
          return success;
        }
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //Delete to wishlist
  static Future<Map<String, String>?> deleteProductFromWishList(Business business,String userID,Product product) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
            document: gql(Queries.deleteProductFromWishList),
            variables: {
              "userID": userID,
              'ProductInputs': product,
              "businessId": business.businessId,
            }
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['deleteProductFromWishList'] != null) {
        if (result.data?['deleteProductFromWishList']["status"] == 201) {
          Map<String, String> success = {
            "success": result.data?['deleteProductFromWishList']["data"],
          };
          return success;
        }
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //Get product wishlist
  static Future<Map<String, String>?> getProductWishList(String userID) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(Queries.getProductWishList),
            variables: {
              "userID": userID
            }
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['getProductWishList'] != null) {
        if (result.data?['getProductWishList']["status"] == 200) {
          Map<String, String> success = {
            "success": jsonEncode(result.data?['getProductWishList']["data"]['favouriteProducts']),
          };
          return success;
        }
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //update user profile
  static Future<Map<String, String>?> userUpdateProfile(String userId, String fName, String lName, String phoneNumber,MultipartFile? uploadImage,String deleteImage) async {
    client = graphQLConfiguration.clientToQuery();
    Map<String,dynamic> image ={
      "file":uploadImage
    };
    Map<String, dynamic> data = {
      "userId": userId,
      "name": {"firstName": fName, "lastName": lName},
      "phoneNumber": phoneNumber,
      "uploadImage" : image,
      "deleteImage" : deleteImage
    };
    try {
      QueryResult result = await client.mutate(
        MutationOptions(document: gql(Queries.updateUserProfile), variables: {
          'UpdateUserProfile': data,
        }
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['updateUserProfile'] != null) {
        if (result.data?['updateUserProfile']["status"] == 200) {
          Map<String, String> success = {
            "success": result.data?['updateUserProfile']["message"],
            "data": jsonEncode(result.data?["updateUserProfile"]["data"])
          };
          return success;
        }
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {"error": e.toString()};
      return error;
    }
    return null;
  }

  //get order history by business
  static Future<Map<String, String>?> getOrdersByCustomerAndStatus(
      String customerId, int pageNo, int noOfElements, String status) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(Queries.getOrdersByCustomerAndStatus),
            variables: {
              "customerId": customerId,
              "status": status,
              "pageNo": pageNo,
              "noOfElements": noOfElements
            },),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
              result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }

      if (result.data?['getOrdersByCustomerAndStatus'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getOrdersByCustomerAndStatus']["data"] ?? []),
          "totalPages": (result.data?['getOrdersByCustomerAndStatus']["totalPages"].toString())!
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //get booking history by business
  static Future<Map<String, String>?> getBookingsByCustomerIdAndStatus(
      String customerId, int pageNo, int noOfElements, String statusType) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.getBookingsByCustomerIdAndStatus),
          variables: {
            "customerId": customerId,
            "statusType": statusType,
            "pageNo": pageNo,
            "noOfElements": noOfElements
          },),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }

      if (result.data?['getBookingsByCustomerIdAndStatus'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['getBookingsByCustomerIdAndStatus']["data"] ?? []),
          "totalPages": (result.data?['getBookingsByCustomerIdAndStatus']["totalPages"].toString())!
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //calculate business within range to get shops when you selected addresses
  static Future<Map<String, String>?> calculateBusinessesWithinRange(
      String userId) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.calculateBusinessesWithinRange),
          variables: {
            "userId": userId
          },
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['calculateBusinessesWithinRange'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['calculateBusinessesWithinRange']["data"]['businesses'] ?? [])
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //update business by selecting the address
  static Future<Map<String, String>?> updateUserAddressStatus(String userId,int index) async {
    print(graphQLConfiguration.getGraphQLUrl());

    await graphQLConfiguration.setHeaders();

    client = graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(Queries.updateUserAddressStatus),
          variables: {
            "userId": userId,
            "index" : index
          },
        ),
      );
      if (result.hasException) {
        if (result.exception?.linkException?.originalException != null) {
          Map<String, String> error = {
            "error": "Something went wrong please try again"
          };
          return error;
        }
        if (result.exception?.linkException is ServerException) {
          HttpLinkServerException exception =
          result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String, String> error = {"error": "Session Expired"};
            return error;
          }
        }
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          print(
              "${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String, String> error = {
            "error": result.exception!.graphqlErrors[0].message
          };
          return error;
        }
      }
      if (result.data?['updateUserAddressStatus'] != null) {
        Map<String, String> success = {
          "success": jsonEncode(result.data?['updateUserAddressStatus']["data"] ?? [])
        };
        return success;
      }
    } catch (e) {
      print(e.toString());
      Map<String, String> error = {
        "error": "Something went wrong please try again"
      };
      return error;
    }
    return null;
  }

  //get places by search google api
  static Future<String> getPlacesBySearch(String text,String countryCode,String lat,String lng,int radius) async {
    try {
      var apiURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&components=country:$countryCode&location=$lat%2C$lng&radius=$radius&strictbounds=true&key=AIzaSyDORyCikRVSrqRH9Gj_kX4Ln4SOo8NZseU';
      Map<String, String> headers = {
        'key': 'AIzaSyDORyCikRVSrqRH9Gj_kX4Ln4SOo8NZseU'
      };

      var response = await http.get(Uri.parse(apiURL), headers: headers);
      if  (response.statusCode != 200 ){
        return "Something went wrong please try again";
      }
      var placesList = jsonDecode(response.body)["predictions"];
      return jsonEncode(placesList);
    }
    catch (e) {
      print(e.toString());
      return "Something went wrong please try again";
    }
  }

//get places detail google api
  static Future<String> getPlacesDetail(String placeId) async {
    try {
      var apiURL = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyDORyCikRVSrqRH9Gj_kX4Ln4SOo8NZseU';
      Map<String, String> headers = {
        'key': 'AIzaSyDORyCikRVSrqRH9Gj_kX4Ln4SOo8NZseU'
      };

      var response = await http.get(Uri.parse(apiURL), headers: headers);
      if  (response.statusCode != 200 ){
        return "Something went wrong please try again";
      }
      var placesList = jsonDecode(response.body)["result"];
      return jsonEncode(placesList);
    }
    catch (e) {
      print(e.toString());
      return "Something went wrong please try again";
    }
  }

  //get address from latitude longitude using google api
  static Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      var apiURL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDORyCikRVSrqRH9Gj_kX4Ln4SOo8NZseU';
      Map<String, String> headers = {
        'key': 'AIzaSyDORyCikRVSrqRH9Gj_kX4Ln4SOo8NZseU'
      };

      var response = await http.get(Uri.parse(apiURL), headers: headers);
      if  (response.statusCode != 200 ){
        return "Something went wrong please try again";
      }
      var placesList = jsonDecode(response.body)["results"][0];
      return jsonEncode(placesList);
    }
    catch (e) {
      print(e.toString());
      return "Something went wrong please try again";
    }
  }

  //update service status By category

  static Future<Map<String,String>?> updateFcmToken(String FCMToken,bool isCustomerApp) async {
    print(graphQLConfiguration.getGraphQLUrl());
    await graphQLConfiguration.setHeaders();
    client=graphQLConfiguration.clientToQuery();
    try {
      QueryResult result = await client.query(
        QueryOptions(
            document: gql(
                Queries.updateFCM),
            variables: {
              "FCMToken":FCMToken,
              "isCustomerApp":isCustomerApp,
            }
        ),
      );

      if(result.hasException){
        if(result.exception?.linkException?.originalException != null){
          Map<String,String> error = {
            "error": "Something went wrong please try again"
          } ;
          return error;
        }
        if(result.exception?.linkException is ServerException) {

          HttpLinkServerException exception = result.exception?.linkException as HttpLinkServerException;

          if (exception.response.statusCode == 401) {
            Map<String,String> error = {
              "error": "Session Expired"
            } ;
            return error;
          }
        }
        if(result.exception?.graphqlErrors.isNotEmpty ?? false){
          print("${result.exception?.graphqlErrors[0].message} : ${result.exception?.graphqlErrors[0].extensions?["statusCode"]}");
          Map<String,String> error = {
            "error": result.exception!.graphqlErrors[0].message
          } ;
          return error;
        }
      }
      if(result.data?['updateFCM']!= null){
        if(!result.data?['updateFCM']) {
          Map<String, String> success = {
            "result": "Something went wrong please try again"
          };
          return success;
        }
        else {
          Map<String, String> success = {
            "result": ""
          };
          return success;
        }
      }
    }

    catch (e) {
      print(e.toString());
      Map<String,String> error = {
        "error": e.toString()
      } ;
      return error;
    }
    return null;
  }
}
