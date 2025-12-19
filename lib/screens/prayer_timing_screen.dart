import 'package:flutter/material.dart';

import '../services/prayer_time_service.dart';

class PrayerTimingScreen extends StatelessWidget {
  const PrayerTimingScreen({super.key, required this.controller});

  final PrayerTimesController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Prayer Times',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF10201A),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF10201A)),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final bool hasData = controller.today != null;
          final bool showLoader = controller.isLoading && !hasData;
          final String? errorText = controller.errorMessage;

          if (!hasData) {
            if (showLoader) {
              return _ScrollContainer(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return _ScrollContainer(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: _ErrorState(
                onRetry: controller.refresh,
                message: errorText,
              ),
            );
          }

          final PrayerCountdownInfo? next = controller.nextPrayer;
          final Duration remaining = next?.remaining ?? Duration.zero;
          final List<PrayerSlot> slots = controller.slots;
          final bool hasCountdown = next != null;
          final String heroCountdown = hasCountdown
              ? _formatDuration(remaining)
              : '-- : -- : --';
          final String heroTitle = next != null
              ? next.slot.label
              : 'Unavailable';
          final bool heroLoading = !hasCountdown && showLoader;

          return _ScrollContainer(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroCard(
                  nextName: heroTitle,
                  countdownText: heroCountdown,
                  isLoading: heroLoading,
                  isRefreshing: controller.isRefreshing && hasCountdown,
                  onFindQibla: () => _showQiblaPlaceholder(context),
                ),
                if (errorText != null && !controller.isLoading) ...[
                  const SizedBox(height: 18),
                  _WarningBanner(
                    message: errorText,
                    onRetry: controller.refresh,
                  ),
                ],
                const SizedBox(height: 26),
                for (int index = 0; index < slots.length; index++) ...[
                  _PrayerRow(
                    slot: slots[index],
                    timeText: controller.formattedTime(slots[index]) ?? '--',
                    isNext: next?.slot == slots[index],
                  ),
                  if (index != slots.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatDuration(Duration duration) {
    final Duration safe = duration.isNegative ? Duration.zero : duration;
    final int hours = safe.inHours;
    final int minutes = safe.inMinutes.remainder(60);
    final int seconds = safe.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')} : '
        '${minutes.toString().padLeft(2, '0')} : '
        '${seconds.toString().padLeft(2, '0')}';
  }

  static void _showQiblaPlaceholder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Qibla finder is coming soon.'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.nextName,
    required this.countdownText,
    required this.isLoading,
    required this.isRefreshing,
    required this.onFindQibla,
  });

  final String nextName;
  final String countdownText;
  final bool isLoading;
  final bool isRefreshing;
  final VoidCallback onFindQibla;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            final double preferredHeight = maxWidth * 0.75;
            const double minimumHeight = 280;
            final double resolvedHeight = preferredHeight < minimumHeight
                ? minimumHeight
                : preferredHeight;

            return SizedBox(
              height: resolvedHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/image5.jpg', fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.1),
                          Colors.black.withValues(alpha: 0.65),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          'NEXT PRAYER',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            color: Color(0xFFE2F5EA),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          nextName,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      countdownText,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (isRefreshing) ...[
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.3,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                        const SizedBox(height: 22),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF22C55E),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            shape: const StadiumBorder(),
                            elevation: 0,
                          ),
                          onPressed: onFindQibla,
                          icon: const Icon(Icons.explore, color: Colors.white),
                          label: const Text(
                            'Find Qibla',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.slot,
    required this.timeText,
    required this.isNext,
  });

  final PrayerSlot slot;
  final String timeText;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = isNext
        ? const Color(0xFF22C55E)
        : const Color(0xFFB8C3BC);
    final Color tileColor = isNext ? const Color(0xFFE6FBE9) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
        border: isNext
            ? Border(left: BorderSide(color: baseColor, width: 4))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            _PrayerIcon(slot: slot, isHighlighted: isNext),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        slot.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF10201A),
                        ),
                      ),
                      if (isNext) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCF8E4),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'NEXT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF10783D),
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isNext
                          ? const Color(0xFF10201A)
                          : const Color(0xFF4C5C55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.notifications_none,
              color: isNext ? const Color(0xFF22C55E) : baseColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrayerIcon extends StatelessWidget {
  const _PrayerIcon({required this.slot, required this.isHighlighted});

  final PrayerSlot slot;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    switch (slot) {
      case PrayerSlot.fajr:
        icon = Icons.nightlight_round;
        break;
      case PrayerSlot.sunrise:
        icon = Icons.wb_sunny_outlined;
        break;
      case PrayerSlot.dhuhr:
        icon = Icons.light_mode;
        break;
      case PrayerSlot.asr:
        icon = Icons.brightness_6;
        break;
      case PrayerSlot.maghrib:
        icon = Icons.bedtime;
        break;
      case PrayerSlot.isha:
        icon = Icons.nights_stay;
        break;
    }

    final Color background = isHighlighted
        ? const Color(0xFF22C55E).withValues(alpha: 0.18)
        : const Color(0xFFF0F4F2);
    final Color foreground = isHighlighted
        ? const Color(0xFF22C55E)
        : const Color(0xFF5F6F68);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: foreground, size: 26),
    );
  }
}

class _ScrollContainer extends StatelessWidget {
  const _ScrollContainer({required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFB26B)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE57A15)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF924B0F),
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Retry',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE57A15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry, this.message});

  final Future<void> Function() onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 52, color: Color(0xFF9BA7A0)),
          const SizedBox(height: 16),
          Text(
            message ?? 'Unable to load prayer times',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4F5E58),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
