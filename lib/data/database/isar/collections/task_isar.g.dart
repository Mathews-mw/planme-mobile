// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskIsarCollection on Isar {
  IsarCollection<TaskIsar> get taskIsars => this.collection();
}

const TaskIsarSchema = CollectionSchema(
  name: r'tasks',
  id: -1059002862309002494,
  properties: {
    r'base_datetime': PropertySchema(
      id: 0,
      name: r'base_datetime',
      type: IsarType.dateTime,
    ),
    r'completed_at': PropertySchema(
      id: 1,
      name: r'completed_at',
      type: IsarType.dateTime,
    ),
    r'created_at': PropertySchema(
      id: 2,
      name: r'created_at',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'is_completed': PropertySchema(
      id: 4,
      name: r'is_completed',
      type: IsarType.bool,
    ),
    r'is_starred': PropertySchema(
      id: 5,
      name: r'is_starred',
      type: IsarType.bool,
    ),
    r'recurrence': PropertySchema(
      id: 6,
      name: r'recurrence',
      type: IsarType.object,
      target: r'RecurrenceRuleEmbedded',
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    ),
    r'uid': PropertySchema(
      id: 8,
      name: r'uid',
      type: IsarType.string,
    ),
    r'updated_at': PropertySchema(
      id: 9,
      name: r'updated_at',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _taskIsarEstimateSize,
  serialize: _taskIsarSerialize,
  deserialize: _taskIsarDeserialize,
  deserializeProp: _taskIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'uid': IndexSchema(
      id: 8193695471701937315,
      name: r'uid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'RecurrenceRuleEmbedded': RecurrenceRuleEmbeddedSchema,
    r'RecurrenceEndEmbedded': RecurrenceEndEmbeddedSchema
  },
  getId: _taskIsarGetId,
  getLinks: _taskIsarGetLinks,
  attach: _taskIsarAttach,
  version: '3.1.0+1',
);

int _taskIsarEstimateSize(
  TaskIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.recurrence;
    if (value != null) {
      bytesCount += 3 +
          RecurrenceRuleEmbeddedSchema.estimateSize(
              value, allOffsets[RecurrenceRuleEmbedded]!, allOffsets);
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.uid.length * 3;
  return bytesCount;
}

void _taskIsarSerialize(
  TaskIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.baseDateTime);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.description);
  writer.writeBool(offsets[4], object.isCompleted);
  writer.writeBool(offsets[5], object.isStarred);
  writer.writeObject<RecurrenceRuleEmbedded>(
    offsets[6],
    allOffsets,
    RecurrenceRuleEmbeddedSchema.serialize,
    object.recurrence,
  );
  writer.writeString(offsets[7], object.title);
  writer.writeString(offsets[8], object.uid);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

TaskIsar _taskIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskIsar();
  object.baseDateTime = reader.readDateTimeOrNull(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.description = reader.readStringOrNull(offsets[3]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[4]);
  object.isStarred = reader.readBool(offsets[5]);
  object.recurrence = reader.readObjectOrNull<RecurrenceRuleEmbedded>(
    offsets[6],
    RecurrenceRuleEmbeddedSchema.deserialize,
    allOffsets,
  );
  object.title = reader.readString(offsets[7]);
  object.uid = reader.readString(offsets[8]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[9]);
  return object;
}

P _taskIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readObjectOrNull<RecurrenceRuleEmbedded>(
        offset,
        RecurrenceRuleEmbeddedSchema.deserialize,
        allOffsets,
      )) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taskIsarGetId(TaskIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskIsarGetLinks(TaskIsar object) {
  return [];
}

void _taskIsarAttach(IsarCollection<dynamic> col, Id id, TaskIsar object) {
  object.id = id;
}

extension TaskIsarByIndex on IsarCollection<TaskIsar> {
  Future<TaskIsar?> getByUid(String uid) {
    return getByIndex(r'uid', [uid]);
  }

  TaskIsar? getByUidSync(String uid) {
    return getByIndexSync(r'uid', [uid]);
  }

  Future<bool> deleteByUid(String uid) {
    return deleteByIndex(r'uid', [uid]);
  }

  bool deleteByUidSync(String uid) {
    return deleteByIndexSync(r'uid', [uid]);
  }

  Future<List<TaskIsar?>> getAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uid', values);
  }

  List<TaskIsar?> getAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uid', values);
  }

  Future<int> deleteAllByUid(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uid', values);
  }

  int deleteAllByUidSync(List<String> uidValues) {
    final values = uidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uid', values);
  }

  Future<Id> putByUid(TaskIsar object) {
    return putByIndex(r'uid', object);
  }

  Id putByUidSync(TaskIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'uid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUid(List<TaskIsar> objects) {
    return putAllByIndex(r'uid', objects);
  }

  List<Id> putAllByUidSync(List<TaskIsar> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'uid', objects, saveLinks: saveLinks);
  }
}

extension TaskIsarQueryWhereSort on QueryBuilder<TaskIsar, TaskIsar, QWhere> {
  QueryBuilder<TaskIsar, TaskIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaskIsarQueryWhere on QueryBuilder<TaskIsar, TaskIsar, QWhereClause> {
  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> uidEqualTo(String uid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uid',
        value: [uid],
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterWhereClause> uidNotEqualTo(
      String uid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [uid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uid',
              lower: [],
              upper: [uid],
              includeUpper: false,
            ));
      }
    });
  }
}

extension TaskIsarQueryFilter
    on QueryBuilder<TaskIsar, TaskIsar, QFilterCondition> {
  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> baseDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'base_datetime',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      baseDateTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'base_datetime',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> baseDateTimeEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'base_datetime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      baseDateTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'base_datetime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> baseDateTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'base_datetime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> baseDateTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'base_datetime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completed_at',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completed_at',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completed_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completed_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completed_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'created_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'created_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> isCompletedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'is_completed',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> isStarredEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'is_starred',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> recurrenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'recurrence',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition>
      recurrenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'recurrence',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> uidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uid',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updated_at',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updated_at',
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updated_at',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updated_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskIsarQueryObject
    on QueryBuilder<TaskIsar, TaskIsar, QFilterCondition> {
  QueryBuilder<TaskIsar, TaskIsar, QAfterFilterCondition> recurrence(
      FilterQuery<RecurrenceRuleEmbedded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'recurrence');
    });
  }
}

extension TaskIsarQueryLinks
    on QueryBuilder<TaskIsar, TaskIsar, QFilterCondition> {}

extension TaskIsarQuerySortBy on QueryBuilder<TaskIsar, TaskIsar, QSortBy> {
  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByBaseDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base_datetime', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByBaseDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base_datetime', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed_at', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed_at', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_completed', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_completed', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByIsStarred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_starred', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByIsStarredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_starred', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }
}

extension TaskIsarQuerySortThenBy
    on QueryBuilder<TaskIsar, TaskIsar, QSortThenBy> {
  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByBaseDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base_datetime', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByBaseDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'base_datetime', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed_at', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed_at', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'created_at', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_completed', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_completed', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByIsStarred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_starred', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByIsStarredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'is_starred', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uid', Sort.desc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.asc);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updated_at', Sort.desc);
    });
  }
}

extension TaskIsarQueryWhereDistinct
    on QueryBuilder<TaskIsar, TaskIsar, QDistinct> {
  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByBaseDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'base_datetime');
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed_at');
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'created_at');
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'is_completed');
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByIsStarred() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'is_starred');
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskIsar, TaskIsar, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updated_at');
    });
  }
}

extension TaskIsarQueryProperty
    on QueryBuilder<TaskIsar, TaskIsar, QQueryProperty> {
  QueryBuilder<TaskIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskIsar, DateTime?, QQueryOperations> baseDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'base_datetime');
    });
  }

  QueryBuilder<TaskIsar, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed_at');
    });
  }

  QueryBuilder<TaskIsar, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'created_at');
    });
  }

  QueryBuilder<TaskIsar, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TaskIsar, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'is_completed');
    });
  }

  QueryBuilder<TaskIsar, bool, QQueryOperations> isStarredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'is_starred');
    });
  }

  QueryBuilder<TaskIsar, RecurrenceRuleEmbedded?, QQueryOperations>
      recurrenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrence');
    });
  }

  QueryBuilder<TaskIsar, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TaskIsar, String, QQueryOperations> uidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uid');
    });
  }

  QueryBuilder<TaskIsar, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updated_at');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RecurrenceRuleEmbeddedSchema = Schema(
  name: r'RecurrenceRuleEmbedded',
  id: -7194760108644095969,
  properties: {
    r'dayOfMonth': PropertySchema(
      id: 0,
      name: r'dayOfMonth',
      type: IsarType.long,
    ),
    r'end': PropertySchema(
      id: 1,
      name: r'end',
      type: IsarType.object,
      target: r'RecurrenceEndEmbedded',
    ),
    r'interval': PropertySchema(
      id: 2,
      name: r'interval',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 3,
      name: r'type',
      type: IsarType.byte,
      enumMap: _RecurrenceRuleEmbeddedtypeEnumValueMap,
    ),
    r'weekOfMonth': PropertySchema(
      id: 4,
      name: r'weekOfMonth',
      type: IsarType.long,
    ),
    r'weekdayOfMonth': PropertySchema(
      id: 5,
      name: r'weekdayOfMonth',
      type: IsarType.long,
    ),
    r'weekdaysBitmask': PropertySchema(
      id: 6,
      name: r'weekdaysBitmask',
      type: IsarType.long,
    )
  },
  estimateSize: _recurrenceRuleEmbeddedEstimateSize,
  serialize: _recurrenceRuleEmbeddedSerialize,
  deserialize: _recurrenceRuleEmbeddedDeserialize,
  deserializeProp: _recurrenceRuleEmbeddedDeserializeProp,
);

int _recurrenceRuleEmbeddedEstimateSize(
  RecurrenceRuleEmbedded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.end;
    if (value != null) {
      bytesCount += 3 +
          RecurrenceEndEmbeddedSchema.estimateSize(
              value, allOffsets[RecurrenceEndEmbedded]!, allOffsets);
    }
  }
  return bytesCount;
}

void _recurrenceRuleEmbeddedSerialize(
  RecurrenceRuleEmbedded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayOfMonth);
  writer.writeObject<RecurrenceEndEmbedded>(
    offsets[1],
    allOffsets,
    RecurrenceEndEmbeddedSchema.serialize,
    object.end,
  );
  writer.writeLong(offsets[2], object.interval);
  writer.writeByte(offsets[3], object.type.index);
  writer.writeLong(offsets[4], object.weekOfMonth);
  writer.writeLong(offsets[5], object.weekdayOfMonth);
  writer.writeLong(offsets[6], object.weekdaysBitmask);
}

RecurrenceRuleEmbedded _recurrenceRuleEmbeddedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecurrenceRuleEmbedded();
  object.dayOfMonth = reader.readLongOrNull(offsets[0]);
  object.end = reader.readObjectOrNull<RecurrenceEndEmbedded>(
    offsets[1],
    RecurrenceEndEmbeddedSchema.deserialize,
    allOffsets,
  );
  object.interval = reader.readLongOrNull(offsets[2]);
  object.type = _RecurrenceRuleEmbeddedtypeValueEnumMap[
          reader.readByteOrNull(offsets[3])] ??
      RecurrenceType.none;
  object.weekOfMonth = reader.readLongOrNull(offsets[4]);
  object.weekdayOfMonth = reader.readLongOrNull(offsets[5]);
  object.weekdaysBitmask = reader.readLongOrNull(offsets[6]);
  return object;
}

P _recurrenceRuleEmbeddedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readObjectOrNull<RecurrenceEndEmbedded>(
        offset,
        RecurrenceEndEmbeddedSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (_RecurrenceRuleEmbeddedtypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RecurrenceType.none) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RecurrenceRuleEmbeddedtypeEnumValueMap = {
  'none': 0,
  'intervalDays': 1,
  'weekly': 2,
  'monthlyDayOfMonth': 3,
  'monthlyWeekdayOfMonth': 4,
  'yearly': 5,
};
const _RecurrenceRuleEmbeddedtypeValueEnumMap = {
  0: RecurrenceType.none,
  1: RecurrenceType.intervalDays,
  2: RecurrenceType.weekly,
  3: RecurrenceType.monthlyDayOfMonth,
  4: RecurrenceType.monthlyWeekdayOfMonth,
  5: RecurrenceType.yearly,
};

extension RecurrenceRuleEmbeddedQueryFilter on QueryBuilder<
    RecurrenceRuleEmbedded, RecurrenceRuleEmbedded, QFilterCondition> {
  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> dayOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayOfMonth',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> dayOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayOfMonth',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> dayOfMonthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> dayOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> dayOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> dayOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> endIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'end',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> endIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'end',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> intervalIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'interval',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> intervalIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'interval',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> intervalEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> intervalGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> intervalLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> intervalBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> typeEqualTo(RecurrenceType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> typeGreaterThan(
    RecurrenceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> typeLessThan(
    RecurrenceType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> typeBetween(
    RecurrenceType lower,
    RecurrenceType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekOfMonth',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekOfMonth',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekOfMonthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdayOfMonthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekdayOfMonth',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdayOfMonthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekdayOfMonth',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdayOfMonthEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdayOfMonthGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekdayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdayOfMonthLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekdayOfMonth',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdayOfMonthBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekdayOfMonth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdaysBitmaskIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekdaysBitmask',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdaysBitmaskIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekdaysBitmask',
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdaysBitmaskEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdaysBitmask',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdaysBitmaskGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekdaysBitmask',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdaysBitmaskLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekdaysBitmask',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> weekdaysBitmaskBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekdaysBitmask',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecurrenceRuleEmbeddedQueryObject on QueryBuilder<
    RecurrenceRuleEmbedded, RecurrenceRuleEmbedded, QFilterCondition> {
  QueryBuilder<RecurrenceRuleEmbedded, RecurrenceRuleEmbedded,
      QAfterFilterCondition> end(FilterQuery<RecurrenceEndEmbedded> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'end');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RecurrenceEndEmbeddedSchema = Schema(
  name: r'RecurrenceEndEmbedded',
  id: 3170320167331130803,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 2,
      name: r'type',
      type: IsarType.byte,
      enumMap: _RecurrenceEndEmbeddedtypeEnumValueMap,
    )
  },
  estimateSize: _recurrenceEndEmbeddedEstimateSize,
  serialize: _recurrenceEndEmbeddedSerialize,
  deserialize: _recurrenceEndEmbeddedDeserialize,
  deserializeProp: _recurrenceEndEmbeddedDeserializeProp,
);

int _recurrenceEndEmbeddedEstimateSize(
  RecurrenceEndEmbedded object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _recurrenceEndEmbeddedSerialize(
  RecurrenceEndEmbedded object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeByte(offsets[2], object.type.index);
}

RecurrenceEndEmbedded _recurrenceEndEmbeddedDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RecurrenceEndEmbedded();
  object.count = reader.readLongOrNull(offsets[0]);
  object.endDate = reader.readDateTimeOrNull(offsets[1]);
  object.type = _RecurrenceEndEmbeddedtypeValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      RecurrenceEndType.never;
  return object;
}

P _recurrenceEndEmbeddedDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (_RecurrenceEndEmbeddedtypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RecurrenceEndType.never) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RecurrenceEndEmbeddedtypeEnumValueMap = {
  'never': 0,
  'onDate': 1,
  'afterCount': 2,
};
const _RecurrenceEndEmbeddedtypeValueEnumMap = {
  0: RecurrenceEndType.never,
  1: RecurrenceEndType.onDate,
  2: RecurrenceEndType.afterCount,
};

extension RecurrenceEndEmbeddedQueryFilter on QueryBuilder<
    RecurrenceEndEmbedded, RecurrenceEndEmbedded, QFilterCondition> {
  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> countIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> countIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'count',
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> countEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> countGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> countLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> countBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> typeEqualTo(RecurrenceEndType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> typeGreaterThan(
    RecurrenceEndType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> typeLessThan(
    RecurrenceEndType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<RecurrenceEndEmbedded, RecurrenceEndEmbedded,
      QAfterFilterCondition> typeBetween(
    RecurrenceEndType lower,
    RecurrenceEndType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RecurrenceEndEmbeddedQueryObject on QueryBuilder<
    RecurrenceEndEmbedded, RecurrenceEndEmbedded, QFilterCondition> {}
