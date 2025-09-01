import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Detectando o tipo de dispositivo
    bool isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text(
          'Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Row(
        children: [
          // Menu Lateral
          isDesktop ? Expanded(child: NavigationDrawer()) : SizedBox(),
          // Corpo Principal
          Expanded(child: DashboardContent())
        ],
      ),
      drawer: isDesktop ? null : NavigationDrawer(), // Apenas em dispositivos móveis
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF121212), // Fundo escuro
      child: Drawer(
        child: Column(
          children: [
            // Avatar e Nome
            UserInfo(),
            // Menu de navegação
            NavigationItem(
              icon: Icons.dashboard,
              label: 'Dashboard',
              onTap: () => context.go('/home'),
            ),
            NavigationItem(
              icon: Icons.list,
              label: 'Metas',
              onTap: () => context.go('/goals'),
            ),
            NavigationItem(
              icon: Icons.settings,
              label: 'Configurações',
              onTap: () => context.go('/settings'),
            ),
            NavigationItem(
              icon: Icons.exit_to_app,
              label: 'Logout',
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://www.example.com/avatar.jpg'), // Substitua com a URL da imagem do usuário
          ),
          SizedBox(height: 10),
          Text(
            'João Silva', // Nome do usuário
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Desenvolvedor Flutter', // Cargo ou descrição
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function onTap;

  const NavigationItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: GoogleFonts.poppins(color: Colors.white)),
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Cards de Progresso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusCard("Metas Concluídas", 0.75, Colors.green),
                _buildStatusCard("Saldo", 0.55, Colors.blue),
              ],
            ),
            SizedBox(height: 20),
            // Gráfico de Progresso
            _buildProgressGraph(),
            SizedBox(height: 30),
            // Atividades recentes
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, double progress, Color color) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: color,
              ),
            ),
            SizedBox(height: 10),
            LinearPercentIndicator(
              width: 120.0,
              lineHeight: 8.0,
              percent: progress,
              backgroundColor: Colors.grey[300]!,
              progressColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressGraph() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.green.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Text(
              'Progresso Geral',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 8.0,
              percent: 0.8,
              center: Text(
                "80%",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey[300]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        _buildActivityCard('Meta 1', 'Você alcançou 80% da sua meta!', Colors.green),
        _buildActivityCard('Meta 2', 'Novo objetivo adicionado', Colors.blue),
        _buildActivityCard('Meta 3', 'Progresso de 50%', Colors.orange),
      ],
    );
  }

  Widget _buildActivityCard(String title, String description, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: color, size: 30),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    description,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}
