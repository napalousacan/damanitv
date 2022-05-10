
import 'package:damanitv/constants.dart';
import 'package:damanitv/model/api_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'apiService.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("api.php")
  Future<ApiResponse> getAppDetails();

/*
  @GET("")
  Future<VODResponse> getVideoData();*/
}
