import 'package:flutter/material.dart';

class PriceFilterModule {
  final String name;
  final RangeValues rangeValues;

  PriceFilterModule(this.name, this.rangeValues);

  factory PriceFilterModule.fromJson(Map<String, dynamic> data) {
    return PriceFilterModule(
      data['name'],
      RangeValues(
        ((data['filterModuleItems'] as Map)['min']).toDouble(),
        ((data['filterModuleItems'] as Map)['max']).toDouble(),
      ),
    );
  }
}
