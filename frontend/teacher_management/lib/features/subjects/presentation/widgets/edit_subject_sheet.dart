// features/subjects/presentation/widgets/edit_subject_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../group/data/models/group_model.dart';
import '../../data/models/subject_model.dart';
import '../providers/subject_providers.dart';
import '../../../group/presentation/providers/group_providers.dart';

class EditSubjectSheet extends ConsumerStatefulWidget {
  final SubjectModel subject;
  const EditSubjectSheet({super.key, required this.subject});

  static Future<bool> show(BuildContext context, SubjectModel subject) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditSubjectSheet(subject: subject),
    );
    return result ?? false;
  }

  @override
  ConsumerState<EditSubjectSheet> createState() => _EditSubjectSheetState();
}

class _EditSubjectSheetState extends ConsumerState<EditSubjectSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _creditsController;
  int? _selectedGroupId;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.subject.name);
    _creditsController = TextEditingController(
      text: widget.subject.credits == widget.subject.credits.roundToDouble()
          ? widget.subject.credits.toInt().toString()
          : widget.subject.credits.toString(),
    );
    _selectedGroupId = widget.subject.groupId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final credits = double.tryParse(
      _creditsController.text.trim().replaceAll(',', '.'),
    );

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Le nom de la matière est requis');
      return;
    }
    if (credits == null || credits <= 0) {
      setState(() => _errorMessage = 'Nombre de crédits invalide');
      return;
    }
    if (_selectedGroupId == null) {
      setState(() => _errorMessage = 'Veuillez sélectionner un parcours');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(subjectRepositoryProvider)
          .updateSubject(
            subjectId: widget.subject.id,
            name: name,
            credits: credits,
            groupId: _selectedGroupId,
          );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Échec de l\'enregistrement : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupListProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Modifier la matière',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Nom de la matière'),
            const SizedBox(height: 8),
            _buildField(controller: _nameController),

            const SizedBox(height: 16),
            _buildLabel('Crédits'),
            const SizedBox(height: 8),
            _buildField(
              controller: _creditsController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: 16),
            _buildLabel('Parcours'),
            const SizedBox(height: 8),
            groupsAsync.when(
              data: (groups) => _buildGroupDropdown(groups),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (e, _) => Text(
                'Impossible de charger les parcours',
                style: const TextStyle(color: AppColors.danger, fontSize: 12.5),
              ),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.danger, fontSize: 12.5),
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
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
                        'Enregistrer',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupDropdown(List<GroupModel> groups) {
    // Sécurité : si le groupe actuel n'est pas (ou plus) dans la liste, on évite un crash du Dropdown
    final validValue = groups.any((g) => g.id == _selectedGroupId)
        ? _selectedGroupId
        : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: validValue,
          isExpanded: true,
          hint: const Text(
            'Sélectionner un parcours',
            style: TextStyle(fontSize: 14, color: AppColors.iconGrey),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.inkSoft),
          style: const TextStyle(fontSize: 15, color: AppColors.ink),
          items: groups
              .map(
                (g) => DropdownMenuItem<int>(
                  value: g.id,
                  child: Text('${g.shortLabel} — ${g.name}'),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _selectedGroupId = value),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
      color: AppColors.inkSoft,
    ),
  );

  Widget _buildField({
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: AppColors.ink),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
