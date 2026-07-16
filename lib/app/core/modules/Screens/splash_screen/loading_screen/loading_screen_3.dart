import 'package:flutter/material.dart';
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
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  // PageView
                  Expanded(
                    flex: 6,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                _pages[index]["image"]!,
                                height: 200,
                                fit: BoxFit.contain,
                              ),

                              const SizedBox(height: 30),

                              Text(
                                _pages[index]["title"]!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.tomato,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              Text(
                                _pages[index]["desc"]!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.tomato.withOpacity(.7),
                                  fontSize: 16,
                                ),
                              ),

                              // শেষ পেজে বাটন
                              if (index == 3) ...[
                                const SizedBox(height: 30),

                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.tomato,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Start Enjoying",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: OutlinedButton(
                                    onPressed: () {

                                      Get.toNamed(Routes.LOGIN);
                                      
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.tomato,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "Login / Registration",
                                      style: TextStyle(
                                        color: AppColors.tomato,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // ========== ডটস (বাটনের উপরে) ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 28 : 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.tomato
                              : AppColors.tomato.withOpacity(.25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ========== বাটন (ডটসের নিচে) ==========
                  if (_currentPage != 3)
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tomato,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              _currentPage == 2 ? "Get Started" : "Next",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              3,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
