import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/modules/Screens/home_screen/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart'; // আপনার প্রোজেক্টের কালার থিম

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(HomeController());

    final List<Map<String, String>> categories = [
      {'name': 'Burger', 'icon': '🍔'},
      {'name': 'Taco', 'icon': '🌮'},
      {'name': 'Burrito', 'icon': '🌯'},
      {'name': 'Drink', 'icon': '🥤'},
      {'name': 'Pizza', 'icon': '🍕'},
      {'name': 'Donut', 'icon': '🍩'},
      {'name': 'Salad', 'icon': '🥗'},
      {'name': 'Noodles', 'icon': '🍜'},
      {'name': 'Sandwich', 'icon': '🥪'},
      {'name': 'Pasta', 'icon': '🍝'},
      {'name': 'Ice Cream', 'icon': '🍦'},
      {'name': 'More', 'icon': '👀'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ========== Main Content (Scrollable) ==========
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100), // বটম নেভিগেশনের জন্য এক্সট্রা স্পেস
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // ১. Header Section (Location & Cart)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Deliver to",
                                  style: TextStyle(color: Colors.black54, fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward, size: 14, color: Colors.black54),
                                const SizedBox(width: 4),
                                const Text(
                                  "Home",
                                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Text(
                                  "221B Baker Street",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_down, color: AppColors.tomato, size: 24),
                              ],
                            ),
                          ],
                        ),
                        // Cart Button
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: const Icon(Icons.shopping_bag_outlined, color: Colors.black87, size: 24),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ২. Promo Banner Slider
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      itemCount: 3,
                      onPageChanged: (index) => controller.currentBannerIndex.value = index,
                      controller: PageController(viewportFraction: 0.85, initialPage: 2),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F7A54), Color(0xFF1BA375)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "GREEN DAY",
                                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "UP TO\n60% OFF",
                                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Salad Category",
                                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              // ব্যানার ফুড ইমেজ মক (ডান পাশে সেট করার জন্য)
                              Positioned(
                                right: -10,
                                bottom: -10,
                                top: -10,
                                child: Opacity(
                                  opacity: 0.9,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=500&auto=format&fit=crop',
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Banner Indicator Dots
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        bool isActive = controller.currentBannerIndex.value == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          width: isActive ? 18 : 6,
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.tomato : Colors.black12,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ৩. Search & Filter Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.black38, size: 26),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.tune, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ৪. Categories Grid (4 Columns)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                categories[index]['icon']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                categories[index]['name']!,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ৫. Special Offers Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Special Offers",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: TextStyle(color: AppColors.tomato, fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.tomato),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ৬. Special Offers Product List (Horizontal/Vertical Grid)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                      children: [
                        _buildFoodCard('https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500'),
                        _buildFoodCard('https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ========== Custom Floating Bottom Navigation Bar ==========
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(0, Icons.home_filled, "Home", controller),
                      _buildNavItem(1, Icons.assignment_outlined, "Orders", controller),
                      _buildNavItem(2, Icons.favorite_border, "Favorites", controller),
                      _buildNavItem(3, Icons.notifications_none_rounded, "Alerts", controller),
                      // Profile Pic Item
                      GestureDetector(
                        onTap: () => controller.currentNavIndex.value = 4,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.currentNavIndex.value == 4 ? AppColors.tomato : Colors.transparent,
                              width: 2,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // স্পেশাল অফার ফুড কার্ড উইজেট
  Widget _buildFoodCard(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cheese Burger", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(" 4.8", style: TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          // Heart Icon (Top Right)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.favorite, color: Colors.red, size: 16),
            ),
          )
        ],
      ),
    );
  }

  // বটম নেভিগেশন বার আইটেম বিল্ডার
  Widget _buildNavItem(int index, IconData icon, String label, HomeController controller) {
    bool isActive = controller.currentNavIndex.value == index;
    return GestureDetector(
      onTap: () => controller.currentNavIndex.value = index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isActive ? 10 : 0),
            decoration: BoxDecoration(
              color: isActive ? AppColors.tomato : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.black38,
              size: 26,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: AppColors.tomato, fontSize: 11, fontWeight: FontWeight.bold),
            )
          ]
        ],
      ),
    );
  }
}