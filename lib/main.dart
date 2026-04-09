import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'state/mission_progress.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wjfoexnahyuvjnthbany.supabase.co',
    anonKey: 'sb_publishable_ngnCf5_uI6NkkeJStJDyqw_E-gpiwg6',
  );
  await MissionProgressController.initialize();
  runApp(const TouristApp());
}
