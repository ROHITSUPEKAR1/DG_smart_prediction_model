import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeworkFormState {
  final String subject;
  final String caption;
  final List<int> selectedClassIds;
  final List<String> attachments; // Mock file paths
  final bool isSubmitting;

  HomeworkFormState({
    this.subject = '',
    this.caption = '',
    this.selectedClassIds = const [],
    this.attachments = const [],
    this.isSubmitting = false,
  });

  HomeworkFormState copyWith({
    String? subject,
    String? caption,
    List<int>? selectedClassIds,
    List<String>? attachments,
    bool? isSubmitting,
  }) {
    return HomeworkFormState(
      subject: subject ?? this.subject,
      caption: caption ?? this.caption,
      selectedClassIds: selectedClassIds ?? this.selectedClassIds,
      attachments: attachments ?? this.attachments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class HomeworkFormNotifier extends StateNotifier<HomeworkFormState> {
  HomeworkFormNotifier() : super(HomeworkFormState());

  void setSubject(String val) => state = state.copyWith(subject: val);
  void setCaption(String val) => state = state.copyWith(caption: val);
  
  void toggleClass(int id) {
    var ids = List<int>.from(state.selectedClassIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(selectedClassIds: ids);
  }

  void addAttachment(String path) {
    state = state.copyWith(attachments: [...state.attachments, path]);
  }

  Future<bool> submit() async {
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(seconds: 2)); // Mock API call
    state = state.copyWith(isSubmitting: false);
    return true;
  }
}

final homeworkFormProvider = StateNotifierProvider<HomeworkFormNotifier, HomeworkFormState>((ref) {
  return HomeworkFormNotifier();
});
