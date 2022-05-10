import 'package:better_player/better_player.dart';
import 'package:damanitv/constants.dart';
import 'package:damanitv/model/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';


// ignore: must_be_immutable
class TVMenuScreen extends StatefulWidget {
  final Api tvItem;

  TVMenuScreen({this.tvItem,});

  @override
  _TVMenuScreenState createState() => _TVMenuScreenState();
}

class _TVMenuScreenState extends State<TVMenuScreen>
    with AutomaticKeepAliveClientMixin<TVMenuScreen> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  GlobalKey _betterPlayerKey = GlobalKey();
  final logger = Logger();
  String tvurl = "";
  String linktv = "";
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  BetterPlayerController playerController;
  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    allowedScreenSleep: false,
    controlsConfiguration: BetterPlayerControlsConfiguration(
      iconsColor: Colors.white,
      controlBarColor: colorPrimary,
      enablePip: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: colorPrimary,
      enableSkips: false,
      overflowMenuIconsColor: colorPrimary,
    ),
  );
  String tvTitle = "";
  String tvIcon = "";

  Future<void> callAPI() async {
    print('UI callled');
    await Jiffy.locale("fr");
    ytResult = await ytApi.channel('UCwJ878YDAKOJOJnTZWNVmcA');
    logger.i(ytResult[0].title);
    setState(() {
      print('UI Updated');
      isLoading = false;
    });
  }
  @override
  void initState() {
    tvurl = widget.tvItem.feedUrl;
    tvTitle = widget.tvItem.title;

    ytApi = new YoutubeAPI('AIzaSyAS-pv77K2uUCChBG5I_prIxJxhyt-sDAg', maxResults: 50, type: "video");
    callAPI();
    logger.i('napal',ytResult);
    playerController = BetterPlayerController(betterPlayerConfiguration);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      tvurl,
      liveStream: true,
      asmsTrackNames: ["3G 360p", "SD 480p", "HD 1080p"],
    );

    playerController.setupDataSource(dataSource)
        .then((response) {
      //isVideoLoading = false;
    })
        .catchError((error) async {
    });
    playerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    if (playerController != null) playerController.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: new Text('Eutelsat TV',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: colorPrimary)),
            content: new Text(
              'Etes-vous sûr de vouloir fermer l\'application?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black),
            ),
            actionsPadding: EdgeInsets.only(left: 10, right: 40),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                  width: 85,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[800], Colors.blue],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(35)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Annuler",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  playerController?.dispose();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Container(
                  width: 85,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[800], Colors.redAccent],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      borderRadius: BorderRadius.circular(35)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Quitter",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new WillPopScope(
        child: Scaffold(
            body: Container(
              /*decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "$imageUri/bg.png"
                  )
                )
              ),*/
              child: Column(
                children: [
                  playerController!=null?
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(
                      controller: playerController,
                    ),
                  ):Container(),
                  Container(
                      height: 65,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(3),
                      //margin: EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
                        color: colorPrimary,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white,
                            ),
                            margin: EdgeInsets.all(5),
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                              height: 140,
                              width: 130,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${tvTitle.toUpperCase()}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "CeraPro",
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )
                  ),

                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: ytResult.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {

                                },
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(ytResult[index].thumbnail['medium']
                                    ['url'])),
                                title: Text(ytResult[index].title),
                                subtitle: Text(Jiffy(ytResult[index].publishedAt,
                                    "yyyy-MM-ddTHH:mm:ssZ")
                                    .yMMMMEEEEdjm,),
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
        onWillPop: _onBackPressed);
  }

  Widget player() {
    return Container(
        width: double.infinity,
        height: 230,
        color: Colors.black,
        child: Center(
            child: Stack(
          children: <Widget>[
            playerController != null
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: BetterPlayer(
                      controller: playerController,
                      //key: _betterPlayerKey,
                    ),
                  )
                : Container(),
          ],
        )));
  }

/*  Widget makeItemTV() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, position) {
        return FadeAnimation(
            0.5,
            Hero(
              tag: tvList[position].title,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    tvurl = tvList[position].feedUrl;
                    tvTitle = tvList[position].title;
                    tvIcon = tvList[position].logo;
                    for (int i = 0; i < tvList.length; i++) {
                      tvList[i].isSelected = false;
                    }
                    tvList[position].isSelected = true;
getLiveUrl(tvurl);
                  });
                },
                child: FadeAnimation(
                    0.5,
                    Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: colorPrimary,
                          boxShadow: [
                            BoxShadow(
                                color: tvList[position].isSelected
                                    ? Colors.red[800]
                                    : Colors.black,
                                blurRadius:
                                    tvList[position].isSelected ? 1 : 1.5,
                                spreadRadius:
                                    tvList[position].isSelected ? 2 : 0.5),
                          ],
                        ),
                        margin: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: tvList[position].logo,
                                height: 70,
                                errorWidget: (context, url, error) =>  Text(
                                  tvList[position].title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          ],
                        ))),
              ),
            ));
      },
      itemCount: tvList.length,
    );
  }

  Widget makeItemVideos() {
    return Container(
      height: 215,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return FadeAnimation(
            0.5,
            GestureDetector(
              onTap: () {
                if (playerController != null) playerController.pause();
                Utils.navigationPage(
                    context,
                    VideoDetailsScreen(
                      videos: videoList,
                      onplay: videoList[i]
                    ),
                    true);
              },
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Container(
                    width: 140,
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(
                            0.5,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                //alignment: Alignment.center,
                                child: new Stack(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: videoList[i].logo,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Image.asset("assets/images/logo.png",color: colorPrimary,),
                                    ),
                                    Center(
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: FadeAnimation(
                            0.6,
                            Text(
                              videoList[i].title,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: "CeraPro",
                                  fontWeight: FontWeight.bold,
                                  color: colorPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        },
        itemCount: videoList.length>10?10:videoList.length,
      ),
    );
  }

  Widget makeItemEmissions() {
    return Container(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          return FadeAnimation(
            0.5,
            GestureDetector(
              onTap: () {
                if (playerController != null) playerController.pause();
                 Utils.navigationPage(
                    context,
                    ProgDetailsScreen(
                      url: emissionList[position].feedUrl,
                    ),
                    true);
              },
              child: FadeAnimation(
                  0.5,
                  Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: colorPrimary,
                              blurRadius: 1.5,
                              spreadRadius: 1),
                        ],
                      ),
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl:  emissionList[position].logo,
                              height: 80,
                              errorWidget: (context, url, error) => Container(),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            emissionList[position].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )
                        ],
                      ))),
            ),
          );
        },
        itemCount: emissionList.length,
      ),
    );
  }

  Widget makeShimmerItem() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, position) {
          return FadeAnimation(
            0.5,
            Shimmer.fromColors(
                baseColor: Colors.grey[400],
                highlightColor: Colors.white,
                child: Container(
                  height: 160.0,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 10,
                        offset: Offset(0, 10.0),
                      ),
                    ],
                  ),
                )),
          );
        },
        itemCount: 6);
  }*/
}
