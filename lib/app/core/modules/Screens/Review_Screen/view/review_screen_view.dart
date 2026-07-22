import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/Review_Screen/controller/review-screen_controller.dart';
import 'package:food_hjoiopk/app/core/widgets/responsive_wrapper/responsive_rapper.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';

class ProductReviewsScreen extends GetView<ProductReviewsController> {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
  

    return ResponsiveWrapper(
      child: Scaffold(
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
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.tomato,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
      
                          // ২. ওভারঅল রেটিং
                          _buildRatingOverview(),
                          const SizedBox(height: 24),
      
                          // ৩. ফিল্টার চিপস
                          _buildFilterChips(),
                          const SizedBox(height: 24),
      
                          // ৪. রিভিউ লিস্ট
                          Obx(
                            () {
                              if (controller.filteredReviews.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40.0),
                                    child: Text(
                                      "No reviews found",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.filteredReviews.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (context, index) {
                                  return _buildReviewCard(
                                    controller.filteredReviews[index],
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== ১. অ্যাপ বার উইজেট ==========
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: controller.goBack,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black87),
                ),
              ),
              const Expanded(
                child: Text(
                  "Reviews",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 44),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => Text(
              controller.productName.value,
              style: const TextStyle(
                fontSize: 22,
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
                style: const TextStyle(
                  fontSize: 40,
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
                      return const Icon(Icons.star, color: Colors.amber, size: 18);
                    } else if (index < rating.ceil() && rating % 1 != 0) {
                      return const Icon(Icons.star_half, color: Colors.amber, size: 18);
                    } else {
                      return const Icon(Icons.star_border, color: Colors.amber, size: 18);
                    }
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "(${controller.getTotalReviews()})",
                style: const TextStyle(fontSize: 13, color: Colors.black45),
              ),
            ],
          ),
          const SizedBox(width: 24),

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
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            "$starNumber",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.tomato),
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
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () => controller.filterReviews(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.tomato : const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        filter,
                        style: TextStyle(
                          fontSize: 13,
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
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
              child: avatarUrl == null
                  ? Text(
                      name[0],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // ইউজার নেম ও ডেট
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    review["date"],
                    style: const TextStyle(fontSize: 12, color: Colors.black38),
                  ),
                ],
              ),
            ),

            // রেটিং স্টার
            Row(
              children: List.generate(
                review["rating"] ?? 5,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // রিভিউ কমেন্ট
        Text(
          review["comment"] ?? "No comment provided.",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}