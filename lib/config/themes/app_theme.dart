import 'package:flutter/material.dart';

import '../items/colors/app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.whiteColor,
    primaryColor: AppColors.primaryColor,
    textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: AppColors.darkGrayColor,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(AppColors.primaryColor),
      ),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thumbColor: WidgetStatePropertyAll(Color.fromARGB(206, 255, 255, 255)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      surfaceTintColor: AppColors.whiteColor,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.primaryColor,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 25,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
    ),
    cardColor: AppColors.whiteColor,
    menuTheme: MenuThemeData(
        style: MenuStyle(
      backgroundColor: const WidgetStatePropertyAll(AppColors.lightGrayColor),
      surfaceTintColor: const WidgetStatePropertyAll(AppColors.whiteColor),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    )),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(AppColors.lightGrayColor),
        surfaceTintColor: const WidgetStatePropertyAll(AppColors.blackColor),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
    hintColor: AppColors.hintColor,
    textTheme: const TextTheme(
      // ? HintText
      displayMedium: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      displaySmall: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      displayLarge: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w600,
        fontSize: 28,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      headlineMedium: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      headlineSmall: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      headlineLarge: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w700,
        fontSize: 28,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      bodyMedium: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        color: AppColors.darkGrayColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      titleLarge: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      titleMedium: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      labelMedium: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 16,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      labelSmall: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
      labelLarge: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w400,
        fontSize: 18,
        wordSpacing: 1.5,
        fontFamily: 'Poppins',
      ),
    ),
    listTileTheme: const ListTileThemeData(),
    //Dropdown Theme
    // dropdownMenuTheme: DropdownMenuThemeData(
    //   menuStyle: MenuStyle(
    //     backgroundColor:
    //         const MaterialStatePropertyAll(AppColors.lightGrayColor),
    //     surfaceTintColor: const MaterialStatePropertyAll(AppColors.blackColor),
    //     shape: MaterialStatePropertyAll<OutlinedBorder>(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(5),
    //       ),
    //     ),
    //   ),
    // ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.whiteColor,
      cancelButtonStyle: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      surfaceTintColor: AppColors.whiteColor,
      todayBorder: const BorderSide(
        color: AppColors.primaryColor,
        width: 2,
      ),
      confirmButtonStyle: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
      ),
    ),
  );
}
