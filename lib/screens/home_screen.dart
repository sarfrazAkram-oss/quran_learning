import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/calendar_service.dart';
import '../services/prayer_time_service.dart';
import '../services/quran_page_service.dart';
import 'bookmark/bookmark_screen.dart';
import 'daily_dua_screen.dart';
import 'holy_quran_para_detail_screen.dart';
import 'prayer_timing_screen.dart';
import 'tasbeeh_screen.dart';

String _formatCountdown(Duration duration) {
  final Duration safe = duration.isNegative ? Duration.zero : duration;
  final int hours = safe.inHours;
  final int minutes = safe.inMinutes.remainder(60);
  final int seconds = safe.inSeconds.remainder(60);
  return '${hours.toString().padLeft(2, '0')} : '
      '${minutes.toString().padLeft(2, '0')} : '
      '${seconds.toString().padLeft(2, '0')}';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.selectedLanguage = ''});

  final String selectedLanguage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CalendarService _calendarService = CalendarService();
  final QuranPageService _pageService = QuranPageService();
  final TextEditingController _pageNumberController = TextEditingController();

  late Future<CalendarMonthData> _calendarFuture;
  late final PrayerTimesController _prayerController;

  @override
  void initState() {
    super.initState();
    _calendarFuture = _calendarService.fetchMonth(DateTime.now());
    _prayerController = PrayerTimesController()..initialize();
  }

  @override
  void dispose() {
    _calendarService.dispose();
    _pageNumberController.dispose();
    _prayerController.dispose();
    super.dispose();
  }

  String _localizedGreeting() {
    if (widget.selectedLanguage == 'العربية') {
      return 'مرحبًا بك في تطبيق القرآن';
    }
    if (widget.selectedLanguage == 'اردو') {
      return 'قرآن لرن میں خوش آمدید';
    }
    return 'Welcome back to Quran Learn';
  }

  void _openCalendar(CalendarMonthData monthData) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CalendarBottomSheet(
        calendarService: _calendarService,
        initialData: monthData,
      ),
    );
  }

  void _openPrayerTimingScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PrayerTimingScreen(controller: _prayerController),
      ),
    );
  }

  void _openDailyDuaScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DailyDuaScreen()));
  }

  void _openTasbeehScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const TasbeehScreen()));
  }

  void _showGoToPageDialog() {
    _pageNumberController
      ..text = ''
      ..selection = const TextSelection.collapsed(offset: 0);

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0x8C000000),
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 28),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Go To Page',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10201A),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _pageNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: const Color(0xFF11C86A),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF10201A),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter page number (1 - 848)',
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7B8D84),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F7F6),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E5E2),
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFF11C86A),
                          width: 1.6,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E5E2),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF7B8D84),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('CANCEL'),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () => _handleGoToPage(dialogContext),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF11C86A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('GO TO PAGE'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleGoToPage(BuildContext dialogContext) async {
    final String rawInput = _pageNumberController.text.trim();
    if (rawInput.isEmpty) {
      return;
    }

    final int? pageNumber = int.tryParse(rawInput);
    if (pageNumber == null || pageNumber < 1 || pageNumber > 848) {
      _showPageRangeMessage();
      return;
    }

    Navigator.of(dialogContext).pop();

    try {
      final QuranPageLocation? location = await _pageService.locate(pageNumber);
      if (!mounted) {
        return;
      }
      if (location == null) {
        _showPageRangeMessage();
        return;
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HolyQuranParaDetailScreen(
            para: location.para,
            initialPage: location.pageInPara,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open that page. Please try again.'),
        ),
      );
    }
  }

  void _showPageRangeMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter a number between 1 and 848.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF11C86A);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardWidth = (screenWidth - 60) / 2;
    final String greeting = _localizedGreeting();

    return Scaffold(
      backgroundColor: const Color(0xFF181A1B),
      body: SafeArea(
        child: FutureBuilder<CalendarMonthData>(
          future: _calendarFuture,
          builder: (context, snapshot) {
            final CalendarMonthData? monthData = snapshot.data;
            final CalendarDay? today = monthData?.today;
            final bool isLoading =
                snapshot.connectionState == ConnectionState.waiting;
            final String? errorText = snapshot.hasError
                ? 'Unable to load calendar'
                : null;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(Icons.menu, size: 32, color: Colors.white),
                    Text(
                      'Quran Learn',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCFD8D4),
                  ),
                ),
                const SizedBox(height: 18),
                AnimatedBuilder(
                  animation: _prayerController,
                  builder: (context, _) {
                    return _DatePrayerCard(
                      accentColor: accentColor,
                      day: today,
                      isCalendarLoading: isLoading,
                      calendarErrorMessage: errorText,
                      prayerController: _prayerController,
                      onCalendarTap: monthData != null
                          ? () => _openCalendar(monthData)
                          : null,
                      onPrayerTap: _openPrayerTimingScreen,
                    );
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FeatureCard(
                      width: cardWidth,
                      icon: Icon(
                        Icons.menu_book_rounded,
                        size: 45,
                        color: accentColor,
                      ),
                      title: 'Holy Quran',
                      subtitle: 'Read the Holy Quran',
                      onTap: () =>
                          Navigator.of(context).pushNamed('/holy-quran'),
                    ),
                    _FeatureCard(
                      width: cardWidth,
                      icon: Icon(
                        Icons.graphic_eq,
                        size: 45,
                        color: accentColor,
                      ),
                      title: 'Tajweed Quran',
                      subtitle: 'Learn pronunciation',
                      onTap: () => Navigator.of(context).pushNamed('/tajweed'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FeatureCard(
                      width: cardWidth,
                      icon: Icon(
                        Icons.menu_book_outlined,
                        size: 45,
                        color: accentColor,
                      ),
                      title: 'Go To Page',
                      subtitle: 'Jump to a specific page',
                      onTap: _showGoToPageDialog,
                    ),
                    _FeatureCard(
                      width: cardWidth,
                      icon: Icon(
                        Icons.bookmark_rounded,
                        size: 45,
                        color: accentColor,
                      ),
                      title: 'Bookmarks',
                      subtitle: 'Access your saved pages',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookmarkScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FeatureCard(
                      width: cardWidth,
                      icon: Icon(
                        Icons.self_improvement,
                        size: 45,
                        color: accentColor,
                      ),
                      title: 'Daily Du\'aa',
                      subtitle: 'Read the daily supplications',
                      onTap: _openDailyDuaScreen,
                    ),
                    _FeatureCard(
                      width: cardWidth,
                      icon: _CounterIcon(color: accentColor),
                      title: 'Tasbeeh Counter',
                      subtitle: 'Digital counter for dhikr',
                      onTap: _openTasbeehScreen,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DatePrayerCard extends StatelessWidget {
  const _DatePrayerCard({
    required this.accentColor,
    required this.day,
    required this.isCalendarLoading,
    required this.calendarErrorMessage,
    required this.prayerController,
    this.onCalendarTap,
    this.onPrayerTap,
  });

  final Color accentColor;
  final CalendarDay? day;
  final bool isCalendarLoading;
  final String? calendarErrorMessage;
  final PrayerTimesController prayerController;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onPrayerTap;

  @override
  Widget build(BuildContext context) {
    final String? hijriLabel = day?.hijriLabel;
    final String? gregorianLabel = day?.gregorianLabel;
    final bool showCalendarError = calendarErrorMessage != null;
    final PrayerCountdownInfo? countdown = prayerController.nextPrayer;
    final bool hasPrayerData = prayerController.today != null;
    final bool prayerLoading = !hasPrayerData && prayerController.isLoading;
    final bool prayerRefreshing =
        prayerController.isRefreshing && hasPrayerData;
    final String? prayerError = prayerController.errorMessage;
    final String nextLabel = countdown != null
        ? countdown.slot.label
        : prayerLoading
        ? 'Loading...'
        : 'Unavailable';
    final Widget countdownWidget = () {
      if (prayerLoading) {
        return const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
        );
      }
      final String display = countdown != null
          ? _formatCountdown(countdown.remaining)
          : '-- : -- : --';
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            display,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          if (prayerRefreshing) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ],
        ],
      );
    }();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF0A2C14),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 12, 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CardEmblem(accentColor: accentColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isCalendarLoading)
                            const _PlaceholderBar(width: 160)
                          else if (showCalendarError)
                            Text(
                              calendarErrorMessage!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFFCDD2),
                              ),
                            )
                          else
                            Text(
                              hijriLabel ?? 'Hijri date unavailable',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          const SizedBox(height: 8),
                          if (isCalendarLoading)
                            const _PlaceholderBar(width: 200)
                          else
                            Text(
                              gregorianLabel ?? 'Fetching today\'s date...',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4EE08F),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Color(0xFF11C86A),
                        size: 26,
                      ),
                      onPressed:
                          (onCalendarTap != null &&
                              !isCalendarLoading &&
                              !showCalendarError)
                          ? onCalendarTap
                          : null,
                      tooltip: 'Open calendar',
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: const Color(0xFF0D8A3B),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                onTap: onPrayerTap,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Prayer Times',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                countdownWidget,
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (prayerError != null && countdown == null)
                              Text(
                                prayerError,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFE8A6),
                                ),
                              )
                            else
                              Text(
                                nextLabel,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.chevron_right, color: Colors.white),
                    ],
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

class _CardEmblem extends StatelessWidget {
  const _CardEmblem({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        shape: BoxShape.circle,
        border: Border.all(color: accentColor.withValues(alpha: 0.45)),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(Icons.calendar_today, size: 22, color: accentColor),
    );
  }
}

class _PlaceholderBar extends StatelessWidget {
  const _PlaceholderBar({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 14,
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final double width;
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Align(alignment: Alignment.centerLeft, child: icon),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7B8D84),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterIcon extends StatelessWidget {
  const _CounterIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Text(
          '5',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _CalendarBottomSheet extends StatefulWidget {
  const _CalendarBottomSheet({
    required this.calendarService,
    required this.initialData,
  });

  final CalendarService calendarService;
  final CalendarMonthData initialData;

  @override
  State<_CalendarBottomSheet> createState() => _CalendarBottomSheetState();
}

class _CalendarBottomSheetState extends State<_CalendarBottomSheet> {
  static const Color _accentColor = Color(0xFF11C86A);

  late CalendarMonthData _monthData;
  late DateTime _focusedDay;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _monthData = widget.initialData;
    _focusedDay = widget.initialData.month;
  }

  Future<void> _loadMonth(DateTime target) async {
    final DateTime normalized = DateTime(target.year, target.month);
    if (normalized.year == _monthData.month.year &&
        normalized.month == _monthData.month.month) {
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final CalendarMonthData data = await widget.calendarService.fetchMonth(
        normalized,
      );
      if (!mounted) return;
      setState(() {
        _monthData = data;
        _focusedDay = normalized;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load calendar';
        _isLoading = false;
      });
    }
  }

  Widget _buildDayCell(DateTime day, {required bool isOutside}) {
    final CalendarDay? info = _monthData.dayFor(day);
    final bool isToday = info?.isToday ?? false;

    final Color background = isToday
        ? _accentColor
        : isOutside
        ? const Color(0xFFE4EAE6)
        : const Color(0xFFF4F7F5);
    final Color primaryText = isToday
        ? Colors.white
        : isOutside
        ? const Color(0xFF9EA9A2)
        : const Color(0xFF10201A);
    final Color secondaryText = isToday
        ? Colors.white.withValues(alpha: 0.85)
        : isOutside
        ? const Color(0xFFB7C0BA)
        : const Color(0xFF5F6F68);

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryText,
            ),
          ),
          if (info != null)
            Text(
              '${info.hijriDay} ${info.hijriMonthName.length > 3 ? info.hijriMonthName.substring(0, 3) : info.hijriMonthName}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: secondaryText,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 56,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E5E2),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _monthData.gregorianMonthLabel,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10201A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (_monthData.hijriMonthLabel != null)
                          Text(
                            _monthData.hijriMonthLabel!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A5A52),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF5F6F68)),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _CalendarLegend(color: _accentColor, label: 'Today'),
                  _CalendarLegend(color: Color(0xFF5F6F68), label: 'Hijri day'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Stack(
                children: [
                  TableCalendar<void>(
                    firstDay: DateTime(2020, 1, 1),
                    lastDay: DateTime(2035, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: CalendarFormat.month,
                    headerVisible: false,
                    startingDayOfWeek: StartingDayOfWeek.saturday,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    onPageChanged: (focusedDay) {
                      _loadMonth(focusedDay);
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) =>
                          _buildDayCell(day, isOutside: false),
                      todayBuilder: (context, day, focusedDay) =>
                          _buildDayCell(day, isOutside: false),
                      outsideBuilder: (context, day, focusedDay) =>
                          _buildDayCell(day, isOutside: true),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F6F68),
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5F6F68),
                      ),
                    ),
                  ),
                  if (_isLoading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(0xAAFFFFFF),
                        child: Center(
                          child: CircularProgressIndicator(color: _accentColor),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F6F68),
          ),
        ),
      ],
    );
  }
}
