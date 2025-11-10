import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';
import 'package:zeta_fin_app/core/state/auth_state.dart';
import 'package:zeta_fin_app/core/theme/app_colors.dart';
import 'package:zeta_fin_app/features/expenses/controllers/transaction_controller.dart';
import 'package:zeta_fin_app/features/expenses/models/transaction_model.dart';
import 'package:zeta_fin_app/features/goals/controllers/user_auth_controller.dart';
import 'package:zeta_fin_app/features/goals/screens/goal/desktop/goals_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/menu_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/user_menu_desktop.dart';
import 'package:zeta_fin_app/features/repositories/user_auth_repository.dart';
import 'package:intl/intl.dart';
// Importe a tela de metas para usar o popup

class HomeDesktopScreen extends StatefulWidget {
  const HomeDesktopScreen({super.key});

  @override
  State<HomeDesktopScreen> createState() => _HomeDesktopScreenState();
}

class _HomeDesktopScreenState extends State<HomeDesktopScreen> {
  late TransactionController _transactionController;

  @override
  void initState() {
    super.initState();
    _transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );

    // Carregar dados logo ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _transactionController.loadAll(); // Carregar as transações
    });
  }

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

                    // Usando o Consumer para acessar o estado de TransactionController
                    Consumer<TransactionController>(
                      builder: (context, controller, child) {
                        return _buildFinancialOverviewCards(controller);
                      },
                    ),
                    const SizedBox(height: 40),

                    // ========== SEÇÃO: METAS ==========
                    _buildSectionTitle("Minhas Metas"),
                    const SizedBox(height: 16),
                    _buildGoalsSection(),
                    const SizedBox(height: 40),

                    // ========== SEÇÃO: TRANSAÇÕES RECENTES ==========
                    _buildSectionTitle("Transações Recentes"),
                    const SizedBox(height: 16),
                    Consumer<TransactionController>(
                      builder: (context, controller, child) {
                        return _buildTransactionTable(controller);
                      },
                    ),
                    const SizedBox(height: 40),
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
    final authState = Provider.of<AuthState>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              saudacaoDoDia(), // aqui usamos a função
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              authState.name.isNotEmpty ? authState.name : "Usuário",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        UserMenuDesktop(
          userName: authState.name.isNotEmpty ? authState.name : "Usuário",
          userEmail: authState.email.isNotEmpty
              ? authState.email
              : "email@email.com",
          userImageUrl:
              "https://media.licdn.com/dms/image/v2/D4D03AQFbnY31wEJ2Xw/profile-displayphoto-shrink_800_800/B4DZdCZqokGYAc-/0/1749165715177?e=1762992000&v=beta&t=E_lTaMGdMDm_XHqiFZQEPzqZPZSIDLo1AzSHO-AJ3gg",
          onLogout: () async {
            final authController = AuthController(
              authRepository: AuthRepository(dioClient: DioClient()),
            );
            await authController.logout(authState);
            context.go('/login');
          },
        ),
      ],
    );
  }

  String saudacaoDoDia() {
    final hora = DateTime.now().hour;

    if (hora >= 5 && hora < 12) {
      return "Bom dia,";
    } else if (hora >= 12 && hora < 18) {
      return "Boa tarde,";
    } else {
      return "Boa noite,";
    }
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
  Widget _buildFinancialOverviewCards(TransactionController controller) {
    final summary = controller.summary;

    // Dados dinâmicos ou valores default se não estiverem disponíveis
    final renda = summary?['income']?['total'] ?? 0.0;
    final totalGastos = summary?['expense']?['total'] ?? 0.0;
    final saldoRestante = renda - totalGastos;
    final contasAPagar = summary?['bills']?['total'] ?? 0.0;

    // Percentual de aumento/diminuição para receitas, despesas e saldo
    final receitaTrend = "+12.5%"; // Pode vir de algum cálculo
    final despesaTrend = "-8.3%"; // Pode vir de algum cálculo
    final saldoTrend = "+4.2%"; // Pode vir de algum cálculo

    return Row(
      children: [
        Expanded(
          child: _buildFinanceCard(
            title: "Receitas",
            value: "R\$ ${renda.toStringAsFixed(2)}",
            icon: Icons.arrow_downward_rounded,
            iconColor: const Color(0xFF00C853),
            backgroundColor: const Color(0xFFE8F5E9),
            trend: receitaTrend,
            trendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: "Despesas",
            value: "R\$ ${totalGastos.toStringAsFixed(2)}",
            icon: Icons.arrow_upward_rounded,
            iconColor: const Color(0xFFFF5252),
            backgroundColor: const Color(0xFFFFEBEE),
            trend: despesaTrend,
            trendPositive: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: "Saldo Disponível",
            value: "R\$ ${saldoRestante.toStringAsFixed(2)}",
            icon: Icons.account_balance_wallet_rounded,
            iconColor: const Color(0xFF2196F3),
            backgroundColor: const Color(0xFFE3F2FD),
            trend: saldoTrend,
            trendPositive: true,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFinanceCard(
            title: "Contas a Pagar",
            value: "R\$ ${contasAPagar.toStringAsFixed(2)}",
            icon: Icons.receipt_long_rounded,
            iconColor: const Color(0xFFFF9800),
            backgroundColor: const Color(0xFFFFF3E0),
            trend:
                "3 pendentes", // O número de contas pode vir do backend também
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
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
        Expanded(flex: 1, child: _buildQuickGoalStats(context)),
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
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
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
    final weeklyTarget = daysRemaining > 0
        ? (remaining / (daysRemaining / 7))
        : 0;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
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
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Colors.grey[600],
              ),
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
              Icon(
                Icons.trending_up_rounded,
                size: 16,
                color: Colors.grey[600],
              ),
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
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: Colors.grey[600],
              ),
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
  Widget _buildTransactionTable(TransactionController controller) {
    // Pegando todas as transações carregadas pelo controlador, incluindo as de receita
    final transactions = [
      ...controller.fixedExpenses, // Transações fixas
      ...controller.variableExpenses, // Transações variáveis
      ...controller.unnecessaryExpenses, // Transações desnecessárias
      ...controller.incomes, // Adicionando as transações de receita
    ];

    // Ordenando as transações pela data, da mais recente para a mais antiga
    transactions.sort((a, b) => b.date.compareTo(a.date));

    // Verificar se há transações, se não, mostrar mensagem de 'Sem Transações'
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma transação encontrada.',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      );
    }

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
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
          ...transactions.map((t) => _buildTransactionRow(t)),
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

  Widget _buildTransactionRow(Transaction transaction) {
    final isReceita = transaction.isIncome; // Use the getter isIncome

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
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
                    transaction.receiptUrl ??
                        'https://gmedia.playstation.com/is/image/SIEPDC/ps-store-listing-thumb-01-en-05nov20?', // Default placeholder image for receipt
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  transaction.description.isNotEmpty
                      ? transaction.description
                      : "Sem descrição", // Default description
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
              transaction.category.isNotEmpty
                  ? transaction.category
                  : "Sem categoria", // Default category
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
              DateFormat(
                'dd/MM/yyyy',
              ).format(transaction.date), // Format the date
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "R\$ ${transaction.value.toStringAsFixed(2)}", // Format the value
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
                isReceita
                    ? 'Receita'
                    : 'Despesa', // Use 'Receita' or 'Despesa' based on the type
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
