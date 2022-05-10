
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';


class YoutubeVideoPlayerPage extends StatefulWidget {
  final String url, title, img, date, related;
  final Map videos;

  YoutubeVideoPlayerPage(
      {  this.url,
         this.title,
         this.img,
         this.date,
         this.related,
         this.videos});

  @override
  _YoutubeVideoPlayerPageState createState() => _YoutubeVideoPlayerPageState();
}

class _YoutubeVideoPlayerPageState extends State<YoutubeVideoPlayerPage> {
   YoutubePlayerController _controller;
  final logger = Logger();
  List<YT_API> ytResult = [];
   bool isLoading;
  Map videos;
  var onPlay;
  String tvurl = "";
  String linktv = "";
  String tvTitle = "";
  String tvIcon = "";
  String tvDate = "";
  int nbre=0;

  Future<void> callAPI() async {
    videos = widget.videos;
    logger.i(videos["items"],"dataaaa");
    videos["items"].map((video){
      //logger.i("napal",video.id);
      nbre++;
    }).toList();
    logger.i(this.nbre,"nnnnnnbrrrrrrrreeeee");
    setState(() {
      videos;
      nbre;
      print('UI Updated');
      //if (ytResult.length > 0) ytResult.removeAt(0);
      isLoading = false;
    });
  }

  @override
  void initState() {
    Wakelock.enable();
    tvurl = widget.url.toString();
    tvTitle = widget.title;
    tvIcon = widget.img;
    tvDate = widget.date;
    logger.i(tvurl,'id video youtube');
    //logger.i(this.videos,'all videos');
    super.initState();

    _controller = YoutubePlayerController(
        initialVideoId:
        tvurl,
        flags: YoutubePlayerFlags(
          controlsVisibleAtStart: false,
          autoPlay: true,
          hideThumbnail: true,
          mute: false,
        ));
    //widget.related != "" ? getVideos() : print("Oups");
    callAPI();
    print("tesy");
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        onExitFullScreen: () {
          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        onEnterFullScreen: (){
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
        },
        player: YoutubePlayer(
          controller: _controller,
          width: double.infinity,
        ),
        builder: (context, player) {
          return Scaffold(
              appBar: appBar(),
              body: Column(
                children: <Widget>[
                  player,
                  Container(
                    height: 70,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: colorPrimary)
                    ),
                    child: Row(
                      children: <Widget>[
                        CachedNetworkImage(
                          width: 80,
                          height: 60,
                          imageUrl: tvIcon,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.contain,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Container(
                                    child: Text(
                                      tvTitle,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "CeraPro",
                                          fontWeight: FontWeight.bold,
                                          color: colorPrimary),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 7),
                                    child: Text(
                                      tvDate,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "CeraPro",
                                          fontWeight: FontWeight.normal,
                                          color: colorPrimary.withOpacity(0.7)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Vidéos similaires",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "CeraPro",
                          fontWeight: FontWeight.bold,
                          color: colorPrimary),
                    ),
                  ),
                           videos != null
                          ? Expanded(child: Container(child: makeItemPVideos()))
                          : Container(),
                ],
              ));
        });
  }

  Widget makeItemPVideos() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return
          GestureDetector(
            onTap: () {
              setState(() {
                tvurl = this.videos["items"][position]["snippet"]["resourceId"]["videoId"];
                tvTitle = this.videos["items"][position]["snippet"]["title"];
                tvIcon = this.videos["items"][position]["snippet"]
                ["thumbnails"]["medium"]["url"];
                tvDate = Jiffy(this.videos["items"][position]["snippet"]["publishedAt"],
                    "yyyy-MM-ddTHH:mm:ssZ").yMMMMEEEEdjm;
              });
              logger.i(tvurl,"ttvvvvv");
              _controller.load(tvurl);
            },
            child: Container(
                margin: EdgeInsets.only(left: 10,right: 5),
                child: Container(
                  width: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 130,
                            //alignment: Alignment.center,
                            child: new Row(
                              children: <Widget>[
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(4),
                                      child: CachedNetworkImage(
                                        height: 90,
                                        width:100,
                                        imageUrl: this.videos["items"][position]["snippet"]
                                        ["thumbnails"]["medium"]["url"],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                              "assets/images/logo.png",
                                              fit: BoxFit.contain,
                                              height: 100,
                                              width: 100,
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                            Image.asset(
                                              "assets/images/logo.png",
                                              fit: BoxFit.contain,
                                              height: 100,
                                              width: 100,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 100,
                                      child: Center(
                                        child: Container(
                                          child: Image.asset(
                                            "assets/images/play.png",
                                            height: 50,
                                            width: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                                SizedBox(width: 5,),
                                Flexible(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child:
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            //height: 70,
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              this.videos["items"][position]["snippet"]["title"],
                                              maxLines: 4,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: colorPrimary),
                                            ),
                                          ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Container(
                                            padding: EdgeInsets.only(left: 10,right: 10,bottom: 15),
                                            child: Text(
                                              //ytResult[position].publishedAt,
                                              "Du ${Jiffy(this.videos["items"][position]["snippet"]["publishedAt"],"yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy à HH:mm")} " ,
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  ),
                )),
        );
      },
      itemCount: this.nbre,
    );
  }

  Widget makeShimmerVideos() {
    return ListView.builder(
      itemBuilder: (context, position) {
        return
          Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Container(
                height: 120.0,
                width: 200,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 10.0),
                    ),
                  ],
                ),
              )
        );
      },
      itemCount: 5,
    );
  }

  appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.only(right: 50),
            child: Image.asset("assets/images/logo.png"),
          )
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
      ),
      elevation: 0.0,
      backgroundColor: colorPrimary,
    );
  }
}
