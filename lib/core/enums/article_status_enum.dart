enum ArticleStatus {
  draft('draft'),
  published('published');

  final String value;
  const ArticleStatus(this.value);

  factory ArticleStatus.fromString(String value) {
    return ArticleStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ArticleStatus.draft,
    );
  }
}
