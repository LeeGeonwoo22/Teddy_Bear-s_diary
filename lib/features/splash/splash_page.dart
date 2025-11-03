import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:teddyBear/model/board_splash.dart';
import 'package:teddyBear/widgets/custom_btn.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Onboard> list = [
    Onboard(
      title: '안녕 반가워, 나는 곰돌이야',
      subtitle: '만나서 반가워 ㅎㅎ',
      image: 'assets/images/onBoarding_1.png',
    ),
    Onboard(
      title: '소중한 너를 지키고 싶어',
      subtitle: '너가 내 곁에서 잠들어 있는 동안, 너의 꿈속에 들어오려는 악몽 괴물로부터 너를 지켜주는 일을 하고있어. 얼굴에 반창고도 이때 생긴 흉터란다..',
      image: 'assets/images/onBoarding_3.png',
    ),
    Onboard(
      title: '이야기 해줄래?',
      subtitle: '나는 언제든지 너의 이야기를 들어줄 준비가 되어있어. 너가 나에게 사랑을 주는 순간 나는 평범한 곰인형이 아니게 되었어.. 항상 고마워. 너는 나에게 소중한 존재야.. ',
      image: 'assets/images/onBoarding_4.png',
    ),
    Onboard(
      title: '나랑 같이 이야기해요',
      subtitle: '함께 같이 일기를 써요!',
      image: 'assets/images/onBoarding_4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: PageView.builder(
                controller: _controller,
                itemCount: list.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = list[index];
                  final isFirst = index == 0;
                  final isLast = index == list.length - 1;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: isFirst ? 60 : 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item.image,
                          height: size.height * 0.4,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.brown,
                          ),
                        ),
                        const Spacer(),
                        // 🔥 버튼 부분 조건부 렌더링
                        CustomBtn(
                          onTap: () {
                            if (isLast) {
                              context.go('/login');
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          text: isLast ? 'Finish' : 'Next',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // 페이지 인디케이터
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(list.length, (index) {
                  final isActive = _currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: isActive ? 20 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.brown : Colors.brown.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
