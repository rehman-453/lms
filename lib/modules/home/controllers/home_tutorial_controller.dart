import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomeTutorialController extends GetxController {
  final welcomeKey = GlobalKey();
  final searchKey = GlobalKey();
  final bannerKey = GlobalKey();
  final continueLearningKey = GlobalKey();
  final categoriesKey = GlobalKey();
  final popularCoursesKey = GlobalKey();
  final bottomNavigationKey = GlobalKey();

  static const String _tutorialCompletedKey = 'home_tutorial_completed';

  TutorialCoachMark? _tutorialCoachMark;

  late List<GlobalKey> _targetKeys;

  Future<void> showTutorial(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_tutorialCompletedKey) ?? false) return;
    if (!context.mounted) return;

    _targetKeys = [
      welcomeKey,
      searchKey,
      bannerKey,
      continueLearningKey,
      categoriesKey,
      popularCoursesKey,
      bottomNavigationKey,
    ];

    // Ensure the first target is available before showing the tutorial.
    if (welcomeKey.currentContext == null) return;

    final targets = <TargetFocus>[
      _buildTarget(
        key: welcomeKey,
        identify: 'welcome',
        title: 'Welcome to LMS!',
        description: 'Yahan se aap apni learning journey start kar sakte hain.',
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        key: searchKey,
        identify: 'search',
        title: 'Search Courses',
        description:
            'Search bar se apne interest ke mutabiq courses find karein.',
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        key: bannerKey,
        identify: 'banner',
        title: 'Explore Learning',
        description:
            'Yahan featured courses aur learning recommendations dekhein.',
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        key: continueLearningKey,
        identify: 'continue_learning',
        title: 'Continue Learning',
        description: 'Apne enrolled courses ko yahan se resume karein.',
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        key: categoriesKey,
        identify: 'categories',
        title: 'Course Categories',
        description: 'Different categories ke courses explore karein.',
        align: ContentAlign.bottom,
      ),
      _buildTarget(
        key: popularCoursesKey,
        identify: 'popular_courses',
        title: 'Popular Courses',
        description: 'Popular courses dekhein aur favorites mein save karein.',
        align: ContentAlign.top,
      ),
      _buildTarget(
        key: bottomNavigationKey,
        identify: 'bottom_navigation',
        title: 'Quick Navigation',
        description: 'Home, Courses, Favorites, Progress aur Profile screens par jaane ke liye navigation use karein.',
        align: ContentAlign.top,
      ),
    ];

    _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      opacityShadow: 0.80,
      paddingFocus: 8,
      hideSkip: true,
      onFinish: _markTutorialCompleted,
      onSkip: () {
        _markTutorialCompleted();
        return true;
      },
    );

    _tutorialCoachMark!.show(context: context);
  }

  TargetFocus _buildTarget({
    required GlobalKey key,
    required String identify,
    required String title,
    required String description,
    required ContentAlign align,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      shape: ShapeLightFocus.RRect,
      radius: 14,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            final currentIndex = _targetKeys.indexOf(key);
            final isFirst = currentIndex == 0;
            final isLast = currentIndex == _targetKeys.length - 1;

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7B8496),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => controller.skip(),
                        child: const Text(
                          'SKIP',
                          style: TextStyle(color: Color(0xFFFF5B6E)),
                        ),
                      ),
                      Row(
                        children: [
                          if (!isFirst)
                            TextButton(
                              onPressed: () {
                                _moveToPreviousTarget(controller, currentIndex);
                              },
                              child: const Text('BACK'),
                            ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () {
                              if (isLast) {
                                controller.skip();
                                _markTutorialCompleted();
                              } else {
                                _moveToNextTarget(controller, currentIndex);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F6BFF),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(isLast ? 'FINISH' : 'NEXT'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _moveToNextTarget(dynamic controller, int currentIndex) async {
    final nextIndex = currentIndex + 1;

    if (nextIndex >= _targetKeys.length) {
      controller.next();
      return;
    }

    await _ensureTargetVisible(_targetKeys[nextIndex]);
    controller.next();
  }

  Future<void> _moveToPreviousTarget(
    dynamic controller,
    int currentIndex,
  ) async {
    final previousIndex = currentIndex - 1;

    if (previousIndex < 0) return;

    await _ensureTargetVisible(_targetKeys[previousIndex]);
    controller.previous();
  }

  Future<void> _ensureTargetVisible(GlobalKey key) async {
    final targetContext = key.currentContext;

    if (targetContext == null) return;

    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );

    await Future.delayed(const Duration(milliseconds: 150));
  }

  Future<void> _markTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialCompletedKey, true);
  }

  Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialCompletedKey);
  }
}
