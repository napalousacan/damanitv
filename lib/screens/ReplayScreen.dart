import 'package:cached_network_image/cached_network_image.dart';
import 'package:damanitv/screens/playlist_youtube.dart';
import 'package:damanitv/screens/youtubePlayer.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';

import '../constants.dart';

class ReplayScreen extends StatefulWidget {
   ReplayScreen({Key key}) : super(key: key);

  @override
  _ReplayScreenState createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
   YoutubeAPI ytApi;
   YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  Logger logger =Logger();

   Future<void> callAPI() async {
     print('UI callled');
     await Jiffy.locale("fr");
     ytResult = await ytApi.channel('UCwJ878YDAKOJOJnTZWNVmcA');
     logger.i(ytResult[0].title);
     setState(() {
       print('UI Updated');
       isLoading = false;
       callAPIPlaylist();
     });
   }

   Future<void> callAPIPlaylist() async {
     print('UI callled');
     await Jiffy.locale("fr");
     ytResultPlaylist = await ytApiPlaylist.playlist('UCwJ878YDAKOJOJnTZWNVmcA');
     logger.i(ytResultPlaylist.length);
     setState(() {
       print('UI Updated');
       //logger.i(ytResultPlaylist[0].title);
       logger.i('napal',ytResultPlaylist[0].id);
       //logger.i(ytResultPlaylist.length);
       isLoadingPlaylist = false;
     });
   }
   @override
  void initState() {
    // TODO: implement initState
     ytApi = new YoutubeAPI('AIzaSyAS-pv77K2uUCChBG5I_prIxJxhyt-sDAg', maxResults: 50, type: "video");
     //logger.i(ytResult);
     ytApiPlaylist =
     new YoutubeAPI('AIzaSyAS-pv77K2uUCChBG5I_prIxJxhyt-sDAg', maxResults: 50, type: "playlist");
     //logger.i(ytApiPlaylist);
     callAPI();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10,),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "Nouvelles vidéos",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Container(
                              height: 5,
                              width: 200,
                              color: Colors.grey,
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey,
                              width: 200,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      ),




                      Container(
                          height: MediaQuery.of(context).size.height/2,
                          child:
                          //isLoading ? Center(child: CircularProgressIndicator()):
                          ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: ytResult.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => YoutubeVideoPlayer(
                                              url: ytResult[i].url,
                                              title: ytResult[i].title,
                                              img: ytResult[i].thumbnail['medium']
                                              ['url'],
                                              date: Jiffy(ytResult[i].publishedAt,
                                                  "yyyy-MM-ddTHH:mm:ssZ")
                                                  .yMMMMEEEEdjm,
                                              related: "",
                                              ytResult: ytResult, videos: [],
                                            )),
                                            (Route<dynamic> route) => true);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10, right: 5),
                                      child: Container(
                                        width: 180,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width,
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
                                                          width: 100,
                                                          imageUrl: ytResult[i].thumbnail['medium']
                                                          ['url'],
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
                                                              //color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Flexible(child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        child:
                                                        Container(
                                                          alignment: Alignment.center,
                                                          //height: 70,
                                                          padding: EdgeInsets.all(10),
                                                          child: Text(
                                                            ytResult[i].title,
                                                            maxLines: 4,
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: colorPrimary),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child:
                                                        Container(
                                                          padding: EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              bottom: 15),
                                                          child: Text(
                                                            //rssList[i].pubDate,
                                                            "Du ${Jiffy(ytResult[i].publishedAt,"yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy à HH:mm")} " ,
                                                            maxLines: 1,
                                                            textAlign: TextAlign.start,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight: FontWeight
                                                                    .normal,
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
                              }
                          )
                      ),



                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10,),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "Playlist",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.bold,
                              color: colorPrimary),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Container(
                              height: 5,
                              width: 200,
                              color: Colors.grey,
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey,
                              width: 200,
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      ),
                      isLoadingPlaylist ? Center(
                        child: Text(
                          "Chargement en cours...",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "CeraPro",
                              fontWeight:
                              FontWeight.bold),
                        ),
                        //child: CircularProgressIndicator(),
                      ) :
                      Container(
                        child:ListView.builder(
                          shrinkWrap: true,
                          /* gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, position) {
                            return
                              Hero(
                                tag: new Text(ytResultPlaylist[position].id),
                                child: GestureDetector(
                                  onTap: () {

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>PlaylistScreen(title: ytResultPlaylist[position].id,) ),
                                            (Route<dynamic> route) => true);
                                    //Get.to(PlaylistScreen(title: ytResultPlaylist[position].id,));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 110,
                                              //alignment: Alignment.center,
                                              child: new Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    //borderRadius: BorderRadius.circular(20),
                                                    child:
                                                    CachedNetworkImage(
                                                      imageUrl: ytResultPlaylist[position].thumbnail["medium"]["url"],
                                                      height: 110,
                                                      width: 150,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) =>
                                                          Image.asset(
                                                            "assets/images/logo.png",
                                                            fit: BoxFit.contain,
                                                            height: 130,
                                                            width: 230,
                                                          ),
                                                      errorWidget: (context, url,
                                                          error) =>
                                                          Image.asset(
                                                            "assets/images/logo.png",
                                                            fit: BoxFit.contain,
                                                            height: 130,
                                                            width: 230,
                                                          ),

                                                    ),
                                                  ),
                                                  Flexible(
                                                    child:
                                                    Container(
                                                      alignment: Alignment.center,
                                                      padding: EdgeInsets.all(10),
                                                      child: Text(
                                                        ytResultPlaylist[position].title,
                                                        maxLines: 2,
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      //Get.to(PlaylistScreen(title: ytResultPlaylist[position].id,));
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Icon(
                                                        Icons.playlist_play,
                                                        size: 40,
                                                        color: colorPrimary,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              );
                          },
                          itemCount: ytResultPlaylist.length,
                        ),
                      )
                    ])
                )]
          )
        ],
      ),
    );
  }
}

