import 'package:flutter/material.dart';

import 'data_parameters.dart';

class SearchParameters {
  int pageSize;
  int pageIndex;

  List<int> brandIds;
  int categoryId;
  int supplierId;
  int campaignId;
  int genderId;
  int sort;
  RangeValues price;
  Map<int, List<int>> propertyFilter;
  String searchExpression;
  List<int> colorIds;
  bool applyAggregation;
  int showcaseId;

  SearchParameters({
    this.pageSize,
    this.pageIndex,
    this.brandIds,
    this.categoryId,
    this.supplierId,
    this.campaignId,
    this.genderId,
    this.sort,
    this.price,
    this.propertyFilter,
    this.searchExpression,
    this.colorIds,
    this.applyAggregation,
    this.showcaseId,
  });

  factory SearchParameters.fromDataParameters(DataParameters dataParameters) {
    return SearchParameters(
      pageSize: 10,
      pageIndex: 0,
      brandIds: dataParameters.brandsIds != null ? [...dataParameters.brandsIds] : [],
      categoryId: dataParameters.categoryId,
      supplierId: dataParameters.supplierId,
      campaignId: dataParameters.campaignId,
      genderId: dataParameters.genderId,
      sort: dataParameters.sortBy,
      showcaseId: dataParameters.showcase,
      searchExpression: dataParameters.keyword,
      colorIds: [],
      propertyFilter: {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize ?? 20,
      'pageIndex': pageIndex ?? 0,
      'brandIds': brandIds,
      'categoryId': categoryId,
      'supplier': supplierId,
      'campaignId': campaignId,
      'genderId': genderId,
      'sort': sort,
      'price': price != null ? {'start': price.start.round(), 'end': price.end.round()} : null,
      'propertyFilter': propertyFilter?.map((key, value) => MapEntry(key.toString(), value.map((e) => e.toString()).toList())) ?? {},
      'searchExpression': searchExpression,
      'colorIds': colorIds,
      'applyAggregation': applyAggregation ?? true,
      'showcaseId': showcaseId,
    };
  }

  reset() {
    pageIndex = 0;
    brandIds = null;
    categoryId = null;
    supplierId = null;
    campaignId = null;
    genderId = null;
    sort = null;
    price = null;
    propertyFilter = null;
    searchExpression = null;
    colorIds = null;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
