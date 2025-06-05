import 'package:flutter/material.dart';

import 'Topics.dart';

class TopicChips extends StatefulWidget {
  final String currentTopic;
  final Map<int, List<Map<String, dynamic>>> levels;

  const TopicChips({
    super.key,
    required this.currentTopic,
    required this.levels,
  });

  @override
  _TopicChipsState createState() => _TopicChipsState();
}

class _TopicChipsState extends State<TopicChips> {
  @override
  Widget build(BuildContext context) {
    final currentLevel = widget.levels.entries.firstWhere(
      (entry) =>
          entry.value.any((topic) => topic['title'] == widget.currentTopic),
      orElse: () => MapEntry(0, []),
    );

    final filteredTopics = currentLevel.value
        .where((topic) => topic['title'] != widget.currentTopic)
        .toList();

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF8C725E).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: Color(0xFF8C725E).withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(),
            const SizedBox(height: 25),
            if (filteredTopics.isEmpty)
              _buildEmptyState()
            else
              _buildTopicGrid(filteredTopics),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF8C725E),
                    Color(0xFF8C725E).withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8C725E).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.explore_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Khám phá thêm",
                    style: TextStyle(
                      color: Color(0xFF8C725E),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Các chủ đề liên quan khác",
                    style: TextStyle(
                      color: Color(0xFF8C725E).withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          height: 4,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8C725E),
                Color(0xFF8C725E).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF8C725E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              color: Color(0xFF8C725E).withOpacity(0.6),
              size: 40,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Không có chủ đề nào khác',
            style: TextStyle(
              color: Color(0xFF8C725E).withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy thử khám phá các cấp độ khác',
            style: TextStyle(
              color: Color(0xFF8C725E).withOpacity(0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicGrid(List<Map<String, dynamic>> filteredTopics) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: filteredTopics.length,
      itemBuilder: (context, index) {
        final topic = filteredTopics[index];
        return _buildTopicChip(
          topic['title'],
          _getTopicIcon(topic['title']),
          index,
        );
      },
    );
  }

  IconData _getTopicIcon(String topic) {
    final iconMap = {
      'Animals': Icons.pets,
      'Food': Icons.restaurant,
      'Travel': Icons.flight,
      'Technology': Icons.computer,
      'Sports': Icons.sports_soccer,
      'Music': Icons.music_note,
      'Art': Icons.palette,
      'Science': Icons.science,
      'Nature': Icons.nature,
      'Business': Icons.business,
    };

    return iconMap[topic] ?? Icons.topic;
  }

  Widget _buildTopicChip(String topic, IconData icon, int index) {
    // Create different gradient combinations for variety
    final gradients = [
      LinearGradient(
        colors: [Color(0xFF8C725E), Color(0xFFA67C52)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFFA67C52), Color(0xFF704638)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      LinearGradient(
        colors: [Color(0xFF8C725E).withOpacity(0.9), Color(0xFF8C725E)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ];

    final selectedGradient = gradients[index % gradients.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Topic(topic: topic),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 300),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            gradient: selectedGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF8C725E).withOpacity(0.25),
                blurRadius: 12,
                offset: Offset(0, 6),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        topic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Chủ đề',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.8),
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
