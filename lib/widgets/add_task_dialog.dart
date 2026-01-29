import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/tasks_cubit.dart';
import '../blocs/task_model.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  bool _isDescriptionExpanded = false;
  bool _isDateExpanded = false;
  bool _isStepsExpanded = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFFDFE1D3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFA9AD90),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add Task title
                  Text(
                    'Add Task',
                    style: const TextStyle(
                      color: Color(0xFF3D402E),
                      fontFamily: 'WixMadeforText',
                      fontSize: 38, // 2.375rem assuming 16px base, 16*2.375=38
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.38, // -0.02375rem assuming 16px base
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Task name',
                    style: const TextStyle(
                      color: Color(0xFFA9AD90),
                      fontFamily: 'WixMadeforText',
                      fontSize: 20, // 1.25rem
                      fontWeight: FontWeight.w600,
                      height: 0.8, // line-height: 1rem / fontSize 20 = 0.8? Wait, 1rem=16px, but fontSize=20, lineHeight=16/20=0.8
                    ),
                  ),
                  const SizedBox(height: 8),
                  Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: const Color(0xFF73AE50),
                        selectionColor: const Color(0x4D73AE50),
                        selectionHandleColor: const Color(0xFF73AE50),
                      ),
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      maxLines: 1,
                      cursorColor: const Color(0xFF73AE50),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)), // 0.3125rem = 5px
                          borderSide: BorderSide(
                            color: Color(0xFF364027),
                            width: 3,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color(0xFF364027),
                            width: 3,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color(0xFF364027),
                            width: 3,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Add Description
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Add Description',
                          style: const TextStyle(
                            color: Color(0xFF364027),
                            fontFamily: 'WixMadeforText',
                            fontSize: 24, // 1.5rem
                            fontWeight: FontWeight.w500,
                            height: 0.6667, // 1rem / 1.5rem
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _isDescriptionExpanded ? FontAwesomeIcons.minus : FontAwesomeIcons.plus,
                          color: const Color(0xFF364027),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  if (_isDescriptionExpanded) ...[
                    const SizedBox(height: 8),
                    Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: const Color(0xFF73AE50),
                          selectionColor: const Color(0x4D73AE50),
                          selectionHandleColor: const Color(0xFF73AE50),
                        ),
                      ),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        cursorColor: const Color(0xFF73AE50),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFF364027),
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFF364027),
                              width: 3,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color(0xFF364027),
                              width: 3,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Set Date
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isDateExpanded = !_isDateExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Set Date',
                          style: const TextStyle(
                            color: Color(0xFF364027),
                            fontFamily: 'WixMadeforText',
                            fontSize: 24, // 1.5rem
                            fontWeight: FontWeight.w500,
                            height: 0.6667, // 1rem / 1.5rem
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _isDateExpanded ? FontAwesomeIcons.minus : FontAwesomeIcons.plus,
                          color: const Color(0xFF364027),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  if (_isDateExpanded) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF73AE50), // header background
                                  onPrimary: Colors.white, // header text
                                  onSurface: Color(0xFF364027), // body text
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Color(0xFF73AE50), // button text
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF364027),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                              style: const TextStyle(
                                color: Color(0xFF364027),
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              FontAwesomeIcons.calendar,
                              color: Color(0xFF364027),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Add Steps
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isStepsExpanded = !_isStepsExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Add Steps',
                          style: const TextStyle(
                            color: Color(0xFF364027),
                            fontFamily: 'WixMadeforText',
                            fontSize: 24, // 1.5rem
                            fontWeight: FontWeight.w500,
                            height: 0.6667, // 1rem / 1.5rem
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _isStepsExpanded ? FontAwesomeIcons.minus : FontAwesomeIcons.plus,
                          color: const Color(0xFF364027),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  if (_isStepsExpanded) ...[
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        ..._stepControllers.asMap().entries.map((entry) {
                          final index = entry.key;
                          final controller = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      textSelectionTheme: TextSelectionThemeData(
                                        cursorColor: const Color(0xFF73AE50),
                                        selectionColor: const Color(0x4D73AE50),
                                        selectionHandleColor: const Color(0xFF73AE50),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: controller,
                                      maxLines: 1,
                                      cursorColor: const Color(0xFF73AE50),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: BorderSide(
                                            color: Color(0xFF364027),
                                            width: 3,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: BorderSide(
                                            color: Color(0xFF364027),
                                            width: 3,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: BorderSide(
                                            color: Color(0xFF364027),
                                            width: 3,
                                          ),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_stepControllers.length > 1)
                                  IconButton(
                                    icon: const Icon(
                                      FontAwesomeIcons.minus,
                                      color: Color(0xFF364027),
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _stepControllers.removeAt(index);
                                      });
                                    },
                                  ),
                              ],
                            ),
                          );
                        }),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.plus,
                            color: Color(0xFF364027),
                            size: 16,
                          ),
                          onPressed: () {
                            setState(() {
                              _stepControllers.add(TextEditingController());
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3D402E),
                          textStyle: const TextStyle(
                            fontFamily: 'WixMadeforText',
                            fontSize: 24, // 1.5rem
                            fontWeight: FontWeight.w600,
                            height: 1.0, // 1.5rem / 1.5rem
                            letterSpacing: -0.24, // -0.015rem assuming 16px base
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: _titleController.text.trim().isNotEmpty
                            ? () {
                                final title = _titleController.text.trim();
                                final description = _descriptionController.text.trim();
                                final steps = _stepControllers
                                    .map((c) => c.text.trim())
                                    .where((s) => s.isNotEmpty)
                                    .toList();
                                final completedSteps = steps.isNotEmpty ? List<bool>.filled(steps.length, false) : null;
                                final task = Task(
                                  id: DateTime.now().toString(),
                                  title: title,
                                  subtitle: description.isNotEmpty ? description : '',
                                  description: description,
                                  steps: steps,
                                  completedSteps: completedSteps,
                                  dueDate: _selectedDate,
                                );
                                context.read<TasksCubit>().addTask(task);
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: TextButton.styleFrom(
                          foregroundColor: _titleController.text.trim().isNotEmpty
                              ? const Color(0xFF73AE50)
                              : const Color(0xFFB7B8B2),
                          textStyle: const TextStyle(
                            fontFamily: 'WixMadeforText',
                            fontSize: 24, // 1.5rem
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            letterSpacing: -0.24,
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}