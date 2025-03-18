import 'package:flutter/material.dart';

class HomeHeading extends StatelessWidget {
  final String title;
  final Widget? traling;

  const HomeHeading({Key? key, required this.title, this.traling})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 54, 127, 244))),
            const Spacer(),
            if (traling != null) traling!,
          ],
        ),
      ),
    );
  }
}
