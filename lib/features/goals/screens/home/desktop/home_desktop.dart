import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';
import 'package:zeta_fin_app/features/goals/screens/goal/desktop/goals_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/menu_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/user_menu_desktop.dart';
// Importe a tela de metas para usar o popup

class HomeDesktopScreen extends StatefulWidget {
  const HomeDesktopScreen({super.key});

  @override
  State<HomeDesktopScreen> createState() => _HomeDesktopScreenState();
}

class _HomeDesktopScreenState extends State<HomeDesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Row(
          children: [
            // ================== MENU LATERAL =====================
            SidebarMenu(
              selectedIndex: 0,
              onItemSelected: (index) {
                debugPrint("Item selecionado: $index");
              },
            ),

            // ================== CONTEÚDO PRINCIPAL ===============
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // ========== SEÇÃO: CONTROLE PESSOAL ==========
                    _buildSectionTitle("Controle Pessoal"),
                    const SizedBox(height: 16),
                    _buildFinancialOverviewCards(),
                    const SizedBox(height: 40),

                    // ========== SEÇÃO: METAS ==========
                    _buildSectionTitle("Minhas Metas"),
                    const SizedBox(height: 16),
                    _buildGoalsSection(),
                    const SizedBox(height: 40),

                    // ========== SEÇÃO: TRANSAÇÕES RECENTES ==========
                    _buildSectionTitle("Transações Recentes"),
                    const SizedBox(height: 16),
                    _buildTransactionTable(),
                  ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bom dia,",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Lucas Likes",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        UserMenuDesktop(
          userName: "Lucas Likes",
          userEmail: "likes@email.com",
          userImageUrl:
              "https://media.licdn.com/dms/image/v2/D4D03AQFbnY31wEJ2Xw/profile-displayphoto-shrink_800_800/B4DZdCZqokGYAc-/0/1749165715177?e=1762992000&v=beta&t=E_lTaMGdMDm_XHqiFZQEPzqZPZSIDLo1AzSHO-AJ3gg",
          onLogout: () {
            debugPrint("Logout realizado!");
          },
        ),
      ],
    );
  }

  // ====================== TÍTULO DAS SEÇÕES ==============================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  // ====================== CARDS DE CONTROLE PESSOAL ==============================
  Widget _buildFinancialOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: _buildFinanceCard(
            title: "Receitas",
            value: "R\$ 8.450,00",
            icon: Icons.arrow_downward_rounded,
            iconColor: const Color(0xFF00C853),
            backgroundColor: const Color(0xFFE8F5E9),
            trend: "+12.5%",
            trendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: "Despesas",
            value: "R\$ 4.320,00",
            icon: Icons.arrow_upward_rounded,
            iconColor: const Color(0xFFFF5252),
            backgroundColor: const Color(0xFFFFEBEE),
            trend: "-8.3%",
            trendPositive: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: "Saldo Disponível",
            value: "R\$ 4.130,00",
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF2196F3),
            backgroundColor: const Color(0xFFE3F2FD),
            trend: "+4.2%",
            trendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: "Contas a Pagar",
            value: "R\$ 1.250,00",
            icon: Icons.receipt_long_rounded,
            iconColor: const Color(0xFFFF9800),
            backgroundColor: const Color(0xFFFFF3E0),
            trend: "3 pendentes",
            trendPositive: null,
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String trend,
    bool? trendPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              if (trendPositive != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendPositive
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    trend,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: trendPositive
                          ? const Color(0xFF00C853)
                          : const Color(0xFFFF5252),
                    ),
                  ),
                ),
              if (trendPositive == null)
                Text(
                  trend,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ====================== SEÇÃO DE METAS ==============================
  Widget _buildGoalsSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildGoalCard(
            title: "Viagem para Paris",
            currentValue: 8500.00,
            targetValue: 15000.00,
            deadline: DateTime(2025, 12, 31),
            color: const Color(0xFF9C27B0),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: _buildGoalCard(
            title: "Notebook Novo",
            currentValue: 2800.00,
            targetValue: 5000.00,
            deadline: DateTime(2025, 8, 15),
            color: const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: _buildQuickGoalStats(context),
        ),
      ],
    );
  }

  Widget _buildQuickGoalStats(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Chama o popup moderno de metas
          GoalsDesktopScreen.showGoalsForPinPopup(context);
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flag_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Total de Metas",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "5",
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.3), height: 1),
              const SizedBox(height: 20),
              _buildQuickStat("Concluídas", "2", Icons.check_circle_rounded),
              const SizedBox(height: 12),
              _buildQuickStat("Em Andamento", "3", Icons.timelapse_rounded),
              const SizedBox(height: 16),
              // Indicador de clique
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.push_pin_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Gerenciar Metas",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required double currentValue,
    required double targetValue,
    required DateTime deadline,
    required Color color,
  }) {
    final percentage = (currentValue / targetValue).clamp(0.0, 1.0);
    final remaining = targetValue - currentValue;
    final daysRemaining = deadline.difference(DateTime.now()).inDays;
    final weeklyTarget = daysRemaining > 0 ? (remaining / (daysRemaining / 7)) : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${(percentage * 100).toStringAsFixed(0)}%",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Barra de Progresso
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 12,
            percent: percentage,
            backgroundColor: Colors.grey[200],
            progressColor: color,
            barRadius: const Radius.circular(6),
            animation: true,
            animationDuration: 1000,
          ),
          
          const SizedBox(height: 20),
          
          // Informações da Meta
          Row(
            children: [
              Expanded(
                child: _buildGoalInfo(
                  label: "Atual",
                  value: "R\$ ${currentValue.toStringAsFixed(2)}",
                  color: Colors.grey[700]!,
                ),
              ),
              Expanded(
                child: _buildGoalInfo(
                  label: "Meta",
                  value: "R\$ ${targetValue.toStringAsFixed(2)}",
                  color: color,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Divider(color: Colors.grey[200], height: 1),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                "Prazo: ${deadline.day}/${deadline.month}/${deadline.year}",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                "Economizar R\$ ${weeklyTarget.toStringAsFixed(2)}/semana",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                "$daysRemaining dias restantes",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalInfo({
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ====================== TABELA DE TRANSAÇÕES ==============================
  Widget _buildTransactionTable() {
    final transactions = [
      {
        "valor": "R\$ 320,00",
        "data": "10/10/2025",
        "tipo": "Receita",
        "categoria": "Salário",
        "descricao": "Pagamento Mensal",
        "avatar": "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=100&h=100&fit=crop",
      },
      {
        "valor": "R\$ 120,00",
        "data": "11/10/2025",
        "tipo": "Despesa",
        "categoria": "Alimentação",
        "descricao": "Supermercado",
        "avatar": "https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=100&h=100&fit=crop",
      },
      {
        "valor": "R\$ 75,00",
        "data": "12/10/2025",
        "tipo": "Despesa",
        "categoria": "Transporte",
        "descricao": "Uber",
        "avatar": "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&h=100&fit=crop",
      },
      {
        "valor": "R\$ 420,00",
        "data": "14/10/2025",
        "tipo": "Receita",
        "categoria": "Freelance",
        "descricao": "Projeto Web",
        "avatar": "https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=100&h=100&fit=crop",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Últimas Transações",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Histórico de movimentações financeiras",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Nova Transação"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Cabeçalho da Tabela
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildTableHeader("Descrição")),
                Expanded(flex: 2, child: _buildTableHeader("Categoria")),
                Expanded(flex: 2, child: _buildTableHeader("Data")),
                Expanded(flex: 2, child: _buildTableHeader("Valor")),
                Expanded(flex: 1, child: _buildTableHeader("Tipo")),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Linhas da Tabela
          ...transactions.map((t) => _buildTransactionRow(t)).toList(),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildTransactionRow(Map<String, String> transaction) {
    final isReceita = transaction["tipo"] == "Receita";
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    transaction["avatar"]!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  transaction["descricao"]!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction["categoria"]!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction["data"]!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction["valor"]!,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isReceita ? const Color(0xFF00C853) : Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isReceita
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                transaction["tipo"]!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isReceita
                      ? const Color(0xFF00C853)
                      : const Color(0xFFFF5252),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}