import 'package:get_storage/get_storage.dart';
import 'package:shopizy/settings/storage_keys.dart';

const String baseUrl = 'https://dev-api.shopizyy.com/api';
// const String baseUrl = 'https://api.shopizi.co/api';
const String webBaseUrl = 'https://dev-web.shopizyy.com';
// const String webBaseUrl = 'https://shopizi.co';
const String cdnBaseUrl = 'https://shopizy-17ca8.kxcdn.com';
const String notificationsUrl = 'https://noti.shopizyy.com/api/notifications';

Map<String, String> get generalHeaders => {
      'accept-language': GetStorage().read(StorageKeys.language),
    };
