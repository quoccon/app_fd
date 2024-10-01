import 'package:app_food/navigation.dart';
import 'package:app_food/page/home/home_page.dart';
import 'package:flutter/material.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Navigation()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Color(0xff6e07d7),
      body: Stack(
        children: [
          Image.asset("assets/images/splash_image 1.png",fit: BoxFit.cover,height: MediaQuery.of(context).size.height,),
          const Center(
            child: Text("Food",style: TextStyle(fontSize: 50,fontWeight: FontWeight.w600,color: Colors.white),),
          )
        ],
      ),
    );
  }
}
