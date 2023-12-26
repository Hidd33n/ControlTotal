// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calculo _$CalculoFromJson(Map<String, dynamic> json) => Calculo(
      id: json['id'] as String,
      fecha: const TimestampSerializer().fromJson(json['fecha']),
      montoFinal: json['montoFinal'] as String,
      montoResta: json['montoResta'] as String,
    );

Map<String, dynamic> _$CalculoToJson(Calculo instance) => <String, dynamic>{
      'id': instance.id,
      'montoFinal': instance.montoFinal,
      'montoResta': instance.montoResta,
      'fecha': const TimestampSerializer().toJson(instance.fecha),
    };
