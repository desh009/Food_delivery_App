import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Review_Screen/controller/review-screen_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class ProductReviewsScreen extends GetView<ProductReviewsController> {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // ১. টপ অ্যাপ বার
              _buildAppBar(),
      
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tomato,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12.h),
      
                          // ২. ওভারঅল রেটিং
                          _buildRatingOverview(),
                          SizedBox(height: 24.h),
      
                          // ৩. ফিল্টার চিপস
                          _buildFilterChips(),
                          SizedBox(height: 24.h),
      
                          // ৪. রিভিউ লিস্ট
                          Obx(
                            () {
                              if (controller.filteredReviews.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40.0.h),
                                    child: Text(
                                      "No reviews found",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.filteredReviews.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 20.h),
                                itemBuilder: (context, index) {
                                  return _buildReviewCard(
                                    controller.filteredReviews[index],
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ========== ১. অ্যাপ বার উইজেট ==========
  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 12.0.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: controller.goBack,
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.black87),
                ),
              ),
              Expanded(
                child: Text(
                  "Reviews",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(width: 44.w),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(
            () => Text(
              controller.productName.value,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== ২. রেটিং ওভারভিউ উইজেট ==========
  Widget _buildRatingOverview() {
    return Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // বাম পাশের বড় রেটিং
          Column(
            children: [
              Text(
                controller.getAverageRating().toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) {
                    final rating = controller.getAverageRating();
                    if (index < rating.floor()) {
                      return Icon(Icons.star, color: Colors.amber, size: 18.sp);
                    } else if (index < rating.ceil() && rating % 1 != 0) {
                      return Icon(Icons.star_half, color: Colors.amber, size: 18.sp);
                    } else {
                      return Icon(Icons.star_border, color: Colors.amber, size: 18.sp);
                    }
                  },
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "(${controller.getTotalReviews()})",
                style: TextStyle(fontSize: 13.sp, color: Colors.black45),
              ),
            ],
          ),
          SizedBox(width: 24.w),

          // ডান পাশের প্রোগ্রেস বার
          Expanded(
            child: Column(
              children: [
                _buildProgressBarRow(5, controller.getRatingPercentage(5)),
                _buildProgressBarRow(4, controller.getRatingPercentage(4)),
                _buildProgressBarRow(3, controller.getRatingPercentage(3)),
                _buildProgressBarRow(2, controller.getRatingPercentage(2)),
                _buildProgressBarRow(1, controller.getRatingPercentage(1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // প্রোগ্রেস বারের একক রো
  Widget _buildProgressBarRow(int starNumber, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.h),
      child: Row(
        children: [
          Text(
            "$starNumber",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.tomato),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== ৩. ফিল্টার চিপস উইজেট ==========
  Widget _buildFilterChips() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: EdgeInsets.only(right: 10.0.w),
              child: GestureDetector(
                onTap: () => controller.filterReviews(filter),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.tomato : Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        Icon(Icons.check, size: 14.sp, color: Colors.white),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ========== ৪. ইন্ডিভিজুয়াল রিভিউ কার্ড ==========
  Widget _buildReviewCard(Map<String, dynamic> review) {
    final String? avatarUrl = review["avatar"];
    final String name = review["name"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ইউজার ইনফো ও রেটিং স্টার
        Row(
          children: [
            // প্রোফাইল ইমেজ
            CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null
                  ? Text(
                      name[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),

            // ইউজার নেম ও ডেট
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    review["date"],
                    style: TextStyle(fontSize: 12.sp, color: Colors.black38),
                  ),
                ],
              ),
            ),

            // রেটিং স্টার
            Row(
              children: List.generate(
                review["rating"] ?? 5,
                (index) => Icon(Icons.star, color: Colors.amber, size: 16.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        // রিভিউ কমেন্ট
        Text(
          review["comment"] ?? "No comment provided.",
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.black87,
            height: 1.4.h,
          ),
        ),
      ],
    );
  }
}