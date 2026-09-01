import 'package:drift/drift.dart';

/// Database table for Bible verses
class Verses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book => text().withLength(min: 1, max: 50)();
  IntColumn get chapter => integer().between(min: 1, max: 150)();
  IntColumn get verseNumber => integer().between(min: 1, max: 200)();
  TextColumn get text => text()();
  TextColumn get translation => text().withDefault(const Constant('KJV'))();
  DateTimeColumn get cachedAt => dateTime().nullable()();
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {book, chapter, verseNumber, translation},
  ];
}

/// Database table for user notes
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text()();
  TextColumn get scriptureReference => text().nullable()();
  TextColumn get tags => text().nullable()(); // Comma-separated tags
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

/// Database table for highlights
class Highlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get verseId => integer().references(Verses, #id)();
  TextColumn get color => text().withDefault(const Constant('#FFD700'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Database table for alarms/reminders
class Alarms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get message => text().nullable()();
  IntColumn get hour => integer().between(min: 0, max: 23)();
  IntColumn get minute => integer().between(min: 0, max: 59)();
  TextColumn get daysOfWeek => text().nullable()(); // e.g., "1,3,5" for Mon,Wed,Fri
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get sound => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

/// Database table for sermon cache
class Sermons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get speaker => text().nullable()();
  TextColumn get videoUrl => text().nullable()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get thumbnailUrl => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime()();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [Verses, Notes, Highlights, Alarms, Sermons])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle migrations here
      },
    );
  }
  
  // Verse queries
  Future<List<Verse>> getVersesByChapter(String book, int chapter) {
    return (select(verses)..where((v) => v.book.equals(book) & v.chapter.equals(chapter))).get();
  }
  
  Future<Verse?> getVerseById(int id) {
    return (select(verses)..where((v) => v.id.equals(id))).getSingleOrNull();
  }
  
  Future<void> insertVerse(VerseCompanion verse) {
    return into(verses).insert(verse);
  }
  
  // Note queries
  Future<List<Note>> getAllNotes() {
    return (select(notes)..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])).get();
  }
  
  Future<List<Note>> getNotesByTag(String tag) {
    return (select(notes)..where((n) => n.tags.like('%$tag%'))).get();
  }
  
  Future<void> insertNote(NoteCompanion note) {
    return into(notes).insert(note);
  }
  
  Future<void> updateNote(NoteCompanion note) {
    return into(notes).update(note);
  }
  
  // Highlight queries
  Future<List<Highlight>> getHighlightsByVerseId(int verseId) {
    return (select(highlights)..where((h) => h.verseId.equals(verseId))).get();
  }
  
  Future<void> insertHighlight(HighlightCompanion highlight) {
    return into(highlights).insert(highlight);
  }
  
  // Alarm queries
  Future<List<Alarm>> getAllAlarms() {
    return (select(alarms)..orderBy([(t) => OrderingTerm.asc(t.hour), (t) => OrderingTerm.asc(t.minute)])).get();
  }
  
  Future<List<Alarm>> getEnabledAlarms() {
    return (select(alarms)..where((a) => a.isEnabled.equals(true))).get();
  }
  
  Future<void> insertAlarm(AlarmCompanion alarm) {
    return into(alarms).insert(alarm);
  }
  
  // Sermon queries
  Future<List<Sermon>> getAllSermons() {
    return (select(sermons)..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])).get();
  }
  
  Future<void> insertSermon(SermonCompanion sermon) {
    return into(sermons).insert(sermon);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getDatabasesPath();
    final file = File(p.join(dbFolder, 'syntrophe.db'));
    return NativeDatabase.createInBackground(file);
  });
}
