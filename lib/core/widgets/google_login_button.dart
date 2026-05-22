import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleLoginButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Container(
      width: 280,
      height: 58,

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(18),

        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF2C2C2C),
                  const Color(0xFF1E1E1E),
                ]
              : [
                  Colors.white,
                  const Color(0xFFF5F5F5),
                ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],

        border: Border.all(
          color: isDark
              ? Colors.grey.shade800
              : Colors.grey.shade300,
        ),
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius:
              BorderRadius.circular(18),

          onTap: onPressed,

          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Container(
                  height: 34,
                  width: 34,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  child: const Center(
                    child: Text(
                      'G',

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,

                        color: Colors.red,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Text(
                  'Continue with Google',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,

                    color: isDark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}