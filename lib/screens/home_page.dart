import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.black, Colors.deepOrange.shade900]
                : [Colors.orange.shade600, Colors.deepOrange.shade700],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header + Theme Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeInDown(
                      child: Text(
                        'SEBA',
                        style: GoogleFonts.orbitron(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.orange.withOpacity(0.9),
                              blurRadius: 25,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () => AdaptiveTheme.of(context).toggleThemeMode(),
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // FIXED: No Shimmer on multiline Text → replaced with glowing effect
                FadeInUp(
                  duration: const Duration(milliseconds: 1300),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sher-E-Bangla\n',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.orange.shade600,
                          ),
                        ),
                        TextSpan(
                          text: 'Sher-E-Bangla\n',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange.shade700],
                              ).createShader(const Rect.fromLTWH(0, 0, 300, 70)),
                          ),
                        ),
                        TextSpan(
                          text: 'Artificial',
                          style: GoogleFonts.poppins(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.orange.withOpacity(0.8),
                                blurRadius: 30,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                FadeInUp(
                  delay: const Duration(milliseconds: 700),
                  child: Text(
                    'Your Intelligent Bengali AI Companion',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Start Button
                FadeInUp(
                  delay: const Duration(milliseconds: 1100),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ChatPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 22),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      elevation: 20,
                      shadowColor: Colors.orange.withOpacity(0.7),
                    ),
                    child: Text(
                      'Start Talking',
                      style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}