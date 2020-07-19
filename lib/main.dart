import 'package:consumir_web_api/ui/home/app.dart';
import 'package:flutter/material.dart';

import 'models/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  runApp(MyApp());
}
