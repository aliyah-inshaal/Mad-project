
import 'package:donation_app/domain/models/donation_ngo_model.dart';
import 'package:donation_app/presentation/widgets/profile_pic.dart';
import 'package:donation_app/style/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../style/custom_text_style.dart';
import 'call_widget.dart';

class UserMarkerInfoWindow extends StatefulWidget {
  final DonationNgoModel request;

  const UserMarkerInfoWindow({super.key, required this.request});

  @override
  State<UserMarkerInfoWindow> createState() => _UserMarkerInfoWindowState();
}

class _UserMarkerInfoWindowState extends State<UserMarkerInfoWindow> {
  @override
  Widget build(BuildContext context) {
    int midIndex =
        widget.request.donarAddress!.length ~/ 2; // Calculate the middle index

    String? firstLine = widget.request.donarAddress!.substring(0, midIndex);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:
            const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
        // padding: EdgeInsets.all(20),
        height: 150.h,
        width: 300.w,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Colors.redAccent),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, top: 4.h),
                      child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 40.h,
                          width: 40.w,
                          child: ProfilePic(
                            height: 35.h,
                            width: 35.w,
                            url: widget.request.donarProfileImage,
                          )),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.requestModel!.senderName!,
                          widget.request.donarName ?? "No Sender Name",
                          style: CustomTextStyle.font_20,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Styling.primaryColor,
                              size: 12.h,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              // widget.request.workshopName!,
                              firstLine ?? "",
                              style: CustomTextStyle.font_14_black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // CallWidget(num: widget.request.phone!, context: context),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 40.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Donation type",
                          style: CustomTextStyle.font_14_black,
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Styling.primaryColor,
                              radius: 5,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              widget.request.donationType ?? "Service Null",
                              style: CustomTextStyle.font_14_black,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "${widget.request.sentDate}   ${widget.request.sentTime}" ??
                              "Service Null",
                          style: CustomTextStyle.font_10_black,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CallWidget(
                        num: widget.request.donarAddress ?? "12345678123",
                        context: context,
                        radius: 20.r,
                        iconSize: 16.h,
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
