import 'package:flutter/material.dart';

class TimerRanking extends StatefulWidget {
  final List<String> tasks; // Nhận danh sách các mục từ bên ngoài

  TimerRanking({required this.tasks});

  @override
  _TimerRankingState createState() => _TimerRankingState();
}

class _TimerRankingState extends State<TimerRanking> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 16),
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepPurpleAccent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.tasks.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: selectedIndex == index
                          ? Colors.purple.shade300
                          : Colors.deepPurpleAccent,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        widget.tasks[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedIndex == index
                              ? Colors.white
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
