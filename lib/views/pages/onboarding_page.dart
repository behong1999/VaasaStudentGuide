import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:students_guide/gen/assets.gen.dart';
import 'package:students_guide/utils/constants.dart' as constants;
import 'package:students_guide/utils/routes/router.gr.dart';
import 'package:students_guide/utils/custom/c_theme_data.dart';
import 'package:students_guide/views/widgets/page_view_item.dart';

final List<Map<String, String>> onboardings = [
  {
    'title': 'EDUCATION & RESIDENCE',
    'content':
        "Provide information about learning new things outside of school and students' residence.",
    'image': Assets.images.onboarding1.path
  },
  {
    'title': 'SPORTS',
    'content': "Show you locations and websites to play the sports you love.",
    'image': Assets.images.onboarding2.path
  },
  {
    'title': 'COMMUNITY',
    'content':
        "Broaden your network, and enjoy having coffee or meals with friends.",
    'image': Assets.images.onboarding3.path
  }
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double hBottomSheet = 80;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: hBottomSheet),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: List.generate(
            onboardings.length,
            (index) => PageViewItem(
              title: onboardings[index]['title'].toString(),
              content: onboardings[index]['content'].toString(),
              image: onboardings[index]['image'].toString(),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Colors.black54
            : dBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: hBottomSheet,
        child: isLastPage
            ? TextButton(
                onPressed: () async {
                  final showHomePref = await SharedPreferences.getInstance();
                  showHomePref.setBool(constants.SHOW_HOME_PREF_KEY, true);
                  await Future.delayed(const Duration(milliseconds: 1));
                  if (mounted) {
                    context.pushRoute(const HomeRoute());
                  }
                },
                child: const Center(
                  child: OnboardingTextButton('Get Started', size: 22),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.jumpToPage(2);
                    },
                    child: const OnboardingTextButton("Skip", size: 22),
                  ),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    onDotClicked: (index) => controller.animateTo(
                      index.toDouble(),
                      duration: const Duration(milliseconds: 20),
                      curve: Curves.easeIn,
                    ),
                    effect: const WormEffect(
                      spacing: 15,
                      activeDotColor: mColor,
                      dotColor: Colors.white60,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 20),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const OnboardingTextButton('Next', size: 22),
                  ),
                ],
              ),
      ),
    );
  }
}

class OnboardingTextButton extends StatelessWidget {
  final String text;
  final double? size;
  const OnboardingTextButton(
    this.text, {
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}
