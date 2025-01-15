import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../providers/pharmacies_laravel_provider.dart';
import '../controllers/category_controller.dart';
import 'medicines_empty_list_widget.dart';
import 'medicines_list_item_widget.dart';
import 'medicines_list_loader_widget.dart';

class MedicinesListWidget extends GetView<CategoryController> {
  MedicinesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<PharmaciesLaravelApiClient>().isLoading(tasks: [
            'getAllMedicinesWithPagination',
            'getFeaturedMedicines',
            'getPopularMedicines',
            'getMostRatedMedicines',
            'getAvailableMedicines',
          ]) &&
          controller.page == 1) {
        return MedicinesListLoaderWidget();
      } else if (controller.medicines.isEmpty) {
        return MedicinesEmptyListWidget();
      } else {
        return MasonryGridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: controller.medicines.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.medicines.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _medicine = controller.medicines.elementAt(index);
              return MedicinesListItemWidget(medicine: _medicine);
            }
          }),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        );
/*        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.medicines.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.medicines.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _medicine = controller.medicines.elementAt(index);
              return MedicinesListItemWidget(medicine: _medicine);
            }
          }),
        );*/
      }
    });
  }
}
