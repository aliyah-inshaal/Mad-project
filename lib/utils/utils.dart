import 'dart:io';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:ui' as ui;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:url_launcher/url_launcher.dart';
import '../domain/models/donation_model.dart';
import '../domain/models/request_model.dart';
import '../domain/models/seller_model.dart';
import '../presentation/donar screens/no_internet_connection.dart';
import '../presentation/widgets/circle_progress.dart';
import 'dialogues/request_sent_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';

class utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static Future<dynamic> openRequestSentDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RequestSentDialogue();
      },
    );
  }

  static int countQuantity(List<DonationModel> donation, String type) {
    int totalFoodQuantity = 0;

    for (var donationModel in donation) {
      // Check if the 'type' is 'food'
      if (donationModel.type == type) {
        // Parse the 'quantity' string to double and add to the totalFoodQuantity
        // totalFoodQuantity += int.parse(donationModel.quantity ?? '0')  ;

        totalFoodQuantity +=
            int.parse(donationModel.quantity?.toString() ?? '0');
      }
    }

    return totalFoodQuantity;
  }
  
  static int countQuantityForNGO(List<RequestModel> donation, String type) {
    int totalFoodQuantity = 0;

    for (var donationModel in donation) {
      // Check if the 'type' is 'food'
      if (donationModel.donationType == type) {
        // Parse the 'quantity' string to double and add to the totalFoodQuantity
        // totalFoodQuantity += int.parse(donationModel.quantity ?? '0')  ;

        totalFoodQuantity +=
            int.parse(donationModel.quantity?.toString() ?? '0');
      }
    }

    return totalFoodQuantity;
  }

  static launchphone(String number, context) async {
    Uri phoneUri = Uri.parse("tel:$number");
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open"),
        ),
      );
    }
  }

  static String trimAddressToHalf(String address) {
    int halfLength = (address.length / 3).floor();
    return address.substring(0, halfLength);
  }

  static List<SellerModel> filterDonars(List<SellerModel> model, String type) {
    return model.where((seller) => seller.type == type).toList();
  }

  static String getCurrentDate() {
    var now = DateTime.now();
    var formatterDate = DateFormat('dd/MM/yy');
    String actualDate = formatterDate.format(now);
    return actualDate;
  }

  static String getCurrentTime() {
    var now = DateTime.now();
    var formatterTime = DateFormat('hh:mm a');
    String actualTime = formatterTime.format(now);
    return actualTime;
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 5),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        // backgroundColor: const Color.fromARGB(255, 90, 89, 89),
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

 static Future<Position> convertLatLngToPosition(LatLng latLng) async {
    return Position(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      isMocked: false,
      floor: null,
    );
  }
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void checkConnectivity(context) {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (connected == false) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Center(
              child: NoInternetCnnection(),
            ),
          ),
        );
        // return connected;
      }
    });
    // return true;
  }

  static String getMonthString(DateTime dateTime) {
    // Function to convert a DateTime to a month string (e.g., "July")
    const monthNames = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return monthNames[dateTime.month];
  }

  static Future<XFile> compressImage(XFile image) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 90, // keep this high to get the original quality of image
    );
    return result!;
  }

  static Future<Uint8List?> pickImage() async {
    //    ImagePicker picker=ImagePicker();
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    //print("before redusing size $file");
    if (file != null) {
      XFile compressedImage = await compressImage(file);
      return compressedImage.readAsBytes();
    }
    return null;
  }

  static String get currentUserUid => FirebaseAuth.instance.currentUser!.uid;

  static hideLoading() {
    Navigator.pop(dialogContext);
  }

  static late BuildContext dialogContext;
  static showLoading(context) {
    // showDialog(context: context, builder: builder)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: CircleProgress(),
        );
      },
    );
  }

  static String getFriendlyErrorMessage(dynamic error) {
    // Check for specific error conditions and return appropriate messages
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'wrong-password':
          return 'Invalid password. Please check your password and try again.';
        case 'user-not-found':
          return 'User not found. Please check your email and try again.';
        default:
          return 'An error occurred. Please try again later.';
      }
    }

    // Handle other types of errors or fallback to a generic message
    return 'An error occurred. Please try again later.';
  }

  static FirebaseFirestore getFireStoreInstance() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db;
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
  Future<void> clearImageCache(String imageUrl) async {
    await CachedNetworkImage.evictFromCache(imageUrl);
  }

  static Future<SharedPreferences> getPreferencesObject() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static Future<void> logOutNGO(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setInt('isNGO', 0);
    } catch (e) {
      utils.flushBarErrorMessage(e.toString(), context);
    }
  }

  static String getRandomid() {
    return (100000 + Random().nextInt(10000)).toString();
  }

  static String getAddressFromPlacemark(Placemark placemark) {
    String address = '';

    // Extract relevant address components
    String name = placemark.name ?? '';
    String subLocality = placemark.subLocality ?? '';
    String locality = placemark.locality ?? '';
    String administrativeArea = placemark.administrativeArea ?? '';
    String postalCode = placemark.postalCode ?? '';
    String country = placemark.country ?? '';

    // Build the address string
    if (name.isNotEmpty) {
      address += '$name, ';
    }

    if (subLocality.isNotEmpty) {
      address += '$subLocality, ';
    }

    if (locality.isNotEmpty) {
      address += '$locality, ';
    }

    if (administrativeArea.isNotEmpty) {
      address += '$administrativeArea, ';
    }

    if (postalCode.isNotEmpty) {
      address += '$postalCode, ';
    }

    if (country.isNotEmpty) {
      address += country;
    }

    return address;
  }

  Future<Uint8List> getByteFromAssets(String path, int widht) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: widht);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // static Future<dynamic> openRequestSentDialogue(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const RequestSentDialogue();
  //     },
  //   );
  // }

  // static launchphone(String number, context) async {
  //   Uri phoneUri = Uri.parse("tel:$number");
  //   if (await canLaunch(phoneUri.toString())) {
  //     await launch(phoneUri.toString());
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Unable to open"),
  //       ),
  //     );
  //   }
  // }

  static Future<String> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = utils.getAddressFromPlacemark(placemark);
        return address;
      } else {
        // utils.flushBarErrorMessage(
        //     "No address found for the given coordinates.", context);
      }
    } catch (e) {
      // utils.flushBarErrorMessage(e.toString(), context);
    }
    return '';
  }

  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  //get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  static  List<DonationModel> filterFoodDonations(List<DonationModel> donationList, String type) {
    return donationList.where((donation) => donation.type ==type).toList();
  }
  
  static  List<RequestModel> filterRequestionDonations(List<RequestModel> donationList, String type) {
    return donationList.where((donation) => donation.donationType ==type).toList();
  }
}
