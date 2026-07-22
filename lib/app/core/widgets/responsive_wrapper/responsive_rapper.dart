import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    const double designWidth = 375;
    const double designHeight = 812;

    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;

    // 📌 শুধুমাত্র প্রস্থ অনুযায়ী স্কেল করি (উচ্চতা উপেক্ষা করি)
    // যাতে বড় ফোনে ফাঁকা জায়গা না থাকে
    final scale = deviceWidth / designWidth;

    // 📌 কিন্তু খুব ছোট ফোনে (৩২০px) যেন খুব ছোট না হয়, সেজন্য Minimum Scale বসাই
    final finalScale = scale < 0.85 ? 0.85 : scale;

    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: finalScale,
          child: Container(
            width: designWidth,
            height: deviceHeight / finalScale, // 📌 উচ্চতা ডায়নামিক করি
            child: child,
          ),
        ),
      ),
    );
  }
}
