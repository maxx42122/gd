import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../providers/providers.dart';
import '../../utils/theme.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  const ProfileSetupScreen({super.key, this.isEdit = false});
  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _gender = 'Male';
  final List<String> _history = [];
  final List<String> _allergies = [];
  final _historyCtrl = TextEditingController();
  final _allergyCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    if (profile != null && profile.isComplete) {
      _nameCtrl.text = profile.name;
      _ageCtrl.text = profile.age.toString();
      _gender = profile.gender.isNotEmpty ? profile.gender : 'Male';
      _history.addAll(profile.medicalHistory);
      _allergies.addAll(profile.allergies);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _historyCtrl.dispose();
    _allergyCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _ageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in name and age')),
      );
      return;
    }
    setState(() => _saving = true);
    final auth = ref.read(authStateProvider).value;
    final profile = UserProfile(
      uid: auth?.uid ?? 'guest',
      name: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      gender: _gender,
      medicalHistory: List.from(_history),
      allergies: List.from(_allergies),
    );
    await ref.read(userProfileProvider.notifier).save(profile);
    if (mounted) {
      if (widget.isEdit) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Profile' : 'Set Up Profile'),
        leading: widget.isEdit
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isEdit) ...[
              Text(
                'Tell us about yourself',
                style: Theme.of(context).textTheme.headlineMedium,
              ).animate().fadeIn(),
              const SizedBox(height: 6),
              Text(
                'This helps us give you more accurate assessments.',
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 28),
            ],
            _label('Full Name'),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: AppTheme.kTextPrimary),
              decoration: const InputDecoration(
                hintText: 'Your name',
                prefixIcon:
                    Icon(Icons.person_outline, color: AppTheme.kTextSecondary),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Age'),
                      TextField(
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppTheme.kTextPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Years',
                          prefixIcon: Icon(Icons.cake_outlined,
                              color: AppTheme.kTextSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Gender'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.kCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.kBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _gender,
                            dropdownColor: AppTheme.kCard,
                            style:
                                const TextStyle(color: AppTheme.kTextPrimary),
                            isExpanded: true,
                            items: ['Male', 'Female', 'Other']
                                .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    ))
                                .toList(),
                            onChanged: (v) => setState(() => _gender = v!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _label('Medical History (optional)'),
            _tagInput(
              controller: _historyCtrl,
              tags: _history,
              hint: 'e.g. Diabetes, Hypertension',
              onAdd: (v) => setState(() => _history.add(v)),
              onRemove: (v) => setState(() => _history.remove(v)),
            ),
            const SizedBox(height: 16),
            _label('Allergies (optional)'),
            _tagInput(
              controller: _allergyCtrl,
              tags: _allergies,
              hint: 'e.g. Penicillin, Peanuts',
              onAdd: (v) => setState(() => _allergies.add(v)),
              onRemove: (v) => setState(() => _allergies.remove(v)),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(widget.isEdit ? 'Save Changes' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: AppTheme.kTextSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500)),
      );

  Widget _tagInput({
    required TextEditingController controller,
    required List<String> tags,
    required String hint,
    required void Function(String) onAdd,
    required void Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: AppTheme.kTextPrimary),
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) {
                    onAdd(v.trim());
                    controller.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onAdd(controller.text.trim());
                  controller.clear();
                }
              },
              icon:
                  const Icon(Icons.add_circle_rounded, color: AppTheme.kAccent),
            ),
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: tags
                .map((t) => Chip(
                      label: Text(t, style: const TextStyle(fontSize: 12)),
                      deleteIcon: const Icon(Icons.close,
                          size: 14, color: AppTheme.kTextSecondary),
                      onDeleted: () => onRemove(t),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}
