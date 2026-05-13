// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      isLasa: json['is_lasa'] as bool,
      lasaGroup: json['lasa_group'] as String?,
      tempZone: json['temp_zone'] as String,
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_lasa': instance.isLasa,
      'lasa_group': instance.lasaGroup,
      'temp_zone': instance.tempZone,
      'barcode': instance.barcode,
    };
