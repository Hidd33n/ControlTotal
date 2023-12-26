import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'calculo.g.dart';

@JsonSerializable()
class Calculo {
  final String id;
  @JsonKey(name: 'monto_final')
  final double montoFinal;
  @JsonKey(name: 'impuesto_resta')
  final double impuestoResta;
  @TimestampSerializer()
  final DateTime fecha;

  Calculo({
    required this.id,
    required this.fecha,
    required this.montoFinal,
    required this.impuestoResta,
  });

  factory Calculo.fromJson(Map<String, dynamic> json) =>
      _$CalculoFromJson(json);

  Map<String, dynamic> toJson() => _$CalculoToJson(this);
}

class TimestampSerializer implements JsonConverter<DateTime, dynamic> {
  const TimestampSerializer();

  @override
  DateTime fromJson(dynamic timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
