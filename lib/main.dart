import 'package:flutter/material.dart';
import 'package:yum_quick/app/app.dart';
import 'package:yum_quick/core/di/di.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const YumQUickApp());
}
