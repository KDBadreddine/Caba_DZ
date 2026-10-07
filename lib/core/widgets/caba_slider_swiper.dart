import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../app/theme.dart';
import '../../models/slider_model.dart';
import 'caba_network_image.dart';

class CabaSliderSwiper extends StatefulWidget {
  final List<SliderModel> items;
  final double height;
  final ValueChanged<SliderModel>? onTap;

  const CabaSliderSwiper({
    super.key,
    required this.items,
    this.height = 168,
    this.onTap,
  });

  @override
  State<CabaSliderSwiper> createState() => _CabaSliderSwiperState();
}

class _CabaSliderSwiperState extends State<CabaSliderSwiper> {
  final _controller = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(CabaSliderSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.items.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final current = _controller.page?.round() ?? 0;
      final next = (current + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: widget.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: items.length,
              itemBuilder: (context, i) {
                final slide = items[i];
                return GestureDetector(
                  onTap: () => widget.onTap?.call(slide),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CabaNetworkImage(url: slide.resolvedImageUrl),
                      if (slide.title.isNotEmpty || slide.subtitle.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      if (slide.title.isNotEmpty || slide.subtitle.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (slide.title.isNotEmpty)
                                Text(
                                  slide.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              if (slide.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  slide.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            if (items.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: items.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 6,
                      dotWidth: 6,
                      spacing: 6,
                      expansionFactor: 3,
                      activeDotColor: Colors.white,
                      dotColor: Color(0x88FFFFFF),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
