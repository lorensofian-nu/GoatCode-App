class LessonChoice {
  final String id;
  final String text;

  const LessonChoice({required this.id, required this.text});
}

class Lesson {
  final String id;
  final String moduleId;
  final String moduleTitle;
  final String title;
  final String analogyTitle;
  final String analogyText;
  final String codeSnippet;
  final String question;
  final List<LessonChoice> choices;
  final int correctChoiceIndex;
  final String explanationSuccess;
  final String explanationFailure;
  final String hint;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.moduleId,
    required this.moduleTitle,
    required this.title,
    required this.analogyTitle,
    required this.analogyText,
    required this.codeSnippet,
    required this.question,
    required this.choices,
    required this.correctChoiceIndex,
    required this.explanationSuccess,
    required this.explanationFailure,
    required this.hint,
    this.xpReward = 100,
  });
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final bool isUnlocked;

  const CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    this.isUnlocked = true,
  });

  int get completedCount => 0; // calculated dynamically
  double get progressPercentage => 0.0;
}
