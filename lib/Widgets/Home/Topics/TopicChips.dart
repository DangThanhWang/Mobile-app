import 'package:flutter/material.dart';

import 'Topics.dart';

class TopicChips extends StatelessWidget {
  final String currentTopic;
  final Map<int, List<Map<String, dynamic>>> levels;

  const TopicChips({
    Key? key,
    required this.currentTopic,
    required this.levels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Flatten levels map into a list of unique topics excluding the current topic
    final currentLevel = levels.entries.firstWhere(
          (entry) => entry.value.any((topic) => topic['title'] == currentTopic),
      orElse: () => MapEntry(0, []),
    );

    // Filter topics within the same level excluding the current topic
    final filteredTopics = currentLevel.value
        .where((topic) => topic['title'] != currentTopic)
        .toList();

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: filteredTopics.map((topic) {
                  return _buildTopicChip(
                    topic['title'],
                    Icons.topic, // You can customize icons based on the topic
                    context,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the section header
  Widget _buildSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Các chủ đề khác",
          style: TextStyle(
            color: Colors.brown.shade800,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          width: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade400, Colors.brown.shade800],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  // Builds an individual topic chip
  Widget _buildTopicChip(String topic, IconData icon, BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle chip tap, for example, navigate to a new screen with the selected topic
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Topic(topic: topic)),
        );
        print("Tapped on topic: $topic");
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade300, Colors.brown.shade800],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              topic,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
