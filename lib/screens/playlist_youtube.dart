import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:damanitv/screens/youtubePlayer.dart';
import 'package:damanitv/screens/youtubePlayerPage.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_api/yt_video.dart';
import 'package:youtube_api_v3/youtube_api_v3.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class PlaylistScreen extends StatefulWidget {
  String title;
   PlaylistScreen({this.title});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class Video{
  final String thumbnail;
  Video(this.thumbnail);
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<PlayListItem> videos = [];
   PlayListItemListResponse currentPage;
  bool isLoading=true;
  Map data;
  int nbre=0;
  //AppDetailsController c=Get.put(AppDetailsController());
  //String apiKey= c.AppDetailsList[0].appGoogleApikey;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  final logger= Logger();
  
  

  @override
  void initState() {
    

    WidgetsBinding.instance?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    //getVideos();
    getData();
    super.initState();
  }

  setVideos(videos){
    setState(() {
      this.videos = videos;
      isLoading=false;
    });
  }

  Future<List> getData() async {
    final response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId="+widget.title+"&maxResults=50&q=surfing&key=" +
        "AIzaSyAS-pv77K2uUCChBG5I_prIxJxhyt-sDAg"));
    data = json.decode(response.body);
    //this.videos.addAll(data["items"]);
    //logger.i(data?["items"],"functionnnnnnnnnn");
    data["items"].map((video){
      //logger.i("napal",video.id);
      nbre++;
    }).toList();
    setState(() {
      data["items"];
      isLoading=false;
      nbre;
    });
    //logger.i("nbre de videos",nbre);
    return data["items"];
  }


  /*Future<List<PlayListItem>?> getVideos() async{
    YoutubeAPIv3 api = new YoutubeAPIv3(c.AppDetailsList[0].appGoogleApikey);

    logger.i(c.AppDetailsList[0].appGoogleApikey,'google id');
    logger.i(widget.title,'title');
    logger.i(Parts.snippet,'part');

    PlayListItemListResponse playlist = await api.playListItems(playlistId : widget.title,maxResults:50,part:Parts.snippet);
    logger.i(playlist.items[0],'datattttta');
    var videos = playlist.items.map((video){
      //logger.i("napal",video.id);
      return video;
    }).toList();
    logger.i(videos);
    currentPage = playlist;
    this.videos.addAll(videos);
    for(int i=0;i<videos.length;i++){
      if(videos[i].snippet.title!="Deleted video"){
        this.videos.add(videos[i]);
      }
    }
    setVideos(this.videos);
  }*/


  @override
  Widget build(BuildContext context) {
    //logger.i(this.data?["items"],'naaaapppppppaaaaallllllll');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/logo.png',
          width: 130,
        ),
        backgroundColor: colorPrimary,
      ),
      body: new Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          child: isLoading
                              ? Center(
                            child: makeShimmerVideos(),
                            //child: CircularProgressIndicator(),
                          )
                              : makeItemVideos(),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
    );
  }


  Widget makeItemVideos() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return
            Hero(
              tag: new Text(this.data["items"][position]["snippet"]["title"]),
              child: GestureDetector(
                onTap: () {
                  //print("https://www.youtube.com/watch?v=${this.data?["items"][position]["snippet"]["resourceId"]["videoId"]}");
                  //logger.i(this.data["items"],"envoies all videos");
                  logger.i(this.data["items"][position]["snippet"]
                  ["thumbnails"]["medium"]["url"],"envoie id video");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => YoutubeVideoPlayerPage(
                            url: this.data["items"][position]["snippet"]["resourceId"]["videoId"],
                            title: this.data["items"][position]["snippet"]["title"],
                            img: this.data["items"][position]["snippet"]
                            ["thumbnails"]["medium"]["url"],
                            date: Jiffy(this.data["items"][position]["snippet"]["publishedAt"],
                                "yyyy-MM-ddTHH:mm:ssZ")
                                .yMMMMEEEEdjm,
                            related: "",
                            videos: this.data,
                          )),
                          (Route<dynamic> route) => true);
                  /*Get.to(YoutubeVideoPlayerPage(
                    url: "https://www.youtube.com/watch?v=${this.data["items"][position]["snippet"]["resourceId"]["videoId"]}",
                    title: this.data["items"][position]["snippet"]["title"],
                    img: this.data["items"][position]["snippet"]
                    ["thumbnails"]["maxres"]["url"],
                    date: Jiffy(this.data["items"][position]["snippet"]["publishedAt"],
                        "yyyy-MM-ddTHH:mm:ssZ")
                        .yMMMMEEEEdjm,
                    related: "",
                    videos: this.data,
                  ));*/
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
                                          child: this.data["items"][position]["snippet"]
                    ["thumbnails"]["medium"]!=null?CachedNetworkImage(
                                            height: 90,
                                            width:100,
                                            imageUrl: this.data["items"][position]["snippet"]
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
                                          ):Image.asset(
                                            "assets/images/logo.png",
                                            fit: BoxFit.contain,
                                            height: 100,
                                            width: 100,
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
                                                  this.data["items"][position]["snippet"]["title"],
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
                                                  "Du ${Jiffy(this.data["items"][position]["snippet"]["publishedAt"],
                                                      "yyyy-MM-ddTHH:mm:ssZ").format("dd/MM/yyyy à HH:mm")} " ,
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
              ),
            );
      },
      itemCount: this.nbre,
    );
  }

  Widget makeShimmerVideos() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
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
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      offset: Offset(0, 10.0),
                    ),
                  ],
                ),
              ),
        );
      },
      itemCount: 5,
    );
  }
}


class AllPlayListScreen extends StatefulWidget {
  List<YT_APIPlaylist> ytResult = [];
  final String apikey;
  AllPlayListScreen({ this.ytResult, this.apikey});

  @override
  _AllPlayListState createState() => _AllPlayListState();
}

class _AllPlayListState extends State<AllPlayListScreen> {

  //String apiKey="AIzaSyAS-pv77K2uUCChBG5I_prIxJxhyt-sDAg";
  bool isLoading=true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  List<YT_APIPlaylist> ytResultPlaylist = [];

  Future<void> callAPI() async {
    /*print('UI callled');
    String query = "Dakaractu TV HD";
    await Jiffy.locale("fr");
    ytResult = await ytApi.search(query);*/
    ytResultPlaylist=widget.ytResult;
    setState(() {
      print('UI Updated');
      isLoading = false;
    });
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _refreshIndicatorKey.currentState?.show());
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(right: 50),
                child:Image.asset('assets/images/logo.png')),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: colorPrimary
            /*borderRadius:
                  BorderRadius.circular(10.0)*/
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: new Container(
          child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: callAPI,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          child: isLoading
                              ? Center(
                            child: makeShimmerEmissions(),
                            //child: CircularProgressIndicator(),
                          )
                              : makeItemEmissions(),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  Widget makeItemEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      /*gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),*/
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return
          GestureDetector(
            onTap: () {
              print(ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", ""));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PlaylistScreen(
                        title: ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", ""))),
                      (Route<dynamic> route) => true);
            },
            child: Container(
              margin: EdgeInsets.all(15),
              child:
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    alignment: Alignment.center,
                    child: new Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            imageUrl:  ytResultPlaylist[position].thumbnail['medium']
                            ['url'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/logo.png",
                              //color: colorPrimary,
                            ),
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  "assets/images/logo.png",
                                  //color: colorPrimary,
                                ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          child:
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: blackClear,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                height: 70,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  ytResultPlaylist[position].title,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                        ),
                      ],
                    ),
                  ),),

        );
      },
      itemCount: ytResultPlaylist.length,
    );
  }

  Widget makeShimmerEmissions() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, position) {
        return
          Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white,
              child: Container(
                height: 240.0,
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
              ),
        );
      },
      itemCount: 10,
    );
  }
}
