import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rejo_jaya_sakti_apps/core/services/navigation_service.dart';

List<SingleChildWidget> providers = [
  ...independentProviders,
  ...dependentProviders,
];

List<SingleChildWidget> independentProviders = [
  Provider<NavigationService>(
    create: (_) => NavigationService(),
  ),
];

List<SingleChildWidget> dependentProviders = [];
