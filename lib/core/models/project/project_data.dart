import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_dto.dart';
import 'package:rejo_jaya_sakti_apps/ui/views/project/add_pic_project_view.dart';

class ProjectData {
  ProjectData({
    required this.customerData,
    required this.picData,
  });

  final CustomerData customerData;
  final List<PicData> picData;
}
