import 'package:flutter/material.dart';
import 'package:flutter_recyclerview_edit_delete_swipe/flutter_recyclerview_edit_delete_swipe.dart';

void main() {
  runApp(const SwipeDemoApp());
}

class SwipeDemoApp extends StatelessWidget {
  const SwipeDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Action List',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF6366F1), // Royal Indigo
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50
        cardColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF0EA5E9), // Cyan / Sky Blue
          surface: Colors.white,
          error: Color(0xFFF43F5E), // Modern Rose
        ),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskItem {
  final String id;
  String title;
  String subtitle;
  Color accentColor;
  IconData icon;
  String tag;
  String timeEstimate;

  TaskItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.icon,
    required this.tag,
    required this.timeEstimate,
  });
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _selectedTabIndex = 0; // 0: Active Tasks, 1: Archived Tasks

  final List<TaskItem> _activeTasks = [
    TaskItem(
      id: '1',
      title: 'Design app landing page',
      subtitle: 'Create a high-fidelity visual prototype in Figma',
      accentColor: const Color(0xFF6366F1), // Indigo
      icon: Icons.palette_outlined,
      tag: 'Design',
      timeEstimate: 'Today',
    ),
    TaskItem(
      id: '2',
      title: 'Buy fresh groceries',
      subtitle: 'Spinach, apples, Greek yogurt, and almond milk',
      accentColor: const Color(0xFF10B981), // Emerald
      icon: Icons.shopping_basket_outlined,
      tag: 'Shopping',
      timeEstimate: 'Tomorrow',
    ),
    TaskItem(
      id: '3',
      title: 'Review codebase changes',
      subtitle: 'Inspect PR #42 for recyclerview swipe actions',
      accentColor: const Color(0xFF0EA5E9), // Cyan / Sky
      icon: Icons.code_rounded,
      tag: 'Development',
      timeEstimate: 'Today',
    ),
    TaskItem(
      id: '4',
      title: 'Book dentist appointment',
      subtitle: 'Routine checkup and cleaning scheduled for Tuesday',
      accentColor: const Color(0xFFEC4899), // Pink
      icon: Icons.calendar_month_outlined,
      tag: 'Personal',
      timeEstimate: 'Next Week',
    ),
  ];

  final List<TaskItem> _archivedTasks = [
    TaskItem(
      id: '5',
      title: 'Prepare presentation slides',
      subtitle: 'Draft Q3 roadmap for the executive review meeting',
      accentColor: const Color(0xFFF59E0B), // Amber
      icon: Icons.slideshow_rounded,
      tag: 'Marketing',
      timeEstimate: 'Archived',
    ),
  ];

  final List<Color> _accentPresets = [
    const Color(0xFF6366F1), // Indigo
    const Color(0xFF10B981), // Emerald
    const Color(0xFF0EA5E9), // Cyan/Sky
    const Color(0xFFEC4899), // Pink
    const Color(0xFFF59E0B), // Amber
  ];

  final List<IconData> _iconPresets = [
    Icons.palette_outlined,
    Icons.shopping_basket_outlined,
    Icons.code_rounded,
    Icons.calendar_month_outlined,
    Icons.slideshow_rounded,
  ];

  void _addTask() {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final tagController = TextEditingController(text: 'Work');
    final timeController = TextEditingController(text: 'Today');
    final formKey = GlobalKey<FormState>();

    Color selectedColor = _accentPresets[0];
    IconData selectedIcon = _iconPresets[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  )
                ],
              ),
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Create New Task',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Task Title',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: titleController,
                        autofocus: true,
                        style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: 'What needs to be done?',
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.normal),
                          fillColor: const Color(0xFFF1F5F9),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a task title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Description / Subtitle',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: subtitleController,
                        style: const TextStyle(color: Color(0xFF0F172A)),
                        decoration: InputDecoration(
                          hintText: 'Provide details or notes...',
                          hintStyle: const TextStyle(color: Colors.black38),
                          fillColor: const Color(0xFFF1F5F9),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tag',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: tagController,
                                  style: const TextStyle(color: Color(0xFF0F172A)),
                                  decoration: InputDecoration(
                                    fillColor: const Color(0xFFF1F5F9),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                                const Text(
                                  'Time Estimate',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF475569),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: timeController,
                                  style: const TextStyle(color: Color(0xFF0F172A)),
                                  decoration: InputDecoration(
                                    fillColor: const Color(0xFFF1F5F9),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Theme Color',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _accentPresets.map((color) {
                          final isSelected = color == selectedColor;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedColor = color;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.black, width: 3)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select Icon Indicator',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _iconPresets.map((icon) {
                          final isSelected = icon == selectedIcon;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedIcon = icon;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? selectedColor.withValues(alpha: 0.15)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: selectedColor, width: 2)
                                    : null,
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? selectedColor : const Color(0xFF64748B),
                                size: 22,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final title = titleController.text.trim();
                            final subtitle = subtitleController.text.trim();
                            setState(() {
                              _activeTasks.add(TaskItem(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                title: title,
                                subtitle: subtitle,
                                accentColor: selectedColor,
                                icon: selectedIcon,
                                tag: tagController.text.trim(),
                                timeEstimate: timeController.text.trim(),
                              ));
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Task "$title" created!'),
                                backgroundColor: selectedColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Add Task',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _editTask(TaskItem task) async {
    final titleController = TextEditingController(text: task.title);
    final subtitleController = TextEditingController(text: task.subtitle);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Edit Task Details',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              fontSize: 18,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Task Title',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Task title cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: subtitleController,
                  style: const TextStyle(color: Color(0xFF0F172A)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Description cannot be empty';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    task.title = titleController.text.trim();
                    task.subtitle = subtitleController.text.trim();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Updated "${task.title}" successfully'),
                      backgroundColor: task.accentColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: task.accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  void _archiveTask(TaskItem task) {
    setState(() {
      _activeTasks.remove(task);
      if (!_archivedTasks.contains(task)) {
        _archivedTasks.insert(0, task);
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Archived "${task.title}"'),
        backgroundColor: const Color(0xFFF59E0B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _archivedTasks.remove(task);
              _activeTasks.add(task);
            });
          },
        ),
      ),
    );
  }

  void _unarchiveTask(TaskItem task) {
    setState(() {
      _archivedTasks.remove(task);
      _activeTasks.add(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Restored "${task.title}" to active list'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _activeTasks.remove(task);
              _archivedTasks.insert(0, task);
            });
          },
        ),
      ),
    );
  }

  Future<bool> _confirmDeleteTask(TaskItem task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFF43F5E), size: 28),
              SizedBox(width: 10),
              Text(
                'Delete Task?',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete "${task.title}"?\nThis action cannot be reverted.',
            style: const TextStyle(color: Color(0xFF475569), fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Keep Task',
                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF43F5E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    return confirm ?? false;
  }

  void _deleteActiveTask(TaskItem task) {
    setState(() {
      _activeTasks.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${task.title}"'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFF43F5E),
          onPressed: () {
            setState(() {
              _activeTasks.add(task);
            });
          },
        ),
      ),
    );
  }

  void _deleteArchivedTask(TaskItem task) {
    setState(() {
      _archivedTasks.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Permanently deleted "${task.title}"'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: const Color(0xFFF43F5E),
          onPressed: () {
            setState(() {
              _archivedTasks.insert(0, task);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTasks = _selectedTabIndex == 0 ? _activeTasks : _archivedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'RecyclerView Swipe Actions',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab selector for Active vs Archived
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTabIndex = 0;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedTabIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list_alt_rounded,
                                    size: 18,
                                    color: _selectedTabIndex == 0
                                        ? const Color(0xFF6366F1)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Active (${_activeTasks.length})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: _selectedTabIndex == 0
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTabIndex = 1;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _selectedTabIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.archive_outlined,
                                    size: 18,
                                    color: _selectedTabIndex == 1
                                        ? const Color(0xFFF59E0B)
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Archived (${_archivedTasks.length})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: _selectedTabIndex == 1
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFF64748B), size: 15),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _selectedTabIndex == 0
                              ? 'Swipe right to Archive • Swipe left to Delete • Tap to Edit'
                              : 'Swipe right to Restore • Swipe left to Delete permanently',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: _selectedTabIndex == 0
                          ? const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (_selectedTabIndex == 0
                                  ? const Color(0xFF6366F1)
                                  : const Color(0xFFF59E0B))
                              .withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedTabIndex == 0
                                  ? '${_activeTasks.length} Active Tasks'
                                  : '${_archivedTasks.length} Archived Tasks',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedTabIndex == 0
                                  ? 'Swipe right to move items to archive'
                                  : 'View, restore, or delete archived items',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _selectedTabIndex == 0
                                ? Icons.task_alt_rounded
                                : Icons.archive_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          currentTasks.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedTabIndex == 0
                              ? Icons.done_all_rounded
                              : Icons.archive_outlined,
                          size: 72,
                          color: const Color(0xFF94A3B8).withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedTabIndex == 0
                              ? 'No active tasks!'
                              : 'No archived tasks',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _selectedTabIndex == 0
                              ? 'Create a task below to start tracking.'
                              : 'Archived items will appear here.',
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = currentTasks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: _selectedTabIndex == 0
                              ? SwipeActionTile(
                                  key: ValueKey('active_${task.id}'),
                                  borderRadius: BorderRadius.circular(20),
                                  archiveColor: const Color(0xFFF59E0B),
                                  deleteColor: const Color(0xFFF43F5E),
                                  archiveIcon: Icons.archive_rounded,
                                  deleteIcon: Icons.delete_outline_rounded,
                                  archiveLabel: 'Archive',
                                  deleteLabel: 'Delete',
                                  archiveDirection: DismissDirection.startToEnd,
                                  onEdit: () => _editTask(task),
                                  onArchive: () => _archiveTask(task),
                                  confirmDelete: () => _confirmDeleteTask(task),
                                  onDelete: () => _deleteActiveTask(task),
                                  child: _buildTaskCard(task),
                                )
                              : SwipeActionTile(
                                  key: ValueKey('archived_${task.id}'),
                                  borderRadius: BorderRadius.circular(20),
                                  archiveColor: const Color(0xFF10B981),
                                  deleteColor: const Color(0xFFF43F5E),
                                  archiveIcon: Icons.unarchive_rounded,
                                  deleteIcon: Icons.delete_forever_rounded,
                                  archiveLabel: 'Restore',
                                  deleteLabel: 'Delete',
                                  archiveDirection: DismissDirection.startToEnd,
                                  onArchive: () => _unarchiveTask(task),
                                  confirmDelete: () => _confirmDeleteTask(task),
                                  onDelete: () => _deleteArchivedTask(task),
                                  child: _buildTaskCard(task, isArchived: true),
                                ),
                        );
                      },
                      childCount: currentTasks.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton(
              onPressed: _addTask,
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add_rounded, size: 26),
            )
          : null,
    );
  }

  Widget _buildTaskCard(TaskItem task, {bool isArchived = false}) {
    return InkWell(
      onTap: isArchived ? null : () => _editTask(task),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEDF2F7),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 5,
                  color: isArchived ? const Color(0xFF94A3B8) : task.accentColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (isArchived ? const Color(0xFF64748B) : task.accentColor)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            task.icon,
                            color: isArchived ? const Color(0xFF64748B) : task.accentColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isArchived
                                      ? const Color(0xFF64748B)
                                      : const Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                  decoration: isArchived ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.subtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (isArchived ? const Color(0xFF64748B) : task.accentColor)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      task.tag,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        color: isArchived
                                            ? const Color(0xFF64748B)
                                            : task.accentColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isArchived
                                              ? Icons.archive_outlined
                                              : Icons.access_time_rounded,
                                          size: 11,
                                          color: const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isArchived ? 'Archived' : task.timeEstimate,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!isArchived)
                          const Icon(
                            Icons.edit_outlined,
                            color: Color(0xFF94A3B8),
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
