import 'package:flutter/material.dart';
import 'package:shopizy/models/data_parameters.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class BannerModel {
  final String picturePath;
  final DataParameters data;
  final String name;

  BannerModel({@required this.picturePath, this.data, this.name});

  factory BannerModel.fromJson(Map<String, dynamic> data) {
    return BannerModel(
      picturePath: (data['mobilePicturePath'] as String).isNotEmpty
          ? '$cdnBaseUrl/${data['mobilePicturePath']}'
          : '$cdnBaseUrl/${data['picturePath']}',
      data: data['data'] != null ? DataParameters.fromJson(data['data']) : null,
      name: data['name'],
    );
  }
}
