import 'package:get/get.dart';
import 'package:iqra/ui/screens/dashboard/dashboard_screen.dart';
import 'package:iqra/ui/screens/members/members_screen.dart';
import 'package:iqra/ui/screens/profile/profile_screen.dart';

class HomeController extends GetxController{
  final currentIndex = 0.obs;
  final list = [
    DashboardScreen(),
    MembersScreen(),
    ProfileScreen()
  ];
}