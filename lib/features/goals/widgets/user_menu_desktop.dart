import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserMenuDesktop extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImageUrl;
  final VoidCallback? onLogout;

  const UserMenuDesktop({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userImageUrl,
    this.onLogout,
  }) : super(key: key);

  @override
  State<UserMenuDesktop> createState() => _UserMenuDesktopState();
}

class _UserMenuDesktopState extends State<UserMenuDesktop> {
  bool isDarkMode = false;
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      elevation: 8,
      offset: const Offset(0, 60),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 280,
      ),
      onOpened: () => setState(() => isMenuOpen = true),
      onCanceled: () => setState(() => isMenuOpen = false),
      onSelected: (value) {
        setState(() => isMenuOpen = false);
        switch (value) {
          case 1:
            debugPrint("My Account");
            break;
          case 2:
            debugPrint("Settings");
            break;
          case 3:
            debugPrint("Billing Details");
            break;
          case 6:
            widget.onLogout?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        // ==== HEADER ====
        PopupMenuItem<int>(
          value: 0,
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Account Options",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF7FE5A8), width: 2), // Borda verde
                        image: DecorationImage(
                          image: NetworkImage(widget.userImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.userEmail,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF7FE5A8),
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const PopupMenuDivider(height: 1),

        // ==== MY ACCOUNT ====
        PopupMenuItem<int>(
          value: 1,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _buildMenuItemContent(Icons.person_outline_rounded, "My Account"),
        ),

        // ==== SETTINGS ====
        PopupMenuItem<int>(
          value: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _buildMenuItemContent(Icons.settings_outlined, "Settings"),
        ),

        // ==== BILLING DETAILS ====
        PopupMenuItem<int>(
          value: 3,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _buildMenuItemContent(Icons.attach_money_rounded, "Billing Details"),
        ),

        const PopupMenuDivider(height: 1),

        // ==== THEME MODE ====
        PopupMenuItem<int>(
          value: -1,
          enabled: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: _buildThemeButton(
                  icon: Icons.wb_sunny_rounded,
                  label: "Light Mode",
                  isSelected: !isDarkMode,
                  onTap: () => setState(() => isDarkMode = false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeButton(
                  icon: Icons.nightlight_round,
                  label: "Dark Mode",
                  isSelected: isDarkMode,
                  onTap: () => setState(() => isDarkMode = true),
                ),
              ),
            ],
          ),
        ),

        const PopupMenuDivider(height: 1),

        // ==== LOGOUT ====
        PopupMenuItem<int>(
          value: 6,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _buildMenuItemContent(Icons.logout_rounded, "Log out"),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMenuOpen ? Colors.grey[100] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isMenuOpen ? Colors.grey[300]! : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF7FE5A8), width: 2), // Borda verde
                image: DecorationImage(
                  image: NetworkImage(widget.userImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.userName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  widget.userEmail,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              isMenuOpen
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemContent(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              label.split(' ')[0],
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
