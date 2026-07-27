import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/routes/app_pages.dart';

class IntroduceStepOneScreen extends StatefulWidget {
  const IntroduceStepOneScreen({super.key});

  @override
  State<IntroduceStepOneScreen> createState() => _IntroduceStepOneScreenState();
}

class _IntroduceStepOneScreenState extends State<IntroduceStepOneScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image":
          "assets/images/Default_Create_an_image_of_a_small_3D_style_rocket_Has_white_b_2 1.png",
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
      "image": "assets/images/Image (1).png",
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
        duration: Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              children: [
                // PageView
                Expanded(
                  flex: 7,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                _pages[index]["image"]!,
                                height: 180.h,
                                fit: BoxFit.contain,
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
                              Text(
                                _pages[index]["desc"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.tomato.withOpacity(.7),
                                  fontSize: 16.sp,
                                ),
                              ),
                              if (index == 3) ...[
                                SizedBox(height: 280.h),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.toNamed(Routes.LOGIN);
                                    },
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
                                    onPressed: () {
                                      Get.toNamed(Routes.LOGIN);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.tomato,
                                      side: BorderSide(
                                        color: AppColors.tomato,
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        width: _currentPage == index ? 28 : 9,
                        height: 9.h,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.tomato
                              : AppColors.tomato.withOpacity(.25),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                      ),
                    ),
                  ),
                ),
      
                // Next
                if (_currentPage != 3)
                  Padding(
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
                              3,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(color: Colors.black38, fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
  }
}
