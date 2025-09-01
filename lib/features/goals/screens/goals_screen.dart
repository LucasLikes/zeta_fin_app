import 'package:flutter/material.dart';
import 'package:zeta_fin_app/core/services/dio_client.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final DioClient _dioClient = DioClient();
  
  Future<List<dynamic>> fetchGoals() async {
    try {
      final response = await _dioClient.dio.get('/goals');
      return response.data;
    } catch (e) {
      print('Erro ao buscar metas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar metas'));
          } else {
            final goals = snapshot.data ?? [];
            return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return ListTile(
                  title: Text(goal['description']),
                  subtitle: Text('Progresso: ${goal['currentAmount']} de ${goal['targetAmount']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}