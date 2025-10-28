import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';

class SidebarMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarMenu({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary, // fundo verde do menu
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(2, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          // Logo / Header
          Row(
            children: [
              const Icon(
                Icons.savings_outlined,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                "Zeta Fin",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Navegação
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.settings, "Configurações", 1),
          _buildNavItem(Icons.swap_vert_rounded, "Histórico", 2),
          _buildNavItem(Icons.flag_rounded, "Metas", 3),

          const Spacer(),

          // Footer (logout, versão, etc)
          Divider(color: Colors.white54),
          const SizedBox(height: 12),

          TextButton.icon(
            onPressed: () {
              // Navega para a tela de login
              context.go(
                '/login',
              ); // Substitua '/login' pela rota correta do seu app
            },
            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            label: Text(
              "Sair",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool selected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Colors.white.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.white : Colors.white70),
        title: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onTap: () => onItemSelected(index),
      ),
    );
  }
}
