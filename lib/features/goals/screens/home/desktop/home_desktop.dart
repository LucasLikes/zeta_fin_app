import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';
import 'package:zeta_fin_app/features/goals/widgets/menu_desktop.dart';

class HomeDesktopScreen extends StatelessWidget {
  const HomeDesktopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // ================== MENU LATERAL =====================
            SidebarMenu(
              selectedIndex: 0,
              onItemSelected: (index) {
                // Aqui você pode trocar de página ou atualizar conteúdo
                print("Item selecionado: $index");
              },
            ),

            // ================== CONTEÚDO PRINCIPAL ===============
              Expanded(
                child: Container(
                  // Não precisa de width/height, o Expanded já cuida
                  color: Colors.white, // fundo branco do conteúdo
                  child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(),
                      const SizedBox(height: 24),

                      // Linha com os cards principais
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildOverviewCard()),
                          const SizedBox(width: 24),
                          Expanded(child: _buildGoalCard()),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Tabela de transações
                      Text(
                        "Transações Recentes",
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTransactionTable(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================== HEADER ==============================
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Bom dia,",
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Likes",
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ====================== CARD OVERVIEW ========================
  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saldo Total",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "\$7.430,00",
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Último pagamento: 8 de Abril, 2025",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            lineHeight: 10,
            percent: 0.6,
            progressColor: AppColors.primary,
            backgroundColor: Colors.grey[300]!,
            barRadius: const Radius.circular(8),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "History",
                  style: GoogleFonts.inter(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Ver detalhes do aviso",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ====================== CARD DE META / PROGRESSO =============
  Widget _buildGoalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saldo Total",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Você está a 80% de concluir seu objetivo",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 10.0,
              percent: 0.8,
              center: Text(
                "62 mil",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
              progressColor: AppColors.primary,
              backgroundColor: Colors.grey[300]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }

  // ====================== TABELA DE TRANSAÇÕES =================
  Widget _buildTransactionTable() {
    final transactions = [
      {"valor": "R\$ 320,00", "data": "10/10/2025", "tipo": "Depósito"},
      {"valor": "R\$ 120,00", "data": "11/10/2025", "tipo": "Compra"},
      {"valor": "R\$ 75,00", "data": "12/10/2025", "tipo": "Serviço"},
      {"valor": "R\$ 420,00", "data": "14/10/2025", "tipo": "Depósito"},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DataTable(
        headingTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
        dataTextStyle: GoogleFonts.inter(
          color: Colors.black87,
        ),
        columns: const [
          DataColumn(label: Text("Valor")),
          DataColumn(label: Text("Data")),
          DataColumn(label: Text("Tipo")),
        ],
        rows: transactions
            .map(
              (t) => DataRow(
                cells: [
                  DataCell(Text(t["valor"]!)),
                  DataCell(Text(t["data"]!)),
                  DataCell(Text(t["tipo"]!)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
