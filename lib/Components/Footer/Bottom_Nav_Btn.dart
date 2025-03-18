import 'package:app/Definitons/Color.dart';
import 'package:app/Definitons/size_config.dart';
import 'package:flutter/material.dart';

class BottomNavBtn extends StatelessWidget {
  const BottomNavBtn(
      {super.key,
      required this.icon,
      required this.index,
      required this.currentIndex,
      required this.onTap});

  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: Container(
            height: AppSizes.blockSizeHorizontal * 13,
            width: AppSizes.blockSizeHorizontal * 17,
            decoration: BoxDecoration(
              color: sectionColors['transparent'],
            ),
            child: Stack(alignment: Alignment.center, children: [
              (currentIndex == index)
                  ? Positioned(
                      left: AppSizes.blockSizeHorizontal * 4,
                      bottom: AppSizes.blockSizeHorizontal * 1.5,
                      child: Icon(
                        icon,
                        color: sectionColors['footer_icon_shadow'],
                        size: AppSizes.blockSizeHorizontal * 7,
                      ),
                    )
                  : Container(),
              AnimatedOpacity(
                opacity: (currentIndex == index) ? 1 : .2,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: Icon(
                  icon,
                  color: sectionColors['footer_icon'],
                  size: AppSizes.blockSizeHorizontal * 8,
                ),
              )
            ])));
  }
}
