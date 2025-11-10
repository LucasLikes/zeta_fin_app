import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class AddTransactionPopup extends StatefulWidget {
  const AddTransactionPopup({super.key});

  // CORRIGIDO: Agora retorna Future<bool?> ao invés de Future<void>
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const AddTransactionPopup(),
    );
  }

  @override
  State<AddTransactionPopup> createState() => _AddTransactionPopupState();
}

class _AddTransactionPopupState extends State<AddTransactionPopup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // Controllers para Receitas
  final _incomeValueController = TextEditingController();
  final _incomeDescriptionController = TextEditingController();
  final _incomeDateController = TextEditingController();
  String? _selectedIncomeCategory;

  // Controllers para Despesas
  final _expenseValueController = TextEditingController();
  final _expenseDescriptionController = TextEditingController();
  final _expenseDateController = TextEditingController();
  String? _selectedExpenseCategory;
  String? _selectedExpenseType; // fixas, variaveis, desnecessarios

  // Upload de arquivo
  Uint8List? _uploadedFileBytes;
  String? _uploadedFileName;
  bool _isProcessingOCR = false;

  final List<String> _incomeCategories = [
    'Salário',
    'Freelance',
    'Investimentos',
    'Aluguel Recebido',
    'Bônus',
    'Outros',
  ];

  final List<String> _expenseCategories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Educação',
    'Lazer',
    'Compras',
    'Contas Fixas',
    'Outros',
  ];

  final List<Map<String, dynamic>> _expenseTypes = [
    {
      'value': 'fixas',
      'label': 'Contas Fixas',
      'color': const Color(0xFF2196F3),
      'icon': Icons.receipt_long_rounded,
    },
    {
      'value': 'variaveis',
      'label': 'Contas Variáveis',
      'color': const Color(0xFFFFA000),
      'icon': Icons.shopping_cart_rounded,
    },
    {
      'value': 'desnecessarios',
      'label': 'Gastos Desnecessários',
      'color': const Color(0xFFE91E63),
      'icon': Icons.warning_amber_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _incomeValueController.dispose();
    _incomeDescriptionController.dispose();
    _incomeDateController.dispose();
    _expenseValueController.dispose();
    _expenseDescriptionController.dispose();
    _expenseDateController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _uploadedFileBytes = result.files.single.bytes;
          _uploadedFileName = result.files.single.name;
        });

        // Simular processamento OCR
        _processOCR();
      }
    } catch (e) {
      _showSnackBar('Erro ao selecionar arquivo: $e', isError: true);
    }
  }

  Future<void> _processOCR() async {
    setState(() => _isProcessingOCR = true);

    // Aqui você vai chamar o endpoint do backend para processar o OCR
    await Future.delayed(const Duration(seconds: 2)); // Simulação

    // Dados fictícios retornados pelo OCR
    setState(() {
      _expenseValueController.text = '125.50';
      _expenseDescriptionController.text = 'Supermercado Extra';
      _expenseDateController.text = DateTime.now().toString().split(' ')[0];
      _selectedExpenseCategory = 'Alimentação';
      _selectedExpenseType = 'variaveis';
      _isProcessingOCR = false;
    });

    _showSnackBar('Recibo processado com sucesso!', isError: false);
  }

  Future<void> _submitIncome() async {
  if (_incomeValueController.text.isEmpty ||
      _incomeDescriptionController.text.isEmpty ||
      _selectedIncomeCategory == null ||
      _incomeDateController.text.isEmpty) {
    _showSnackBar('Por favor, preencha todos os campos', isError: true);
    return;
  }

  setState(() => _isLoading = true);

  try {
    final parsedValue =
        double.tryParse(_incomeValueController.text.replaceAll(',', '.'));
    if (parsedValue == null) {
      _showSnackBar('Valor inválido', isError: true);
      return;
    }

    // Preparar dados para enviar ao backend
    final incomeData = {
      'type': 0, // 0 = income, conforme seu backend
      'value': parsedValue,
      'description': _incomeDescriptionController.text,
      'category': _selectedIncomeCategory,
      'expenseType': null, // receita não possui tipo de despesa
      'date': DateTime.parse(_incomeDateController.text).toIso8601String(),
      'hasReceipt': false,
      'userId': 'USER_ID_PLACEHOLDER', // Substituir pelo ID do usuário logado
    };

    // TODO: Chamar endpoint do backend
    // Exemplo:
    // await transactionController.createTransaction(
    //   type: 'income',
    //   value: parsedValue,
    //   description: _incomeDescriptionController.text,
    //   category: _selectedIncomeCategory!,
    //   date: _incomeDateController.text,
    // );

    await Future.delayed(const Duration(seconds: 1)); // Simulação

    _showSnackBar('Receita adicionada com sucesso!', isError: false);

    if (mounted) {
      Navigator.of(context).pop(true); // Fecha o diálogo e retorna sucesso
    }
  } catch (e) {
    _showSnackBar('Erro ao adicionar receita: $e', isError: true);
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  Future<void> _submitExpense() async {
    if (_expenseValueController.text.isEmpty ||
        _expenseDescriptionController.text.isEmpty ||
        _selectedExpenseCategory == null ||
        _selectedExpenseType == null ||
        _expenseDateController.text.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Preparar dados para enviar ao backend
      final expenseData = {
        'type': 'expense',
        'value': double.parse(_expenseValueController.text.replaceAll(',', '.')),
        'description': _expenseDescriptionController.text,
        'category': _selectedExpenseCategory,
        'expenseType': _selectedExpenseType, // fixas, variaveis, desnecessarios
        'date': _expenseDateController.text,
        'userId': 'USER_ID_PLACEHOLDER', // Substituir pelo ID do usuário logado
        'hasReceipt': _uploadedFileBytes != null,
      };

      // TODO: Chamar endpoint do backend
      // await _transactionController.createTransaction(...);

      // Se houver arquivo de recibo, enviar separadamente
      if (_uploadedFileBytes != null) {
        // TODO: Upload do arquivo
        // await _transactionController.createTransactionWithReceipt(...);
      }

      await Future.delayed(const Duration(seconds: 1)); // Simulação

      _showSnackBar('Despesa adicionada com sucesso!', isError: false);
      
      // Fecha o diálogo e retorna true para indicar sucesso
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      _showSnackBar('Erro ao adicionar despesa: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 900,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildIncomeTab(),
                  _buildExpenseTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nova Transação',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Adicione receitas ou despesas de forma inteligente',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF1A237E),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.arrow_downward_rounded),
            text: 'Receitas',
          ),
          Tab(
            icon: Icon(Icons.arrow_upward_rounded),
            text: 'Despesas',
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informações da Receita'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _incomeValueController,
            label: 'Valor',
            hint: 'R\$ 0,00',
            icon: Icons.attach_money_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _incomeDescriptionController,
            label: 'Descrição',
            hint: 'Ex: Salário de Outubro',
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Categoria',
            hint: 'Selecione uma categoria',
            value: _selectedIncomeCategory,
            items: _incomeCategories,
            onChanged: (value) => setState(() => _selectedIncomeCategory = value),
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 16),
          _buildDateField(
            controller: _incomeDateController,
            label: 'Data de Recebimento',
          ),
          const SizedBox(height: 32),
          _buildSubmitButton(
            text: 'Adicionar Receita',
            onPressed: _submitIncome,
            color: const Color(0xFF00C853),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload de Recibo
          _buildSectionTitle('Upload de Recibo (Opcional)'),
          const SizedBox(height: 16),
          _buildUploadArea(),
          const SizedBox(height: 24),

          _buildSectionTitle('Informações da Despesa'),
          const SizedBox(height: 16),

          // Tipo de Despesa
          _buildExpenseTypeSelector(),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _expenseValueController,
            label: 'Valor',
            hint: 'R\$ 0,00',
            icon: Icons.attach_money_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _expenseDescriptionController,
            label: 'Descrição',
            hint: 'Ex: Compra no supermercado',
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Categoria',
            hint: 'Selecione uma categoria',
            value: _selectedExpenseCategory,
            items: _expenseCategories,
            onChanged: (value) => setState(() => _selectedExpenseCategory = value),
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 16),
          _buildDateField(
            controller: _expenseDateController,
            label: 'Data da Despesa',
          ),
          const SizedBox(height: 32),
          _buildSubmitButton(
            text: 'Adicionar Despesa',
            onPressed: _submitExpense,
            color: const Color(0xFFE91E63),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
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
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[600]),
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
            filled: true,
            fillColor: Colors.grey[50],
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Selecione a data',
            prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.grey[600]),
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
            filled: true,
            fillColor: Colors.grey[50],
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              controller.text = date.toString().split(' ')[0];
            }
          },
        ),
      ],
    );
  }

  Widget _buildExpenseTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Despesa',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _expenseTypes.map((type) {
            final isSelected = _selectedExpenseType == type['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedExpenseType = type['value']),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? type['color'] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? type['color'] : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        type['icon'],
                        color: isSelected ? Colors.white : type['color'],
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        type['label'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: _uploadedFileBytes == null
            ? Column(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Clique para fazer upload do recibo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Formatos aceitos: JPG, PNG, PDF',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : _isProcessingOCR
                ? Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Processando recibo...',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _uploadedFileName!,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Recibo processado com sucesso',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _uploadedFileBytes = null;
                            _uploadedFileName = null;
                          });
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildSubmitButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}