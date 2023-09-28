import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String todayPath = "/today";

  void getTodayWebtoon() async {
    final url = Uri.parse('$baseUrl$todayPath');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }
    throw Exception("Today Server ERROR");
  }
}
