import '../../data/models/article_preview.dart';
import '../../data/models/birth_profile.dart';

class ChartRouteArgs {
  const ChartRouteArgs({required this.profileId, required this.year});

  final String profileId;
  final int year;
}

class ChartFormArgs {
  const ChartFormArgs({this.profile});

  final BirthProfile? profile;
}

class PalaceRouteArgs {
  const PalaceRouteArgs({
    required this.profileId,
    required this.year,
    required this.palaceKey,
  });

  final String profileId;
  final int year;
  final String palaceKey;

  PalaceRouteArgs copyWith({
    String? profileId,
    int? year,
    String? palaceKey,
  }) {
    return PalaceRouteArgs(
      profileId: profileId ?? this.profileId,
      year: year ?? this.year,
      palaceKey: palaceKey ?? this.palaceKey,
    );
  }
}

class FortuneRouteArgs {
  const FortuneRouteArgs({required this.profileId, required this.year});

  final String profileId;
  final int year;
}

class AiRouteArgs {
  const AiRouteArgs({
    required this.profileId,
    required this.year,
    this.seedQuestion,
  });

  final String profileId;
  final int year;
  final String? seedQuestion;
}

class ArticleRouteArgs {
  const ArticleRouteArgs(this.article);

  final ArticlePreview article;
}
