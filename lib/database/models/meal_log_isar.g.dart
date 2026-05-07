// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMealLogIsarCollection on Isar {
  IsarCollection<MealLogIsar> get mealLogIsars => this.collection();
}

const MealLogIsarSchema = CollectionSchema(
  name: r'MealLogIsar',
  id: -8668667403960787769,
  properties: {
    r'appliedModifiers': PropertySchema(
      id: 0,
      name: r'appliedModifiers',
      type: IsarType.stringList,
    ),
    r'calories': PropertySchema(
      id: 1,
      name: r'calories',
      type: IsarType.long,
    ),
    r'carbs': PropertySchema(
      id: 2,
      name: r'carbs',
      type: IsarType.double,
    ),
    r'dishName': PropertySchema(
      id: 3,
      name: r'dishName',
      type: IsarType.string,
    ),
    r'domainId': PropertySchema(
      id: 4,
      name: r'domainId',
      type: IsarType.string,
    ),
    r'fats': PropertySchema(
      id: 5,
      name: r'fats',
      type: IsarType.double,
    ),
    r'photoLocalPath': PropertySchema(
      id: 6,
      name: r'photoLocalPath',
      type: IsarType.string,
    ),
    r'portionSize': PropertySchema(
      id: 7,
      name: r'portionSize',
      type: IsarType.byte,
      enumMap: _MealLogIsarportionSizeEnumValueMap,
    ),
    r'protein': PropertySchema(
      id: 8,
      name: r'protein',
      type: IsarType.double,
    ),
    r'timestamp': PropertySchema(
      id: 9,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _mealLogIsarEstimateSize,
  serialize: _mealLogIsarSerialize,
  deserialize: _mealLogIsarDeserialize,
  deserializeProp: _mealLogIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'domainId': IndexSchema(
      id: -9138809277110658179,
      name: r'domainId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'domainId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mealLogIsarGetId,
  getLinks: _mealLogIsarGetLinks,
  attach: _mealLogIsarAttach,
  version: '3.1.0+1',
);

int _mealLogIsarEstimateSize(
  MealLogIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appliedModifiers.length * 3;
  {
    for (var i = 0; i < object.appliedModifiers.length; i++) {
      final value = object.appliedModifiers[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.dishName.length * 3;
  bytesCount += 3 + object.domainId.length * 3;
  {
    final value = object.photoLocalPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _mealLogIsarSerialize(
  MealLogIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.appliedModifiers);
  writer.writeLong(offsets[1], object.calories);
  writer.writeDouble(offsets[2], object.carbs);
  writer.writeString(offsets[3], object.dishName);
  writer.writeString(offsets[4], object.domainId);
  writer.writeDouble(offsets[5], object.fats);
  writer.writeString(offsets[6], object.photoLocalPath);
  writer.writeByte(offsets[7], object.portionSize.index);
  writer.writeDouble(offsets[8], object.protein);
  writer.writeDateTime(offsets[9], object.timestamp);
}

MealLogIsar _mealLogIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealLogIsar();
  object.appliedModifiers = reader.readStringList(offsets[0]) ?? [];
  object.calories = reader.readLong(offsets[1]);
  object.carbs = reader.readDouble(offsets[2]);
  object.dishName = reader.readString(offsets[3]);
  object.domainId = reader.readString(offsets[4]);
  object.fats = reader.readDouble(offsets[5]);
  object.id = id;
  object.photoLocalPath = reader.readStringOrNull(offsets[6]);
  object.portionSize =
      _MealLogIsarportionSizeValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          PortionSizeIsar.small;
  object.protein = reader.readDouble(offsets[8]);
  object.timestamp = reader.readDateTime(offsets[9]);
  return object;
}

P _mealLogIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_MealLogIsarportionSizeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PortionSizeIsar.small) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MealLogIsarportionSizeEnumValueMap = {
  'small': 0,
  'regular': 1,
  'large': 2,
};
const _MealLogIsarportionSizeValueEnumMap = {
  0: PortionSizeIsar.small,
  1: PortionSizeIsar.regular,
  2: PortionSizeIsar.large,
};

Id _mealLogIsarGetId(MealLogIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealLogIsarGetLinks(MealLogIsar object) {
  return [];
}

void _mealLogIsarAttach(
    IsarCollection<dynamic> col, Id id, MealLogIsar object) {
  object.id = id;
}

extension MealLogIsarByIndex on IsarCollection<MealLogIsar> {
  Future<MealLogIsar?> getByDomainId(String domainId) {
    return getByIndex(r'domainId', [domainId]);
  }

  MealLogIsar? getByDomainIdSync(String domainId) {
    return getByIndexSync(r'domainId', [domainId]);
  }

  Future<bool> deleteByDomainId(String domainId) {
    return deleteByIndex(r'domainId', [domainId]);
  }

  bool deleteByDomainIdSync(String domainId) {
    return deleteByIndexSync(r'domainId', [domainId]);
  }

  Future<List<MealLogIsar?>> getAllByDomainId(List<String> domainIdValues) {
    final values = domainIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'domainId', values);
  }

  List<MealLogIsar?> getAllByDomainIdSync(List<String> domainIdValues) {
    final values = domainIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'domainId', values);
  }

  Future<int> deleteAllByDomainId(List<String> domainIdValues) {
    final values = domainIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'domainId', values);
  }

  int deleteAllByDomainIdSync(List<String> domainIdValues) {
    final values = domainIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'domainId', values);
  }

  Future<Id> putByDomainId(MealLogIsar object) {
    return putByIndex(r'domainId', object);
  }

  Id putByDomainIdSync(MealLogIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'domainId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDomainId(List<MealLogIsar> objects) {
    return putAllByIndex(r'domainId', objects);
  }

  List<Id> putAllByDomainIdSync(List<MealLogIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'domainId', objects, saveLinks: saveLinks);
  }
}

extension MealLogIsarQueryWhereSort
    on QueryBuilder<MealLogIsar, MealLogIsar, QWhere> {
  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealLogIsarQueryWhere
    on QueryBuilder<MealLogIsar, MealLogIsar, QWhereClause> {
  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> domainIdEqualTo(
      String domainId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'domainId',
        value: [domainId],
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterWhereClause> domainIdNotEqualTo(
      String domainId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'domainId',
              lower: [],
              upper: [domainId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'domainId',
              lower: [domainId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'domainId',
              lower: [domainId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'domainId',
              lower: [],
              upper: [domainId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MealLogIsarQueryFilter
    on QueryBuilder<MealLogIsar, MealLogIsar, QFilterCondition> {
  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appliedModifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appliedModifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appliedModifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appliedModifiers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'appliedModifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'appliedModifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'appliedModifiers',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'appliedModifiers',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appliedModifiers',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'appliedModifiers',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appliedModifiers',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appliedModifiers',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appliedModifiers',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appliedModifiers',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appliedModifiers',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      appliedModifiersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appliedModifiers',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> caloriesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      caloriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      caloriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calories',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> caloriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> carbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      carbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> carbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> carbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> dishNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dishName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dishName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dishName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> dishNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dishName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dishName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dishName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dishName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> dishNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dishName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dishName',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      dishNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dishName',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> domainIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'domainId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'domainId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'domainId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> domainIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'domainId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'domainId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'domainId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'domainId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> domainIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'domainId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'domainId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      domainIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'domainId',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> fatsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> fatsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> fatsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> fatsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'photoLocalPath',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'photoLocalPath',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoLocalPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'photoLocalPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'photoLocalPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      photoLocalPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'photoLocalPath',
        value: '',
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      portionSizeEqualTo(PortionSizeIsar value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portionSize',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      portionSizeGreaterThan(
    PortionSizeIsar value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portionSize',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      portionSizeLessThan(
    PortionSizeIsar value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portionSize',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      portionSizeBetween(
    PortionSizeIsar lower,
    PortionSizeIsar upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portionSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> proteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      proteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> proteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition> proteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MealLogIsarQueryObject
    on QueryBuilder<MealLogIsar, MealLogIsar, QFilterCondition> {}

extension MealLogIsarQueryLinks
    on QueryBuilder<MealLogIsar, MealLogIsar, QFilterCondition> {}

extension MealLogIsarQuerySortBy
    on QueryBuilder<MealLogIsar, MealLogIsar, QSortBy> {
  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByDishName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dishName', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByDishNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dishName', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByDomainId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'domainId', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByDomainIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'domainId', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByPhotoLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy>
      sortByPhotoLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByPortionSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByPortionSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension MealLogIsarQuerySortThenBy
    on QueryBuilder<MealLogIsar, MealLogIsar, QSortThenBy> {
  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calories', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbs', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByDishName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dishName', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByDishNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dishName', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByDomainId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'domainId', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByDomainIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'domainId', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fats', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByPhotoLocalPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy>
      thenByPhotoLocalPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'photoLocalPath', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByPortionSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByPortionSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'portionSize', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension MealLogIsarQueryWhereDistinct
    on QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> {
  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct>
      distinctByAppliedModifiers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appliedModifiers');
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calories');
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbs');
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByDishName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dishName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByDomainId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'domainId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fats');
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByPhotoLocalPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoLocalPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByPortionSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'portionSize');
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein');
    });
  }

  QueryBuilder<MealLogIsar, MealLogIsar, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension MealLogIsarQueryProperty
    on QueryBuilder<MealLogIsar, MealLogIsar, QQueryProperty> {
  QueryBuilder<MealLogIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealLogIsar, List<String>, QQueryOperations>
      appliedModifiersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appliedModifiers');
    });
  }

  QueryBuilder<MealLogIsar, int, QQueryOperations> caloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calories');
    });
  }

  QueryBuilder<MealLogIsar, double, QQueryOperations> carbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbs');
    });
  }

  QueryBuilder<MealLogIsar, String, QQueryOperations> dishNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dishName');
    });
  }

  QueryBuilder<MealLogIsar, String, QQueryOperations> domainIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'domainId');
    });
  }

  QueryBuilder<MealLogIsar, double, QQueryOperations> fatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fats');
    });
  }

  QueryBuilder<MealLogIsar, String?, QQueryOperations>
      photoLocalPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoLocalPath');
    });
  }

  QueryBuilder<MealLogIsar, PortionSizeIsar, QQueryOperations>
      portionSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'portionSize');
    });
  }

  QueryBuilder<MealLogIsar, double, QQueryOperations> proteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein');
    });
  }

  QueryBuilder<MealLogIsar, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyProgressIsarCollection on Isar {
  IsarCollection<DailyProgressIsar> get dailyProgressIsars => this.collection();
}

const DailyProgressIsarSchema = CollectionSchema(
  name: r'DailyProgressIsar',
  id: 5140346039545846515,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'targetCalories': PropertySchema(
      id: 1,
      name: r'targetCalories',
      type: IsarType.long,
    ),
    r'targetCarbs': PropertySchema(
      id: 2,
      name: r'targetCarbs',
      type: IsarType.double,
    ),
    r'targetFats': PropertySchema(
      id: 3,
      name: r'targetFats',
      type: IsarType.double,
    ),
    r'targetProtein': PropertySchema(
      id: 4,
      name: r'targetProtein',
      type: IsarType.double,
    ),
    r'totalCalories': PropertySchema(
      id: 5,
      name: r'totalCalories',
      type: IsarType.long,
    ),
    r'totalCarbs': PropertySchema(
      id: 6,
      name: r'totalCarbs',
      type: IsarType.double,
    ),
    r'totalFats': PropertySchema(
      id: 7,
      name: r'totalFats',
      type: IsarType.double,
    ),
    r'totalProtein': PropertySchema(
      id: 8,
      name: r'totalProtein',
      type: IsarType.double,
    )
  },
  estimateSize: _dailyProgressIsarEstimateSize,
  serialize: _dailyProgressIsarSerialize,
  deserialize: _dailyProgressIsarDeserialize,
  deserializeProp: _dailyProgressIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyProgressIsarGetId,
  getLinks: _dailyProgressIsarGetLinks,
  attach: _dailyProgressIsarAttach,
  version: '3.1.0+1',
);

int _dailyProgressIsarEstimateSize(
  DailyProgressIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyProgressIsarSerialize(
  DailyProgressIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.targetCalories);
  writer.writeDouble(offsets[2], object.targetCarbs);
  writer.writeDouble(offsets[3], object.targetFats);
  writer.writeDouble(offsets[4], object.targetProtein);
  writer.writeLong(offsets[5], object.totalCalories);
  writer.writeDouble(offsets[6], object.totalCarbs);
  writer.writeDouble(offsets[7], object.totalFats);
  writer.writeDouble(offsets[8], object.totalProtein);
}

DailyProgressIsar _dailyProgressIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyProgressIsar();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.targetCalories = reader.readLong(offsets[1]);
  object.targetCarbs = reader.readDouble(offsets[2]);
  object.targetFats = reader.readDouble(offsets[3]);
  object.targetProtein = reader.readDouble(offsets[4]);
  object.totalCalories = reader.readLong(offsets[5]);
  object.totalCarbs = reader.readDouble(offsets[6]);
  object.totalFats = reader.readDouble(offsets[7]);
  object.totalProtein = reader.readDouble(offsets[8]);
  return object;
}

P _dailyProgressIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyProgressIsarGetId(DailyProgressIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyProgressIsarGetLinks(
    DailyProgressIsar object) {
  return [];
}

void _dailyProgressIsarAttach(
    IsarCollection<dynamic> col, Id id, DailyProgressIsar object) {
  object.id = id;
}

extension DailyProgressIsarByIndex on IsarCollection<DailyProgressIsar> {
  Future<DailyProgressIsar?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyProgressIsar? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyProgressIsar?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyProgressIsar?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyProgressIsar object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyProgressIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyProgressIsar> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyProgressIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyProgressIsarQueryWhereSort
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QWhere> {
  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyProgressIsarQueryWhere
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QWhereClause> {
  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyProgressIsarQueryFilter
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QFilterCondition> {
  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCaloriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCalories',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCaloriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetCalories',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCaloriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetCalories',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCaloriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCarbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCarbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCarbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetCarbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetCarbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetFatsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetFats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetFatsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetFats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetFatsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetFats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetFatsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetFats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetProteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetProteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetProteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      targetProteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetProtein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCaloriesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCalories',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCaloriesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCalories',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCaloriesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCalories',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCaloriesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCalories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCarbsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCarbsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCarbsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCarbs',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalCarbsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCarbs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalFatsEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalFats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalFatsGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalFats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalFatsLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalFats',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalFatsBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalFats',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalProteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalProteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalProteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalProtein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterFilterCondition>
      totalProteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalProtein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension DailyProgressIsarQueryObject
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QFilterCondition> {}

extension DailyProgressIsarQueryLinks
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QFilterCondition> {}

extension DailyProgressIsarQuerySortBy
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QSortBy> {
  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCalories', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCalories', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCarbs', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCarbs', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFats', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFats', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProtein', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTargetProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProtein', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFats', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFats', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      sortByTotalProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.desc);
    });
  }
}

extension DailyProgressIsarQuerySortThenBy
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QSortThenBy> {
  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCalories', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCalories', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCarbs', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCarbs', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFats', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFats', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProtein', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTargetProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetProtein', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalCaloriesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCalories', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalCarbsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCarbs', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFats', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalFatsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFats', Sort.desc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.asc);
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QAfterSortBy>
      thenByTotalProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalProtein', Sort.desc);
    });
  }
}

extension DailyProgressIsarQueryWhereDistinct
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct> {
  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTargetCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetCalories');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTargetCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetCarbs');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTargetFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetFats');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTargetProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetProtein');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTotalCalories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCalories');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTotalCarbs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCarbs');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTotalFats() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalFats');
    });
  }

  QueryBuilder<DailyProgressIsar, DailyProgressIsar, QDistinct>
      distinctByTotalProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalProtein');
    });
  }
}

extension DailyProgressIsarQueryProperty
    on QueryBuilder<DailyProgressIsar, DailyProgressIsar, QQueryProperty> {
  QueryBuilder<DailyProgressIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyProgressIsar, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyProgressIsar, int, QQueryOperations>
      targetCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetCalories');
    });
  }

  QueryBuilder<DailyProgressIsar, double, QQueryOperations>
      targetCarbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetCarbs');
    });
  }

  QueryBuilder<DailyProgressIsar, double, QQueryOperations>
      targetFatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetFats');
    });
  }

  QueryBuilder<DailyProgressIsar, double, QQueryOperations>
      targetProteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetProtein');
    });
  }

  QueryBuilder<DailyProgressIsar, int, QQueryOperations>
      totalCaloriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCalories');
    });
  }

  QueryBuilder<DailyProgressIsar, double, QQueryOperations>
      totalCarbsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCarbs');
    });
  }

  QueryBuilder<DailyProgressIsar, double, QQueryOperations>
      totalFatsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalFats');
    });
  }

  QueryBuilder<DailyProgressIsar, double, QQueryOperations>
      totalProteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalProtein');
    });
  }
}
