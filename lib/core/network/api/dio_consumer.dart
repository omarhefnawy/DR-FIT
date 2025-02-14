import 'package:dio/dio.dart';
import 'package:dr_fit/core/network/api/api_url.dart';

class DioConsumer {
  final dio = Dio();

  Future<dynamic> getExerciseByBodyPart({
    required String targetPart,
  }) async {
    try {
      print("${Api.baseUrl}$targetPart");
      final response = await dio.get(
        "${Api.baseUrl}$targetPart",
        queryParameters: {
          "limit": 1000,
          "offset": 0,
        },
        options: Options(
          headers: {
            'x-rapidapi-key': Api.apiKey,
            'x-rapidapi-host': Api.host,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            "Failed to load exercises. Status Code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception("DioException: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
