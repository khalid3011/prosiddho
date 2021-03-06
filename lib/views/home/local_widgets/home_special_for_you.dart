import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prosiddho/constant/constant_export.dart';
import 'package:prosiddho/model/product_model/product_model.dart';
import 'package:prosiddho/style/style_export.dart';
import 'package:prosiddho/views/product_details/product_details_screen.dart';

class HomeSpecialForYou extends StatelessWidget {
  final List<ProductModel> products = ProductFilter.specialForYou();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(
            products.length,
            (index) => _productItem(
              products[index],
              products.length,
              index,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productItem(ProductModel product, int length, int itemNo) {
    String url = Values.defaultImage;

    if (product.imageLink.length > 0) {
      url = product.imageLink[0];

      if (product.imageLink.length > 1) {
        url = product
            .imageLink[Util.random(min: 1, max: product.imageLink.length) - 1];
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(ProductDetailsScreen(product: product));
      },
      child: Container(
        height: Util.getProportionateScreenHeight(90),
        width: Util.getProportionateScreenWidth(242),
        margin: Style.marginHorizontalListview(length, itemNo),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              //background image
              ImageLoading.cachedNetworkImage(url, radius: 20),

              //image overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF343434).withOpacity(0.9),
                      Color(0xFF343434).withOpacity(0.5),
                    ],
                  ),
                ),
              ),

              //details
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Util.getProportionateScreenHeight(15),
                  vertical: Util.getProportionateScreenHeight(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(color: Colors.white),
                        children: [
                          //name
                          TextSpan(
                            text: "${product.name.capitalize}\n",
                            style: TextStyle(
                              fontSize: Util.getProportionateScreenHeight(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //division
                          TextSpan(
                            text: "${product.birthPlace.division}\n",
                          ),
                        ],
                      ),
                    ),
                    if (product.offerPercent != null &&
                        product.offerPercent != 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Discount: ${product.offerPercent}%",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
