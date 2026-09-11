class ReadingSection {
  const ReadingSection(
    this.title, {
    this.paragraphs = const [],
    this.points = const [],
    this.note,
  });
  final String title;
  final List<String> paragraphs;
  final List<String> points;
  final String? note;
}

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.sections,
  });
  final String id;
  final String title;
  final String summary;
  final String source;
  final List<ReadingSection> sections;
}

class ContentGroup {
  const ContentGroup({
    required this.id,
    required this.title,
    required this.summary,
    required this.asset,
    required this.articles,
  });
  final String id;
  final String title;
  final String summary;
  final String asset;
  final List<Article> articles;
}
