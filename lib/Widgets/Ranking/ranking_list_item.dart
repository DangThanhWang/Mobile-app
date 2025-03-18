import 'package:app/Definitons/size_config.dart';
import 'package:flutter/material.dart';

List<int> numbers = [1, 2, 3];
Map<int, String> medalImages = {
  1: "assets/images/users/Medal_1.png",
  2: "assets/images/users/Medal_2.png",
  3: "assets/images/users/Medal_3.png",
};

class RankingListItem extends StatelessWidget {
  final int number;
  final bool check;
  const RankingListItem({
    Key? key,
    required this.number,
    required this.check,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              margin: EdgeInsets.only(left: 16, right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Color(0xFFE6E6E6), width: 1),
              ),
              child: Center(
                child: Text(number.toString()),
              ),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/images/users/avatar.jpg'),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tai",
                  style: TextStyle(
                      color: Color(0xFF0C092A),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: "Rubik"),
                ),
                Text(
                  "20 points",
                  style: TextStyle(
                      color: Color(0xFF858494),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: "Rubik"),
                ),
              ],
            ),
            Spacer(),
            if (!check && medalImages.containsKey(number))
              Image.asset(
                medalImages[number]!,
                fit: BoxFit.cover,
                width: AppSizes.blockSizeHorizontal * 10,
              ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }
}
