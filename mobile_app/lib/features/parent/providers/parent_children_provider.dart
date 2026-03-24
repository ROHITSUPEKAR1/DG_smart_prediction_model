import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/cache/cache_manager.dart';
import 'package:mobile_app/core/cache/cache_keys.dart';

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'className': className,
    'sectionName': sectionName,
    'profilePhoto': profilePhoto,
    'todayStatus': todayStatus,
  };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
    id: json['id'],
    name: json['name'],
    className: json['className'],
    sectionName: json['sectionName'],
    profilePhoto: json['profilePhoto'],
    todayStatus: json['todayStatus'] ?? 'Pending',
  );
}

class ParentChildrenNotifier extends StateNotifier<List<ChildProfile>> {
  ParentChildrenNotifier() : super([]) {
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    try {
      // Mock Data for v1 UI dev (replace with real Dio call)
      final children = [
        ChildProfile(id: 1, name: 'Aditya Sharma', className: '10', sectionName: 'A', todayStatus: 'Present'),
        ChildProfile(id: 2, name: 'Esha Sharma', className: '5', sectionName: 'C', todayStatus: 'Absent'),
      ];

      // Cache on success
      await CacheManager.put(
        CacheKeys.parentChildren,
        children.map((c) => c.toJson()).toList(),
      );

      state = children;
    } catch (e) {
      // Fallback to cache on network failure
      final cached = CacheManager.get<List<dynamic>>(CacheKeys.parentChildren);
      if (cached != null) {
        state = cached
            .map((item) => ChildProfile.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    }
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
