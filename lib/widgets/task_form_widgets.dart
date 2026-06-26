import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:okami/models/task_model.dart';
import 'package:okami/theme/app_theme.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
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

//Widget para la seleccion de tiempo
class DurationSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const DurationSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  //Helper para el formato horas + minutos
  String _label() {
    return value.asDuration;
  }

  //Logica para el selecetor
  void _openPicker(BuildContext context) {
    Duration temp = Duration(minutes: value);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
         
              Align(//Boton de Done
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                  onPressed: () {
                    onChanged(temp.inMinutes);//Sube el dato de tiempo seleccionado
                    Navigator.pop(sheetContext);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: AppColors.ultramarineBright, fontSize: 16)
                  ),
                ),
              ),

              Expanded(//Selector de tiempo
                child: CupertinoTheme(
                  data: CupertinoThemeData(brightness: Brightness.dark),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: temp,
                    minuteInterval: 5,
                    onTimerDurationChanged: (d) => temp = d
                  )
                )
              )

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openPicker(context),//Abre el picker de tiempo creado
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.hairline),
          borderRadius: BorderRadius.circular(12),
        ),

        child: Row(
          children: [
            const Icon(
              CupertinoIcons.clock, 
              size: 18,
              color: AppColors.inkMuted
            ),
            const SizedBox(width: 10),
            Text(
              _label(),
              style: const TextStyle(color: AppColors.ink, fontSize: 16),
            ),
            const Spacer(), 
            const Icon(
              CupertinoIcons.chevron_down,
              size: 16,
              color: AppColors.inkFaint
            ),
          ],
        ),
      ),
    );
  }
}