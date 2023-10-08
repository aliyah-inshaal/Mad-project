import 'package:donation_app/presentation/widgets/user_seller_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../style/images.dart';
import '../utils/routes/routes_name.dart';

class DonarOrSellerScreeen extends StatelessWidget {
  const DonarOrSellerScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: const Color(0xffF5AD0D),
        //        appBar: custom_appbar(),
        body: Padding(
          padding: EdgeInsets.only(left: 100.w, top: 40.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserSellerComponent(
                image: 'assets/planet.png',
                text: "NGO",
                ontap: () {
                  Navigator.pushNamed(context, RoutesName.ngoLogin);
                },
              ),
              SizedBox(
                height: 50.h,
              ),
              UserSellerComponent(
                  image: "assets/donation.png",
                  text: "Donar",
                  ontap: () {
                    Navigator.pushNamed(context, RoutesName.donarLogin);
                  }),
              SizedBox(
                height: 60.h,
              ),
              // Image.asset(
              //   Images.logo,
              //   height: 100.h,
              //   width: 109.w,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
