import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../widgets/featured_carousel_widget.dart';
import '../../../models/patient_model.dart';
import '../../../models/media_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/patient_controller.dart';
import '../widgets/patient_til_widget.dart';
import '../widgets/patient_title_bar_widget.dart';

class PatientView extends GetView<PatientController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _patient = controller.patient.value;
      if (!_patient.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          body: RefreshIndicator(
              onRefresh: () async {
                Get.find<LaravelApiClient>().forceRefresh();
                controller.refreshPatient(showMessage: true);
                Get.find<LaravelApiClient>().unForceRefresh();
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 310,
                    elevation: 0,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]),
                        child: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      ),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildPatientTitleBarWidget(_patient),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_patient),
                            buildCarouselBullets(_patient),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),
                  //WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        PatientTilWidget(
                          title: Text("Medical History".tr, style: Get.textTheme.titleSmall),
                          content: Obx(() {
                            if (controller.patient.value.medical_history == '' || controller.patient.value.medical_history == null) {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_patient.medical_history, style: Get.textTheme.bodyLarge);
                          }),
                        ),
                        SizedBox(height: 10),
                        PatientTilWidget(
                          title: Text("Notes".tr, style: Get.textTheme.titleSmall),
                          content: Obx(() {
                            if (controller.patient.value.notes == '' || controller.patient.value.notes == null) {
                              return SizedBox();
                            }
                            return Ui.applyHtml(_patient.notes, style: Get.textTheme.bodyLarge);
                          }),
                        ),
                        PatientTilWidget(
                          horizontalPadding: 0,
                          title: Text("Recent Doctors".tr, style: Get.textTheme.titleSmall).paddingSymmetric(horizontal: 20),
                          content: FeaturedCarouselWidget(),
                          actions: [
                            InkWell(
                              onTap: () {
                                //Get.toNamed(Routes.CLINIC_DOCTORS, arguments: _clinic);
                              },
                              child: Text("View All".tr, style: Get.textTheme.titleMedium),
                            ).paddingSymmetric(horizontal: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.edit_outlined, size: 32, color: Get.theme.primaryColor),
            onPressed: () => {Get.toNamed(Routes.PATIENT_FORM, arguments: {'patient': _patient, 'heroTag': 'patient_view'})},
            backgroundColor: Get.theme.colorScheme.secondary,
          ),
        );
      }
    });
  }


  CarouselSlider buildCarouselSlider(Patient _patient) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _patient.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _patient.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(Patient _patient) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _patient.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _patient.images.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }


  PatientTitleBarWidget buildPatientTitleBarWidget(Patient _patient) {
    return PatientTitleBarWidget(
      title: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        _patient.first_name ?? '',
                        style: Get.textTheme.headlineSmall?.merge(TextStyle(height: 1.1)),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                      Text(
                        _patient.last_name ?? '',
                        style: Get.textTheme.headlineSmall?.merge(TextStyle(height: 1.1)),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You have (%s) appointments with this patient".trArgs([_patient.total_appointments.toString()]),
                        style: Get.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ).marginOnly(top: 10, bottom: 10),
            Divider(height: 2, thickness: 1, color: Get.theme.dividerColor,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.account_box,
                  size: 18,
                  color: Get.theme.focusColor,
                ),
                SizedBox(width: 1),
                Flexible(
                  child: Text(
                    _patient.age,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Get.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.male_rounded ,
                  size: 18,
                  color: Get.theme.focusColor,
                ),
                SizedBox(width: 1),
                Flexible(
                  child: Text(
                    _patient.gender,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Get.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.monitor_weight_outlined,
                  size: 18,
                  color: Get.theme.focusColor,
                ),
                SizedBox(width: 1),
                Flexible(
                  child: Text(
                    _patient.weight +'(KG)' ,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Get.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.height,
                  size: 18,
                  color: Get.theme.focusColor,
                ),
                SizedBox(width: 1),
                Flexible(
                  child: Text(
                    _patient.height+'(CM)',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Get.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
