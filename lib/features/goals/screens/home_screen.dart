import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtendo o tamanho da tela para adaptar os componentes
    double screenWidth = MediaQuery.of(context).size.width;

    // Definir a quantidade de cards por linha com base na largura da tela
    int columns = screenWidth > 600 ? 2 : 1; // Para telas grandes, dois cards por linha, caso contrário, 1.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'App Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.settings),
            onPressed: () {
              print("Settings clicked");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card com informações rápidas (Progressos)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildStatusCard("Metas Concluídas", 0.75, Colors.green)),
                  SizedBox(width: 10), // Espaçamento entre os cards
                  Expanded(child: _buildStatusCard("Saldo", 0.55, Colors.blue)),
                ],
              ),
              SizedBox(height: 20),

              // Gráfico de progresso
              _buildProgressGraph(),

              SizedBox(height: 30),

              // Lista de atividades
              _buildActivityList(columns),

              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("FAB Clicked");
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
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

  Widget _buildActivityList(int columns) {
    // Modificando o layout da lista de atividades conforme o número de colunas
    return GridView.builder(
      shrinkWrap: true, // Permite que o grid ocupe apenas o espaço necessário
      physics: NeverScrollableScrollPhysics(), // Desabilita a rolagem para não interferir com o SingleChildScrollView
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns, // Definido dinamicamente com base na largura da tela
        crossAxisSpacing: 10, // Espaçamento entre as colunas
        mainAxisSpacing: 10, // Espaçamento entre as linhas
        childAspectRatio: 1.2, // Proporção do card para que ele se ajuste bem
      ),
      itemCount: 3, // Número de atividades
      itemBuilder: (context, index) {
        return _buildActivityCard(
          'Meta ${index + 1}',
          index == 0
              ? 'Você alcançou 80% da sua meta!'
              : (index == 1 ? 'Novo objetivo adicionado' : 'Progresso de 50%'),
          index == 0
              ? Colors.green
              : (index == 1 ? Colors.blue : Colors.orange),
        );
      },
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
