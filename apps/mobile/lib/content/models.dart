class ReadingSection {
  const ReadingSection(
    this.title, {
    this.paragraphs = const [],
    this.points = const [],
    this.afterPoints = const [],
    this.media = const [],
    this.tables = const [],
    this.communicationExamples = const [],
    this.links = const [],
    this.note,
    this.noteLabel,
    this.callout,
    this.calloutLabel,
  });
  final String title;
  final List<String> paragraphs;
  final List<String> points;
  final List<String> afterPoints;
  final List<ReadingMedia> media;
  final List<ReadingTable> tables;
  final List<CommunicationExample> communicationExamples;
  final List<ReadingLink> links;
  final String? note;
  final String? noteLabel;
  final String? callout;
  final String? calloutLabel;
}

class CommunicationExample {
  const CommunicationExample({required this.avoid, required this.use});

  final String avoid;
  final String use;
}

class ReadingTable {
  const ReadingTable({
    required this.title,
    required this.headers,
    required this.rows,
    this.exportable = false,
    this.note,
  });

  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  final bool exportable;
  final String? note;
}

class ReadingLink {
  const ReadingLink({required this.label, required this.url});

  final String label;
  final String url;
}

class ReadingMedia {
  const ReadingMedia({
    required this.asset,
    required this.alt,
    this.caption,
  });

  final String asset;
  final String alt;
  final String? caption;
}

class Article {
  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.sections,
    this.openingParagraphs = const [],
    this.closingParagraphs = const [],
    this.primaryActionArticleId,
    this.primaryActionLabel,
  });
  final String id;
  final String title;
  final String summary;
  final String source;
  final List<ReadingSection> sections;
  final List<String> openingParagraphs;
  final List<String> closingParagraphs;
  final String? primaryActionArticleId;
  final String? primaryActionLabel;
}

class ContentGroup {
  const ContentGroup({
    required this.id,
    required this.title,
    required this.summary,
    required this.asset,
    required this.articles,
    this.singleSectionIconAsset,
  });
  final String id;
  final String title;
  final String summary;
  final String asset;
  final List<Article> articles;
  final String? singleSectionIconAsset;
}
