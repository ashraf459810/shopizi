import 'package:get/get.dart';
import 'package:shopizy/services/api_services/remote_address_service.dart';
import 'package:shopizy/services/api_services/remote_cart_service.dart';
import 'package:shopizy/services/api_services/remote_favorite_service.dart';
import 'package:shopizy/services/api_services/remote_gender_service.dart';
import 'package:shopizy/services/api_services/remote_language_service.dart';
import 'package:shopizy/services/api_services/remote_notification_service.dart';
import 'package:shopizy/services/api_services/remote_order_service.dart';
import 'package:shopizy/services/api_services/remote_product_service.dart';
import 'package:shopizy/services/api_services/remote_reviews_service.dart';
import 'package:shopizy/services/api_services/remote_showcase_service.dart';
import 'package:shopizy/services/api_services/remote_static_page_service.dart';
import 'package:shopizy/services/api_services/remote_user_service.dart';
import 'package:shopizy/services/global_services/address_service.dart';
import 'package:shopizy/services/global_services/cart_controller.dart';
import 'package:shopizy/services/global_services/favorite_controller.dart';
import 'package:shopizy/services/global_services/gender_service.dart';
import 'package:shopizy/services/global_services/language_service.dart';
import 'package:shopizy/services/global_services/notification_service.dart';
import 'package:shopizy/services/global_services/order_service.dart';
import 'package:shopizy/services/global_services/product_service.dart';
import 'package:shopizy/services/global_services/review_service.dart';
import 'package:shopizy/services/global_services/showcase_service.dart';
import 'package:shopizy/services/global_services/static_page_service.dart';
import 'package:shopizy/services/global_services/user_controller.dart';
import 'package:shopizy/ui/screens/main/main_screen.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Authentication
    Get.put(UserController(), permanent: true);
    Get.lazyPut(() => RemoteUserService(), fenix: true);
    // Languages
    Get.lazyPut(() => LanguageService(), fenix: true);
    Get.lazyPut(() => RemoteLanguageService(), fenix: true);
    // Genders
    Get.lazyPut(() => GenderService(), fenix: true);
    Get.lazyPut(() => RemoteGenderService(), fenix: true);
    // Showcase
    Get.lazyPut(() => ShowcaseService(), fenix: true);
    Get.lazyPut(() => RemoteShowcaseService(), fenix: true);
    // Product
    Get.lazyPut(() => ProductService(), fenix: true);
    Get.lazyPut(() => RemoteProductService(), fenix: true);
    // Cart
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => RemoteCartService(), fenix: true);
    // Favorites
    Get.lazyPut(() => FavoriteController(), fenix: true);
    Get.lazyPut(() => RemoteFavoriteService(), fenix: true);
    // Addresses
    Get.lazyPut(() => AddressService(), fenix: true);
    Get.lazyPut(() => RemoteAddressService(), fenix: true);
    // Orders
    Get.lazyPut(() => OrderService(), fenix: true);
    Get.lazyPut(() => RemoteOrderService(), fenix: true);
    // Notifications
    Get.lazyPut(() => NotificationService(), fenix: true);
    Get.lazyPut(() => RemoteNotificationService(), fenix: true);
    // Static pages
    Get.lazyPut(() => StaticPageService(), fenix: true);
    Get.lazyPut(() => RemoteStaticPageService(), fenix: true);
    // Reviews
    Get.lazyPut(() => ReviewService(), fenix: true);
    Get.lazyPut(() => RemoteReviewsService(), fenix: true);

    // Controllers
    Get.lazyPut(() => MainScreenController(), fenix: true);
  }
}
