import 'package:app/Definitons/size_config.dart';
import 'package:app/Widgets/Games/GamePage.dart';
import 'package:flutter/material.dart';

class Feature extends StatelessWidget {
  const Feature({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);

    // Các giá trị thường dùng
    const EdgeInsets containerPadding = EdgeInsets.all(25);
    const EdgeInsets containerMargin = EdgeInsets.all(24);
    const Color backgroundColor = Color(0x99CFB39F);

    return Container(
      margin: containerMargin,
      padding: containerPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -15,
              left: -30,
              child: Image.asset(
                "assets/images/home/1.png",
                width: 45,
              ),
            ),
            Positioned(
              bottom: 0,
              right: -20,
              child: Image.asset(
                "assets/images/home/2.png",
                width: 50,
              ),
            ),
            Column(
              children: [
                _buildText("FEATURED", 16, FontWeight.w500),
                SizedBox(
                  height: 10,
                ),
                _buildText("Tham gia thử thách bằng", 18, FontWeight.bold),
                _buildText("các trò trò chơi về từ vựng", 18, FontWeight.bold),
                SizedBox(height: 15),
                _FindFriendsButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo Text theo kiểu chuẩn
  Widget _buildText(String text, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: fontWeight,
      ),
    );
  }
}

class _FindFriendsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => GamePage())),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        width: AppSizes.blockSizeHorizontal * 38,
        child: Row(
          children: [
            Image.asset(
              "assets/images/home/Icon.png",
              width: 20,
            ),
            SizedBox(width: 10),
            Text(
              "Play game",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7A6CE4),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
