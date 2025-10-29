import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zeta_fin_app/features/goals/widgets/menu_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/user_menu_desktop.dart';

class GoalsDesktopScreen extends StatefulWidget {
  const GoalsDesktopScreen({super.key});

  @override
  State<GoalsDesktopScreen> createState() => _GoalsDesktopScreenState();
}

class _GoalsDesktopScreenState extends State<GoalsDesktopScreen> {
  String _filterStatus = "Todas";
  String _viewMode = "cards"; // cards, list, timeline
  bool _showAddGoalDialog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Row(
          children: [
            // ===== MENU LATERAL =====
            SidebarMenu(
              selectedIndex: 3,
              onItemSelected: (index) {
                debugPrint("Item selecionado: $index");
              },
            ),

            // ===== CONTEÚDO PRINCIPAL =====
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 32),
                        _buildStatsCards(),
                        const SizedBox(height: 32),
                        _buildFilterAndViewControls(),
                        const SizedBox(height: 24),
                        _buildGoalsContent(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),

                  // Botão Flutuante para Adicionar Meta
                  Positioned(
                    right: 32,
                    bottom: 32,
                    child: _buildFloatingAddButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Minhas Metas Financeiras",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Planeje, economize e alcance seus objetivos 🎯",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
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

  // ===== CARDS DE ESTATÍSTICAS =====
  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: "Metas Ativas",
            value: "3",
            icon: Icons.flag_rounded,
            color: const Color(0xFF2196F3),
            trend: "+1 este mês",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: "Total Economizado",
            value: "R\$ 9.500",
            icon: Icons.savings_rounded,
            color: const Color(0xFF4CAF50),
            trend: "+12% vs mês anterior",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: "Metas Concluídas",
            value: "1",
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF9C27B0),
            trend: "100% de sucesso",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: "Próximo Aporte",
            value: "R\$ 500",
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFFFFA000),
            trend: "em 5 dias",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                trend,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== FILTROS E CONTROLES DE VISUALIZAÇÃO =====
  Widget _buildFilterAndViewControls() {
    return Row(
      children: [
        // Filtros
        Expanded(
          child: Row(
            children: [
              _buildFilterChip("Todas", _filterStatus == "Todas"),
              const SizedBox(width: 8),
              _buildFilterChip("Em andamento", _filterStatus == "Em andamento"),
              const SizedBox(width: 8),
              _buildFilterChip("Atrasadas", _filterStatus == "Atrasadas"),
              const SizedBox(width: 8),
              _buildFilterChip("Concluídas", _filterStatus == "Concluídas"),
              const SizedBox(width: 8),
              _buildFilterChip(
                "Compartilhadas",
                _filterStatus == "Compartilhadas",
              ),
            ],
          ),
        ),

        // Controles de Visualização
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              _buildViewButton(Icons.grid_view_rounded, "cards"),
              _buildViewButton(Icons.list_rounded, "list"),
              _buildViewButton(Icons.timeline_rounded, "timeline"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _filterStatus = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildViewButton(IconData icon, String mode) {
    bool isSelected = _viewMode == mode;
    return InkWell(
      onTap: () {
        setState(() {
          _viewMode = mode;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2196F3).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? const Color(0xFF2196F3) : Colors.grey[600],
        ),
      ),
    );
  }

  // ===== CONTEÚDO DAS METAS =====
  Widget _buildGoalsContent() {
    final goals = _getFilteredGoals();

    if (_viewMode == "cards") {
      return _buildGoalsGrid(goals);
    } else if (_viewMode == "list") {
      return _buildGoalsList(goals);
    } else {
      return _buildGoalsTimeline(goals);
    }
  }

  List<Map<String, dynamic>> _getFilteredGoals() {
    final allGoals = [
      {
        "nome": "Viagem à Europa",
        "descricao": "Viagem de férias para Paris e Roma",
        "valorTotal": 15000.0,
        "valorAtual": 4500.0,
        "prazo": DateTime(2025, 12, 31),
        "categoria": "Viagem",
        "status": "Em andamento",
        "compartilhada": true,
        "prioridade": "alta",
        "contribuintes": [
          {"nome": "Lucas", "valor": 2700.0},
          {"nome": "Maria", "valor": 1800.0},
        ],
        "aportes": [
          {"data": DateTime(2025, 9, 1), "valor": 1500.0, "usuario": "Lucas"},
          {"data": DateTime(2025, 9, 15), "valor": 1000.0, "usuario": "Maria"},
          {"data": DateTime(2025, 10, 1), "valor": 1200.0, "usuario": "Lucas"},
          {"data": DateTime(2025, 10, 15), "valor": 800.0, "usuario": "Maria"},
        ],
        "icon": Icons.flight_rounded,
        "color": const Color(0xFF2196F3),
      },
      {
        "nome": "Reserva de Emergência",
        "descricao": "Fundo de emergência para 6 meses",
        "valorTotal": 30000.0,
        "valorAtual": 18000.0,
        "prazo": DateTime(2026, 6, 30),
        "categoria": "Investimento",
        "status": "Em andamento",
        "compartilhada": false,
        "prioridade": "alta",
        "contribuintes": [
          {"nome": "Lucas", "valor": 18000.0},
        ],
        "aportes": [
          {"data": DateTime(2025, 8, 1), "valor": 5000.0, "usuario": "Lucas"},
          {"data": DateTime(2025, 9, 1), "valor": 6000.0, "usuario": "Lucas"},
          {"data": DateTime(2025, 10, 1), "valor": 7000.0, "usuario": "Lucas"},
        ],
        "icon": Icons.shield_rounded,
        "color": const Color(0xFF4CAF50),
      },
      {
        "nome": "Curso de UX Design",
        "descricao": "Especialização em Design de Experiência",
        "valorTotal": 2000.0,
        "valorAtual": 2000.0,
        "prazo": DateTime(2025, 9, 30),
        "categoria": "Educação",
        "status": "Concluída",
        "compartilhada": false,
        "prioridade": "média",
        "contribuintes": [
          {"nome": "Lucas", "valor": 2000.0},
        ],
        "aportes": [
          {"data": DateTime(2025, 7, 1), "valor": 1000.0, "usuario": "Lucas"},
          {"data": DateTime(2025, 8, 1), "valor": 1000.0, "usuario": "Lucas"},
        ],
        "icon": Icons.school_rounded,
        "color": const Color(0xFF9C27B0),
      },
      {
        "nome": "Carro Novo",
        "descricao": "Entrada para financiamento",
        "valorTotal": 20000.0,
        "valorAtual": 8000.0,
        "prazo": DateTime(2025, 11, 30),
        "categoria": "Veículo",
        "status": "Atrasada",
        "compartilhada": true,
        "prioridade": "média",
        "contribuintes": [
          {"nome": "Lucas", "valor": 5000.0},
          {"nome": "Maria", "valor": 3000.0},
        ],
        "aportes": [
          {"data": DateTime(2025, 8, 1), "valor": 4000.0, "usuario": "Lucas"},
          {"data": DateTime(2025, 9, 1), "valor": 2000.0, "usuario": "Maria"},
          {"data": DateTime(2025, 10, 1), "valor": 2000.0, "usuario": "Lucas"},
        ],
        "icon": Icons.directions_car_rounded,
        "color": const Color(0xFFFFA000),
      },
    ];

    if (_filterStatus == "Todas") return allGoals;
    if (_filterStatus == "Compartilhadas") {
      return allGoals.where((g) => g["compartilhada"] == true).toList();
    }
    return allGoals.where((g) => g["status"] == _filterStatus).toList();
  }

  // ===== VISUALIZAÇÃO EM GRID =====
  Widget _buildGoalsGrid(List<Map<String, dynamic>> goals) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: goals.length,
      itemBuilder: (context, index) => _buildGoalCard(goals[index]),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
    final valorAtual = goal["valorAtual"] as double;
    final valorTotal = goal["valorTotal"] as double;
    final percent = valorAtual / valorTotal;
    final prazo = goal["prazo"] as DateTime;
    final diasRestantes = prazo.difference(DateTime.now()).inDays;
    final status = goal["status"] as String;

    // Calcular aporte mensal necessário
    final faltante = valorTotal - valorAtual;
    final mesesRestantes = (diasRestantes / 30).ceil();
    final aporteMensalNecessario = mesesRestantes > 0
        ? faltante / mesesRestantes
        : 0.0;

    Color statusColor;
    if (status == "Concluída") {
      statusColor = const Color(0xFF4CAF50);
    } else if (status == "Atrasada") {
      statusColor = const Color(0xFFFF5252);
    } else {
      statusColor = const Color(0xFF2196F3);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: (goal["color"] as Color).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: (goal["color"] as Color).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (goal["color"] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  goal["icon"] as IconData,
                  color: goal["color"] as Color,
                  size: 24,
                ),
              ),
              Row(
                children: [
                  if (goal["compartilhada"] == true)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.people_rounded,
                        color: Colors.purple,
                        size: 16,
                      ),
                    ),
                  const SizedBox(width: 8),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 1, child: Text("Editar")),
                      const PopupMenuItem(
                        value: 2,
                        child: Text("Adicionar Aporte"),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text("Ver Histórico"),
                      ),
                      const PopupMenuItem(value: 4, child: Text("Excluir")),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Nome da Meta
          Text(
            goal["nome"] as String,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Categoria
          Text(
            goal["categoria"] as String,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
          ),

          const Spacer(),

          // Progresso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "R\$ ${valorAtual.toStringAsFixed(0)}",
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                "de R\$ ${valorTotal.toStringAsFixed(0)}",
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Barra de Progresso
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8,
            percent: percent > 1 ? 1 : percent,
            backgroundColor: Colors.grey[200],
            progressColor: statusColor,
            barRadius: const Radius.circular(10),
            animation: true,
          ),

          const SizedBox(height: 12),

          // Info adicional
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status == "Concluída" ? "Concluída" : "$diasRestantes dias",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${(percent * 100).toStringAsFixed(0)}%",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          if (status != "Concluída" && aporteMensalNecessario > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.blue),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Aporte R\$ ${aporteMensalNecessario.toStringAsFixed(0)}/mês",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===== VISUALIZAÇÃO EM LISTA =====
  Widget _buildGoalsList(List<Map<String, dynamic>> goals) {
    return Column(
      children: goals.map((goal) => _buildGoalListItem(goal)).toList(),
    );
  }

  Widget _buildGoalListItem(Map<String, dynamic> goal) {
    final valorAtual = goal["valorAtual"] as double;
    final valorTotal = goal["valorTotal"] as double;
    final percent = valorAtual / valorTotal;
    final status = goal["status"] as String;

    Color statusColor;
    if (status == "Concluída") {
      statusColor = const Color(0xFF4CAF50);
    } else if (status == "Atrasada") {
      statusColor = const Color(0xFFFF5252);
    } else {
      statusColor = const Color(0xFF2196F3);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (goal["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              goal["icon"] as IconData,
              color: goal["color"] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal["nome"] as String,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (goal["compartilhada"] == true)
                      const Icon(
                        Icons.people_rounded,
                        color: Colors.purple,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  goal["categoria"] as String,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "R\$ ${valorAtual.toStringAsFixed(0)}",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "R\$ ${valorTotal.toStringAsFixed(0)}",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 6,
                  percent: percent > 1 ? 1 : percent,
                  backgroundColor: Colors.grey[200],
                  progressColor: statusColor,
                  barRadius: const Radius.circular(10),
                  animation: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${(percent * 100).toStringAsFixed(0)}%",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text("Ver Detalhes")),
              const PopupMenuItem(value: 2, child: Text("Adicionar Aporte")),
              const PopupMenuItem(value: 3, child: Text("Editar")),
              const PopupMenuItem(value: 4, child: Text("Excluir")),
            ],
          ),
        ],
      ),
    );
  }

  // ===== VISUALIZAÇÃO EM TIMELINE =====
  Widget _buildGoalsTimeline(List<Map<String, dynamic>> goals) {
    // Ordenar por prazo
    final sortedGoals = List<Map<String, dynamic>>.from(goals)
      ..sort(
        (a, b) => (a["prazo"] as DateTime).compareTo(b["prazo"] as DateTime),
      );

    return Column(
      children: sortedGoals.asMap().entries.map((entry) {
        final index = entry.key;
        final goal = entry.value;
        final isLast = index == sortedGoals.length - 1;

        return _buildTimelineItem(goal, isLast);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> goal, bool isLast) {
    final valorAtual = goal["valorAtual"] as double;
    final valorTotal = goal["valorTotal"] as double;
    final percent = valorAtual / valorTotal;
    final prazo = goal["prazo"] as DateTime;
    final status = goal["status"] as String;

    Color statusColor;
    if (status == "Concluída") {
      statusColor = const Color(0xFF4CAF50);
    } else if (status == "Atrasada") {
      statusColor = const Color(0xFFFF5252);
    } else {
      statusColor = const Color(0xFF2196F3);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Visual
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: statusColor, width: 3),
              ),
              child: Center(
                child: Icon(
                  goal["icon"] as IconData,
                  color: statusColor,
                  size: 18,
                ),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 100, color: Colors.grey[300]),
          ],
        ),
        const SizedBox(width: 20),

        // Card da Meta
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.1),
                  blurRadius: 15,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                goal["nome"] as String,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (goal["compartilhada"] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.people_rounded,
                                        size: 12,
                                        color: Colors.purple,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Compartilhada",
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: Colors.purple,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Prazo: ${prazo.day}/${prazo.month}/${prazo.year}",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  lineHeight: 10,
                  percent: percent > 1 ? 1 : percent,
                  backgroundColor: Colors.grey[200],
                  progressColor: statusColor,
                  barRadius: const Radius.circular(10),
                  animation: true,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "R\$ ${valorAtual.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "R\$ ${valorTotal.toStringAsFixed(2)}",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===== BOTÃO FLUTUANTE =====
  Widget _buildFloatingAddButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showAddGoalModal();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                "Nova Meta",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== MODAL DE ADICIONAR META =====
  void _showAddGoalModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 700,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Criar Nova Meta",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Nome da Meta
                _buildTextField(
                  label: "Nome da Meta",
                  hint: "Ex: Viagem para o Japão",
                  icon: Icons.flag_rounded,
                ),
                const SizedBox(height: 16),

                // Descrição
                _buildTextField(
                  label: "Descrição (opcional)",
                  hint: "Adicione detalhes sobre sua meta",
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Valor Total e Prazo
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "Valor Total",
                        hint: "R\$ 0,00",
                        icon: Icons.attach_money_rounded,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: "Prazo",
                        hint: "dd/mm/aaaa",
                        icon: Icons.calendar_today_rounded,
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Categoria e Prioridade
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: "Categoria",
                        items: [
                          "Viagem",
                          "Investimento",
                          "Educação",
                          "Veículo",
                          "Imóvel",
                          "Outro",
                        ],
                        icon: Icons.category_rounded,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdown(
                        label: "Prioridade",
                        items: ["Alta", "Média", "Baixa"],
                        icon: Icons.priority_high_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Periodicidade
                _buildDropdown(
                  label: "Periodicidade de Aportes",
                  items: ["Diária", "Semanal", "Quinzenal", "Mensal"],
                  icon: Icons.repeat_rounded,
                ),
                const SizedBox(height: 24),

                // Opções Avançadas
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Opções Avançadas",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCheckboxOption(
                        "Meta compartilhada (convide outras pessoas)",
                        false,
                      ),
                      _buildCheckboxOption(
                        "Aportar valor inicial agora",
                        false,
                      ),
                      _buildCheckboxOption(
                        "Ativar lembretes automáticos",
                        true,
                      ),
                      _buildCheckboxOption(
                        "Considerar rendimento (investimento)",
                        false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botões de Ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Cancelar",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Implementar criação de meta
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Meta criada com sucesso!"),
                              backgroundColor: const Color(0xFF4CAF50),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Criar Meta",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildCheckboxOption(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (v) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
