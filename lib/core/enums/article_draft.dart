import 'package:hive/hive.dart';

class ArticleDraftAdapter extends TypeAdapter<ArticleDraft> {
  @override
  final int typeId = 0;

  @override
  ArticleDraft read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ArticleDraft(
      articleId: fields[0] as String,
      contentMarkdown: fields[1] as String,
      title: fields[2] as String,
      savedAt: fields[3] as DateTime,
      synced: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleDraft obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.write(obj.articleId);
    writer.writeByte(1);
    writer.write(obj.contentMarkdown);
    writer.writeByte(2);
    writer.write(obj.title);
    writer.writeByte(3);
    writer.write(obj.savedAt);
    writer.writeByte(4);
    writer.write(obj.synced);
  }
}

class ArticleDraft {
  final String articleId;
  final String contentMarkdown;
  final String title;
  final DateTime savedAt;
  final bool synced;

  const ArticleDraft({
    required this.articleId,
    required this.contentMarkdown,
    required this.title,
    required this.savedAt,
    this.synced = false,
  });

  ArticleDraft copyWith({
    String? contentMarkdown,
    String? title,
    bool? synced,
  }) {
    return ArticleDraft(
      articleId: articleId,
      contentMarkdown: contentMarkdown ?? this.contentMarkdown,
      title: title ?? this.title,
      savedAt: DateTime.now(),
      synced: synced ?? this.synced,
    );
  }
}
