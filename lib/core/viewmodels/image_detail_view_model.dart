import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/viewmodels/base_view_model.dart';

class ImageDetailViewModel extends BaseViewModel {
  ImageDetailViewModel({
    required this.initialIndex,
  });

  final int initialIndex;

  late PageController _pageController;
  PageController get pageController => _pageController;

  @override
  void initModel() {
    setBusy(true);
    _pageController = PageController(initialPage: initialIndex);
    setBusy(false);
  }
}
