// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sqlite_database.dart';

// ignore_for_file: type=lint
class $NoteLocalModelTable extends NoteLocalModel
    with TableInfo<$NoteLocalModelTable, NoteDrift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteLocalModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _lastEditedMeta =
      const VerificationMeta('lastEdited');
  @override
  late final GeneratedColumn<DateTime> lastEdited = GeneratedColumn<DateTime>(
      'last_edited', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt, lastEdited];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_local_model';
  @override
  VerificationContext validateIntegrity(Insertable<NoteDrift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_edited')) {
      context.handle(
          _lastEditedMeta,
          lastEdited.isAcceptableOrUnknown(
              data['last_edited']!, _lastEditedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteDrift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteDrift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastEdited: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_edited']),
    );
  }

  @override
  $NoteLocalModelTable createAlias(String alias) {
    return $NoteLocalModelTable(attachedDatabase, alias);
  }
}

class NoteDrift extends DataClass implements Insertable<NoteDrift> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? lastEdited;
  const NoteDrift(
      {required this.id,
      required this.name,
      required this.createdAt,
      this.lastEdited});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastEdited != null) {
      map['last_edited'] = Variable<DateTime>(lastEdited);
    }
    return map;
  }

  NoteLocalModelCompanion toCompanion(bool nullToAbsent) {
    return NoteLocalModelCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      lastEdited: lastEdited == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEdited),
    );
  }

  factory NoteDrift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteDrift(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastEdited: serializer.fromJson<DateTime?>(json['lastEdited']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastEdited': serializer.toJson<DateTime?>(lastEdited),
    };
  }

  NoteDrift copyWith(
          {String? id,
          String? name,
          DateTime? createdAt,
          Value<DateTime?> lastEdited = const Value.absent()}) =>
      NoteDrift(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
        lastEdited: lastEdited.present ? lastEdited.value : this.lastEdited,
      );
  NoteDrift copyWithCompanion(NoteLocalModelCompanion data) {
    return NoteDrift(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastEdited:
          data.lastEdited.present ? data.lastEdited.value : this.lastEdited,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteDrift(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastEdited: $lastEdited')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt, lastEdited);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteDrift &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.lastEdited == this.lastEdited);
}

class NoteLocalModelCompanion extends UpdateCompanion<NoteDrift> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastEdited;
  final Value<int> rowid;
  const NoteLocalModelCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastEdited = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteLocalModelCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
    this.lastEdited = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<NoteDrift> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastEdited,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (lastEdited != null) 'last_edited': lastEdited,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteLocalModelCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastEdited,
      Value<int>? rowid}) {
    return NoteLocalModelCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastEdited: lastEdited ?? this.lastEdited,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastEdited.present) {
      map['last_edited'] = Variable<DateTime>(lastEdited.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteLocalModelCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastEdited: $lastEdited, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContentLocalModelTable extends ContentLocalModel
    with TableInfo<$ContentLocalModelTable, ContentDrift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentLocalModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _lastEditedMeta =
      const VerificationMeta('lastEdited');
  @override
  late final GeneratedColumn<DateTime> lastEdited = GeneratedColumn<DateTime>(
      'last_edited', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
      'note_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES note_local_model (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, lastEdited, position, noteId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_local_model';
  @override
  VerificationContext validateIntegrity(Insertable<ContentDrift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_edited')) {
      context.handle(
          _lastEditedMeta,
          lastEdited.isAcceptableOrUnknown(
              data['last_edited']!, _lastEditedMeta));
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('note_id')) {
      context.handle(_noteIdMeta,
          noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta));
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  ContentDrift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentDrift(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastEdited: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_edited']),
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      noteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note_id'])!,
    );
  }

  @override
  $ContentLocalModelTable createAlias(String alias) {
    return $ContentLocalModelTable(attachedDatabase, alias);
  }
}

class ContentDrift extends DataClass implements Insertable<ContentDrift> {
  final String id;
  final DateTime createdAt;
  final DateTime? lastEdited;
  final int position;
  final String noteId;
  const ContentDrift(
      {required this.id,
      required this.createdAt,
      this.lastEdited,
      required this.position,
      required this.noteId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastEdited != null) {
      map['last_edited'] = Variable<DateTime>(lastEdited);
    }
    map['position'] = Variable<int>(position);
    map['note_id'] = Variable<String>(noteId);
    return map;
  }

  ContentLocalModelCompanion toCompanion(bool nullToAbsent) {
    return ContentLocalModelCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      lastEdited: lastEdited == null && nullToAbsent
          ? const Value.absent()
          : Value(lastEdited),
      position: Value(position),
      noteId: Value(noteId),
    );
  }

  factory ContentDrift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentDrift(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastEdited: serializer.fromJson<DateTime?>(json['lastEdited']),
      position: serializer.fromJson<int>(json['position']),
      noteId: serializer.fromJson<String>(json['noteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastEdited': serializer.toJson<DateTime?>(lastEdited),
      'position': serializer.toJson<int>(position),
      'noteId': serializer.toJson<String>(noteId),
    };
  }

  ContentDrift copyWith(
          {String? id,
          DateTime? createdAt,
          Value<DateTime?> lastEdited = const Value.absent(),
          int? position,
          String? noteId}) =>
      ContentDrift(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        lastEdited: lastEdited.present ? lastEdited.value : this.lastEdited,
        position: position ?? this.position,
        noteId: noteId ?? this.noteId,
      );
  ContentDrift copyWithCompanion(ContentLocalModelCompanion data) {
    return ContentDrift(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastEdited:
          data.lastEdited.present ? data.lastEdited.value : this.lastEdited,
      position: data.position.present ? data.position.value : this.position,
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentDrift(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastEdited: $lastEdited, ')
          ..write('position: $position, ')
          ..write('noteId: $noteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, lastEdited, position, noteId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentDrift &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.lastEdited == this.lastEdited &&
          other.position == this.position &&
          other.noteId == this.noteId);
}

class ContentLocalModelCompanion extends UpdateCompanion<ContentDrift> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastEdited;
  final Value<int> position;
  final Value<String> noteId;
  final Value<int> rowid;
  const ContentLocalModelCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastEdited = const Value.absent(),
    this.position = const Value.absent(),
    this.noteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentLocalModelCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastEdited = const Value.absent(),
    required int position,
    required String noteId,
    this.rowid = const Value.absent(),
  })  : position = Value(position),
        noteId = Value(noteId);
  static Insertable<ContentDrift> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastEdited,
    Expression<int>? position,
    Expression<String>? noteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (lastEdited != null) 'last_edited': lastEdited,
      if (position != null) 'position': position,
      if (noteId != null) 'note_id': noteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentLocalModelCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastEdited,
      Value<int>? position,
      Value<String>? noteId,
      Value<int>? rowid}) {
    return ContentLocalModelCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      lastEdited: lastEdited ?? this.lastEdited,
      position: position ?? this.position,
      noteId: noteId ?? this.noteId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastEdited.present) {
      map['last_edited'] = Variable<DateTime>(lastEdited.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentLocalModelCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastEdited: $lastEdited, ')
          ..write('position: $position, ')
          ..write('noteId: $noteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TextContentLocalModelTable extends TextContentLocalModel
    with TableInfo<$TextContentLocalModelTable, TextContentDrift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TextContentLocalModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta =
      const VerificationMeta('contentId');
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
      'content_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textContentMeta =
      const VerificationMeta('textContent');
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [contentId, textContent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'text_content_local_model';
  @override
  VerificationContext validateIntegrity(Insertable<TextContentDrift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta));
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_textContentMeta,
          textContent.isAcceptableOrUnknown(data['text']!, _textContentMeta));
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  TextContentDrift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TextContentDrift(
      contentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_id'])!,
      textContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
    );
  }

  @override
  $TextContentLocalModelTable createAlias(String alias) {
    return $TextContentLocalModelTable(attachedDatabase, alias);
  }
}

class TextContentDrift extends DataClass
    implements Insertable<TextContentDrift> {
  final String contentId;
  final String textContent;
  const TextContentDrift({required this.contentId, required this.textContent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['text'] = Variable<String>(textContent);
    return map;
  }

  TextContentLocalModelCompanion toCompanion(bool nullToAbsent) {
    return TextContentLocalModelCompanion(
      contentId: Value(contentId),
      textContent: Value(textContent),
    );
  }

  factory TextContentDrift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TextContentDrift(
      contentId: serializer.fromJson<String>(json['contentId']),
      textContent: serializer.fromJson<String>(json['textContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'textContent': serializer.toJson<String>(textContent),
    };
  }

  TextContentDrift copyWith({String? contentId, String? textContent}) =>
      TextContentDrift(
        contentId: contentId ?? this.contentId,
        textContent: textContent ?? this.textContent,
      );
  TextContentDrift copyWithCompanion(TextContentLocalModelCompanion data) {
    return TextContentDrift(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TextContentDrift(')
          ..write('contentId: $contentId, ')
          ..write('textContent: $textContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, textContent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TextContentDrift &&
          other.contentId == this.contentId &&
          other.textContent == this.textContent);
}

class TextContentLocalModelCompanion extends UpdateCompanion<TextContentDrift> {
  final Value<String> contentId;
  final Value<String> textContent;
  final Value<int> rowid;
  const TextContentLocalModelCompanion({
    this.contentId = const Value.absent(),
    this.textContent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TextContentLocalModelCompanion.insert({
    required String contentId,
    required String textContent,
    this.rowid = const Value.absent(),
  })  : contentId = Value(contentId),
        textContent = Value(textContent);
  static Insertable<TextContentDrift> custom({
    Expression<String>? contentId,
    Expression<String>? textContent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (textContent != null) 'text': textContent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TextContentLocalModelCompanion copyWith(
      {Value<String>? contentId,
      Value<String>? textContent,
      Value<int>? rowid}) {
    return TextContentLocalModelCompanion(
      contentId: contentId ?? this.contentId,
      textContent: textContent ?? this.textContent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (textContent.present) {
      map['text'] = Variable<String>(textContent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TextContentLocalModelCompanion(')
          ..write('contentId: $contentId, ')
          ..write('textContent: $textContent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImageContentLocalModelTable extends ImageContentLocalModel
    with TableInfo<$ImageContentLocalModelTable, ImageContentDrift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImageContentLocalModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta =
      const VerificationMeta('contentId');
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
      'content_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageFileNameMeta =
      const VerificationMeta('imageFileName');
  @override
  late final GeneratedColumn<String> imageFileName = GeneratedColumn<String>(
      'image_file_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [contentId, imageFileName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'image_content_local_model';
  @override
  VerificationContext validateIntegrity(Insertable<ImageContentDrift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta));
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('image_file_name')) {
      context.handle(
          _imageFileNameMeta,
          imageFileName.isAcceptableOrUnknown(
              data['image_file_name']!, _imageFileNameMeta));
    } else if (isInserting) {
      context.missing(_imageFileNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  ImageContentDrift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImageContentDrift(
      contentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_id'])!,
      imageFileName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_file_name'])!,
    );
  }

  @override
  $ImageContentLocalModelTable createAlias(String alias) {
    return $ImageContentLocalModelTable(attachedDatabase, alias);
  }
}

class ImageContentDrift extends DataClass
    implements Insertable<ImageContentDrift> {
  final String contentId;
  final String imageFileName;
  const ImageContentDrift(
      {required this.contentId, required this.imageFileName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['image_file_name'] = Variable<String>(imageFileName);
    return map;
  }

  ImageContentLocalModelCompanion toCompanion(bool nullToAbsent) {
    return ImageContentLocalModelCompanion(
      contentId: Value(contentId),
      imageFileName: Value(imageFileName),
    );
  }

  factory ImageContentDrift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImageContentDrift(
      contentId: serializer.fromJson<String>(json['contentId']),
      imageFileName: serializer.fromJson<String>(json['imageFileName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'imageFileName': serializer.toJson<String>(imageFileName),
    };
  }

  ImageContentDrift copyWith({String? contentId, String? imageFileName}) =>
      ImageContentDrift(
        contentId: contentId ?? this.contentId,
        imageFileName: imageFileName ?? this.imageFileName,
      );
  ImageContentDrift copyWithCompanion(ImageContentLocalModelCompanion data) {
    return ImageContentDrift(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      imageFileName: data.imageFileName.present
          ? data.imageFileName.value
          : this.imageFileName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImageContentDrift(')
          ..write('contentId: $contentId, ')
          ..write('imageFileName: $imageFileName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, imageFileName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageContentDrift &&
          other.contentId == this.contentId &&
          other.imageFileName == this.imageFileName);
}

class ImageContentLocalModelCompanion
    extends UpdateCompanion<ImageContentDrift> {
  final Value<String> contentId;
  final Value<String> imageFileName;
  final Value<int> rowid;
  const ImageContentLocalModelCompanion({
    this.contentId = const Value.absent(),
    this.imageFileName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImageContentLocalModelCompanion.insert({
    required String contentId,
    required String imageFileName,
    this.rowid = const Value.absent(),
  })  : contentId = Value(contentId),
        imageFileName = Value(imageFileName);
  static Insertable<ImageContentDrift> custom({
    Expression<String>? contentId,
    Expression<String>? imageFileName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (imageFileName != null) 'image_file_name': imageFileName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImageContentLocalModelCompanion copyWith(
      {Value<String>? contentId,
      Value<String>? imageFileName,
      Value<int>? rowid}) {
    return ImageContentLocalModelCompanion(
      contentId: contentId ?? this.contentId,
      imageFileName: imageFileName ?? this.imageFileName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (imageFileName.present) {
      map['image_file_name'] = Variable<String>(imageFileName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImageContentLocalModelCompanion(')
          ..write('contentId: $contentId, ')
          ..write('imageFileName: $imageFileName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DrawingContentLocalModelTable extends DrawingContentLocalModel
    with TableInfo<$DrawingContentLocalModelTable, DrawingContentDrift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrawingContentLocalModelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta =
      const VerificationMeta('contentId');
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
      'content_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _drawingJsonContentMeta =
      const VerificationMeta('drawingJsonContent');
  @override
  late final GeneratedColumn<String> drawingJsonContent =
      GeneratedColumn<String>('drawing', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [contentId, drawingJsonContent];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drawing_content_local_model';
  @override
  VerificationContext validateIntegrity(
      Insertable<DrawingContentDrift> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(_contentIdMeta,
          contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta));
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('drawing')) {
      context.handle(
          _drawingJsonContentMeta,
          drawingJsonContent.isAcceptableOrUnknown(
              data['drawing']!, _drawingJsonContentMeta));
    } else if (isInserting) {
      context.missing(_drawingJsonContentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  DrawingContentDrift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrawingContentDrift(
      contentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_id'])!,
      drawingJsonContent: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}drawing'])!,
    );
  }

  @override
  $DrawingContentLocalModelTable createAlias(String alias) {
    return $DrawingContentLocalModelTable(attachedDatabase, alias);
  }
}

class DrawingContentDrift extends DataClass
    implements Insertable<DrawingContentDrift> {
  final String contentId;
  final String drawingJsonContent;
  const DrawingContentDrift(
      {required this.contentId, required this.drawingJsonContent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['drawing'] = Variable<String>(drawingJsonContent);
    return map;
  }

  DrawingContentLocalModelCompanion toCompanion(bool nullToAbsent) {
    return DrawingContentLocalModelCompanion(
      contentId: Value(contentId),
      drawingJsonContent: Value(drawingJsonContent),
    );
  }

  factory DrawingContentDrift.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrawingContentDrift(
      contentId: serializer.fromJson<String>(json['contentId']),
      drawingJsonContent:
          serializer.fromJson<String>(json['drawingJsonContent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'drawingJsonContent': serializer.toJson<String>(drawingJsonContent),
    };
  }

  DrawingContentDrift copyWith(
          {String? contentId, String? drawingJsonContent}) =>
      DrawingContentDrift(
        contentId: contentId ?? this.contentId,
        drawingJsonContent: drawingJsonContent ?? this.drawingJsonContent,
      );
  DrawingContentDrift copyWithCompanion(
      DrawingContentLocalModelCompanion data) {
    return DrawingContentDrift(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      drawingJsonContent: data.drawingJsonContent.present
          ? data.drawingJsonContent.value
          : this.drawingJsonContent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrawingContentDrift(')
          ..write('contentId: $contentId, ')
          ..write('drawingJsonContent: $drawingJsonContent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentId, drawingJsonContent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrawingContentDrift &&
          other.contentId == this.contentId &&
          other.drawingJsonContent == this.drawingJsonContent);
}

class DrawingContentLocalModelCompanion
    extends UpdateCompanion<DrawingContentDrift> {
  final Value<String> contentId;
  final Value<String> drawingJsonContent;
  final Value<int> rowid;
  const DrawingContentLocalModelCompanion({
    this.contentId = const Value.absent(),
    this.drawingJsonContent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DrawingContentLocalModelCompanion.insert({
    required String contentId,
    required String drawingJsonContent,
    this.rowid = const Value.absent(),
  })  : contentId = Value(contentId),
        drawingJsonContent = Value(drawingJsonContent);
  static Insertable<DrawingContentDrift> custom({
    Expression<String>? contentId,
    Expression<String>? drawingJsonContent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (drawingJsonContent != null) 'drawing': drawingJsonContent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DrawingContentLocalModelCompanion copyWith(
      {Value<String>? contentId,
      Value<String>? drawingJsonContent,
      Value<int>? rowid}) {
    return DrawingContentLocalModelCompanion(
      contentId: contentId ?? this.contentId,
      drawingJsonContent: drawingJsonContent ?? this.drawingJsonContent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (drawingJsonContent.present) {
      map['drawing'] = Variable<String>(drawingJsonContent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrawingContentLocalModelCompanion(')
          ..write('contentId: $contentId, ')
          ..write('drawingJsonContent: $drawingJsonContent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$SqliteDatabase extends GeneratedDatabase {
  _$SqliteDatabase(QueryExecutor e) : super(e);
  $SqliteDatabaseManager get managers => $SqliteDatabaseManager(this);
  late final $NoteLocalModelTable noteLocalModel = $NoteLocalModelTable(this);
  late final $ContentLocalModelTable contentLocalModel =
      $ContentLocalModelTable(this);
  late final $TextContentLocalModelTable textContentLocalModel =
      $TextContentLocalModelTable(this);
  late final $ImageContentLocalModelTable imageContentLocalModel =
      $ImageContentLocalModelTable(this);
  late final $DrawingContentLocalModelTable drawingContentLocalModel =
      $DrawingContentLocalModelTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        noteLocalModel,
        contentLocalModel,
        textContentLocalModel,
        imageContentLocalModel,
        drawingContentLocalModel
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('note_local_model',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('content_local_model', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$NoteLocalModelTableCreateCompanionBuilder = NoteLocalModelCompanion
    Function({
  Value<String> id,
  required String name,
  Value<DateTime> createdAt,
  Value<DateTime?> lastEdited,
  Value<int> rowid,
});
typedef $$NoteLocalModelTableUpdateCompanionBuilder = NoteLocalModelCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<DateTime> createdAt,
  Value<DateTime?> lastEdited,
  Value<int> rowid,
});

final class $$NoteLocalModelTableReferences
    extends BaseReferences<_$SqliteDatabase, $NoteLocalModelTable, NoteDrift> {
  $$NoteLocalModelTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContentLocalModelTable, List<ContentDrift>>
      _contentLocalModelRefsTable(_$SqliteDatabase db) =>
          MultiTypedResultKey.fromTable(db.contentLocalModel,
              aliasName: $_aliasNameGenerator(
                  db.noteLocalModel.id, db.contentLocalModel.noteId));

  $$ContentLocalModelTableProcessedTableManager get contentLocalModelRefs {
    final manager =
        $$ContentLocalModelTableTableManager($_db, $_db.contentLocalModel)
            .filter((f) => f.noteId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_contentLocalModelRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$NoteLocalModelTableFilterComposer
    extends Composer<_$SqliteDatabase, $NoteLocalModelTable> {
  $$NoteLocalModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastEdited => $composableBuilder(
      column: $table.lastEdited, builder: (column) => ColumnFilters(column));

  Expression<bool> contentLocalModelRefs(
      Expression<bool> Function($$ContentLocalModelTableFilterComposer f) f) {
    final $$ContentLocalModelTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.contentLocalModel,
        getReferencedColumn: (t) => t.noteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContentLocalModelTableFilterComposer(
              $db: $db,
              $table: $db.contentLocalModel,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NoteLocalModelTableOrderingComposer
    extends Composer<_$SqliteDatabase, $NoteLocalModelTable> {
  $$NoteLocalModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastEdited => $composableBuilder(
      column: $table.lastEdited, builder: (column) => ColumnOrderings(column));
}

class $$NoteLocalModelTableAnnotationComposer
    extends Composer<_$SqliteDatabase, $NoteLocalModelTable> {
  $$NoteLocalModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEdited => $composableBuilder(
      column: $table.lastEdited, builder: (column) => column);

  Expression<T> contentLocalModelRefs<T extends Object>(
      Expression<T> Function($$ContentLocalModelTableAnnotationComposer a) f) {
    final $$ContentLocalModelTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.contentLocalModel,
            getReferencedColumn: (t) => t.noteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ContentLocalModelTableAnnotationComposer(
                  $db: $db,
                  $table: $db.contentLocalModel,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$NoteLocalModelTableTableManager extends RootTableManager<
    _$SqliteDatabase,
    $NoteLocalModelTable,
    NoteDrift,
    $$NoteLocalModelTableFilterComposer,
    $$NoteLocalModelTableOrderingComposer,
    $$NoteLocalModelTableAnnotationComposer,
    $$NoteLocalModelTableCreateCompanionBuilder,
    $$NoteLocalModelTableUpdateCompanionBuilder,
    (NoteDrift, $$NoteLocalModelTableReferences),
    NoteDrift,
    PrefetchHooks Function({bool contentLocalModelRefs})> {
  $$NoteLocalModelTableTableManager(
      _$SqliteDatabase db, $NoteLocalModelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteLocalModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteLocalModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteLocalModelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastEdited = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteLocalModelCompanion(
            id: id,
            name: name,
            createdAt: createdAt,
            lastEdited: lastEdited,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastEdited = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NoteLocalModelCompanion.insert(
            id: id,
            name: name,
            createdAt: createdAt,
            lastEdited: lastEdited,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NoteLocalModelTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({contentLocalModelRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (contentLocalModelRefs) db.contentLocalModel
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contentLocalModelRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$NoteLocalModelTableReferences
                            ._contentLocalModelRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NoteLocalModelTableReferences(db, table, p0)
                                .contentLocalModelRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.noteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$NoteLocalModelTableProcessedTableManager = ProcessedTableManager<
    _$SqliteDatabase,
    $NoteLocalModelTable,
    NoteDrift,
    $$NoteLocalModelTableFilterComposer,
    $$NoteLocalModelTableOrderingComposer,
    $$NoteLocalModelTableAnnotationComposer,
    $$NoteLocalModelTableCreateCompanionBuilder,
    $$NoteLocalModelTableUpdateCompanionBuilder,
    (NoteDrift, $$NoteLocalModelTableReferences),
    NoteDrift,
    PrefetchHooks Function({bool contentLocalModelRefs})>;
typedef $$ContentLocalModelTableCreateCompanionBuilder
    = ContentLocalModelCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime?> lastEdited,
  required int position,
  required String noteId,
  Value<int> rowid,
});
typedef $$ContentLocalModelTableUpdateCompanionBuilder
    = ContentLocalModelCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime?> lastEdited,
  Value<int> position,
  Value<String> noteId,
  Value<int> rowid,
});

final class $$ContentLocalModelTableReferences extends BaseReferences<
    _$SqliteDatabase, $ContentLocalModelTable, ContentDrift> {
  $$ContentLocalModelTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $NoteLocalModelTable _noteIdTable(_$SqliteDatabase db) =>
      db.noteLocalModel.createAlias($_aliasNameGenerator(
          db.contentLocalModel.noteId, db.noteLocalModel.id));

  $$NoteLocalModelTableProcessedTableManager get noteId {
    final manager = $$NoteLocalModelTableTableManager($_db, $_db.noteLocalModel)
        .filter((f) => f.id($_item.noteId));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ContentLocalModelTableFilterComposer
    extends Composer<_$SqliteDatabase, $ContentLocalModelTable> {
  $$ContentLocalModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastEdited => $composableBuilder(
      column: $table.lastEdited, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  $$NoteLocalModelTableFilterComposer get noteId {
    final $$NoteLocalModelTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.noteLocalModel,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteLocalModelTableFilterComposer(
              $db: $db,
              $table: $db.noteLocalModel,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContentLocalModelTableOrderingComposer
    extends Composer<_$SqliteDatabase, $ContentLocalModelTable> {
  $$ContentLocalModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastEdited => $composableBuilder(
      column: $table.lastEdited, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  $$NoteLocalModelTableOrderingComposer get noteId {
    final $$NoteLocalModelTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.noteLocalModel,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteLocalModelTableOrderingComposer(
              $db: $db,
              $table: $db.noteLocalModel,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContentLocalModelTableAnnotationComposer
    extends Composer<_$SqliteDatabase, $ContentLocalModelTable> {
  $$ContentLocalModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastEdited => $composableBuilder(
      column: $table.lastEdited, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$NoteLocalModelTableAnnotationComposer get noteId {
    final $$NoteLocalModelTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.noteId,
        referencedTable: $db.noteLocalModel,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NoteLocalModelTableAnnotationComposer(
              $db: $db,
              $table: $db.noteLocalModel,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContentLocalModelTableTableManager extends RootTableManager<
    _$SqliteDatabase,
    $ContentLocalModelTable,
    ContentDrift,
    $$ContentLocalModelTableFilterComposer,
    $$ContentLocalModelTableOrderingComposer,
    $$ContentLocalModelTableAnnotationComposer,
    $$ContentLocalModelTableCreateCompanionBuilder,
    $$ContentLocalModelTableUpdateCompanionBuilder,
    (ContentDrift, $$ContentLocalModelTableReferences),
    ContentDrift,
    PrefetchHooks Function({bool noteId})> {
  $$ContentLocalModelTableTableManager(
      _$SqliteDatabase db, $ContentLocalModelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentLocalModelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentLocalModelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentLocalModelTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastEdited = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> noteId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentLocalModelCompanion(
            id: id,
            createdAt: createdAt,
            lastEdited: lastEdited,
            position: position,
            noteId: noteId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastEdited = const Value.absent(),
            required int position,
            required String noteId,
            Value<int> rowid = const Value.absent(),
          }) =>
              ContentLocalModelCompanion.insert(
            id: id,
            createdAt: createdAt,
            lastEdited: lastEdited,
            position: position,
            noteId: noteId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ContentLocalModelTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({noteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (noteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.noteId,
                    referencedTable:
                        $$ContentLocalModelTableReferences._noteIdTable(db),
                    referencedColumn:
                        $$ContentLocalModelTableReferences._noteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ContentLocalModelTableProcessedTableManager = ProcessedTableManager<
    _$SqliteDatabase,
    $ContentLocalModelTable,
    ContentDrift,
    $$ContentLocalModelTableFilterComposer,
    $$ContentLocalModelTableOrderingComposer,
    $$ContentLocalModelTableAnnotationComposer,
    $$ContentLocalModelTableCreateCompanionBuilder,
    $$ContentLocalModelTableUpdateCompanionBuilder,
    (ContentDrift, $$ContentLocalModelTableReferences),
    ContentDrift,
    PrefetchHooks Function({bool noteId})>;
typedef $$TextContentLocalModelTableCreateCompanionBuilder
    = TextContentLocalModelCompanion Function({
  required String contentId,
  required String textContent,
  Value<int> rowid,
});
typedef $$TextContentLocalModelTableUpdateCompanionBuilder
    = TextContentLocalModelCompanion Function({
  Value<String> contentId,
  Value<String> textContent,
  Value<int> rowid,
});

class $$TextContentLocalModelTableFilterComposer
    extends Composer<_$SqliteDatabase, $TextContentLocalModelTable> {
  $$TextContentLocalModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnFilters(column));
}

class $$TextContentLocalModelTableOrderingComposer
    extends Composer<_$SqliteDatabase, $TextContentLocalModelTable> {
  $$TextContentLocalModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => ColumnOrderings(column));
}

class $$TextContentLocalModelTableAnnotationComposer
    extends Composer<_$SqliteDatabase, $TextContentLocalModelTable> {
  $$TextContentLocalModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
      column: $table.textContent, builder: (column) => column);
}

class $$TextContentLocalModelTableTableManager extends RootTableManager<
    _$SqliteDatabase,
    $TextContentLocalModelTable,
    TextContentDrift,
    $$TextContentLocalModelTableFilterComposer,
    $$TextContentLocalModelTableOrderingComposer,
    $$TextContentLocalModelTableAnnotationComposer,
    $$TextContentLocalModelTableCreateCompanionBuilder,
    $$TextContentLocalModelTableUpdateCompanionBuilder,
    (
      TextContentDrift,
      BaseReferences<_$SqliteDatabase, $TextContentLocalModelTable,
          TextContentDrift>
    ),
    TextContentDrift,
    PrefetchHooks Function()> {
  $$TextContentLocalModelTableTableManager(
      _$SqliteDatabase db, $TextContentLocalModelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TextContentLocalModelTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$TextContentLocalModelTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TextContentLocalModelTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> contentId = const Value.absent(),
            Value<String> textContent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TextContentLocalModelCompanion(
            contentId: contentId,
            textContent: textContent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String contentId,
            required String textContent,
            Value<int> rowid = const Value.absent(),
          }) =>
              TextContentLocalModelCompanion.insert(
            contentId: contentId,
            textContent: textContent,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TextContentLocalModelTableProcessedTableManager
    = ProcessedTableManager<
        _$SqliteDatabase,
        $TextContentLocalModelTable,
        TextContentDrift,
        $$TextContentLocalModelTableFilterComposer,
        $$TextContentLocalModelTableOrderingComposer,
        $$TextContentLocalModelTableAnnotationComposer,
        $$TextContentLocalModelTableCreateCompanionBuilder,
        $$TextContentLocalModelTableUpdateCompanionBuilder,
        (
          TextContentDrift,
          BaseReferences<_$SqliteDatabase, $TextContentLocalModelTable,
              TextContentDrift>
        ),
        TextContentDrift,
        PrefetchHooks Function()>;
typedef $$ImageContentLocalModelTableCreateCompanionBuilder
    = ImageContentLocalModelCompanion Function({
  required String contentId,
  required String imageFileName,
  Value<int> rowid,
});
typedef $$ImageContentLocalModelTableUpdateCompanionBuilder
    = ImageContentLocalModelCompanion Function({
  Value<String> contentId,
  Value<String> imageFileName,
  Value<int> rowid,
});

class $$ImageContentLocalModelTableFilterComposer
    extends Composer<_$SqliteDatabase, $ImageContentLocalModelTable> {
  $$ImageContentLocalModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageFileName => $composableBuilder(
      column: $table.imageFileName, builder: (column) => ColumnFilters(column));
}

class $$ImageContentLocalModelTableOrderingComposer
    extends Composer<_$SqliteDatabase, $ImageContentLocalModelTable> {
  $$ImageContentLocalModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageFileName => $composableBuilder(
      column: $table.imageFileName,
      builder: (column) => ColumnOrderings(column));
}

class $$ImageContentLocalModelTableAnnotationComposer
    extends Composer<_$SqliteDatabase, $ImageContentLocalModelTable> {
  $$ImageContentLocalModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get imageFileName => $composableBuilder(
      column: $table.imageFileName, builder: (column) => column);
}

class $$ImageContentLocalModelTableTableManager extends RootTableManager<
    _$SqliteDatabase,
    $ImageContentLocalModelTable,
    ImageContentDrift,
    $$ImageContentLocalModelTableFilterComposer,
    $$ImageContentLocalModelTableOrderingComposer,
    $$ImageContentLocalModelTableAnnotationComposer,
    $$ImageContentLocalModelTableCreateCompanionBuilder,
    $$ImageContentLocalModelTableUpdateCompanionBuilder,
    (
      ImageContentDrift,
      BaseReferences<_$SqliteDatabase, $ImageContentLocalModelTable,
          ImageContentDrift>
    ),
    ImageContentDrift,
    PrefetchHooks Function()> {
  $$ImageContentLocalModelTableTableManager(
      _$SqliteDatabase db, $ImageContentLocalModelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImageContentLocalModelTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ImageContentLocalModelTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImageContentLocalModelTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> contentId = const Value.absent(),
            Value<String> imageFileName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ImageContentLocalModelCompanion(
            contentId: contentId,
            imageFileName: imageFileName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String contentId,
            required String imageFileName,
            Value<int> rowid = const Value.absent(),
          }) =>
              ImageContentLocalModelCompanion.insert(
            contentId: contentId,
            imageFileName: imageFileName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ImageContentLocalModelTableProcessedTableManager
    = ProcessedTableManager<
        _$SqliteDatabase,
        $ImageContentLocalModelTable,
        ImageContentDrift,
        $$ImageContentLocalModelTableFilterComposer,
        $$ImageContentLocalModelTableOrderingComposer,
        $$ImageContentLocalModelTableAnnotationComposer,
        $$ImageContentLocalModelTableCreateCompanionBuilder,
        $$ImageContentLocalModelTableUpdateCompanionBuilder,
        (
          ImageContentDrift,
          BaseReferences<_$SqliteDatabase, $ImageContentLocalModelTable,
              ImageContentDrift>
        ),
        ImageContentDrift,
        PrefetchHooks Function()>;
typedef $$DrawingContentLocalModelTableCreateCompanionBuilder
    = DrawingContentLocalModelCompanion Function({
  required String contentId,
  required String drawingJsonContent,
  Value<int> rowid,
});
typedef $$DrawingContentLocalModelTableUpdateCompanionBuilder
    = DrawingContentLocalModelCompanion Function({
  Value<String> contentId,
  Value<String> drawingJsonContent,
  Value<int> rowid,
});

class $$DrawingContentLocalModelTableFilterComposer
    extends Composer<_$SqliteDatabase, $DrawingContentLocalModelTable> {
  $$DrawingContentLocalModelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get drawingJsonContent => $composableBuilder(
      column: $table.drawingJsonContent,
      builder: (column) => ColumnFilters(column));
}

class $$DrawingContentLocalModelTableOrderingComposer
    extends Composer<_$SqliteDatabase, $DrawingContentLocalModelTable> {
  $$DrawingContentLocalModelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
      column: $table.contentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get drawingJsonContent => $composableBuilder(
      column: $table.drawingJsonContent,
      builder: (column) => ColumnOrderings(column));
}

class $$DrawingContentLocalModelTableAnnotationComposer
    extends Composer<_$SqliteDatabase, $DrawingContentLocalModelTable> {
  $$DrawingContentLocalModelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get drawingJsonContent => $composableBuilder(
      column: $table.drawingJsonContent, builder: (column) => column);
}

class $$DrawingContentLocalModelTableTableManager extends RootTableManager<
    _$SqliteDatabase,
    $DrawingContentLocalModelTable,
    DrawingContentDrift,
    $$DrawingContentLocalModelTableFilterComposer,
    $$DrawingContentLocalModelTableOrderingComposer,
    $$DrawingContentLocalModelTableAnnotationComposer,
    $$DrawingContentLocalModelTableCreateCompanionBuilder,
    $$DrawingContentLocalModelTableUpdateCompanionBuilder,
    (
      DrawingContentDrift,
      BaseReferences<_$SqliteDatabase, $DrawingContentLocalModelTable,
          DrawingContentDrift>
    ),
    DrawingContentDrift,
    PrefetchHooks Function()> {
  $$DrawingContentLocalModelTableTableManager(
      _$SqliteDatabase db, $DrawingContentLocalModelTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DrawingContentLocalModelTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$DrawingContentLocalModelTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DrawingContentLocalModelTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> contentId = const Value.absent(),
            Value<String> drawingJsonContent = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DrawingContentLocalModelCompanion(
            contentId: contentId,
            drawingJsonContent: drawingJsonContent,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String contentId,
            required String drawingJsonContent,
            Value<int> rowid = const Value.absent(),
          }) =>
              DrawingContentLocalModelCompanion.insert(
            contentId: contentId,
            drawingJsonContent: drawingJsonContent,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DrawingContentLocalModelTableProcessedTableManager
    = ProcessedTableManager<
        _$SqliteDatabase,
        $DrawingContentLocalModelTable,
        DrawingContentDrift,
        $$DrawingContentLocalModelTableFilterComposer,
        $$DrawingContentLocalModelTableOrderingComposer,
        $$DrawingContentLocalModelTableAnnotationComposer,
        $$DrawingContentLocalModelTableCreateCompanionBuilder,
        $$DrawingContentLocalModelTableUpdateCompanionBuilder,
        (
          DrawingContentDrift,
          BaseReferences<_$SqliteDatabase, $DrawingContentLocalModelTable,
              DrawingContentDrift>
        ),
        DrawingContentDrift,
        PrefetchHooks Function()>;

class $SqliteDatabaseManager {
  final _$SqliteDatabase _db;
  $SqliteDatabaseManager(this._db);
  $$NoteLocalModelTableTableManager get noteLocalModel =>
      $$NoteLocalModelTableTableManager(_db, _db.noteLocalModel);
  $$ContentLocalModelTableTableManager get contentLocalModel =>
      $$ContentLocalModelTableTableManager(_db, _db.contentLocalModel);
  $$TextContentLocalModelTableTableManager get textContentLocalModel =>
      $$TextContentLocalModelTableTableManager(_db, _db.textContentLocalModel);
  $$ImageContentLocalModelTableTableManager get imageContentLocalModel =>
      $$ImageContentLocalModelTableTableManager(
          _db, _db.imageContentLocalModel);
  $$DrawingContentLocalModelTableTableManager get drawingContentLocalModel =>
      $$DrawingContentLocalModelTableTableManager(
          _db, _db.drawingContentLocalModel);
}
