import 'package:donation_app/presentation/admin/donation_request_screen.dart';
import 'package:donation_app/presentation/chatting_screen.dart';
import 'package:donation_app/presentation/donar%20screens/donar_homepage.dart';
import 'package:donation_app/presentation/donar%20screens/donar_setting.dart';
import 'package:donation_app/presentation/donar%20screens/donar_donation_screen.dart';
import 'package:donation_app/style/images.dart';
import 'package:donation_app/utils/dialogues/select_donation_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../style/styling.dart';

class DonarNavigation extends StatefulWidget {
  const DonarNavigation({Key? key}) : super(key: key);
  @override
  State<DonarNavigation> createState() => _DonarNavigationState();
}

class _DonarNavigationState extends State<DonarNavigation> {
  List pages = [
    const DonarHomePage(),
    const DonarDonationsScreen(),
    // const ChattingScreen(),
    const DonationRequestScreen(),
    const DonarSetting(),
  ];
  int currentindex = 0;
  void onTap(int index) {
    setState(() {
      currentindex = index;
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const DonarHomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Styling.primaryColor,
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styling.primaryColor,
        onPressed: () {
          selectDonationTypePopup(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Styling.primaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const DonarHomePage();
                        currentindex = 0;
                      });
                    },
                    child: Image.asset(
                      Images.home,
                      height: 26.h,
                      width: 26.w,
                      color: currentindex == 0 ? Colors.white : Colors.grey,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {
                      setState(() {
                        currentScreen = const DonarDonationsScreen();
                        currentindex = 1;
                      });
                    },
                    child: Icon(
                      size: 26.h,
                      Icons.directions,
                      color: currentindex == 1 ? Colors.white : Colors.grey,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {
                      setState(() {
                        currentScreen = const DonationRequestScreen();
                        currentindex = 2;
                      });
                    },
                    child: Icon(
                      size: 26.h,
                      Icons.chat,
                      color: currentindex == 2 ? Colors.white : Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 40.w,
                          onPressed: () {
                            setState(() {
                              currentScreen = const DonarSetting();
                              currentindex = 3;
                            });
                          },
                          child: Icon(
                            size: 26.h,
                            Icons.settings_outlined,
                            color:
                                currentindex == 3 ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
