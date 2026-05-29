import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mevtech/features/chat/chat-constant/chat_color_scheme.dart';

class MyChatTheme extends StatelessWidget {
  const MyChatTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        primaryColor: ChatColor.accentColor,
        scaffoldBackgroundColor: ChatColor.lightPrimary,
        cardColor: ChatColor.lightSecondary,
        dividerColor: Colors.black12,
        textTheme: GoogleFonts.montserratTextTheme(
          ThemeData.light().textTheme.apply(
                bodyColor: const Color(0xFF263238), // Dark text for readability
                displayColor: const Color(0xFF263238),
              ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ChatColor.lightTertiary,
          elevation: 1, // Subtle shadow for header separation
          iconTheme: IconThemeData(color: Color(0xFF263238)),
          titleTextStyle: TextStyle(
              color: Color(0xFF263238),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        // Custom text field style for a clean look
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(
              0xFFF0F4F7), // Input field background (very light blue-grey)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),
      child: child,
    );
  }
}
