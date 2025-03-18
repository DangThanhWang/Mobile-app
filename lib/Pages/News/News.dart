// ignore: file_names
import 'package:app/Definitons/size_config.dart';
import 'package:app/Pages/News/ViewAllStoriesPage.dart';
import 'package:app/Widgets/News/home_heading.dart';
import 'package:app/Widgets/News/home_slider.dart';
import 'package:app/Widgets/News/new_list.dart';
import 'package:flutter/material.dart';

class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            HomeHeading(
              title: "Truyện ngắn",
              traling: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewAllStoriesPage(),
                      ),
                    );
                  },
                  child: Text("View all")),
            ),
            HomeSlider(),
            HomeHeading(
              title: "Có thể bạn thích",
              traling: TextButton(onPressed: () {}, child: Text("View all")),
            ),
            NewsList(),
          ],
        ),
      ),
    );
  }
}
