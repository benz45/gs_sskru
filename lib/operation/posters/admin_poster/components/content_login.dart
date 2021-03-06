import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gs_sskru/components/buttons/k_button.dart';
import 'package:gs_sskru/components/input_text/k_input_field.dart';
import 'package:gs_sskru/components/k_format_date.dart';
import 'package:gs_sskru/components/k_toast.dart';
import 'package:gs_sskru/controllers/navbar_menu_controller.dart';
import 'package:gs_sskru/util/constants.dart';
import 'package:gs_sskru/controllers/firebase_auth_service_controller.dart';
import 'package:gs_sskru/util/responsive.dart';

class ContentLogin extends StatefulWidget {
  @override
  _ContentLoginState createState() => _ContentLoginState();
}

class _ContentLoginState extends State<ContentLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _firebaseAuthService = Get.find<FirebaseAuthServiceController>();

  void _toHomePoster() {
    Get.find<NavBarMenuController>().setSelectedIndex(0);
  }

  // Loading button
  bool _isLoading = false;

  void _eventLoad() {
    setState(() => _isLoading = !_isLoading);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    return Container(
      height: kDefaultPadding * (isDesktop ? 20 : 15.5),
      width: kDefaultPadding * 24,
      padding: EdgeInsets.all(kDefaultPadding),
      child: GetBuilder(
        init: FirebaseAuthServiceController(),
        builder: (_) {
          return _firebaseAuthService.getIsAuthenticated ? formAuthenticated() : formLogin();
        },
      ),
    );
  }

  Column formAuthenticated() {
    User _user = _firebaseAuthService.user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '???????????????????????????????????????????????????',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        SizedBox(height: 22),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '???????????????',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Text(
                '${_user.email}',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '?????????????????????????????????',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  KFormatDate.getDateUs(date: '${_user.metadata.creationTime}', time: true),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '???????????????????????????????????????????????????',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  KFormatDate.getDateUs(date: '${_user.metadata.lastSignInTime}', time: true),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        KButton(
          isLoading: _isLoading,
          text: '??????????????????????????????',
          onPressed: () {
            _toHomePoster();
            _firebaseAuthService.signOut();
          },
        ),
      ],
    );
  }

  Form formLogin() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          KInputField(
            controller: _emailController,
            hintText: '????????????????????????????????????????????????',
            onSubmitted: (_) => _onLogin(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          ),
          KInputField(
            obscureText: true,
            controller: _passwordController,
            hintText: '????????????????????????',
            onSubmitted: (_) => _onLogin(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          ),
          KButton(
            isLoading: _isLoading,
            text: '?????????????????????????????????',
            onPressed: () => _onLogin(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          ),
        ],
      ),
    );
  }

  void _onLogin({required String email, required String password}) async {
    _eventLoad();
    try {
      User? user = await _firebaseAuthService.signInWithEmailAndPassword(email, password);
      if (user == null) {
        kToast(notFound, Text('$notFound?????????????????????????????????'));
        _eventLoad();
      } else {
        _toHomePoster();
        _eventLoad();
      }
    } on FirebaseAuthException catch (e) {
      print(e.code.characters.string);
      String msg = '????????????????????????????????????????????????????????????????????????????????????????????????????????????';
      switch (e.code.characters.string) {
        case 'invalid-email':
          kToast('???????????????????????????????????????????????????????????????', Text(msg));
          break;
        case 'user-not-found':
          kToast('????????????????????????????????????????????????????????????????????????', Text(msg));
          break;
        case 'wrong-password':
          kToast('??????????????????????????????????????????????????????', Text(msg));
          break;
        default:
      }
      _eventLoad();
    }
  }
}
