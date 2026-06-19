import 'package:flutter/material.dart';

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
class PrioritySelector extends StatefulWidget {
  const PrioritySelector({super.key});

  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State <PrioritySelector> {
  String _selected = 'B'; //Prioridad intermedia como el valor inicial

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'A', label: Text('A')),
        ButtonSegment(value: 'B', label: Text('B')),
        ButtonSegment(value: 'C', label: Text('C')),
      ],
      selected: {_selected},
      onSelectionChanged: (newSelection) {
        setState(() {
          _selected = newSelection.first;
        });
      },
    );
  }
}

//Selector de categoria
class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String _selected = 'Neuroplasticity';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: ['Body', 'Neuroplasticity', 'Motion'].map((cat) {
        final isSelected = _selected == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (_) {
            setState(() {
              _selected = cat;
            });
          },
        );
      }).toList(),
    );
  }
}

//Togle de repeticion
class RepeatToggle extends StatefulWidget {
  const RepeatToggle({super.key});

  @override
  State<RepeatToggle> createState() => _RepeatToggleState();
}

class _RepeatToggleState extends State<RepeatToggle> {
  bool _repeats = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        _repeats ? 'Every week' : 'Does not repeat',
        style: const TextStyle(fontSize: 14),
      ),
      value: _repeats,
      onChanged: (newValue) {
        setState(() {
          _repeats = newValue;
        });
      },
    );
  }
}