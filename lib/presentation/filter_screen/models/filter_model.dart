import 'package:get/get.dart';
import 'filter_item_model.dart';

class FilterModel {
  RxList<FilterItemModel> filterItemList =
      RxList.generate(4, (index) => FilterItemModel());
}
