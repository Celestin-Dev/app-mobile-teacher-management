import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher_management/core/widgets/image_source_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../departement/data/models/department_model.dart';
import '../../../departement/presentation/providers/departement_providers.dart';
import '../providers/teacher_providers.dart';
import '../widgets/photo_picker_avatar.dart';

class AddTeacherScreen extends ConsumerStatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  ConsumerState<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends ConsumerState<AddTeacherScreen> {
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specialtyController = TextEditingController();

  int? _selectedDepartmentId;
  bool _isSaving = false;
  String? _errorMessage;
  File? _pickedPhoto;

  Future<void> _pickPhoto() async {
    final xfile = await ImageSourceSheet.show(context);
    if (xfile != null) {
      setState(() => _pickedPhoto = File(xfile.path));
    }
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specialtyController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (lastName.isEmpty) {
      setState(() => _errorMessage = 'Le nom est requis');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Email invalide');
      return;
    }
    if (_selectedDepartmentId == null) {
      setState(() => _errorMessage = 'Veuillez sélectionner un département');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(teacherRepositoryProvider)
          .createTeacher(
            lastName: lastName,
            firstName: _firstNameController.text.trim(),
            email: email,
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
            departmentId: _selectedDepartmentId!,
            specialty: _specialtyController.text.trim().isEmpty
                ? null
                : _specialtyController.text.trim(),
          );

      ref.invalidate(teacherListProvider);

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Échec de l\'ajout : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentListProvider);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const Divider(height: 1, color: AppColors.line),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  children: [
                    PhotoPickerAvatar(
                      localFile: _pickedPhoto,
                      photoUrl: null,
                      onTap: _pickPhoto,
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      label: 'Nom',
                      required: true,
                      controller: _lastNameController,
                      hint: 'Alan',
                    ),

                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Prénom',
                      controller: _firstNameController,
                      hint: 'Turing',
                    ),

                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Email',
                      required: true,
                      controller: _emailController,
                      hint: 'a.turing@stateuniversity.edu',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Téléphone',
                      controller: _phoneController,
                      hint: '+ 261 34 00 000 00',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),

                    _buildLabel('Department', required: true),
                    const SizedBox(height: 8),
                    departmentsAsync.when(
                      data: (departments) =>
                          _buildDepartmentDropdown(departments),
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      error: (e, _) => const Text(
                        'Impossible de charger les départements',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildTextField(
                      label: 'Spécialité',
                      controller: _specialtyController,
                      hint: 'Cybersécurité',
                    ),

                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: OutlinedButton(
                              onPressed: _isSaving
                                  ? null
                                  : () => Navigator.of(context).maybePop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.ink,
                                side: const BorderSide(
                                  color: AppColors.line,
                                  width: 1.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Annuler',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.eniGreen,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Ajouter',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.chevron_left,
              color: AppColors.eniGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'Nouveaux enseignant',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.eniGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        children: [
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.danger),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, required: required),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.iconGrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line, width: 1.4),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line, width: 1.4),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.eniGreen,
                width: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown(List<DepartmentModel> departments) {
    final validValue = departments.any((d) => d.id == _selectedDepartmentId)
        ? _selectedDepartmentId
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.line, width: 1.4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: validValue,
          isExpanded: true,
          hint: const Text(
            'Informatique generale',
            style: TextStyle(fontSize: 15, color: AppColors.iconGrey),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.inkSoft),
          style: const TextStyle(fontSize: 15, color: AppColors.ink),
          items: departments
              .map(
                (d) => DropdownMenuItem<int>(value: d.id, child: Text(d.name)),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedDepartmentId = value),
        ),
      ),
    );
  }
}
