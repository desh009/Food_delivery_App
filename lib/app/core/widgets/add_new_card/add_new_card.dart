import 'package:flutter/material.dart';
import 'package:food_hjoiopk/app/core/remote/theme/app_colors.dart';
import 'package:get/get.dart';

class AddNewCardBottomSheet extends StatefulWidget {
  const AddNewCardBottomSheet({super.key});

  // Bottom Sheet ওপেন করার সুবিধার জন্য স্ট্যাটিক মেথড
  static void show(BuildContext context) {
    Get.bottomSheet(
      const AddNewCardBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<AddNewCardBottomSheet> createState() => _AddNewCardBottomSheetState();
}

class _AddNewCardBottomSheetState extends State<AddNewCardBottomSheet> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // ✅ ফর্ম ভ্যালিডেশন স্টেট
  bool _isCardNumberValid = false;
  bool _isCardHolderValid = false;
  bool _isExpiryValid = false;
  bool _isCvvValid = false;

  String cardNumber = "**** **** **** ****";
  String cardHolder = "—";
  String expiryDate = "--/--";

  // ✅ সব ফিল্ড ভ্যালিড কিনা চেক করুন
  bool get _isFormValid {
    return _isCardNumberValid &&
        _isCardHolderValid &&
        _isExpiryValid &&
        _isCvvValid;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // ✅ কার্ড নম্বর ভ্যালিডেশন (১৬ ডিজিট)
  bool _validateCardNumber(String value) {
    final cleaned = value.replaceAll(' ', '');
    return cleaned.length == 16 && int.tryParse(cleaned) != null;
  }

  // ✅ এক্সপায়ারি ডেট ভ্যালিডেশন (MM/YY)
  bool _validateExpiry(String value) {
    if (value.length != 5) return false;
    if (!value.contains('/')) return false;

    final parts = value.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    if (year < 0 || year > 99) return false;

    return true;
  }

  // ✅ CVV ভ্যালিডেশন (৩ ডিজিট)
  bool _validateCvv(String value) {
    return value.length == 3 && int.tryParse(value) != null;
  }

  // ✅ কার্ড নম্বর ফরম্যাটিং (স্পেস সহ)
  String _formatCardNumber(String value) {
    final cleaned = value.replaceAll(' ', '');
    if (cleaned.length <= 4) return cleaned;
    if (cleaned.length <= 8)
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4)}';
    if (cleaned.length <= 12)
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8)}';
    return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8, 12)} ${cleaned.substring(12, 16)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            const Text(
              "Add New Card",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // ========== 💳 Live Credit Card Preview ==========
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.tomato,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tomato.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Chip
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 40,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card Number Display
                  Text(
                    cardNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bottom Card Details Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Cardholder Name",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cardHolder,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Expiry Date",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            expiryDate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ========== 📝 Form Input Fields ==========

            // Card Number Field
            _buildInputField(
              label: "Card Number",
              hintText: "**** **** **** ****",
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 19, // 16 ডিজিট + 3 স্পেস
              onChanged: (val) {
                final cleaned = val.replaceAll(' ', '');
                setState(() {
                  _isCardNumberValid = _validateCardNumber(cleaned);
                  // ফরম্যাটেড নম্বর দেখান
                  if (cleaned.length <= 16) {
                    cardNumber = _formatCardNumber(cleaned);
                    if (cardNumber.isEmpty) {
                      cardNumber = "**** **** **** ****";
                    }
                  }
                });
              },
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Card number is required';
                }
                final cleaned = val.replaceAll(' ', '');
                if (cleaned.length != 16) {
                  return 'Enter 16 digit card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Cardholder Name Field
            _buildInputField(
              label: "Cardholder Name",
              hintText: "Enter Cardholder Name",
              controller: _cardHolderController,
              onChanged: (val) {
                setState(() {
                  _isCardHolderValid = val.trim().length >= 3;
                  cardHolder = val.isEmpty ? "—" : val;
                });
              },
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Cardholder name is required';
                }
                if (val.trim().length < 3) {
                  return 'Enter valid name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Expiry Date & CVV Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: "Expiry Date / Valid Thru",
                    hintText: "MM/YY",
                    controller: _expiryDateController,
                    keyboardType: TextInputType.datetime,
                    maxLength: 5,
                    suffixIcon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.black54,
                      size: 20,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _isExpiryValid = _validateExpiry(val);
                        expiryDate = val.isEmpty ? "--/--" : val;
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Expiry date required';
                      }
                      if (!_validateExpiry(val)) {
                        return 'Invalid format (MM/YY)';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    label: "CVV / CVC",
                    hintText: "Enter CVV",
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 3,
                    onChanged: (val) {
                      setState(() {
                        _isCvvValid = _validateCvv(val);
                      });
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'CVV required';
                      }
                      if (val.length != 3) {
                        return 'Enter 3 digits';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ========== 🔘 Save Button (Dynamic Color) ==========
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                        // ✅ কার্ড সংরক্ষণ করুন
                        if (_cardNumberController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter card details',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // এখানে আপনার কার্ড সংরক্ষণের লজিক
                        Get.back();
                        Get.snackbar(
                          'Success',
                          'Card added successfully!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      }
                    : null, // ✅ ফর্ম ভ্যালিড না হলে onPressed null হবে
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid
                      ? AppColors
                            .tomato // ✅ ফর্ম ভ্যালিড হলে Tomato
                      : Colors.grey[400], // ❌ ফর্ম ভ্যালিড না হলে Grey
                  elevation: _isFormValid ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: _isFormValid ? Colors.white : Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Custom Input Field Helper (Updated with Validation)
  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
            filled: true,
            fillColor: const Color(0xFFF7F7F8),
            suffixIcon: suffixIcon,
            counterText: '', // ম্যাক্স লেন্থ কাউন্টার লুকান
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.tomato, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}
