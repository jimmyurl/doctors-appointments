import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/patients_controller.dart';
import '../widgets/patients_list_widget.dart';

class PatientsView extends GetView<PatientsController> {
  PatientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            if (!Get.find<LaravelApiClient>().isLoading(task: 'getPatientsWithUserId')) {
              Get.find<LaravelApiClient>().forceRefresh();
              controller.refreshPatients(showMessage: true);
              Get.find<LaravelApiClient>().unForceRefresh();
            }
          },
          child: CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                floating: false,
                iconTheme: IconThemeData(color: Get.theme.primaryColor),
                title: Text(
                  'Patients'.tr,
                  style: Get.textTheme.titleLarge,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [NotificationsButtonWidget()],
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Text("Patients".tr, style: Get.textTheme.headlineSmall).paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                    Text("These are all the patients assigned to your account you can create ne ones using the add button below".tr, style: Get.textTheme.bodySmall).paddingSymmetric(horizontal: 22, vertical: 5,),
                    PatientsListWidget(),
                  ],
                ),
              ),
            ],
          )),
      floatingActionButton: new FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
        child: new Icon(Icons.add, size: 32, color: Get.theme.primaryColor),
        onPressed: () => {Get.toNamed(Routes.PATIENT_CREATE)},
        backgroundColor: Get.theme.colorScheme.secondary,
      ),
    );
  }
}
