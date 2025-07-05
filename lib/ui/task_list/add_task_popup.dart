import 'package:flutter/material.dart';

class AddTaskPopup extends StatefulWidget {
  const AddTaskPopup({super.key});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un élément'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Nom de l\'élément'),
          validator: (value) =>
          value == null || value.trim().isEmpty ? 'Champ requis' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}
