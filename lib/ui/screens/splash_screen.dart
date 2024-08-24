import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controller/auth_controller.dart';
import '../utility/asset_path.dart';
import '../widgets/background_widget.dart';
import 'auth/sign_in_screen.dart';
import 'main_bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadNextScreen();
  }
  
  Future<void> _loadNextScreen()async{
   await Future.delayed(const Duration(seconds: 2));
   bool isUserLoggedIn = await AuthController.checkAuthState();
   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => isUserLoggedIn ? const MainBottomNavScreen() : const SignInScreen(),),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BackgroundWidget(
          child: Center(
            child: SvgPicture.asset(AssetPath.appLogoSVG,
            ),
          ),),
      ),

    );
  }
}
