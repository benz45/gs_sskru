import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/state_manager.dart';
import 'package:get/get.dart';
import 'package:gs_sskru/controllers/navbar_menu_controller.dart';

class FirebaseAuthServiceController extends GetxController {
  final _navBarMenuController = Get.find<NavBarMenuController>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late User? _user;
  RxBool _isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkCurrentUser();
  }

  User get user => _user!;
  bool get getIsAuthenticated => _isAuthenticated.value;

  Future checkCurrentUser() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      _isAuthenticated.value = true;
      _navBarMenuController.setMenuItemsOfAuthStatus(true);
    }
    update();
  }

  Future<User?> signInWithEmailAndPassword(String userEmail, String userPassword) async {
    return _user = await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword).then((userCredential) => userCredential.user);
  }

  Stream<User?> authStateChanges() {
    Stream<User?> _authStateChanges = _firebaseAuth.authStateChanges();

    _authStateChanges.listen((event) {
      if (event != null) {
        _user = event;
        _isAuthenticated.value = true;
        update();
        _navBarMenuController.setMenuItemsOfAuthStatus(true);
        print('Authentication status: Already logged in !');
      } else {
        _user = null;
        _isAuthenticated.value = false;
        _navBarMenuController.setMenuItemsOfAuthStatus(false);
        update();
        print('Authentication status: Logged out !');
      }
    });
    return _authStateChanges;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}
