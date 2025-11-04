import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:zeta_fin_app/features/goals/widgets/menu_desktop.dart';
import 'package:zeta_fin_app/features/goals/widgets/user_menu_desktop.dart';

class MyAccountDesktopScreen extends StatefulWidget {
  const MyAccountDesktopScreen({super.key});

  @override
  State<MyAccountDesktopScreen> createState() => _MyAccountDesktopScreenState();
}

class _MyAccountDesktopScreenState extends State<MyAccountDesktopScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nomeController = TextEditingController(text: "Lucas Likes");
  final _emailController = TextEditingController(text: "likes@email.com");
  final _telefoneController = TextEditingController(text: "(41) 99999-8888");
  final _cpfController = TextEditingController(text: "123.456.789-00");
  final _dataNascimentoController = TextEditingController(text: "15/03/1995");
  final _enderecoController = TextEditingController(text: "Rua das Flores, 123");
  final _cidadeController = TextEditingController(text: "Curitiba");
  final _estadoController = TextEditingController(text: "PR");
  final _cepController = TextEditingController(text: "80000-000");
  
  // Estados
  bool _notificacoesEmail = true;
  bool _notificacoesPush = true;
  bool _notificacoesFinanceiras = true;
  bool _autenticacaoDuploFator = false;
  bool _isEditMode = false;
  bool _isLoading = false;

  String _selectedAvatar = "https://media.licdn.com/dms/image/v2/D4D03AQFbnY31wEJ2Xw/profile-displayphoto-shrink_800_800/B4DZdCZqokGYAc-/0/1749165715177?e=1762992000&v=beta&t=E_lTaMGdMDm_XHqiFZQEPzqZPZSIDLo1AzSHO-AJ3gg";

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _enderecoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simula salvamento
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _isEditMode = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Alterações salvas com sucesso!'),
              ],
            ),
            backgroundColor: const Color(0xFF00C853),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      });
    }
  }

  void _showImagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Escolher Foto de Perfil',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageOption(
              icon: Icons.photo_library_rounded,
              label: 'Escolher da Galeria',
              onTap: () {
                Navigator.pop(context);
                _showImageGallery();
              },
            ),
            const SizedBox(height: 12),
            _buildImageOption(
              icon: Icons.camera_alt_rounded,
              label: 'Tirar Foto',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Câmera em desenvolvimento')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildImageOption(
              icon: Icons.delete_outline_rounded,
              label: 'Remover Foto',
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedAvatar = "";
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageGallery() {
    final avatars = [
      "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400&h=400&fit=crop",
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop",
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop",
      "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop",
      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop",
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Escolher Avatar',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: SizedBox(
          width: 400,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedAvatar = avatars[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedAvatar == avatars[index]
                          ? const Color(0xFF1A237E)
                          : Colors.grey[300]!,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(avatars[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? const Color(0xFF1A237E)),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Row(
          children: [
            // Menu Lateral
            SidebarMenu(
              selectedIndex: 4,
              onItemSelected: (index) {
                debugPrint("Item selecionado: $index");
              },
            ),

            // Conteúdo Principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Coluna Esquerda
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildProfileCard(),
                              const SizedBox(height: 24),
                              _buildPersonalInfoCard(),
                              const SizedBox(height: 24),
                              _buildAddressCard(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        
                        // Coluna Direita
                        Expanded(
                          child: Column(
                            children: [
                              _buildStatsCard(),
                              const SizedBox(height: 24),
                              _buildNotificationsCard(),
                              const SizedBox(height: 24),
                              _buildSecurityCard(),
                              const SizedBox(height: 24),
                              _buildDangerZoneCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              "Minha Conta",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Gerencie suas informações pessoais e preferências",
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
          userImageUrl: _selectedAvatar,
          onLogout: () {
            debugPrint("Logout realizado!");
          },
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
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
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _selectedAvatar.isNotEmpty
                      ? Image.network(_selectedAvatar, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImagePicker,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _nomeController.text,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _emailController.text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, color: Colors.greenAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Conta Verificada",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildProfileStat("15", "Metas Ativas"),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildProfileStat("3", "Anos na ZetaFin"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informações Pessoais",
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_isEditMode) {
                      _saveChanges();
                    } else {
                      setState(() => _isEditMode = true);
                    }
                  },
                  icon: Icon(
                    _isEditMode ? Icons.save_rounded : Icons.edit_rounded,
                    size: 18,
                  ),
                  label: Text(_isEditMode ? "Salvar" : "Editar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditMode
                        ? const Color(0xFF00C853)
                        : const Color(0xFF1A237E),
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
            _buildTextField("Nome Completo", _nomeController, Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField("E-mail", _emailController, Icons.email_outlined,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField("Telefone", _telefoneController, Icons.phone_outlined,
                      keyboardType: TextInputType.phone),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField("CPF", _cpfController, Icons.badge_outlined,
                      enabled: false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField("Data de Nascimento", _dataNascimentoController,
                Icons.cake_outlined,
                keyboardType: TextInputType.datetime),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
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
            "Endereço",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField("Endereço", _enderecoController, Icons.home_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField("Cidade", _cidadeController, Icons.location_city_outlined),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField("Estado", _estadoController, Icons.map_outlined),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField("CEP", _cepController, Icons.pin_drop_outlined,
              keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
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
            "Estatísticas da Conta",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatItem("Perfil Completo", 0.85, const Color(0xFF2196F3)),
          const SizedBox(height: 16),
          _buildStatItem("Nível de Atividade", 0.72, const Color(0xFF00C853)),
          const SizedBox(height: 16),
          _buildStatItem("Segurança", 0.60, const Color(0xFFFF9800)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.star_rounded,
                    color: Color(0xFF1A237E),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Membro Premium",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Desde Janeiro 2023",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
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

  Widget _buildStatItem(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              "${(value * 100).toStringAsFixed(0)}%",
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

  Widget _buildNotificationsCard() {
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
            "Notificações",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildSwitchItem(
            "Notificações por E-mail",
            "Receba atualizações por e-mail",
            _notificacoesEmail,
            (value) => setState(() => _notificacoesEmail = value),
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            "Notificações Push",
            "Receba alertas no dispositivo",
            _notificacoesPush,
            (value) => setState(() => _notificacoesPush = value),
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            "Alertas Financeiros",
            "Avisos sobre metas e gastos",
            _notificacoesFinanceiras,
            (value) => setState(() => _notificacoesFinanceiras = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
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
            "Segurança",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildSwitchItem(
            "Autenticação de Dois Fatores",
            "Adicione uma camada extra de segurança",
            _autenticacaoDuploFator,
            (value) => setState(() => _autenticacaoDuploFator = value),
          ),
          const SizedBox(height: 16),
          _buildSecurityButton(
            "Alterar Senha",
            Icons.lock_outline_rounded,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildSecurityButton(
            "Histórico de Atividades",
            Icons.history_rounded,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
              const SizedBox(width: 8),
              Text(
                "Zona de Perigo",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Ações irreversíveis que afetam permanentemente sua conta.",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              _showDeleteAccountDialog();
            },
            icon: const Icon(Icons.delete_forever_rounded),
            label: const Text("Excluir Conta"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: _isEditMode && enabled,
          keyboardType: keyboardType,
          style: GoogleFonts.inter(fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Colors.grey[600]),
            filled: true,
            fillColor: _isEditMode && enabled ? Colors.white : Colors.grey[100],
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
              borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, preencha este campo';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF1A237E),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1A237E), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(
              'Excluir Conta',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tem certeza que deseja excluir sua conta?',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Esta ação é irreversível e você perderá:',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            _buildDeleteWarningItem('Todas as suas metas e progresso'),
            _buildDeleteWarningItem('Histórico de transações'),
            _buildDeleteWarningItem('Configurações e preferências'),
            _buildDeleteWarningItem('Acesso à conta Premium'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Seus dados serão permanentemente apagados em 30 dias.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Funcionalidade em desenvolvimento'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Excluir Conta'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteWarningItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.close_rounded, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}