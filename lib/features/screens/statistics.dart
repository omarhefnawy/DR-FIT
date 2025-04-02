import 'dart:math'; // Add this import for pow function

import 'package:dr_fit/core/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dr_fit/features/exercises/controller/exercise_cubit.dart';
import 'package:dr_fit/features/exercises/model/exercise_model.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatefulWidget {
  final double weight;
  final double height;
  final int age;

  const StatisticsScreen({
    Key? key,
    required this.weight,
    required this.height,
    required this.age,
  }) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late final  double bmi;
  late final  String bmiCategory;
  int waterIntake = 0;
  int waterGoal = 2500;
  DateTime? lastUpdatedDate;

 @override
void initState() {
  super.initState();
  bmi = _calculateBMI();
  bmiCategory = _getBMICategory(bmi);
  _loadWaterData();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _fetchExercises();
  });
}

  void _fetchExercises() {
    String targetMuscle = _getTargetMuscle(bmiCategory);
    print('💪 العضلات المستهدفة: $targetMuscle');

    context.read<ExerciseCubit>().getExerciseByBody(
          target: targetMuscle,
          context: context,
        );
  }

  double _calculateBMI() {
    final heightInMeters = widget.height / 100;
    return widget.weight / pow(heightInMeters, 2);
  }

  int _calculateCalories(String activityLevel) {
    final bmr =
        (10 * widget.weight) + (6.25 * widget.height) - (5 * widget.age) + 5;
    switch (activityLevel) {
      case 'منخفض':
        return (bmr * 1.2).toInt();
      case 'متوسط':
        return (bmr * 1.55).toInt();
      case 'عالي':
        return (bmr * 1.9).toInt();
      default:
        return bmr.toInt();
    }
  }

  double _estimateBodyFat(double bmi) {
    return (1.2 * bmi) + (0.23 * widget.age) - 5.4;
  }

  String _getTargetMuscle(String category) {
    switch (category) {
      case 'نحافة':
        return 'chest'; // تمارين الصدر لزيادة الكتلة العضلية
      case 'وزن صحي':
        return 'back'; // تمارين الظهر للحفاظ على اللياقة
      case 'وزن زائد':
        return 'waist'; // تمارين الخصر لحرق الدهون
      default: // للسمنة
        return 'cardio'; // تمارين كارديو منخفضة الشدة
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'نحافة';
    if (bmi < 24.9) return 'وزن صحي';
    if (bmi < 29.9) return 'وزن زائد';
    return 'سمنة';
  }

  String _getFoodAdvice() {
    switch (bmiCategory) {
      case 'نحافة':
        return '• تناول وجبات غنية بالبروتين والسعرات الحرارية\n'
            '• زد من تناول المكسرات والأفوكادو\n'
            '• تناول 5-6 وجبات صغيرة يومياً';
      case 'وزن صحي':
        return '• حافظ على نظام غذائي متوازن\n'
            '• تناول الخضروات والفواكه الطازجة\n'
            '• اشرب كميات كافية من الماء';
      case 'وزن زائد':
        return '• قلل من السكريات والأطعمة المعالجة\n'
            '• ركز على البروتينات الخالية من الدهون\n'
            '• استبدل الكربوهيدرات البسيطة بالمعقدة';
      default:
        return '• اتبع نظام غذائي منخفض الكربوهيدرات\n'
            '• استشر أخصائي تغذية\n'
            '• تجنب الوجبات السريعة والمشروبات الغازية';
    }
  }

  String _getWorkoutAdvice() {
    switch (bmiCategory) {
      case 'نحافة':
        return '• ركز على تمارين القوة لزيادة الكتلة العضلية\n'
            '• استخدم أوزان متوسطة إلى ثقيلة\n'
            '• قلل من تمارين الكارديو';
      case 'وزن صحي':
        return '• حافظ على مزيج من الكارديو والمقاومة\n'
            '• جرب تمارين HIIT\n'
            '• لا تهمل تمارين المرونة';
      case 'وزن زائد':
        return '• ابدأ بتمارين الكارديو لحرق الدهون\n'
            '• مارس المشي السريع أو السباحة\n'
            '• زد الشدة تدريجياً';
      default:
        return '• ابدأ بتمارين منخفضة الشدة\n'
            '• المشي يومياً لمدة 30 دقيقة\n'
            '• استشر مدرب متخصص';
    }
  }

  Color _getBMIColor() {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  Future<void> _loadWaterData() async {
    await CacheHelper.init();
    final lastDateString = CacheHelper.getData(key: 'lastWaterDate');
    if (lastDateString != null) {
      lastUpdatedDate = DateTime.parse(lastDateString);
    }

    if (lastUpdatedDate == null ||
        !DateUtils.isSameDay(lastUpdatedDate!, DateTime.now())) {
      await _resetWaterIntake();
    } else {
      setState(() {
        waterIntake = CacheHelper.getData(key: 'waterIntake', defaultValue: 0);
      });
    }
  }

  Future<void> _checkDateChange() async {
    final dynamic lastDateData = CacheHelper.getData(key: 'lastWaterDate');

    if (lastDateData is String && lastDateData.isNotEmpty) {
      try {
        final lastDate = DateTime.parse(lastDateData);
        if (!DateUtils.isSameDay(lastDate, DateTime.now())) {
          await _resetWaterIntake();
        }
      } catch (e) {
        print('⚠️ خطأ في تحويل lastWaterDate إلى DateTime: $e');
        _resetLastWaterDate(); // إعادة ضبط التاريخ
      }
    } else {
      print('⚠️ lastWaterDate ليس نصًا صحيحًا! القيم المخزنة: $lastDateData');
      _resetLastWaterDate(); // إعادة ضبط التاريخ
    }
  }

  Future<void> _resetLastWaterDate() async {
    final newDate = DateTime.now().toIso8601String();
    await CacheHelper.setData(key: 'lastWaterDate', value: newDate);
    print('✅ تم تصحيح lastWaterDate وتعيينه إلى: $newDate');
  }

  Future<void> _resetWaterIntake() async {
    setState(() {
      waterIntake = 0;
    });
    await CacheHelper.setData(key: 'waterIntake', value: 0);
    await CacheHelper.setData(
      key: 'lastWaterDate',
      value: DateTime.now().toString(),
    );
  }

  Future<void> _addWater(int amount) async {
    final newAmount = (waterIntake + amount).clamp(0, waterGoal);

    await CacheHelper.setData(key: 'waterIntake', value: newAmount);
    await CacheHelper.setData(
      key: 'lastWaterDate',
      value: DateTime.now().toString(),
    );

    setState(() {
      waterIntake = newAmount;
    });

    if (newAmount >= waterGoal) {
      _showGoalAchieved();
    }
  }

  void _showGoalAchieved() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.celebration, color: Colors.yellow[700]),
            SizedBox(width: 8),
            Text('🎉 لقد حققت هدفك اليومي من الماء!'),
          ],
        ),
        backgroundColor: Colors.green[700],
        duration: Duration(seconds: 3),
      ),
    );
  }

  double _getBMIProgressValue() {
    if (bmi < 18.5) return 0.2;
    if (bmi < 24.9) return 0.5;
    if (bmi < 29.9) return 0.8;
    return 1.0;
  }

  Widget _buildHeaderCard(Color bmiColor, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مؤشر كتلة الجسم',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      bmiCategory,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: bmiColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Chip(
                  backgroundColor: bmiColor.withOpacity(0.2),
                  label: Text(
                    bmi.toStringAsFixed(1),
                    style: TextStyle(
                      color: bmiColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: _getBMIProgressValue(),
              backgroundColor: Colors.grey[200],
              color: bmiColor,
              minHeight: 8,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('نحافة'),
                Text('صحي'),
                Text('زائد'),
                Text('سمنة'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    int calories,
    double bodyFat,
    double idealWeight,
    Color bmiColor,
    ThemeData theme,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          icon: Icons.local_fire_department,
          title: 'السعرات اليومية',
          value: '$calories سعرة',
          color: Colors.deepOrange,
          theme: theme,
        ),
        _buildStatCard(
          icon: Icons.fitness_center,
          title: 'نسبة الدهون',
          value: '${bodyFat.toStringAsFixed(1)}%',
          color: Colors.purple,
          theme: theme,
        ),
        _buildStatCard(
          icon: Icons.monitor_weight,
          title: 'الوزن الحالي',
          value: '${widget.weight} كجم',
          color: Colors.blue,
          theme: theme,
        ),
        _buildStatCard(
          icon: Icons.straighten,
          title: 'الوزن المثالي',
          value: '${idealWeight.toStringAsFixed(1)} كجم',
          color: Colors.teal,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildWaterTracker(ThemeData theme) {
    final progress = waterIntake / waterGoal;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (waterIntake >= waterGoal)
                  Icon(Icons.celebration, color: Colors.yellow[700]),
                Icon(Icons.water_drop, color: Colors.blue[400]),
                SizedBox(width: 8),
                Text(
                  'تتبع شرب الماء',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat('d/M/y')
                      .format(DateTime.now()), // يعرض اليوم/الشهر/السنة
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: progress >= 1 ? Colors.green : Colors.blue,
              minHeight: 12,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$waterIntake مل',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '$waterGoal مل',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: waterIntake >= waterGoal ? null : () => _addWater(250),
              icon: Icon(Icons.add),
              label: Text('أضف كوب ماء (250 مل)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: waterIntake >= waterGoal
                    ? Colors.grey[300]
                    : Colors.blue[50],
                foregroundColor:
                    waterIntake >= waterGoal ? Colors.grey : Colors.blue,
                elevation: 0,
              ),
            ),
            if (waterIntake >= waterGoal)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'تم تحقيق الهدف اليومي',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceCard({
    required String title,
    required String advice,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              advice,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نصائح لك',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        _buildAdviceCard(
          title: 'نصيحة غذائية',
          advice: _getFoodAdvice(),
          icon: Icons.restaurant,
          color: Colors.brown,
          theme: theme,
        ),
        SizedBox(height: 12),
        _buildAdviceCard(
          title: 'نصيحة رياضية',
          advice: _getWorkoutAdvice(),
          icon: Icons.fitness_center,
          color: Colors.blueGrey,
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: exercise.gifUrl.isNotEmpty
              ? Image.network(
                  exercise.gifUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
                )
              : _buildPlaceholderImage(),
        ),
        title: Text(
          exercise.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('العضلة: ${exercise.target}'),
            Text('الأدوات: ${exercise.equipment}'),
          ],
        ),
        trailing: Icon(Icons.chevron_left),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: Icon(Icons.fitness_center, color: Colors.grey),
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تمارين مقترحة لـ ($bmiCategory)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          _getExerciseDescription(),
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 12),
        BlocBuilder<ExerciseCubit, ExerciseState>(
          builder: (context, state) {
            if (state is ExerciseLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ExerciseSuccess) {
              if (state.exercise.isEmpty) {
                return Text('لا توجد تمارين متاحة لهذه الفئة');
              }
              return Column(
                children: state.exercise
                    .take(3) // عرض فقط 3 تمارين رئيسية
                    .map((exercise) => _buildExerciseItem(exercise))
                    .toList(),
              );
            } else if (state is ExerciseError) {
              return Text('حدث خطأ في جلب التمارين');
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  String _getExerciseDescription() {
    switch (bmiCategory) {
      case 'نحافة':
        return 'تمارين القوة لزيادة الكتلة العضلية';
      case 'وزن صحي':
        return 'تمارين متوازنة للحفاظ على لياقتك';
      case 'وزن زائد':
        return 'تمارين لحرق الدهون وتقوية العضلات';
      default:
        return 'تمارين منخفضة الشدة لتحسين صحتك';
    }
  }

  @override
  Widget build(BuildContext context) {
    final calories = _calculateCalories('متوسط');
    final bodyFat = _estimateBodyFat(bmi);
    final idealWeight = 22 * pow(widget.height / 100, 2).toDouble();
    final bmiColor = _getBMIColor();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('الإحصائيات الصحية'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetWaterIntake,
            tooltip: 'إعادة تعيين عداد الماء',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(bmiColor, theme),
            SizedBox(height: 16),
            _buildStatsGrid(calories, bodyFat, idealWeight, bmiColor, theme),
            SizedBox(height: 24),
            _buildWaterTracker(theme),
            SizedBox(height: 24),
            _buildAdviceSection(theme),
            SizedBox(height: 24),
            _buildExercisesSection(),
          ],
        ),
      ),
    );
  }
}
