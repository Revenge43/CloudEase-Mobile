import 'package:cloudease/theme/colors.dart';
import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Image? image; // Optional image
  final VoidCallback onTap;

  const ModuleCard({
    required this.title,
    required this.icon,
    this.image, // Optional image parameter
    required this.onTap,
    super.key,
  });

 @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.transparent,
            ],
          ),
        ),
        child: Material(
          color: const Color.fromARGB(255, 171, 200, 223),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (image != null) ...[
                    SizedBox(
                      width: double.infinity, // Make the image take full width
                      height: 85, // Set a fixed height for the image
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: image!, // Use the image widget directly
                      ),
                    ),
                    const SizedBox(height: 8), // Reduced spacing
                  ],
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14, // Slightly smaller text
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
