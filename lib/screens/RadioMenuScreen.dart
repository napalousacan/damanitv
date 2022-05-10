import 'package:damanitv/animation/fadeanimation.dart';
import 'package:damanitv/constants.dart';
import 'package:damanitv/model/api.dart';
import 'package:damanitv/screens/RadioPlayerScreen.dart';
import 'package:damanitv/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';


class RadioMenuScreen extends StatefulWidget {
  final Api radioItem;

  RadioMenuScreen({this.radioItem});

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioMenuScreen>
    with AutomaticKeepAliveClientMixin<RadioMenuScreen> {
  @override
  bool get wantKeepAlive => true;
  final logger = Logger();
  List<Api> radioList = [];
  String radioName = "", radioFreq = "", radioImg, radioUrl;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    logger.i('napal',widget.radioItem.streamUrl);
    setState(() {
      radioList.add(widget.radioItem);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Scaffold(
            body: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              /*gradient: LinearGradient(
                colors: [colorPrimaryClear, colorPrimary],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),*/
            ),
            child: Stack(
              children: [
                Container(
                  child: isLoading
                      ? makeShimmerItem()
                      : CustomScrollView(slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildListDelegate([
                              SizedBox(
                                height: 20,
                              ),
                              radioList.length > 0
                                  ? Container(
                                      margin: EdgeInsets.only(left: 16),
                                      child: Text(
                                        ">> Radios FM",
                                        style: TextStyle(
                                            color: colorPrimary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: radioList.length > 0 ? 10 : 0,
                              ),
                              radioList.length > 0
                                  ? radioListWidget(radioList)
                                  : Container()
                            ]),
                          ),
                        ]),
                ),
              ],
            ),
          ),
        );
  }

  Widget appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              //width: 110,
              child: Row(
                children: [
                  Icon(
                    Icons.radio,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Radios",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.png')))),
        ],
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorPrimaryClear, colorPrimary],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
            borderRadius: BorderRadius.circular(10.0)),
      ),
      elevation: 1.0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget radioListWidget(List<Api> radioList) {
    return new Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemBuilder: (BuildContext context, int i) {
          return new GestureDetector(
            onTap: () {
              logger.i(radioList[i].streamUrl,'radio');
              setState(() {
                Utils.navigationPage(
                    context,
                    RadioPlayerScreen(
                        radioItem: radioList[i]),
                    true);
              });
            },
            child: FadeAnimation(
                0.5,
                Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorPrimary,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 1.5,
                            spreadRadius: 0.5),
                      ],
                    ),
                    margin: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*CachedNetworkImage(
                          imageUrl: radioList[position].logo,
                        ),*/
                        Icon(
                          Icons.radio_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          radioList[i].title,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ],
                    ))),
          );
        },
        itemCount: radioList.length,
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
  }
}
