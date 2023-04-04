import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/unit_customer/unit_customer_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class DetailUnitCustomerViewModel extends BaseViewModel {
  DetailUnitCustomerViewModel({
    UnitData? unitData,
    required DioService dioService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _unitData = unitData;

  final ApiService _apiService;

  final UnitData? _unitData;
  UnitData? get unitData => _unitData;

  @override
  Future<void> initModel() async {}
}
