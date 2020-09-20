import 'package:align_positioned/align_positioned.dart';
import 'package:GuardianAngel/data/data.dart';
import 'package:GuardianAngel/models/emergency_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EmergencyTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Emergency Guidelines and Tips',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return DefenseStrategyCard(
                    strategy: defenseStrategyList.elementAt(index),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 100,
                  );
                },
                itemCount: defenseStrategyList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DefenseStrategyCard extends StatelessWidget {
  final EmergencyStrategy strategy;
  DefenseStrategyCard({this.strategy});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: MediaQuery.of(context).size.height * (3 / 8),
      decoration: BoxDecoration(
        color: Colors.red,
        image: DecorationImage(
            image: AssetImage(strategy.imageUrl), fit: BoxFit.fill),
        borderRadius: BorderRadius.circular(50),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.of(context).pushNamed('Strategy', arguments: strategy);
        },
        child: Stack(
          children: [
            AlignPositioned(
              moveByContainerHeight: 0.1,
              moveByContainerWidth: 0.1,
              alignment: Alignment.topLeft,
              child: Text(
                strategy.title,
                style: TextStyle(
                    color: strategy.title == 'Heart Attack Symptoms'
                        ? Colors.black
                        : Colors.white,
                    backgroundColor: strategy.title == 'Heart Attack Symptoms'
                        ? Colors.transparent
                        : Colors.blue,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DefenseInfoPage extends StatelessWidget {
  // final DefenseStrategy strategy;
  // DefenseInfoPage({this.strategy});
  @override
  Widget build(BuildContext context) {
    final EmergencyStrategy strategy =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              floating: false,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                strategy.title,
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  strategy.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ];
        },
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              // Text(strategy.title),
              YoutubePlayer(
                controller: YoutubePlayerController(
                    initialVideoId: strategy.videoUrl,
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      captionLanguage: 'en',
                      loop: false,
                      controlsVisibleAtStart: true,
                      enableCaption: true,
                      mute: false,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(strategy.description),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
