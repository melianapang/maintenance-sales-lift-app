import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/maintenance/maintenance_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class FormDeleteMaintenanceViewModel extends BaseViewModel {
  FormDeleteMaintenanceViewModel({
    MaintenanceData? maintenanceData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _maintenanceData = maintenanceData;

  final ApiService _apiService;

  MaintenanceData? _maintenanceData;
  MaintenanceData? get maintenanceData => _maintenanceData;

  List<String> reasonItems = [
    "Dibatalkan oleh pelanggan",
    "Teknisi berhalangan pada hari tersebut",
    "Dijadwalkan ulang",
    "Teknisi/Pelanggan lupa",
    "Lainnya",
  ];

  String _selectedReason = "Dibatalkan oleh pelanggan.";
  String get selectedReason => _selectedReason;

  TextEditingController reasonController = TextEditingController();

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {}

  void setSelectedReason(String value) {
    _selectedReason = value;
    notifyListeners();
  }

  String mappingSelectedReasonOption() {
    if (_selectedReason != reasonItems.last) return reasonController.text;

    return _selectedReason;
  }

  Future<bool> requestDeleteMaintenanceDate() async {
    final response = await _apiService.requestDeleteMaintenance(
      maintenanceId: int.parse(_maintenanceData?.maintenanceId ?? "0"),
      reason: mappingSelectedReasonOption(),
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }
}
