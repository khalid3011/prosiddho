import 'package:flutter/material.dart';
import 'package:prosiddho/style/style_export.dart';

import 'local_widgets/home_division.dart';
import 'local_widgets/home_header.dart';
import 'local_widgets/home_offer.dart';
import 'local_widgets/home_special_for_you.dart';
import 'local_widgets/home_hot_products.dart';
import 'local_widgets/home_recetly_updated.dart';
import 'local_widgets/home_category.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? -0.5 : 0)
        ..rotateX(isDrawerOpen ? -0.08 : 0)
        ..rotateZ(isDrawerOpen ? -0.08 : 0),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(
          isDrawerOpen ? 40 : 0.0,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //menu
            //search field
            //cart
            //notification
            _appBar(),

            //offer carouous
            HomeOffer(),

            //category or type
            HomeCategory(),

            //division title
            SectionTitle(
              title: "Divisions",
              showMoreText: "Show All",
            ),

            //all division
            HomeDivision(),

            //special for you head
            SectionTitle(
              title: "Special for you",
              showMore: false,
              margin: EdgeInsets.all(Style.margin),
            ),

            //special for you body
            HomeSpecialForYou(),

            //Hot Products
            //last sell + new product
            SectionTitle(
              title: "Hot products",
              subTitle: "Include new product",
              showMore: false,
            ),

            //hot product body
            HomeHotProducts(),

            //Recently update
            SectionTitle(
              title: "Recently updated",
              subTitle: "Fresh products & new offer",
              showMore: false,
            ),

            //recently updated body
            HomeRecentlyUpdated(),

            //Most popular
            //top sell + top rating + top comment + wishlist
            SectionTitle(
              title: "Most popular",
              showMore: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      margin: Style.marginAppbar.copyWith(
        top: 60,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //menu icon and back icon
          isDrawerOpen
              ? GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  onTap: () {
                    setState(() {
                      xOffset = 0;
                      yOffset = 0;
                      scaleFactor = 1;
                      isDrawerOpen = false;
                    });
                  },
                )
              : GestureDetector(
                  child: Icon(Icons.menu),
                  onTap: () {
                    setState(() {
                      xOffset = 250;
                      yOffset = 150;
                      scaleFactor = 0.6;
                      isDrawerOpen = true;
                    });
                  }),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: HomeHeader(),
            ),
          ),
        ],
      ),
    );
  }
}
