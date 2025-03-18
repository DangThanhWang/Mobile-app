import 'package:app/Middlewares/Circle_Percent.dart';
import 'package:flutter/material.dart';

class Recent extends StatelessWidget {
  const Recent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "RECENT QUIZ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(161, 102, 0, 19),
                ),
              ),
              Row(
                children: [
                  Image.asset("assets/images/home/headphone.png"),
                  SizedBox(width: 4),
                  Text(
                    "A Basic Music Quiz",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Rubik",
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF660012),
                    ),
                  )
                ],
              ),
            ],
          ),
          Spacer(),
          CirclePercent(
            text: '65%',
            radius: 25.0,
            lineWidth: 12.0,
            percent: 0.65,
            fontSize: 14.0,
            check: false,
          ),
        ],
      ),
    );
  }
}
