import 'package:bola_negra/widgets/admob_widgets.dart';
import 'package:bola_negra/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AdMobWidgets.instance(androidBannerAdUnitId: "ca-app-pub-6473425324446369/6678421588", androidInterstitialAdUnitId: "ca-app-pub-6473425324446369/4057510566");
  await MobileAds.instance.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ask your question', style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                fontSize: 40
              ),),
              const Spacer(),
              const BolaNegra(),
              const SizedBox(height: 15,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, color: Colors.redAccent,),
                  Text('Tap or drag the center to get an answer', style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
              const Spacer(),
              const BannerInlineWidget()
            ],
          ),
        ),
      ),
    );
  }
}
