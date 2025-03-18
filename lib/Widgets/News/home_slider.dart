import 'package:app/Data/News/dummy.dart';
import 'package:app/Definitons/normalizePage.dart';
import 'package:app/Widgets/News/home_slider_item.dart';
import 'package:app/helpers/DotsIndicator.dart';
import 'package:flutter/material.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({Key? key}) : super(key: key);

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  late final PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(
      [
        SizedBox(
          height: 235,
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _pageIndex = value % newsrItems.length;
              });
            },
            controller: _pageController,
            itemBuilder: (context, index) {
              final i = index % newsrItems.length;
              return HomeSliderItem(
                isActive: _pageIndex == i,
                imageAssetPath: newsrItems[i]['imageAssetPath']!,
                category: newsrItems[i]['category']!,
                title: newsrItems[i]['title']!,
                // author: newsrItems[i]['author']!,
                // date: DateTime.parse(newsrItems[i]['date']!),
                content: newsrItems[i]['content']!,
                // authorImageAssetPath: newsrItems[i]['authorImageAssetPath']!,
              );
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        DotsIndicator(
            currentIndex: normalizePageIndex(_pageIndex), totalDots: 8,onDotTap: null ,),
      ],
    ));
  }
}
