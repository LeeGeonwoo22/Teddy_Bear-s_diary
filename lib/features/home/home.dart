// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
//
// import '../chat/chat.dart';
//
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NavigationController());
//     return Scaffold(
//       bottomNavigationBar: Obx(
//           ()=> NavigationBar(
//             selectedIndex : controller.selectedIndex.value,
//             onDestinationSelected: (index) => controller.selectedIndex.value = index,
//             destinations: [
//           NavigationDestination(icon :Icon(Iconsax.snapchat), label: 'Talk'),
//           NavigationDestination(icon :Icon(Iconsax.book), label: 'Diary'),
//           NavigationDestination(icon :Icon(Iconsax.chart), label: 'Graph'),
//           NavigationDestination(icon :Icon(Iconsax.settings), label: 'Setting'),
//
//         ]),
//       ),
//       body: Obx(()=> controller.screens[controller.selectedIndex.value]),
//     );
//   }
// }
//
// class NavigationController extends GetxController {
//   final Rx<int> selectedIndex = 0.obs;
//   final screens = [
//     ChatbotFeature(),
//     Container(color: Colors.deepOrangeAccent,),
//     Container(color: Colors.redAccent,),
//     Container(color: Colors.blueAccent,),];
// }