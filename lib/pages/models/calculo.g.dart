// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Calculo _$CalculoFromJson(Map<String, dynamic> json) => Calculo(
      id: json['id'] as String,
      fecha: const TimestampSerializer().fromJson(json['fecha']),
      montoFinal: (json['monto_final'] as num).toDouble(),
      impuestoResta: (json['impuesto_resta'] as num).toDouble(),
    );

Map<String, dynamic> _$CalculoToJson(Calculo instance) => <String, dynamic>{
      'id': instance.id,
      'monto_final': instance.montoFinal,
      'impuesto_resta': instance.impuestoResta,
      'fecha': const TimestampSerializer().toJson(instance.fecha),
    };
