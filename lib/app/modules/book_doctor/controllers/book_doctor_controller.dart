/*
 * File name: book_doctor_controller.dart
 * Last modified: 2022.10.23 at 11:42:19
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/address_model.dart';
import '../../../models/appointment_model.dart';
import '../../../models/coupon_model.dart';
import '../../../models/doctor_model.dart';
import '../../../models/patient_model.dart';
import '../../../repositories/appointment_repository.dart';
import '../../../repositories/doctor_repository.dart';
import '../../../repositories/patient_repository.dart';
import '../../../repositories/setting_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../appointments/controllers/appointments_controller.dart';
import '../../global_widgets/tab_bar_widget.dart';

class BookDoctorController extends GetxController {
  final scheduled = false.obs;
  final onlineConsultation = true.obs;
  final atClinic = false.obs;
  final atAddress = false.obs;
  final List<bool> appointmentTypes = <bool>[true, false, false];
  final appointment = Appointment().obs;
  final addresses = <Address>[].obs;
  final patients = <Patient>[].obs;
  final morningTimes = [].obs;
  final afternoonTimes = [].obs;
  final eveningTimes = [].obs;
  final nightTimes = [].obs;
  DatePickerController datePickerController = DatePickerController();
  late AppointmentRepository _appointmentRepository;
  late PatientRepository _patientRepository;
  late DoctorRepository _doctorRepository;
  late SettingRepository _settingRepository;

  Address get currentAddress => Get.find<SettingsService>().address.value;

  BookDoctorController() {
    _appointmentRepository = AppointmentRepository();
    _settingRepository = SettingRepository();
    _doctorRepository = DoctorRepository();
    _patientRepository = PatientRepository();
  }

  @override
  void onInit() async {
    final _doctor = (Get.arguments['doctor'] as Doctor);
    this.appointment.value = Appointment(
      appointmentAt: DateTime.now(),
      doctor: _doctor,
      clinic: _doctor.clinic,
      taxes: _doctor.clinic.taxes,
      online: true,
      user: Get.find<AuthService>().user.value,
      address: _doctor.clinic.address,
      coupon: new Coupon(),
    );
    await getAddresses();
    await getTimes();
    await getPatients();
    super.onInit();
  }
  Future refreshPatients({bool showMessage = false}) async {
    this.patients.clear();
    await getPatients();
    getTimes();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Patients refreshed successfully".tr));
    }

  }
  void toggleAtClinic(value) {
    atClinic.value = value;
    atAddress.value = false;
    onlineConsultation.value = false;
    appointment.update((val) {
      val?.online = false;
    });
  }

  void toggleAtAddress(value) {
    atAddress.value = value;
    atClinic.value = false;
    onlineConsultation.value = false;
    appointment.update((val) {
      val?.online = false;
    });
  }

  void toggleOnline(value) {
    appointment.update((val) {
      val?.online = true;
    });
    atClinic.value = false;
    atAddress.value = false;
    onlineConsultation.value = value;
  }


  TextStyle? getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyMedium;
  }

  Color? getColor(bool selected) {
    if (selected) {
      return Get.theme.colorScheme.secondary;
    }
    return null;
  }

  void createAppointment() async {
    try {
      if (!currentAddress.isUnknown() && appointment.value.address!.isUnknown()) {
        this.appointment.value.address = currentAddress;
      }

      await _appointmentRepository.add(appointment.value);
      Get.find<AppointmentsController>().currentStatus.value = Get.find<AppointmentsController>().getStatusByOrder(1).id;
      if (Get.isRegistered<TabBarController>(tag: 'appointments')) {
        Get.find<TabBarController>(tag: 'appointments').selectedId.value = Get.find<AppointmentsController>().getStatusByOrder(1).id;
      }
      Get.toNamed(Routes.CONFIRMATION);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getAddresses() async {
    try {
      if (Get.find<AuthService>().isAuth) {
        addresses.assignAll(await _settingRepository.getAddresses());
        if (!currentAddress.isUnknown()) {
          addresses.remove(currentAddress);
          addresses.insert(0, currentAddress);
        }
        if (Get.isRegistered<TabBarController>(tag: 'addresses')) {
          Get.find<TabBarController>(tag: 'addresses').selectedId.value = addresses.elementAt(0).id;
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getPatients() async {
    try {
      patients.assignAll(await _patientRepository.getAllWithUserId(Get.find<AuthService>().user.value.id));
    } on Exception catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getTimes({DateTime? date}) async {
    try {
      nightTimes.clear();
      morningTimes.clear();
      afternoonTimes.clear();
      eveningTimes.clear();
      List<dynamic> times = await _doctorRepository.getAvailabilityHours(this.appointment.value.doctor!.id, date ?? DateTime.now());
      for (var timeEntry in times) {
        final dateTime = DateTime.parse(timeEntry.elementAt(0)).toLocal();
        final hour = dateTime.hour;
        if (hour < 6) {
          nightTimes.add(timeEntry);
        } else if (hour < 12) {
          morningTimes.add(timeEntry);
        } else if (hour < 18) {
          afternoonTimes.add(timeEntry);
        } else {
          eveningTimes.add(timeEntry);
        }
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void validateCoupon() async {
    try {
      Coupon _coupon = await _appointmentRepository.coupon(appointment.value);
      appointment.update((val) {
        val!.coupon = _coupon;
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  String? getValidationMessage() {
    if (appointment.value.coupon?.id == null) {
      return null;
    } else {
      if (appointment.value.coupon?.code == '') {
        return "Invalid Coupon Code".tr;
      } else {
        return null;
      }
    }
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: appointment.value.appointmentAt?.add(Duration(days: 1)) ?? DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget? child) {
        return child!.paddingAll(10);
      },
    );
    if (picked != null) {
      appointment.update((val) {
        val!.appointmentAt = DateTime(picked.year, picked.month, picked.day, val!.appointmentAt!.hour, val!.appointmentAt!.minute);
        ;
      });
    }
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(appointment.value.appointmentAt ?? DateTime.now().add(Duration(days: 1))),
      builder: (BuildContext context, Widget? child) {
        return child!.paddingAll(10);
      },
    );
    if (picked != null) {
      appointment.update((val) {
        val!.appointmentAt = DateTime(appointment.value.appointmentAt!.year, appointment.value.appointmentAt!.month, appointment.value.appointmentAt!.day).add(Duration(minutes: picked.minute + picked.hour * 60));
      });
    }
  }

  void selectPatient(Patient patient) async {
    appointment.update((val) {
      if (val!.patient == null) {
        val.patient = patient;
      } else {
        val.patient = null;
      }
    });
  }

  void selectAppointmentType(value){
    // appointment.update((val) {
    //   if (val.type == null) {
    //     val.type = value;
    //   } else {
    //     val.type = null;
    //   }
    // });
  }

  bool isCheckedPatient(Patient patient) {
    return (appointment.value.patient?.id ?? '0') == patient.id;
  }

  TextStyle? getTitleTheme(Patient patient) {
    if (isCheckedPatient(patient)) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyMedium;
  }


}


