import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

CachedNetworkImage buildCacheNetworkImage({double width, double height, url, plColor}){
  if(width == 0 && height == 0){
    return CachedNetworkImage(
      placeholder: (context, url) {
        return Container(
          color: plColor==null?Colors.grey[200]:plColor,
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          color: Colors.grey[200],
        );
      },
      imageUrl: url,
      fit: BoxFit.cover,
    );
  } else if(height == 0){
    return CachedNetworkImage(
      placeholder: (context, url) {
        return Container(
          width: width,
          color: plColor==null?Colors.grey[200]:plColor,
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          color: Colors.grey[200],
        );
      },
      imageUrl: url,
      fit: BoxFit.cover,
      width: width,
    );
  } else {
    return CachedNetworkImage(
      placeholder: (context, url) {
        return Container(
          width: width,
          height: height,
          color: plColor==null?Colors.grey[200]:plColor,
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
        );
      },
      imageUrl: url,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }
}