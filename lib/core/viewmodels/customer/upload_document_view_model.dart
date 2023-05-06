import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/apis/api.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/models/gallery_data_model.dart';
import 'package:rejo_jaya_sakti_apps/core/services/dio_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/gcloud_service.dart';
import 'package:rejo_jaya_sakti_apps/core/services/remote_config_service.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/date_time_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';
import 'package:rejo_jaya_sakti_apps/ui/widgets/filter_menu.dart';

class UploadDocumentViewModel extends BaseViewModel {
  UploadDocumentViewModel({
    CustomerData? customerData,
    required DioService dioService,
    required GCloudService gCloudService,
    required RemoteConfigService remoteConfigService,
  })  : _apiService = ApiService(
          api: Api(
            dioService.getDioJwt(),
          ),
        ),
        _customerData = customerData,
        _gCloudService = gCloudService,
        _remoteConfigService = remoteConfigService;

  final ApiService _apiService;
  final GCloudService _gCloudService;
  final RemoteConfigService _remoteConfigService;

  final CustomerData? _customerData;
  CustomerData? get customerData => _customerData;

  //region Feature flag values
  bool _isGCloudStorageEnabled = false;
  //endregion

  final noteController = TextEditingController();

  int _selectedTipeDokumentOption = 0;
  int get selectedTipeDokumentOption => _selectedTipeDokumentOption;
  final List<FilterOption> _tipeDokumentOption = [
    FilterOption("Purchase Order", true),
    FilterOption("Quotation", false),
    FilterOption("Dokumen Perjanjian Kerja Sama", false),
  ];
  List<FilterOption> get tipeDokumentOption => _tipeDokumentOption;

  //region gallery
  final List<GalleryData> _galleryData = [];
  List<GalleryData> get galleryData => _galleryData;

  List<String> _uploadedFilesLink = [];
  List<String> get uploadedFilesLink => _uploadedFilesLink;
  //endregion

  String? _errorMsg;
  String? get errorMsg => _errorMsg;

  @override
  Future<void> initModel() async {
    setBusy(true);
    _isGCloudStorageEnabled =
        _remoteConfigService.isGCloudStorageEnabled ?? false;
    setBusy(false);
  }

  void resetErrorMsg() {
    _errorMsg = null;
  }

  void setTipeDokumen({
    required int selectedMenu,
  }) {
    _selectedTipeDokumentOption = selectedMenu;
    for (int i = 0; i < _tipeDokumentOption.length; i++) {
      if (i == selectedMenu) {
        _tipeDokumentOption[i].isSelected = true;
        continue;
      }
      _tipeDokumentOption[i].isSelected = false;
    }

    notifyListeners();
  }

  Future<bool> _requestCreateDocument() async {
    final response = await _apiService.requestCreateDocument(
      filePath: _uploadedFilesLink.first,
      fileType: _selectedTipeDokumentOption + 1,
      customerId: int.parse(_customerData?.customerId ?? "0"),
      note: noteController.text,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<void> _saveGalleryToCloud() async {
    try {
      final currDateString = DateTimeUtils.convertDateToString(
        date: DateTime.now(),
        formatter: DateFormat(DateTimeUtils.DATE_FORMAT_3),
      );

      for (GalleryData gallery in _galleryData) {
        File file = File(gallery.filepath);
        String ext = gallery.filepath.split('.').last;

        final response = await _gCloudService.save(
          '${customerData?.customerId}_customer_document_$currDateString.$ext',
          file.readAsBytesSync(),
        );
        print("LINK GCLOUD: ${response?.downloadLink}");

        //Save the link that will be sent to api (ONLY FOR PDF use downloadLink)
        _uploadedFilesLink.add(
          response?.downloadLink.toString() ?? "",
        );
        print("LINK UPLOADED SERVER: ${gallery.filepath}");
      }
    } catch (e) {
      _errorMsg = "$e";
    }
  }

  Future<bool> _requestCreateDocumentDummy() async {
    final response = await _apiService.requestCreateDocument(
      //if use this document, after creating the document,
      //user cannot download it on 'daftar dokumen' section in detail customer view page.
      filePath: 'http://www.africau.edu/images/default/sample.pdf',
      fileType: _selectedTipeDokumentOption + 1,
      customerId: int.parse(_customerData?.customerId ?? "0"),
      note: noteController.text,
    );

    if (response.isRight) return true;

    _errorMsg = response.left.message;
    return false;
  }

  Future<bool> requestUploadDocumentData() async {
    _errorMsg = null;

    if (!_isGCloudStorageEnabled) {
      return await _requestCreateDocumentDummy();
    }

    if (_galleryData.isEmpty) {
      _errorMsg = "Bukti Dokumen tidak boleh kosong";
      return false;
    }

    await _saveGalleryToCloud();
    if (_errorMsg != null) return false;

    return await _requestCreateDocument();
  }
}
