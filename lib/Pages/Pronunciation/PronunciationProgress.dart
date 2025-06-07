import 'package:flutter/material.dart';

class PronunciationProgress extends StatefulWidget {
  final int completedSentences;
  final int totalSentences;

  PronunciationProgress({
    required this.completedSentences,
    required this.totalSentences,
  });

  @override
  _PronunciationProgressState createState() => _PronunciationProgressState();
}

class _PronunciationProgressState extends State<PronunciationProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _updateProgress();
  }

  @override
  void didUpdateWidget(PronunciationProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completedSentences != widget.completedSentences) {
      _updateProgress();
    }
  }

  void _updateProgress() {
    double newProgress = widget.totalSentences > 0
        ? widget.completedSentences / widget.totalSentences
        : 0.0;

    _progressAnimation = Tween<double>(
      begin: _previousProgress,
      end: newProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward(from: 0.0);
    _previousProgress = newProgress;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) {
      return Colors.red[400]!;
    } else if (progress < 0.7) {
      return Colors.orange[400]!;
    } else {
      return Colors.green[400]!;
    }
  }

  String _getProgressEmoji(double progress) {
    if (progress < 0.3) {
      return "🚀";
    } else if (progress < 0.7) {
      return "⭐";
    } else if (progress < 1.0) {
      return "🔥";
    } else {
      return "🎉";
    }
  }

  String _getProgressMessage(double progress) {
    if (progress < 0.3) {
      return "Bắt đầu thôi!";
    } else if (progress < 0.7) {
      return "Đang tiến bộ!";
    } else if (progress < 1.0) {
      return "Sắp hoàn thành!";
    } else {
      return "Hoàn thành xuất sắc!";
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.totalSentences > 0
        ? widget.completedSentences / widget.totalSentences
        : 0.0;

    return Column(
      children: [
        // Header with emoji and message
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getProgressEmoji(progress),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(width: 8),
            Text(
              _getProgressMessage(progress),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF95785E),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Progress stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getProgressColor(progress).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getProgressColor(progress).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: _getProgressColor(progress),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Hoàn thành: ${widget.completedSentences}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getProgressColor(progress),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Tổng: ${widget.totalSentences}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Progress bar container
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Background
                  Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                  ),
                  // Animated progress
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getProgressColor(progress),
                                _getProgressColor(progress).withOpacity(0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Progress text overlay
                  Center(
                    child: Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: progress > 0.3 ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 12),

        // Achievement badges
        if (progress >= 1.0) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.yellow[400]!, Colors.orange[400]!],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  'Thành tựu mở khóa!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ] else if (progress >= 0.5) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              'Đã vượt qua nửa chặng đường! 💪',
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
