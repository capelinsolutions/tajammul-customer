

import 'BaseConfig.dart';

class LiveConfiguration implements BaseConfig{
  @override
  // TODO: implement apiHost
  String get apiHost => "http://ec2-3-233-214-217.compute-1.amazonaws.com:8081/graphql/";

  //image bucket url
  @override
  String get imageUrl => "https://tajammul.s3.amazonaws.com/";

}