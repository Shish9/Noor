import 'package:flutter/material.dart';

import '../../core/data/surah_data.dart';
import '../../core/models/surah.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/glass_card.dart';

class SurahSearchScreen extends StatefulWidget {
  const SurahSearchScreen({super.key});

  @override
  State<SurahSearchScreen> createState() => _SurahSearchScreenState();
}

class _SurahSearchScreenState extends State<SurahSearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<Surah> results = SurahData.search(_query);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Search the Quran', style: AppTypography.titleLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                onChanged: (String v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search surah by name, meaning, or number',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext _, int i) {
                    final Surah s = results[i];
                    return GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      borderRadius: 16,
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/quran/reader',
                          arguments: <String, dynamic>{'surah': s.number},
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${s.number}',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.emeraldGlow,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(s.nameTransliteration,
                                    style: AppTypography.titleMedium),
                                Text(s.meaning, style: AppTypography.caption),
                              ],
                            ),
                          ),
                          Text(
                            s.nameArabic,
                            style: AppTypography.arabic(
                              fontSize: 22,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
