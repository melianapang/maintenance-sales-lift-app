import 'package:json_annotation/json_annotation.dart';

class PaginationControl {
  PaginationControl(
      {this.currentPage = 0, this.pageSize = 10, this.totalData = -1});

  int currentPage;
  int pageSize;
  int totalData;
}
