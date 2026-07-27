import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/material.dart';
// import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
// import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   static int totalPages = 4;
//   static int currentPage = 3;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF1E1E1E),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(12.r),
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24.r),
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
//               child: Column(
//                 children: [
//                   Spacer(flex: 3),

//                   // ইমেজ
//                   Image.asset(
//                     "assets/images/Image (1).png",
//                     height: 180.h,
//                     fit: BoxFit.contain,
//                   ),

//                   Spacer(flex: 2),

//                   // টাইটেল
//                   Text(
//                     "Special Offers",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.tomato,
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                     ),
//                   ),

//                   SizedBox(height: 12.h),

//                   // সাবটাইটেল
//                   Text(
//                     "Weekly deals and discounts.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.tomato.withOpacity(.7),
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),

//                   // এই Spacer-টি ডটগুলোকে নিচের দিকে পুশ করবে, কিন্তু একেবারে নিচে নামতে দেবে না
//                   Spacer(flex: 2),

//                   // ========== ডটস ==========
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       totalPages,
//                       (index) => Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 4.w),
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 300),
//                           width: index == currentPage ? 28 : 9,
//                           height: 9.h,
//                           decoration: BoxDecoration(
//                             color: index == currentPage
//                                 ? AppColors.tomato.withOpacity(.7)
//                                 : AppColors.tomato.withOpacity(.25),
//                             borderRadius: BorderRadius.circular(10.r),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // ডট এবং বাটনের মাঝে ফিক্সড গ্যাপ (যাতে ডটটি বেশি নিচে না দেখায়)
//                   SizedBox(height: 32.h),

//                   // ========== Start enjoying Button ==========
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56.h,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.tomato,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28.r),
//                         ),
//                       ),
//                       child: Text(
//                         "Start enjoying",
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 12.h),

//                   // ========== Login Button ==========
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56.h,
//                     child: OutlinedButton(
//                       onPressed: () {
//                         Get.toNamed(Routes.LOGIN);

//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: AppColors.tomato,
//                         side: BorderSide(
//                           color: AppColors.tomato.withOpacity(.15),
//                           width: 1.5.w,
//                         ),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28.r),
//                         ),
//                       ),
//                       child: Text(
//                         "Login / Registration",
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
