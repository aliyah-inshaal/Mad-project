import 'package:donation_app/presentation/donar%20screens/donar_homepage.dart';
import 'package:donation_app/presentation/donar%20screens/donar_navigation.dart';
import 'package:donation_app/presentation/donar%20screens/donate_clothes.dart';
import 'package:donation_app/presentation/donar%20screens/donate_food.dart';
import 'package:donation_app/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../data/firebase_user_repository.dart';
import '../../../style/styling.dart';
import '../../../utils/storage_services.dart';
import '../../domain/models/seller_model.dart';
import '../../domain/models/user_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/donars_list_provider.dart';
import '../../providers/seller_provider.dart';
import '../../style/custom_text_style.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/circle_progress.dart';
import '../widgets/input_field.dart';
import 'admin_navigation.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final FirebaseUserRepository _firebaseRepository = FirebaseUserRepository();
  final _formKey = GlobalKey<FormState>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool? obsecureText = true;
  bool isLoadingNow = false;
  bool _obsecureText = true;
  Widget k = SizedBox(
    height: 16.h,
  );

  void isLoading(bool value) {
    setState(() {
      isLoadingNow = value;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  void _login() {
    isLoading(true);
    _firebaseRepository
        .login("admin@gmail.com", "111111", context)
        // .login(_emailController.text, _passwordController.text, context)
        .then((User? user) async {
      if (user != null) {
        //  final   currentLocation = await Geolocator.getCurrentPosition();
        _getAdminDetails();
      } else {
        isLoading(false);
        utils.flushBarErrorMessage("Failed to login", context);
      }
    });
  }

  void _getAdminDetails() {
    _firebaseRepository.getAdminDetails().then((UserModel? adminModel) {
      if (adminModel != null) {
        StorageService.saveAdmin(adminModel).then((value) async {
          // await Provider.of<SellerProvider>(context, listen: false)
          //     .getSellerFromServer();
          await Provider.of<AdminProvider>(context, listen: false)
              .getAdminFromServer(context);

          // await _firebaseRepository.loadSellerDataOnAppInit(context);

          isLoading(false);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AdminNavigation()));
        }).catchError((error) {
          isLoading(false);
          utils.flushBarErrorMessage(error.message.toString(), context);
        });
      } else {
        isLoading(false);
        utils.flushBarErrorMessage("User is null", context);
      }
    }).catchError((error) {
      isLoading(false);
      utils.flushBarErrorMessage(error.message.toString(), context);
    });
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    utils.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    height: 230.h,
                    text: "Welcome To Admin Panel",
                    style: CustomTextStyle.font_20_white,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InputField(
                    hint_text: "Email",
                    currentNode: emailFocusNode,
                    focusNode: emailFocusNode,
                    nextNode: passwordFocusNode,
                    controller: _emailController,
                    obsecureText: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter email address";
                      } else if (!EmailValidator.validate(value)) {
                        return "Invalid email address";
                      }
                    },
                  ),
                  // k,
                  InputField(
                    hint_text: "Password",
                    currentNode: passwordFocusNode,
                    focusNode: passwordFocusNode,
                    nextNode: passwordFocusNode,
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    icon: obsecureText!
                        ? Icons.visibility_off
                        : Icons.remove_red_eye,
                    obsecureText: obsecureText,
                    onIconPress: () {
                      setState(() {
                        obsecureText = !obsecureText!;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter password";
                      } else if (value.length < 6) {
                        return "password must be of 6 characters";
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 230.w),
                    child: TextButton(
                        onPressed: () {}, child: const Text("Forget Password")),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Center(
                    child: isLoadingNow
                        ? const CircleProgress()
                        : AuthButton(
                            text: "Login",
                            func: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              // _submitForm();
                              _login();
                            },
                            color: Styling.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 48.w),
                    child: TextButton(
                      onPressed: () {},
                      child: Text.rich(TextSpan(
                          text: 'Dont have a account? ',
                          style: CustomTextStyle.font_15,
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Create Now',
                              style: CustomTextStyle.font_15_primaryColor,
                            )
                          ])),
                    ),
                  ),
                  // Pa
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onIconPress() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }
}
