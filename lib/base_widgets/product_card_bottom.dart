import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';


class ProductCardBottom extends StatelessWidget {

  final GestureTapCallback onTap;

  const ProductCardBottom({
    Key? key,
    // required this.product,
    required this.onTap,
  }) : super(key: key);

  // final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add To Cart',
              style: AppTextStyles.heading2(context,
                overrideStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(context, 14)),

              ),
            ),
            // RatingBar.builder(
            //   initialRating: product.rating,
            //   allowHalfRating: false,
            //   itemCount: product.rating.toInt(),
            //   ignoreGestures: true, // this disables the change star rating
            //   itemSize: 20,
            //   itemBuilder: (context, _) => Icon(
            //     Icons.star,
            //     color: kWhite,
            //   ),
            //   onRatingUpdate: (rating) {},
            // )
          ],
        ),
      ),
    );
  }
}
