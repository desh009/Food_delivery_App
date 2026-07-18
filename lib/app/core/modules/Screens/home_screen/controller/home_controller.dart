import 'package:get/get.dart';

class HomeController extends GetxController {
  // বটম নেভিগেশন বারের কারেন্ট ইনডেক্স
  var currentNavIndex = 0.obs;

  // ব্যানার স্লাইডারের কারেন্ট পেজ ইনডেক্স
  var currentBannerIndex = 2.obs; // স্ক্রিনশটে ৩ নম্বর ডটটি একটিভ (0, 1, 2)
}