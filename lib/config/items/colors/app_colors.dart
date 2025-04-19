import 'dart:ui';

class AppColors {
  AppColors._();
  // New Colors based on reference UI
  static const Color primaryColor = Color(0xFFFCC434); // Altın Sarısı
  static const Color grayColor = Color(0xFFCCCCCC); // Gri
  static const Color blackColor =
      Color(0xFF000000); // Siyah (Zaten vardı, teyit edildi)
  static const Color darkBackgroundColor =
      Color(0xFF262626); // Koyu Gri (Arka Plan)

  // Existing Colors (Keep or update as needed)
  static const Color whiteColor = Color(0xFFffffff);
  static const Color subtitleColor = Color(0xFFFBFBFB); // May need update?
  static const Color lightBlackColor = Color(0x90000000); // May need update?
  static const Color dividerColor = Color(0x20000000); // May need update?
  static const Color infoColor = Color(0xFFF09E54); // Keep for now
  static const Color errorColor = Color(0xFFE5383B); // Keep for now
  static const Color successColor = Color(0xFF38B000); // Keep for now
  static const Color notificationColor = Color(0xFF1F1D2B); // Keep for now
  static const Color lightGrayColor = Color(
      0x20ADB5BD); // Likely replace usage with grayColor or darkBackgroundColor
  static const Color darkGrayColor =
      Color(0xFF495057); // Keep for potential other shades
  static const Color titleColor =
      Color(0xFF243465); // Likely replace usage with whiteColor
  static const Color barrierColor = Color(0x50000000); // Keep for now
  static const Color hintColor =
      Color(0xFF667080); // Likely replace usage with grayColor
  static const Color borderColor =
      Color(0xFFE0E0E0); // Likely replace usage with grayColor or remove
}
