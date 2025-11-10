import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:zeta_fin_app/features/expenses/controllers/transaction_controller.dart';
import 'package:zeta_fin_app/features/expenses/widgets/add_transaction_popup.dart';
import 'package:zeta_fin_app/features/goals/widgets/menu_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/user_menu_desktop.dart';

// ===== CLASSE PRINCIPAL =====
class ExpensesDesktopScreen extends StatefulWidget {
  const ExpensesDesktopScreen({super.key});

  @override
  State<ExpensesDesktopScreen> createState() => _ExpensesDesktopScreenState();
}

// ===== STATE =====
class _ExpensesDesktopScreenState extends State<ExpensesDesktopScreen> {
  late TransactionController _transactionController;

  @override
  void initState() {
    super.initState();
    _transactionController = Provider.of<TransactionController>(
      context,
      listen: false,
    );
    // Chama _loadData após o build inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  // Carrega os dados da API
  Future<void> _loadData() async {
    try {
      await _transactionController.loadAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Row(
          children: [
            // ===== MENU LATERAL =====
            SidebarMenu(
              selectedIndex: 1,
              onItemSelected: (index) {
                debugPrint("Item selecionado: $index");
              },
            ),

            // ===== CONTEÚDO PRINCIPAL =====
            Expanded(
              child: Consumer<TransactionController>(
                builder: (context, controller, child) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.errorMessage!,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.red[700],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _loadData,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 40),

                        // 💰 VISÃO GERAL FINANCEIRA
                        _buildFinancialOverview(controller),
                        const SizedBox(height: 32),

                        // 📊 DASHBOARD DE CONTROLE
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildExpensesBreakdown(controller),
                                  const SizedBox(height: 24),
                                  _buildSpendingLimit(controller),
                                  const SizedBox(height: 24),
                                  _buildMonthlyComparison(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildSavingsGoal(controller),
                                  const SizedBox(height: 24),
                                  _buildFinancialHealth(),
                                  const SizedBox(height: 24),
                                  _buildQuickInsights(),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // 🎯 CATEGORIAS DETALHADAS
                        _buildSectionTitle("Análise Detalhada por Categoria"),
                        const SizedBox(height: 16),
                        _buildCategoryTabs(controller),

                        const SizedBox(height: 32),

                        // 💡 INTELIGÊNCIA FINANCEIRA
                        _buildSectionTitle("Seu Consultor Financeiro"),
                        const SizedBox(height: 16),
                        _buildFinancialAdvisor(),

                        const SizedBox(height: 32),

                        // 🏆 CONQUISTAS E PROGRESSO
                        _buildSectionTitle("Seu Progresso Financeiro"),
                        const SizedBox(height: 16),
                        _buildAchievementsSection(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Minhas Despesas",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Controle total das suas finanças",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Row(
          children: [
            // 🆕 BOTÃO PARA ADICIONAR TRANSAÇÃO
            ElevatedButton.icon(
              onPressed: () async {
                final result = await AddTransactionPopup.show(context);
                if (result == true && mounted) {
                  // Recarregar dados após adicionar transação
                  await _loadData();
                  
                  // Mostrar mensagem de sucesso
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transação adicionada com sucesso!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(
                "Nova Transação",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 16),
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
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  // 💰 VISÃO GERAL FINANCEIRA
  Widget _buildFinancialOverview(TransactionController controller) {
    final summary = controller.summary;
    
    // Se não tiver dados do resumo, usa valores default
    final renda = summary?['income']?['total'] ?? 8000.00;
    final totalGastos = summary?['expense']?['total'] ?? 4320.00;
    final saldoRestante = renda - totalGastos;
    final percentualGasto = renda > 0 ? totalGastos / renda : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                    "Saldo Disponível",
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "R\$ ${saldoRestante.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "de R\$ ${renda.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      "${(percentualGasto * 100).toStringAsFixed(0)}%",
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "gasto",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildQuickStat(
                "Total Gasto",
                "R\$ ${totalGastos.toStringAsFixed(2)}",
                Icons.arrow_upward_rounded,
                Colors.redAccent,
              ),
              const SizedBox(width: 24),
              _buildQuickStat(
                "Economia do Mês",
                "R\$ ${saldoRestante.toStringAsFixed(2)}",
                Icons.savings_rounded,
                Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📊 BREAKDOWN DE DESPESAS - SOMENTE DADOS REAIS
  Widget _buildExpensesBreakdown(TransactionController controller) {
    final summary = controller.summary;
    
    // Pega os valores REAIS do summary, se não houver retorna 0
    final contasFixas = summary?['expense']?['byType']?['fixas']?.toDouble() ?? 0.0;
    final contasVariaveis = summary?['expense']?['byType']?['variaveis']?.toDouble() ?? 0.0;
    final desnecessarios = summary?['expense']?['byType']?['desnecessarios']?.toDouble() ?? 0.0;
    final renda = summary?['income']?['total']?.toDouble() ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Distribuição de Gastos",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          _buildExpenseBar("Contas Fixas", contasFixas, renda,
              const Color(0xFF2196F3), "${((contasFixas/renda)*100).toStringAsFixed(1)}% ideal: ≤50%"),
          const SizedBox(height: 16),
          _buildExpenseBar("Contas Variáveis", contasVariaveis, renda,
              const Color(0xFFFFA000), "${((contasVariaveis/renda)*100).toStringAsFixed(1)}% ideal: ≤30%"),
          const SizedBox(height: 16),
          _buildExpenseBar("Gastos Desnecessários", desnecessarios, renda,
              const Color(0xFFE91E63), "${((desnecessarios/renda)*100).toStringAsFixed(1)}% ideal: ≤20%"),
        ],
      ),
    );
  }

  Widget _buildExpenseBar(String label, double value, double total,
      Color color, String percentage) {
    double percent = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Text(
              "R\$ ${value.toStringAsFixed(2)}",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 12,
          percent: percent,
          backgroundColor: Colors.grey[200],
          progressColor: color,
          barRadius: const Radius.circular(6),
          animation: true,
        ),
        const SizedBox(height: 4),
        Text(
          percentage,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // 🎯 LIMITE DE GASTOS - CORRIGIDO
  Widget _buildSpendingLimit(TransactionController controller) {
    final summary = controller.summary;
    
    final renda = summary?['income']?['total'] ?? 8000.00;
    final contasFixas = summary?['expense']?['byType']?['fixas'] ?? 2050.00;
    final metaPoupanca = renda * 0.2; // 20% da renda
    final limiteGastos = renda - contasFixas - metaPoupanca;
    
    final contasVariaveis = summary?['expense']?['byType']?['variaveis'] ?? 1870.00;
    final desnecessarios = summary?['expense']?['byType']?['desnecessarios'] ?? 400.00;
    final gastoAtual = contasVariaveis + desnecessarios;
    
    final percentUsado = limiteGastos > 0 ? gastoAtual / limiteGastos : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Text(
                "Limite de Gastos Livres",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: percentUsado > 1
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentUsado > 1 ? "ATENÇÃO" : "OK",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: percentUsado > 1 ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gastou",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "R\$ ${gastoAtual.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: percentUsado > 1 ? Colors.red : Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Limite",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    "R\$ ${limiteGastos.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 16,
            percent: percentUsado.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            progressColor: percentUsado > 0.9
                ? Colors.red
                : percentUsado > 0.7
                    ? Colors.orange
                    : Colors.green,
            barRadius: const Radius.circular(8),
            animation: true,
          ),
          const SizedBox(height: 12),
          Text(
            "💡 Cálculo: Renda (R\$ ${renda.toStringAsFixed(2)}) - Fixas (R\$ ${contasFixas.toStringAsFixed(2)}) - Poupança (R\$ ${metaPoupanca.toStringAsFixed(2)})",
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Continua com os outros métodos (_buildMonthlyComparison, _buildSavingsGoal, etc.)
  // mantendo o código original...

  // 📈 COMPARAÇÃO MENSAL
  Widget _buildMonthlyComparison() {
    final data = [
      {"mes": "Jul", "valor": 4100.00},
      {"mes": "Ago", "valor": 4320.00},
      {"mes": "Set", "valor": 3980.00},
      {"mes": "Out", "valor": 4250.00},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Evolução dos Gastos",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((e) {
                final max = data
                    .map((item) => item["valor"] as double)
                    .reduce((a, b) => a > b ? a : b);
                final percent = (e["valor"] as double) / max;
                final isCurrent = e == data.last;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "R\$ ${((e["valor"] as double) / 1000).toStringAsFixed(1)}k",
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: 80 * percent,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isCurrent
                                  ? [
                                      const Color(0xFF1A237E),
                                      const Color(0xFF283593)
                                    ]
                                  : [Colors.grey[400]!, Colors.grey[300]!],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          e["mes"] as String,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight:
                                isCurrent ? FontWeight.w700 : FontWeight.w500,
                            color: isCurrent ? Colors.black87 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 🎯 META DE POUPANÇA - CORRIGIDO
  Widget _buildSavingsGoal(TransactionController controller) {
    final summary = controller.summary;
    
    final renda = summary?['income']?['total'] ?? 8000.00;
    final totalGastos = summary?['expense']?['total'] ?? 4320.00;
    final economizado = renda - totalGastos;
    final metaMensal = renda * 0.2; // 20% da renda
    final progresso = metaMensal > 0 ? (economizado / metaMensal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00C853), Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Meta de Economia",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.savings_rounded,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "R\$ ${economizado.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            "de R\$ ${metaMensal.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 12,
            percent: progresso,
            backgroundColor: Colors.white.withOpacity(0.3),
            progressColor: Colors.white,
            barRadius: const Radius.circular(6),
            animation: true,
          ),
          const SizedBox(height: 12),
          Text(
            "${(progresso * 100).toStringAsFixed(0)}% da meta mensal",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // 💊 SAÚDE FINANCEIRA
  Widget _buildFinancialHealth() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Saúde Financeira",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildHealthMetric("Reserva de Emergência", 0.5, Colors.orange),
          const SizedBox(height: 16),
          _buildHealthMetric("Controle de Gastos", 0.85, Colors.green),
          const SizedBox(height: 16),
          _buildHealthMetric("Meta de Poupança", 0.91, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              "${(value * 100).toStringAsFixed(0)}%",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 8,
          percent: value,
          backgroundColor: Colors.grey[200],
          progressColor: color,
          barRadius: const Radius.circular(4),
          animation: true,
        ),
      ],
    );
  }

  // ⚡ INSIGHTS RÁPIDOS
  Widget _buildQuickInsights() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Insights Rápidos",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            Icons.trending_down_rounded,
            "Você gastou 8% a menos que o mês passado",
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.warning_amber_rounded,
            "Delivery subiu 35% este mês",
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildInsightItem(
            Icons.stars_rounded,
            "Meta de economia quase atingida!",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // 📑 TABS DE CATEGORIAS
  Widget _buildCategoryTabs(TransactionController controller) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: const Color(0xFF1A237E),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF1A237E),
              indicatorWeight: 3,
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: "Fixas"),
                Tab(text: "Variáveis"),
                Tab(text: "Desnecessários"),
              ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                children: [
                  _buildExpensesList(controller, "fixas"),
                  _buildExpensesList(controller, "variaveis"),
                  _buildExpensesList(controller, "desnecessarios"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(TransactionController controller, String type) {
    // Filtra transações do controller por tipo
    List expenses = [];
    
    if (type == "fixas") {
      expenses = controller.fixedExpenses;
    } else if (type == "variaveis") {
      expenses = controller.variableExpenses;
    } else {
      expenses = controller.unnecessaryExpenses;
    }

    // Se não houver dados do controller, usa mock data
    if (expenses.isEmpty) {
      if (type == "fixas") {
        expenses = [
          {"nome": "Aluguel", "valor": 1200.00, "vencimento": "10/11/2025"},
          {"nome": "Internet", "valor": 150.00, "vencimento": "05/11/2025"},
          {"nome": "Academia", "valor": 100.00, "vencimento": "08/11/2025"},
          {"nome": "Netflix", "valor": 39.90, "vencimento": "20/11/2025"},
          {"nome": "Plano de Saúde", "valor": 560.00, "vencimento": "12/11/2025"},
        ];
      } else if (type == "variaveis") {
        expenses = [
          {"nome": "Supermercado", "valor": 750.00, "categoria": "Alimentação"},
          {"nome": "Uber", "valor": 210.00, "categoria": "Transporte"},
          {"nome": "Restaurantes", "valor": 320.00, "categoria": "Lazer"},
          {"nome": "Cinema", "valor": 95.00, "categoria": "Lazer"},
          {"nome": "Farmácia", "valor": 135.00, "categoria": "Saúde"},
        ];
      } else {
        expenses = [
          {"nome": "Assinatura Spotify (não usada)", "valor": 34.90},
          {"nome": "Compras impulsivas (Shopee)", "valor": 89.00},
          {"nome": "Delivery excessivo", "valor": 275.00},
        ];
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        
        // Adapta para trabalhar tanto com Transaction objects quanto com Maps
        final nome = expense is Map ? expense["nome"] : expense.description;
        final valor = expense is Map ? expense["valor"] : expense.value;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: type == "fixas"
                      ? const Color(0xFF2196F3).withOpacity(0.1)
                      : type == "variaveis"
                          ? const Color(0xFFFFA000).withOpacity(0.1)
                          : const Color(0xFFE91E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  type == "fixas"
                      ? Icons.receipt_long_rounded
                      : type == "variaveis"
                          ? Icons.shopping_cart_rounded
                          : Icons.warning_amber_rounded,
                  color: type == "fixas"
                      ? const Color(0xFF2196F3)
                      : type == "variaveis"
                          ? const Color(0xFFFFA000)
                          : const Color(0xFFE91E63),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (expense is Map && expense.containsKey("vencimento"))
                      Text(
                        "Venc: ${expense["vencimento"]}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (expense is Map && expense.containsKey("categoria"))
                      Text(
                        expense["categoria"],
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                "R\$ ${valor.toStringAsFixed(2)}",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: type == "fixas"
                      ? const Color(0xFF2196F3)
                      : type == "variaveis"
                          ? const Color(0xFFFFA000)
                          : const Color(0xFFE91E63),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 💡 CONSULTOR FINANCEIRO
  Widget _buildFinancialAdvisor() {
    return Column(
      children: [
        _buildAdvisorCard(
          "💰 Custo Real do Consumo por Impulso",
          "Se você comprar 5 cafés por semana (R\$ 15,00 cada), em 1 ano você gastará R\$ 3.900,00. Esse valor daria para uma viagem incrível!",
          Colors.brown,
          Icons.coffee_rounded,
        ),
        const SizedBox(height: 16),
        _buildAdvisorCard(
          "📊 Comparativo com o Ideal",
          "• Fixas: 25.6% ✅ (ideal ≤ 50%)\n• Variáveis: 23.4% ✅ (ideal ≤ 30%)\n• Supérfluos: 5% ✅ (ideal ≤ 20%)\n\nParabéns! Seus gastos estão equilibrados!",
          Colors.blue,
          Icons.analytics_rounded,
        ),
        const SizedBox(height: 16),
        _buildAdvisorCard(
          "🎯 Reserva de Emergência",
          "Meta recomendada: R\$ 6.150,00 (3 meses de despesas fixas)\nAtual: R\$ 3.200,00 (52%)\n\nContinue guardando R\$ 983,00 por mês para completar em 3 meses!",
          Colors.orange,
          Icons.savings_rounded,
        ),
        const SizedBox(height: 16),
        _buildAdvisorCard(
          "💎 Simulação de Investimento",
          "Se você investir seus R\$ 1.600,00 mensais:\n• Poupança (6% a.a.): R\$ 20.150 em 1 ano\n• CDB (12% a.a.): R\$ 20.890 em 1 ano\n• Tesouro Direto (13% a.a.): R\$ 21.050 em 1 ano\n\nDiferença: R\$ 900,00 a mais escolhendo bem!",
          Colors.green,
          Icons.trending_up_rounded,
        ),
      ],
    );
  }

  Widget _buildAdvisorCard(
      String title, String content, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🏆 CONQUISTAS
  Widget _buildAchievementsSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Suas Conquistas",
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const Icon(
                Icons.emoji_events_rounded,
                color: Colors.amberAccent,
                size: 36,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildAchievementBadge(
                  "🎯",
                  "Economizador\nNível 3",
                  "Guardou por 3 meses seguidos",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAchievementBadge(
                  "📊",
                  "Controle\nTotal",
                  "Sem gastos impulsivos",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAchievementBadge(
                  "💎",
                  "Investidor\nIniciante",
                  "Primeiro investimento feito",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAchievementBadge(
                  "🧠",
                  "Planejador\nMestre",
                  "Meta atingida 3x",
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: Colors.amberAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Próxima Conquista",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reserve R\$ 1.000,00 a mais para desbloquear \"Reserva de Ouro\"",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      LinearPercentIndicator(
                        padding: EdgeInsets.zero,
                        lineHeight: 8,
                        percent: 0.65,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        progressColor: Colors.amberAccent,
                        barRadius: const Radius.circular(4),
                        animation: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String emoji, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white70,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}