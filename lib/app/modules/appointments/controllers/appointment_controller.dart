import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart'; // For SHA-256 hashing
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../../models/appointment_model.dart';
import '../../../models/appointment_status_model.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/appointment_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../../../services/settings_service.dart';
import 'appointments_controller.dart';

class AppointmentController extends GetxController {
  late AppointmentRepository _appointmentRepository;
  final allMarkers = <Marker>[].obs;
  final appointmentStatuses = <AppointmentStatus>[].obs;
  Timer? timer;
  GoogleMapController? mapController;
  final appointment = Appointment().obs;
  final _jitsiMeetPlugin = JitsiMeet();
  List<String> participants = [];

  AppointmentController() {
    _appointmentRepository = AppointmentRepository();
  }

  @override
  void onInit() async {
    appointment.value = Get.arguments as Appointment;
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onReady() async {
    await refreshAppointment();
    super.onReady();
  }
  void joinMeeting() async {
    try {

      var options = JitsiMeetConferenceOptions(
          room: hashRoomName('Appointment'+appointment.value.id),
          configOverrides: {
            "startWithAudioMuted": true,
            "startWithVideoMuted": true,
          },
        featureFlags: {
          FeatureFlags.addPeopleEnabled: true,
          FeatureFlags.welcomePageEnabled: false,
          FeatureFlags.preJoinPageEnabled: false,
          FeatureFlags.unsafeRoomWarningEnabled: false,
          FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
          FeatureFlags.audioFocusDisabled: true,
          FeatureFlags.audioMuteButtonEnabled: true,
          FeatureFlags.audioOnlyButtonEnabled: true,
          FeatureFlags.calenderEnabled: false,
          FeatureFlags.callIntegrationEnabled: true,
          FeatureFlags.carModeEnabled: true,
          FeatureFlags.closeCaptionsEnabled: true,
          FeatureFlags.conferenceTimerEnabled: true,
          FeatureFlags.chatEnabled: false,
          FeatureFlags.filmstripEnabled: false,
          FeatureFlags.fullScreenEnabled: false,
          FeatureFlags.helpButtonEnabled: true,
          FeatureFlags.inviteEnabled: false,
          FeatureFlags.androidScreenSharingEnabled: true,
          FeatureFlags.speakerStatsEnabled: true,
          FeatureFlags.kickOutEnabled: true,
          FeatureFlags.liveStreamingEnabled: false,
          FeatureFlags.lobbyModeEnabled: false,
          FeatureFlags.meetingNameEnabled: false,
          FeatureFlags.meetingPasswordEnabled: false,
          FeatureFlags.notificationEnabled: true,
          FeatureFlags.overflowMenuEnabled: true,
          FeatureFlags.pipEnabled: true,
          FeatureFlags.pipWhileScreenSharingEnabled: true,
          FeatureFlags.preJoinPageHideDisplayName: true,
          FeatureFlags.raiseHandEnabled: true,
          FeatureFlags.reactionsEnabled: true,
          FeatureFlags.recordingEnabled: true,
          FeatureFlags.replaceParticipant: true,
          FeatureFlags.securityOptionEnabled: true,
          FeatureFlags.serverUrlChangeEnabled: true,
          FeatureFlags.settingsEnabled: true,
          FeatureFlags.tileViewEnabled: true,
          FeatureFlags.videoMuteEnabled: true,
          FeatureFlags.videoShareEnabled: true,
          FeatureFlags.toolboxEnabled: true,
          FeatureFlags.iosRecordingEnabled: true,
          FeatureFlags.iosScreenSharingEnabled: true,
          FeatureFlags.toolboxAlwaysVisible: true,

        },

        userInfo: JitsiMeetUserInfo(
            displayName: (appointment.value.patient!.first_name! + appointment.value.patient!.last_name!),
            email: appointment.value.user.email,
            avatar: appointment.value.patient!.images.first.thumb
        ),
        serverURL: Get.find<SettingsService>().setting.value.jitsiMeetLink
      );

      await _jitsiMeetPlugin.join(options);
    } catch (error) {
      print("error: $error");
    }
  }

  String hashRoomName(String roomName) {
    var bytes = utf8.encode(roomName); // Convert room name to bytes
    var digest = sha256.convert(bytes); // Apply SHA-256 hashing
    return digest.toString(); // Convert hash to string
  }

  Future refreshAppointment({bool showMessage = false}) async {
    await getAppointment();
    initAppointmentAddress();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Appointment page refreshed successfully".tr));
    }
  }
  Future<void> getAppointment() async {
    try {
      appointment.value = await _appointmentRepository.get(appointment.value.id);
      if (appointment.value.status == Get.find<AppointmentsController>().getStatusByOrder(Get.find<GlobalService>().global.value.inProgress) && timer == null) {
        timer = Timer.periodic(Duration(minutes: 1), (t) {
          appointment.update((val) {
            val!.duration += (1 / 60);
          });
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> startAppointment() async {
    try {
      final _status = Get.find<AppointmentsController>().getStatusByOrder(Get.find<GlobalService>().global.value.inProgress);
      final _appointment = new Appointment(id: appointment.value.id, startAt: DateTime.now(), status: _status);
      await _appointmentRepository.update(_appointment);
      appointment.update((val) {
        val?.startAt = _appointment.startAt;
        val?.status = _status;
      });
      timer = Timer.periodic(Duration(minutes: 1), (t) {
        appointment.update((val) {
          val?.duration += (1 / 60);
        });
      });
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> finishAppointment() async {
    try {
      final _status = Get.find<AppointmentsController>().getStatusByOrder(Get.find<GlobalService>().global.value.done);
      var _appointment = new Appointment(id: appointment.value.id, endsAt: DateTime.now(), status: _status);
      final result = await _appointmentRepository.update(_appointment);
      appointment.update((val) {
        val?.endsAt = result.endsAt;
        val?.duration = result.duration;
        val?.status = _status;
      });
      timer?.cancel();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future<void> cancelAppointment() async {
    try {
      if ((appointment.value.status!.order) < (Get.find<GlobalService>().global.value.onTheWay ?? 0 )) {
        final _status = Get.find<AppointmentsController>().getStatusByOrder(Get.find<GlobalService>().global.value.failed);
        final _appointment = new Appointment(id: appointment.value.id, cancel: true, status: _status);
        await _appointmentRepository.update(_appointment);
        appointment.update((val) {
          val?.cancel = true;
          val?.status = _status;
        });
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void initAppointmentAddress() {
    mapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: appointment.value.address!.getLatLng(), zoom: 12.4746),
      ),
    );
    MapsUtil.getMarker(address: appointment.value.address, id: appointment.value.id, description: appointment.value.user.name).then((marker) {
      allMarkers.add(marker);
    });
  }

  String getTime({String separator = ":"}) {
    String hours = "";
    String minutes = "";
    int minutesInt = ((appointment.value.duration - appointment.value.duration.toInt()) * 60).toInt();
    int hoursInt = appointment.value.duration.toInt();
    if (hoursInt < 10) {
      hours = "0" + hoursInt.toString();
    } else {
      hours = hoursInt.toString();
    }
    if (minutesInt < 10) {
      minutes = "0" + minutesInt.toString();
    } else {
      minutes = minutesInt.toString();
    }
    return hours + separator + minutes;
  }

  Future<void> startChat() async {
    var _doctors = <User>[].obs;
    _doctors.add(appointment.value.doctor!.user);
    Message _message = new Message(_doctors, name:  appointment.value.doctor!.name);
    Get.toNamed(Routes.CHAT, arguments: _message);
  }
}
