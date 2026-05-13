import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/data/surah_data.dart';
import '../../core/l10n/translations.dart';
import '../../core/models/surah.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _query = '';
  String _filter = 'All'; // All | Meccan | Medinan

  List<Surah> _filtered() {
    List<Surah> list = SurahData.search(_query);
    if (_filter != 'All') {
      list = list.where((Surah s) => s.revelationPlace == _filter).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List<Surah> list = _filtered();

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(context.t('quran.title'), style: AppTypography.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    context.t('quran.subtitle'),
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: _SearchField(onChanged: (String v) => setState(() => _query = v)),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 38,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _FilterChip(
                    label: context.t('quran.filter.all'),
                    selected: _filter == 'All',
                    onTap: () => setState(() => _filter = 'All'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: context.t('quran.filter.meccan'),
                    selected: _filter == 'Meccan',
                    onTap: () => setState(() => _filter = 'Meccan'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: context.t('quran.filter.medinan'),
                    selected: _filter == 'Medinan',
                    onTap: () => setState(() => _filter = 'Medinan'),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverList.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (BuildContext _, int i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SurahTile(surah: list[i]),
              ).animate().fadeIn(duration: 280.ms, delay: (i * 12).ms);
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 200)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: context.t('quran.searchHint'),
        prefixIcon: const Icon(Icons.search_rounded,
            color: AppColors.textTertiary, size: 20),
        suffixIcon: const Icon(Icons.tune_rounded,
            color: AppColors.textTertiary, size: 20),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.emeraldGradient : null,
          color: selected ? null : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : AppColors.glassBorder,
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: selected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 18, 14),
      borderRadius: 18,
      onTap: () => Navigator.pushNamed(
        context,
        '/quran/reader',
        arguments: <String, dynamic>{'surah': surah.number},
      ),
      child: Row(
        children: <Widget>[
          // 8-pointed star number badge
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomPaint(
                  size: const Size(44, 44),
                  painter: _StarBadgePainter(
                    color: surah.revelationPlace == 'Meccan'
                        ? AppColors.gold
                        : AppColors.emeraldGlow,
                  ),
                ),
                Text(
                  '${surah.number}',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(surah.nameTransliteration, style: AppTypography.titleLarge),
                const SizedBox(height: 2),
                Text(
                  '${surah.meaning} · ${surah.ayahCount} ayahs · ${surah.revelationPlace}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          Text(
            surah.nameArabic,
            style: AppTypography.arabic(
              fontSize: 24,
              color: AppColors.gold,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _StarBadgePainter extends CustomPainter {
  _StarBadgePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stroke = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Paint fill = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          color.withValues(alpha: 0.18),
          color.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path path = Path();
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double rOut = size.width * 0.46;
    final double rIn = rOut * 0.5;
    for (int i = 0; i < 16; i++) {
      final double a = (i * math.pi / 8) - math.pi / 2;
      final double r = i.isEven ? rOut : rIn;
      final double dx = cx + r * math.cos(a);
      final double dy = cy + r * math.sin(a);
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _StarBadgePainter old) => old.color != color;
}
