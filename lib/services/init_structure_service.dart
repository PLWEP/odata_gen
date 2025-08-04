import 'dart:io';

class InitStructureService {
  final String basePath;

  InitStructureService({this.basePath = 'lib'});

  void generate() {
    final directories = [
      '$basePath/app/data/models',
      '$basePath/app/data/providers',
      '$basePath/app/data/repositories',
      '$basePath/app/modules/home/controllers',
      '$basePath/app/modules/home/views',
      '$basePath/app/modules/home/bindings',
      '$basePath/app/modules/home/widgets',
      '$basePath/app/modules/profile/controllers',
      '$basePath/app/modules/profile/views',
      '$basePath/app/modules/profile/bindings',
      '$basePath/app/modules/profile/widgets',
      '$basePath/app/routes',
      '$basePath/app/core/values',
      '$basePath/app/core/theme',
      '$basePath/app/core/utils',
      '$basePath/app/widgets',
    ];

    final files = {
      '$basePath/main.dart': _mainFileContent(),
      '$basePath/app/routes/app_routes.dart': _appRoutesContent(),
      '$basePath/app/routes/app_pages.dart': _appPagesContent(),
      '$basePath/app/app_binding.dart': _appBindingContent(),
      '$basePath/app/modules/home/controllers/home_controller.dart':
          _homeControllerContent(),
      '$basePath/app/modules/home/views/home_view.dart': _homeViewContent(),
      '$basePath/app/modules/home/bindings/home_binding.dart':
          _homeBindingContent(),
    };

    for (var dir in directories) {
      Directory(dir).createSync(recursive: true);
      print('Created directory: $dir');
    }

    files.forEach((path, content) {
      File(path).writeAsStringSync(content);
      print('Created file: $path');
    });

    print('✅ GetX structure generated successfully at $basePath/');
  }

  /// ================== File Templates ==================

  String _mainFileContent() => '''
/// Main entry point of the application
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/app_binding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX App',
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.routes,
    );
  }
}
''';

  String _appRoutesContent() => '''
/// All route names in one place
abstract class AppRoutes {
  static const HOME = '/home';
  static const PROFILE = '/profile';
}
''';

  String _appPagesContent() => '''
/// Define all application pages and their bindings
import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    // Add more pages here
  ];
}
''';

  String _appBindingContent() => '''
/// Global bindings for dependency injection
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Put global controllers or services here
  }
}
''';

  String _homeControllerContent() => '''
/// Controller for Home module
import 'package:get/get.dart';

class HomeController extends GetxController {
  var counter = 0.obs;

  void increment() {
    counter++;
  }
}
''';

  String _homeViewContent() => '''
/// UI for Home module
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Obx(() => Text('Counter: \${controller.counter}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: Icon(Icons.add),
      ),
    );
  }
}
''';

  String _homeBindingContent() => '''
/// Binding for Home module (connects Controller with View)
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
''';
}
