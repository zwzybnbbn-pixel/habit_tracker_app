import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/habit_database.dart';
import 'models/habit_model.dart';
import 'models/day_model.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/habit_details_screen.dart';
import 'screens/completion_screen.dart';
import 'utils/constants.dart';
import 'utils/notifications.dart';

class HabitModelAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    return Habit(
      id: reader.readString(),
      name: reader.readString(),
      goal: reader.readString(),
      startDate: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      currentDay: reader.readInt(),
      completedDays: reader.readMap().cast<int, bool>(),
      color: reader.readString(),
      icon: reader.readString(),
      isCompletionShown: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.goal);
    writer.writeInt(obj.startDate.millisecondsSinceEpoch);
    writer.writeInt(obj.currentDay);
    writer.writeMap(obj.completedDays);
    writer.writeString(obj.color);
    writer.writeString(obj.icon);
    writer.writeBool(obj.isCompletionShown);
  }
}

class DayModelAdapter extends TypeAdapter<DayModel> {
  @override
  final int typeId = 1;

  @override
  DayModel read(BinaryReader reader) {
    final dayNumber = reader.readInt();
    final isCompleted = reader.readBool();
    final hasCompletedAt = reader.readBool();
    DateTime? completedAt;
    if (hasCompletedAt) {
      completedAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    }
    final note = reader.readString();

    return DayModel(
      dayNumber: dayNumber,
      isCompleted: isCompleted,
      completedAt: completedAt,
      note: note.isEmpty ? null : note,
    );
  }

  @override
  void write(BinaryWriter writer, DayModel obj) {
    writer.writeInt(obj.dayNumber);
    writer.writeBool(obj.isCompleted);
    writer.writeBool(obj.completedAt != null);
    if (obj.completedAt != null) {
      writer.writeInt(obj.completedAt!.millisecondsSinceEpoch);
    }
    writer.writeString(obj.note ?? '');
  }
}

ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Hive.initFlutter();
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(DayModelAdapter());
  await HabitDatabase.initialize();

  await NotificationService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch') ?? true;
  final savedDarkMode = prefs.getBool('dark_mode') ?? false;

  isDarkModeNotifier.value = savedDarkMode;

  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
  }

  runApp(HabitTrackerApp(
    isFirstLaunch: isFirstLaunch,
  ));
}

class HabitTrackerApp extends StatelessWidget {
  final bool isFirstLaunch;

  const HabitTrackerApp({
    super.key,
    required this.isFirstLaunch,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: isFirstLaunch ? '/welcome' : '/home',
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/add_habit': (context) => const AddHabitScreen(),
            '/home': (context) {
              final habit = ModalRoute.of(context)?.settings.arguments as Habit?;
              return HomeScreen(initialHabit: habit);
            },
            '/details': (context) {
              final habit = ModalRoute.of(context)!.settings.arguments as Habit;
              return HabitDetailsScreen(habit: habit);
            },
            '/completion': (context) {
              final habit = ModalRoute.of(context)!.settings.arguments as Habit;
              return CompletionScreen(habit: habit);
            },
          },
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: child!,
            );
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        foregroundColor: AppColors.textPrimaryLight,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryLight,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Cairo',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        foregroundColor: AppColors.textPrimaryDark,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
      ),
    );
  }
}