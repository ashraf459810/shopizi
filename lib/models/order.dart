import 'package:intl/intl.dart';
import 'package:shopizy/services/api_services/api_config.dart';

class Order {
  int id;
  double totalAmount;
  String createdOn;
  int totalItemCount;
  int status;
  String statusName;
  SampleProduct sampleProduct;

  Order({this.id, this.totalAmount, this.createdOn, this.totalItemCount, this.status, this.statusName, this.sampleProduct});

  Order.fromJson(dynamic json) {
    id = json["id"];
    totalAmount = json["totalAmount"];
    createdOn = DateFormat('MMM dd, yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(json['createdOn'], true));
    totalItemCount = json["totalItemCount"];
    status = json["status"];
    statusName = json["statusName"];
    sampleProduct = json["sampleProduct"] != null ? SampleProduct.fromJson(json["sampleProduct"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["totalAmount"] = totalAmount;
    map["createdOn"] = createdOn;
    map["totalItemCount"] = totalItemCount;
    map["status"] = status;
    map["statusName"] = statusName;
    if (sampleProduct != null) {
      map["sampleProduct"] = sampleProduct.toJson();
    }
    return map;
  }
}

class SampleProduct {
  String title;
  String picturePath;

  SampleProduct({this.title, this.picturePath});

  SampleProduct.fromJson(dynamic json) {
    title = json["title"];
    picturePath = '$cdnBaseUrl/${json['picturePath']}';
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    map["picturePath"] = picturePath;
    return map;
  }
}
