import 'package:flutter/material.dart';
import 'package:okami/models/task_model.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}


//Selector de prioridad
class PrioritySelector extends StatelessWidget {
  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  const PrioritySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const [
        ButtonSegment(value: TaskPriority.a, label: Text('A')),
        ButtonSegment(value: TaskPriority.b, label: Text('B')),
        ButtonSegment(value: TaskPriority.c, label: Text('C')),
      ],
      selected: {value},
      onSelectionChanged: (newSelection) => onChanged(newSelection.first),
    );
  }
}


//Selector de categoria
class CategorySelector extends StatelessWidget {
  final TaskCategory value;
  final ValueChanged<TaskCategory> onChanged;

  const CategorySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  //Helper para el display de los nombres de las categorias
  String _label(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.body:
        return 'Body';
      case TaskCategory.neuroplasticity:
        return 'Neuroplasticity';
      case TaskCategory.motion:
        return 'Motion';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: TaskCategory.values.map((cat) {
        return ChoiceChip(
          label: Text(_label(cat)),
          selected: value == cat,
          onSelected: (_) => onChanged(cat),
        );
      }).toList(),
    );
  }
}


//Togle de repeticion
class RepeatToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RepeatToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        value ? 'Every week' : 'Does not repeat',
        style: const TextStyle(fontSize: 14),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}