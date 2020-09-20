import 'package:GuardianAngel/shared/constants.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:GuardianAngel/bloc/state_bloc.dart';
import 'package:GuardianAngel/bloc/state_provider.dart';
import 'package:GuardianAngel/pages/cmt.dart';
import 'package:GuardianAngel/models/car.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:GuardianAngel/shared/constants.dart';

var currentCar = carList.cars[0];

class CMT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
            margin: EdgeInsets.only(left: 25),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            // margin: EdgeInsets.only(right: 25),
            icon: Icon(Icons.videocam),
          ),
          IconButton(
            onPressed: () {},
            // margin: EdgeInsets.only(right: 25),
            icon: Icon(Icons.audiotrack),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('Image_Picker');
            },
            // margin: EdgeInsets.only(right: 25),
            icon: Icon(Icons.image),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: LayoutStarts(),
    );
  }
}

class LayoutStarts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarDetailsAnimation(),
        CustomBottomSheet(),

        // RentButton(),
      ],
    );
  }
}

class RentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SizedBox(
        width: 200,
        child: FlatButton(
          onPressed: () {},
          child: Text(
            "Rent Car",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.4,
                fontFamily: "arial"),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
          ),
          color: Colors.black,
          padding: EdgeInsets.all(25),
        ),
      ),
    );
  }
}

class CarDetailsAnimation extends StatefulWidget {
  @override
  _CarDetailsAnimationState createState() => _CarDetailsAnimationState();
}

class _CarDetailsAnimationState extends State<CarDetailsAnimation>
    with TickerProviderStateMixin {
  AnimationController fadeController;
  AnimationController scaleController;

  Animation fadeAnimation;
  Animation scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fadeController =
        AnimationController(duration: Duration(milliseconds: 180), vsync: this);

    scaleController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);

    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
    scaleAnimation = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(
      parent: scaleController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  forward() {
    scaleController.forward();
    fadeController.forward();
  }

  reverse() {
    scaleController.reverse();
    fadeController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        initialData: StateProvider().isAnimating,
        stream: stateBloc.animationStatus,
        builder: (context, snapshot) {
          snapshot.data ? forward() : reverse();

          return ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: CarDetails(),
            ),
          );
        });
  }
}

class CarDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30),
              child: _carTitle(),
            ),
            Container(
              width: double.infinity,
              child: CarCarousel(),
            )
          ],
        )),
        AlignPositioned(
            moveByChildWidth: -1,
            moveByContainerHeight: -0.4,
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              child: IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // title: Text('Hello!!'),
                            content: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: <Color>[
                                Color(0xffFAFFD1),
                                Color(0xffA1FFCE),
                              ])),
                              width: MediaQuery.of(context).size.width - 100,
                              height: MediaQuery.of(context).size.width - 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        UserDetailBox(
                                            detail: 'Driver ID', number: '#72'),
                                        UserDetailBox(
                                            detail: 'Device ID',
                                            number: '#204'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        UserDetailBox(
                                            detail: 'Drive ID',
                                            number: '#9127'),
                                        UserDetailBox(
                                            detail: 'TAG Add.', number: '#102'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {});
                  }
                  // showDialog(
                  //     context: context,
                  //     builder: (_) {
                  //       return Container(
                  //         width: 200,
                  //         height: 100,
                  //       );
                  //     });
                  // },
                  ),
            ))
      ],
    );
  }

  _carTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 38),
              children: [
                TextSpan(text: currentCar.companyName),
                TextSpan(text: "\n"),
                TextSpan(
                    text: currentCar.carName,
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ]),
        ),
        SizedBox(height: 10),
        RichText(
          text: TextSpan(style: TextStyle(fontSize: 16), children: [
            TextSpan(
                text: currentCar.price.toString(),
                style: TextStyle(color: Colors.grey[20])),
            // TextSpan(
            //   text: " / day",
            //   style: TextStyle(color: Colors.grey),
            // )
          ]),
        ),
        RichText(
          text: TextSpan(style: TextStyle(fontSize: 16), children: [
            TextSpan(
                text: currentCar.number,
                style: TextStyle(color: Colors.grey[20])),
            // TextSpan(
            //   text: " / day",
            //   style: TextStyle(color: Colors.grey),
            // )
          ]),
        ),
      ],
    );
  }
}

class CarCarousel extends StatefulWidget {
  @override
  _CarCarouselState createState() => _CarCarouselState();
}

class _CarCarouselState extends State<CarCarousel> {
  static final List<String> imgList = currentCar.imgList;

  final List<Widget> child = _map<Widget>(imgList, (index, String assetName) {
    return Container(
        child: Image.asset("assets/$assetName", fit: BoxFit.fitWidth));
  }).toList();

  static List<T> _map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            height: 250,
            viewportFraction: 1.0,
            items: child,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _map<Widget>(imgList, (index, assetName) {
                return Container(
                  width: 50,
                  height: 2,
                  decoration: BoxDecoration(
                      color: _current == index
                          ? Colors.grey[100]
                          : Colors.grey[600]),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class CustomBottomSheet extends StatefulWidget {
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet>
    with SingleTickerProviderStateMixin {
  double sheetTop = 400;
  double minSheetTop = 30;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    final StorageReference ref =
        FirebaseStorage().ref().child('users/userid1').child('image.jpg');
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: sheetTop, end: minSheetTop)
        .animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  forwardAnimation() {
    controller.forward();
    stateBloc.toggleAnimation();
  }

  reverseAnimation() {
    controller.reverse();
    stateBloc.toggleAnimation();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: animation.value,
      left: 0,
      child: GestureDetector(
        onTap: () {
          controller.isCompleted ? reverseAnimation() : forwardAnimation();
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          //upward drag
          if (dragEndDetails.primaryVelocity < 0.0) {
            forwardAnimation();
            controller.forward();
          } else if (dragEndDetails.primaryVelocity > 0.0) {
            //downward drag
            reverseAnimation();
          } else {
            return;
          }
        },
        child: SheetContainer(),
      ),
    );
  }
}

class SheetContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sheetItemHeight = 110;
    double officeHeight = 220;
    return Container(
      padding: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Color(0xfff1f1f1)),
      child: Column(
        children: <Widget>[
          drawerHandle(),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                damageDetails(officeHeight),
                specifications(sheetItemHeight),
                features(sheetItemHeight),
                // features(sheetItemHeight),
                SizedBox(height: 220),
              ],
            ),
          )
        ],
      ),
    );
  }

  drawerHandle() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      height: 3,
      width: 65,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xffd9dbdb)),
    );
  }

  specifications(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Crash Orientation",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return ListItem(
                      sheetItemHeight: sheetItemHeight,
                      detail: 'Airbag Deployed',
                      value: false,
                      icon: Icon(Icons.accessibility),
                    );
                  case 1:
                    return ListItem(
                      sheetItemHeight: sheetItemHeight,
                      detail: 'Vehicale Spin',
                      value: true,
                      icon: Icon(Icons.crop_rotate),
                    );
                  case 2:
                    return ListItem(
                      sheetItemHeight: sheetItemHeight,
                      detail: 'Rollover',
                      value: true,
                      icon: Icon(Icons.cloud_circle),
                    );
                  case 3:
                    return ListItem(
                      sheetItemHeight: sheetItemHeight,
                      detail: 'Continue Driving',
                      value: false,
                      icon: Icon(Icons.accessibility),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  features(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Features",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.separated(
              separatorBuilder: (_, index) {
                return SizedBox(
                  width: 5,
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0)
                  return BlockCrashOverviewSquare(
                    //change this to a square widget
                    height: MediaQuery.of(context).size.width / 2 - 10,
                    width: MediaQuery.of(context).size.width / 2 - 10,
                    detail: 'Crash Information',
                    onPress: () {},
                    // value: false,
                    icon: Icon(Icons.accessibility),
                  );

                return BlockCrashOverviewSquare(
                    //change this to a square widget
                    height: MediaQuery.of(context).size.width / 2 - 10,
                    width: MediaQuery.of(context).size.width / 2 - 10,
                    detail: 'Crash Weather report',
                    onPress: () {},
                    // value: false,
                    icon: Icon(Icons.settings_system_daydream));
              },
            ),
          )
        ],
      ),
    );
  }

  damageDetails(double sheetItemHeight) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Damage Info",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            height: sheetItemHeight,
            child: ListView.separated(
              separatorBuilder: (_, index) {
                return SizedBox(
                  width: 20,
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0)
                  return Column(
                    children: [
                      SleekCircularSlider(
                          appearance: CircularSliderAppearance(size: 110),
                          initialValue: 96),
                      Text(
                        'Severity',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  );

                return Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Front Hit',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Rear Hit',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Left Hit',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Right Hit',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        LinearPercentIndicator(
                          width: 80,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          percent: 0.8,
                          center: Text("80.0%"),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.red,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LinearPercentIndicator(
                          width: 80,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          percent: 0.346,
                          center: Text("34.6%"),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.orange,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LinearPercentIndicator(
                          width: 80,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          percent: 0.16,
                          center: Text("16.0%"),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.yellow,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        LinearPercentIndicator(
                          width: 80,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2500,
                          percent: 0.02,
                          center: Text("2.0%"),
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Colors.green,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                );

                //ListItem(
                //sheetItemHeight: sheetItemHeight,
                //mapVal: currentCar.offerDetails[index],
                //);
              },
            ),
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final double sheetItemHeight;
  final String detail;
  final Icon icon;
  final bool value;

  ListItem({
    this.sheetItemHeight,
    this.detail,
    this.icon,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: sheetItemHeight,
      height: sheetItemHeight,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value == true ? Colors.green : Colors.red,
        // borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          Text(
            detail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}

class UserDetailBox extends StatelessWidget {
  String number;
  String detail;
  UserDetailBox({this.detail, this.number});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(number),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}

class BlockCrashOverviewSquare extends StatelessWidget {
  final width;
  final height;

  final icon;
  final detail;

  final onPress;
  BlockCrashOverviewSquare(
      {this.width, this.height, this.icon, this.detail, this.onPress});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPress,
      child: Container(
        padding: EdgeInsets.all(10),
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon,
            Text(
              detail,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CrashDialogOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              ListItem(
                detail: 'Prior Speeding',
                icon: Icon(Icons.fast_forward),
                value: false,
                sheetItemHeight: 110,
              ),
              ListItem(
                detail: 'Prior Speeding',
                icon: Icon(Icons.fast_forward),
                value: false,
                sheetItemHeight: 110,
              ),
            ],
          ),
          LinearPercentIndicator(
            width: 80,
            animation: true,
            lineHeight: 20.0,
            animationDuration: 2500,
            percent: 0.8,
            center: Text("80.0%"),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
