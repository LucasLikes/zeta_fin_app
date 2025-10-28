import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const MobileBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 240,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF7FE5A8),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.grid_view_rounded, "Menu", 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool selected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? Colors.black87 : Colors.black54),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.black87 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
