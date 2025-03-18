import 'package:app/Definitons/Theme/New_Color.dart';
// import 'package:app/Definitons/app_date_formatters.dart';
import 'package:app/Pages/News/singe_news_item_page.dart';
import 'package:flutter/material.dart';

class HomeSliderItem extends StatelessWidget {
  final bool isActive;
  final String imageAssetPath;
  final String category;
  final String title;
  final String content;
  // final String authorImageAssetPath;

  // final String author;
  // final DateTime date;
  const HomeSliderItem({
    Key? key,
    required this.isActive,
    required this.imageAssetPath,
    required this.category,
    required this.title,
    // required this.author,
    // required this.date,
    required this.content,
    // required this.authorImageAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleNewsItemPage(
                      title: title,
                      content: content,
                      // author: author,
                      category: category,
                      // authorImageAssetPath: authorImageAssetPath,
                      imageAssetPath: imageAssetPath,
                      // date: date,
                    )));
      },
      child: FractionallySizedBox(
        widthFactor: 1.08,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: isActive ? 1 : 0.8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  color: Colors.red,
                ),
                Image.asset(
                  imageAssetPath,
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Chip(
                    label: Text(
                      category,
                      style: TextStyle(color: AppColors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    AppColors.black08,
                    AppColors.black06,
                    AppColors.black00,
                  ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      // '$author - ${AppDateFormatters.mdY(date)}',
                      //   style: Theme.of(context)
                      //       .textTheme
                      //       .headlineSmall
                      //       ?.copyWith(color: AppColors.white),
                      //   maxLines: 1,
                      // ),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.white,
                                ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
