import 'package:keshav_s_application2/core/app_export.dart';
import 'package:keshav_s_application2/presentation/product_detail_screen/models/product_detail_model.dart';

class ProductDetailController extends GetxController {
  // Rx<ProductDetailModel> productDetailModelObj = ProductDetailModel().obs;

  Rx<int> silderIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
