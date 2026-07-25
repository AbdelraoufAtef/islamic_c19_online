import 'package:flutter/material.dart';
import 'package:islamic_c19_online/modules/layout/screens/layout_screen.dart';
class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<IntroPageData> pages = [
    IntroPageData(
      imagePath: 'assets/intro/welcome.png',
      title: 'Welcome To Islami App',
      subtitle: '',
      showLogo: true,
    ),
    IntroPageData(
      imagePath: 'assets/intro/mosque.png',
      title: 'Welcome To Islami',
      subtitle: 'We Are Very Excited To Have You In Our Community',
    ),
    IntroPageData(
      imagePath: 'assets/intro/quran.png',
      title: 'Reading the Quran',
      subtitle: 'Read, and your Lord is the Most Generous',
    ),
    IntroPageData(
      imagePath: 'assets/intro/hands.png',
      title: 'Bearish',
      subtitle: 'Praise the name of your Lord, the Most High',
    ),
    IntroPageData(
      imagePath: 'assets/intro/microphone.png',
      title: 'Holy Quran Radio',
      subtitle: 'You can listen to the Holy Quran Radio through the application for free and easily',
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LayoutScreen(), // 👈 استبدل QuranScreen بـ LayoutScreen
        ),
      );
    }
  }

  void _prevPage() {
    if (currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                'assets/intro/header.png',
                height: 171,
              ),
            ),
          ),

          // PageView
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => currentPage = index),
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return IntroPage(data: pages[index]);
              },
            ),
          ),
          DotsIndicator(
            count: pages.length,
            current: currentPage,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  TextButton(
                    onPressed: _prevPage,
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xffE2BE7F),
                        fontSize: 16,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 60),
                ElevatedButton(
                  onPressed:nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffE2BE7F),
                    foregroundColor: const Color(0xff202020),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    currentPage == pages.length - 1 ? 'Finish' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class IntroPageData {
  final String imagePath;
  final String title;
  final String subtitle;
  final bool showLogo;

  IntroPageData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.showLogo = false,
  });
}

class IntroPage extends StatelessWidget {
  final IntroPageData data;

  const IntroPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              data.imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xffE2BE7F),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (data.subtitle.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xffE2BE7F),
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
class DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xffE2BE7F),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}