import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model for Student (Child)
class ChildProfile {
  final int id;
  final String name;
  final String className;
  final String sectionName;
  final String? profilePhoto;
  final String todayStatus; // Present, Absent, Pending

  ChildProfile({
    required this.id,
    required this.name,
    required this.className,
    required this.sectionName,
    this.profilePhoto,
    this.todayStatus = 'Pending',
  });
}

class ParentChildrenNotifier extends StateNotifier<List<ChildProfile>> {
  ParentChildrenNotifier() : super([]) {
    _loadChildren();
  }

  void _loadChildren() {
    // Mock Data for v1 UI dev
    state = [
      ChildProfile(id: 1, name: 'Aditya Sharma', className: '10', sectionName: 'A', todayStatus: 'Present'),
      ChildProfile(id: 2, name: 'Esha Sharma', className: '5', sectionName: 'C', todayStatus: 'Absent'),
    ];
  }
}

// All children provider
final parentChildrenProvider = StateNotifierProvider<ParentChildrenNotifier, List<ChildProfile>>((ref) {
  return ParentChildrenNotifier();
});

// Currently selected child index
final selectedChildIndexProvider = StateProvider<int>((ref) => 0);

// Selected student profile
final selectedChildProvider = Provider<ChildProfile>((ref) {
  final children = ref.watch(parentChildrenProvider);
  final index = ref.watch(selectedChildIndexProvider);
  if (children.isEmpty) return ChildProfile(id: 0, name: '', className: '', sectionName: '');
  return children[index];
});
