import 'package:flutter/material.dart';
import 'package:toonflix/screen/home_screen.dart';
import 'package:toonflix/service/api_service.dart';

void main() {
  ApiService().getTodayWebtoon();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
