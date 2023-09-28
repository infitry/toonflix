import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/model/webtoon_model.dart';

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String todayPath = "/today";

  Future<List<WebtoonModel>> getTodayWebtoon() async {
    final url = Uri.parse('$baseUrl$todayPath');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      List<WebtoonModel> convertedWebtoons = [];

      for (var webtoon in webtoons) {
        final webtoonModel = WebtoonModel.fromJson(webtoon);
        convertedWebtoons.add(webtoonModel);
      }
      return convertedWebtoons;
    }
    throw Exception("Today Server ERROR");
  }
}
