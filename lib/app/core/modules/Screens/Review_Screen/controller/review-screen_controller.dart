import 'package:get/get.dart';

class ProductReviewsController extends GetxController {
  // Observable Variables
  var selectedFilter = 'All'.obs;
  var isLoading = false.obs;
  
  // Product Info (Arguments থেকে নেওয়া)
  var productName = ''.obs;
  var productId = ''.obs;
  
  // Filters List
  final List<String> filters = ["All", "Positive", "Negative", "5 ★", "4 ★"];
  
  // Reviews List
  var reviews = <Map<String, dynamic>>[].obs;
  var filteredReviews = <Map<String, dynamic>>[].obs;
  
  // Rating Statistics
  var averageRating = 4.9.obs;
  var totalReviews = 1205.obs;
  var ratingDistribution = <int, double>{
    5: 0.85,
    4: 0.12,
    3: 0.02,
    2: 0.01,
    1: 0.0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Arguments থেকে Product Info নেওয়া
    if (Get.arguments != null) {
      if (Get.arguments is Map<String, dynamic>) {
        productName.value = Get.arguments['name'] ?? 'Chicken Burger';
        productId.value = Get.arguments['id'] ?? '1';
      } else {
        productName.value = Get.arguments.toString();
      }
    }
    
    loadReviews();
  }

  // ========== Load Reviews (API Call Mock) ==========
  void loadReviews() {
    isLoading.value = true;
    
    // Mock Data (API থেকে আসবে)
    final List<Map<String, dynamic>> mockReviews = [
      {
        "id": "1",
        "name": "John Doe",
        "date": "29/03/2024",
        "rating": 5,
        "avatar": "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150",
        "comment": "Delicious chicken burger! Loved the crispy chicken and the bun was perfectly toasted. Definitely a new favorite!"
      },
      {
        "id": "2",
        "name": "David Smith",
        "date": "10/04/2024",
        "rating": 5,
        "avatar": null,
        "comment": "Absolutely delicious! The chicken burger was juicy and flavorful, with just the right amount of seasoning. Highly recommend!"
      },
      {
        "id": "3",
        "name": "Tom Wilson",
        "date": "05/04/2024",
        "rating": 4,
        "avatar": "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=150",
        "comment": "One of the best chicken burgers I've ever had! The chicken was tender and the bun was soft. Loved every bite!"
      },
      {
        "id": "4",
        "name": "Adam Brown",
        "date": "01/04/2024",
        "rating": 5,
        "avatar": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150",
        "comment": "Great food and fast delivery! Will order again."
      },
      {
        "id": "5",
        "name": "Sarah Johnson",
        "date": "28/03/2024",
        "rating": 3,
        "avatar": null,
        "comment": "Good burger but delivery took longer than expected."
      },
      {
        "id": "6",
        "name": "Mike Davis",
        "date": "25/03/2024",
        "rating": 4,
        "avatar": "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=150",
        "comment": "Nice packaging and great taste. Will order again!"
      },
    ];
    
    reviews.value = mockReviews;
    filteredReviews.value = mockReviews;
    isLoading.value = false;
  }

  // ========== Filter Reviews ==========
  void filterReviews(String filter) {
    selectedFilter.value = filter;
    
    if (filter == "All") {
      filteredReviews.value = reviews;
    } else if (filter == "Positive") {
      filteredReviews.value = reviews.where((r) => r['rating'] >= 4).toList();
    } else if (filter == "Negative") {
      filteredReviews.value = reviews.where((r) => r['rating'] <= 3).toList();
    } else if (filter == "5 ★") {
      filteredReviews.value = reviews.where((r) => r['rating'] == 5).toList();
    } else if (filter == "4 ★") {
      filteredReviews.value = reviews.where((r) => r['rating'] == 4).toList();
    }
  }

  // ========== Get Rating Percentage ==========
  double getRatingPercentage(int star) {
    return ratingDistribution[star] ?? 0.0;
  }

  // ========== Get Average Rating ==========
  double getAverageRating() {
    if (reviews.isEmpty) return 0.0;
    double total = 0;
    for (var review in reviews) {
      total += review['rating'];
    }
    return total / reviews.length;
  }

  // ========== Get Total Reviews ==========
  int getTotalReviews() {
    return reviews.length;
  }

  // ========== Refresh Reviews ==========
  void refreshReviews() {
    loadReviews();
  }

  // ========== Navigate Back ==========
  void goBack() {
    Get.back();
  }
}