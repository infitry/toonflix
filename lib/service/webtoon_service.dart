import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/model/webtoon_episode_model.dart';
import 'package:toonflix/model/webtoon_model.dart';

import '../model/webtoon_detail_model.dart';

class WebtoonService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String todayPath = "today";
  static const String episodePath = "episodes";

  static Future<List<WebtoonModel>> getTodayWebtoons() async {
    final url = Uri.parse('$baseUrl/$todayPath');
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

  static Future<WebtoonDetailModel> getWebtoonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final dynamic webtoons = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoons);
    }
    throw Exception("Webtoon Detail Server ERROR");
  }

  static Future<List<WebtoonEpisodeModel>> getWebtoonEpisodesById(
      String id) async {
    final url = Uri.parse('$baseUrl/$id/$episodePath');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      List<WebtoonEpisodeModel> webtoonEpisodes = [];

      for (var webtoon in webtoons) {
        final webtoonEpisodeModel = WebtoonEpisodeModel.fromJson(webtoon);
        webtoonEpisodes.add(webtoonEpisodeModel);
      }
      return webtoonEpisodes;
    }
    throw Exception("Webtoon episode Server ERROR");
  }
}
