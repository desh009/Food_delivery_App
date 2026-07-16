// import 'package:flutter/material.dart';
// import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
// import 'package:food_hjoiopk/app/core/routes/app_pages.dart';
// import 'package:get/get.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   static const int totalPages = 4;
//   static const int currentPage = 3;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E1E),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//               child: Column(
//                 children: [
//                   const Spacer(flex: 3),

//                   // ইমেজ
//                   Image.asset(
//                     "assets/images/Image (1).png",
//                     height: 180,
//                     fit: BoxFit.contain,
//                   ),

//                   const Spacer(flex: 2),

//                   // টাইটেল
//                   const Text(
//                     "Special Offers",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.tomato,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // সাবটাইটেল
//                   Text(
//                     "Weekly deals and discounts.",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: AppColors.tomato.withOpacity(.7),
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),

//                   // এই Spacer-টি ডটগুলোকে নিচের দিকে পুশ করবে, কিন্তু একেবারে নিচে নামতে দেবে না
//                   const Spacer(flex: 2),

//                   // ========== ডটস ==========
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       totalPages,
//                       (index) => Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 4),
//                         child: AnimatedContainer(
//                           duration: const Duration(milliseconds: 300),
//                           width: index == currentPage ? 28 : 9,
//                           height: 9,
//                           decoration: BoxDecoration(
//                             color: index == currentPage
//                                 ? AppColors.tomato.withOpacity(.7)
//                                 : AppColors.tomato.withOpacity(.25),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // ডট এবং বাটনের মাঝে ফিক্সড গ্যাপ (যাতে ডটটি বেশি নিচে না দেখায়)
//                   const SizedBox(height: 32),

//                   // ========== Start enjoying Button ==========
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.tomato,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28),
//                         ),
//                       ),
//                       child: const Text(
//                         "Start enjoying",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // ========== Login Button ==========
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: OutlinedButton(
//                       onPressed: () {
//                         Get.toNamed(Routes.LOGIN);

//                       },
//                       style: OutlinedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: AppColors.tomato,
//                         side: BorderSide(
//                           color: AppColors.tomato.withOpacity(.15),
//                           width: 1.5,
//                         ),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(28),
//                         ),
//                       ),
//                       child: const Text(
//                         "Login / Registration",
//                         style: TextStyle(
//                           fontSize: 18,
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
