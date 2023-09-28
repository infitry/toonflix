import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/service/webtoon_service.dart';

import '../model/webtoon_detail_model.dart';
import '../model/webtoon_episode_model.dart';
import '../widget/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;
  const DetailScreen(
      {super.key, required this.title, required this.thumb, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const likeWebtoonsKey = "likedWebtoons";
  late Future<WebtoonDetailModel> webtoonDetail;
  late Future<List<WebtoonEpisodeModel>> webtoonEpisodes;
  late SharedPreferences prefer;
  bool isLike = false;

  Future initPreferences() async {
    prefer = await SharedPreferences.getInstance();
    final likedWebtoons = prefer.getStringList(likeWebtoonsKey);
    if (likedWebtoons != null) {
      if (likedWebtoons.contains(widget.id)) {
        setState(() {
          isLike = true;
        });
      }
    } else {
      await prefer.setStringList(likeWebtoonsKey, []);
    }
  }

  onHeartTap() async {
    final likeWebtoons = prefer.getStringList(likeWebtoonsKey);
    if (likeWebtoons != null) {
      if (isLike) {
        likeWebtoons.remove(widget.id);
      } else {
        likeWebtoons.add(widget.id);
      }
      prefer.setStringList(likeWebtoonsKey, likeWebtoons);
    }
    setState(() {
      isLike = !isLike;
    });
  }

  @override
  void initState() {
    super.initState();
    webtoonDetail = WebtoonService.getWebtoonById(widget.id);
    webtoonEpisodes = WebtoonService.getWebtoonEpisodesById(widget.id);
    initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLike ? Icons.favorite : Icons.favorite_border_outlined,
            ),
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      height: 300,
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            offset: const Offset(10, 10),
                            color: Colors.black.withOpacity(0.8),
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        widget.thumb,
                        width: 250,
                        height: 300,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: webtoonDetail,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.about,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${snapshot.data!.genre} / ${snapshot.data!.age}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }
                    return const Text('...');
                  }),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: webtoonEpisodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(episode: episode, webtoonId: widget.id)
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
