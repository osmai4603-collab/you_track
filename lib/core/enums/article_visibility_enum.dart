enum ArticleVisibility {
  admin('admin'),
  developer('developer'),
  visitor('visitor');

  final String value;
  const ArticleVisibility(this.value);

  factory ArticleVisibility.fromString(String value) {
    return ArticleVisibility.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ArticleVisibility.visitor,
    );
  }
}
