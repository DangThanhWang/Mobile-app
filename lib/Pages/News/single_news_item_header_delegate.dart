import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class SingleNewsItemHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String category;
  final String imageAssetPath;
  final double topPadding;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onBookmarkPressed;
  final VoidCallback? onSharePressed;

  final bool isFavorite;
  final bool isBookmarked;

  final Function(double value) borderRadiusAnimationValue;

  @override
  final double maxExtent;
  @override
  final double minExtent;

  const SingleNewsItemHeaderDelegate({
    required this.borderRadiusAnimationValue,
    required this.title,
    required this.category,
    required this.imageAssetPath,
    required this.maxExtent,
    required this.minExtent,
    required this.topPadding,
    this.onFavoritePressed,
    this.onBookmarkPressed,
    this.onSharePressed,
    this.isFavorite = false,
    this.isBookmarked = false,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final screenWidth = MediaQuery.of(context).size.width;
    const animationDuration = Duration(milliseconds: 200);

    final showCategoryDate = shrinkOffset < 100;

    final calcForTitleAnimations =
        (maxExtent - shrinkOffset - topPadding - 56 - 100) / 100;

    final titleAnimationValue = calcForTitleAnimations > 1.0
        ? 1.0
        : calcForTitleAnimations < 0.0
            ? 0.0
            : calcForTitleAnimations;

    final calcForTopBarAnimations =
        (maxExtent - shrinkOffset - topPadding - 56) / 50;

    final topBarAnimationValue = calcForTopBarAnimations > 1.0
        ? 1.0
        : calcForTopBarAnimations < 0.0
            ? 0.0
            : calcForTopBarAnimations;

    borderRadiusAnimationValue(topBarAnimationValue);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image with parallax effect
        Transform.translate(
          offset: Offset(0, shrinkOffset * 0.5),
          child: Image.asset(
            imageAssetPath,
            fit: BoxFit.cover,
            width: screenWidth,
            height: maxExtent + shrinkOffset,
          ),
        ),

        // Enhanced gradient overlay
        Positioned(
          bottom: 0,
          child: Container(
            height: maxExtent / 1.5,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // Story information
        Positioned(
          bottom: 0,
          child: AnimatedOpacity(
            opacity: titleAnimationValue,
            duration: animationDuration,
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip with enhanced styling
                  AnimatedSwitcher(
                    duration: animationDuration,
                    child: showCategoryDate
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF8C725E),
                                  Color(0xFF8C725E).withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(category),
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  category,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  AnimatedContainer(
                    duration: animationDuration,
                    height: showCategoryDate ? 16 : 0,
                  ),

                  // Enhanced title with shadow
                  SizedBox(
                    width: screenWidth - 40,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedContainer(
                    duration: animationDuration,
                    height: showCategoryDate ? 12 : 0,
                  ),

                  // Reading stats
                  AnimatedSwitcher(
                    duration: animationDuration,
                    child: showCategoryDate
                        ? Row(
                            children: [
                              _buildStatChip(Icons.schedule,
                                  '${(title.length / 5).round()} phút đọc'),
                              SizedBox(width: 12),
                              _buildStatChip(Icons.visibility,
                                  '${(title.length * 10)} lượt xem'),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Enhanced top bar
        Positioned(
          top: 0,
          child: AnimatedContainer(
            duration: animationDuration,
            height: 56 + topPadding,
            decoration: BoxDecoration(
              color: Color(0xFF8C725E).withOpacity(1 - topBarAnimationValue),
              boxShadow: topBarAnimationValue < 0.5
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            width: screenWidth,
            child: Column(
              children: [
                SizedBox(height: topPadding),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      // Back button with enhanced styling
                      AnimatedCrossFade(
                        duration: animationDuration,
                        crossFadeState: topBarAnimationValue > 0
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        secondChild: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(CupertinoIcons.left_chevron,
                                color: Color(0xFF8C725E)),
                          ),
                        ),
                        firstChild: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(CupertinoIcons.left_chevron,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

                      // Title or action buttons
                      Expanded(
                        child: AnimatedCrossFade(
                          duration: animationDuration,
                          crossFadeState: topBarAnimationValue > 0
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          secondChild: Text(
                            title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          firstChild: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildActionButton(
                                isFavorite
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                () {
                                  HapticFeedback.lightImpact();
                                  onFavoritePressed?.call();
                                },
                                isActive: isFavorite,
                              ),
                              SizedBox(width: 12),
                              _buildActionButton(
                                isBookmarked
                                    ? CupertinoIcons.bookmark_fill
                                    : CupertinoIcons.bookmark,
                                () {
                                  HapticFeedback.lightImpact();
                                  onBookmarkPressed?.call();
                                },
                                isActive: isBookmarked,
                              ),
                              SizedBox(width: 12),
                              _buildActionButton(
                                CupertinoIcons.share,
                                () {
                                  HapticFeedback.lightImpact();
                                  onSharePressed?.call();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed,
      {bool isActive = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? Colors.red.withOpacity(0.9)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
            color: isActive
                ? Colors.red.withOpacity(0.5)
                : Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon:
            Icon(icon, color: isActive ? Colors.white : Colors.white, size: 20),
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'truyện ngắn':
        return Icons.short_text;
      case 'tiểu thuyết':
        return Icons.menu_book;
      case 'truyện cổ tích':
        return Icons.auto_stories;
      case 'truyện kinh dị':
        return Icons.psychology;
      case 'truyện tình cảm':
        return Icons.favorite;
      case 'truyện phiêu lưu':
        return Icons.explore;
      case 'truyện hài':
        return Icons.sentiment_very_satisfied;
      case 'truyện trinh thám':
        return Icons.search;
      case 'truyện khoa học viễn tưởng':
        return Icons.rocket_launch;
      case 'truyện lịch sử':
        return Icons.history_edu;
      default:
        return Icons.book;
    }
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: 100,
        onStretchTrigger: () async {
          // Add haptic feedback when stretching
          HapticFeedback.lightImpact();
        },
      );
}
