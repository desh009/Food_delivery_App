// lib/app/core/modules/Screens/introduce_step_one_screen/view/introduce_step_one_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class IntroduceStepOneScreen extends StatefulWidget {
  const IntroduceStepOneScreen({Key? key}) : super(key: key);

  @override
  State<IntroduceStepOneScreen> createState() =>
      _IntroduceStepOneScreenState();
}

class _IntroduceStepOneScreenState extends State<IntroduceStepOneScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image":
          "assets/images/Default_Create_an_image_of_a_small_3D_style_rocket_Has_white_b_2_1.png",
      "title": "Wide Selection",
      "desc": "More than 400 restaurants nationwide.",
    },
    {
      "image": "assets/images/Image.png",
      "title": "Hot & Fast Delivery",
      "desc": "Deliver to your doorstep as fast as lightning.",
    },
    {
      "image": "assets/images/Image.png",
      "title": "Easy Payment",
      "desc": "Pay with your favorite payment gateways.",
    },
    {
      "image": "assets/images/Image_1.png",
      "title": "Special Offers",
      "desc": "Weekly deals and discounts.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToLogin() {
    Get.toNamed(Routes.LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          // ✅ borderRadius সরিয়ে দিন Full Screen এর জন্য
          // borderRadius: BorderRadius.circular(24.r),  // ❌ Remove this
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            child: Column(
              children: [
                // =========================
                // PAGE VIEW
                // =========================
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(
                        context: context,
                        index: index,
                      );
                    },
                  ),
                ),

                // =========================
                // PAGE INDICATOR
                // =========================
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) {
                        final bool isSelected = _currentPage == index;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: isSelected ? 28.w : 9.w,
                          height: 9.h,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.tomato
                                : AppColors.tomato.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 8.h),

                // =========================
                // BOTTOM BUTTONS
                // =========================
                if (_currentPage != _pages.length - 1)
                  _buildNextSection()
                else
                  _buildFinalSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PAGE CONTENT
  // ============================================================

  Widget _buildPage({
    required BuildContext context,
    required int index,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableHeight = constraints.maxHeight;
        final double imageHeight = (availableHeight * 0.30).clamp(140.h, 220.h);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: availableHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImage(
                  imagePath: _pages[index]["image"]!,
                  height: imageHeight,
                ),

                SizedBox(height: 20.h),

                Text(
                  _pages[index]["title"]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.tomato,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    _pages[index]["desc"]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.tomato.withOpacity(0.7),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // IMAGE WIDGET
  // ============================================================

  Widget _buildImage({
    required String imagePath,
    required double height,
  }) {
    return Image.asset(
      imagePath,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.image_not_supported,
            size: 40.sp,
            color: Colors.grey[400],
          ),
        );
      },
    );
  }

  // ============================================================
  // NEXT / GET STARTED SECTION
  // ============================================================

  Widget _buildNextSection() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tomato,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                _currentPage == 2 ? "Get Started" : "Next",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          TextButton(
            onPressed: () {
              _pageController.animateToPage(
                _pages.length - 1,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            child: Text(
              "Skip",
              style: TextStyle(
                color: Colors.black38,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FINAL PAGE SECTION
  // ============================================================

  Widget _buildFinalSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: goToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tomato,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Text(
              "Start Enjoying",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        SizedBox(height: 10.h),

        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            onPressed: goToLogin,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.tomato,
              side: BorderSide(
                color: AppColors.tomato,
                width: 1.5.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Text(
              "Login / Registration",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}