import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  final String number;
  final String point;
  final String name;
  final double widthUser;
  final double heightUser;

  const LeaderboardItem({
    Key? key,
    required this.number,
    required this.point,
    required this.name,
    required this.widthUser,
    required this.heightUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/images/users/avatar.jpg'),
              ),
            ),
            if (number == '1')
              Positioned(
                right: 12,
                top: -15,
                child: Image.asset(
                  "assets/images/users/Medal_1.png",
                  width: 35,
                ),
              ),
          ],
        ),
        SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 170, 170),
              fontWeight: FontWeight.w700,
              fontSize: 16,
              fontFamily: "Rubik"),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
              color: const Color(0xFF9087E5),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            point,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                fontFamily: "Rubik"),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: heightUser,
          width: widthUser,
          decoration: BoxDecoration(
            color: number == '2'
                ? Color(0xFFAEA7EC)
                : number == '1'
                    ? Color.fromARGB(255, 144, 133, 244)
                    : Color(0xFF9087E5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: number == '1'
                    ? 50
                    : number == '2'
                        ? 45
                        : 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
