/*Name: Hong Nguyen
Date: 6/18/2026
Assigment: 5 - Mortgage Calculator using State Management
 */

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// ENTRY POINT
// Load the saved data first, then provide the model to the app.
// ============================================================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed before async in main
  final model = await MortgageModel.load(); // restore last-saved inputs
  runApp(
    ChangeNotifierProvider.value(
      value: model,
      child: const MortgageApp(),
    ),
  );
}

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const MortgageHomeScreen(),
    );
  }
}

// ============================================================
// MODEL  (Provider's ChangeNotifier + SharedPreferences)
// rate is stored as a decimal fraction, e.g. 0.035 for 3.5%
// ============================================================
class MortgageModel extends ChangeNotifier {
  double amount;
  int years;
  double rate;

  MortgageModel({this.amount = 100000.0, this.years = 30, this.rate = 0.035});

  // --- Calculations (ported from the Lab 4 Mortgage class) ---
  double monthlyPayment() {
    final double mRate = rate / 12;
    if (mRate == 0) return years > 0 ? amount / (years * 12) : 0;
    final double temp = pow(1 / (1 + mRate), years * 12).toDouble();
    return amount * mRate / (1 - temp);
  }

  double totalPayment() {
    final double monthly = double.parse(monthlyPayment().toStringAsFixed(2));
    return monthly * years * 12;
  }

  // --- Formatting helpers ---
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  String get formattedRate => '${(rate * 100).toStringAsFixed(2)}%';
  String get formattedMonthly => '\$${monthlyPayment().toStringAsFixed(2)}';
  String get formattedTotal => '\$${totalPayment().toStringAsFixed(2)}';

  // --- Requirement 1: update shared state and notify both screens ---
  // --- Requirement 2: persist the inputs with SharedPreferences ---
  Future<void> updateAndSave({
    required double amount,
    required int years,
    required double rate,
  }) async {
    this.amount = amount;
    this.years = years;
    this.rate = rate;
    notifyListeners(); // both screens listening to this model rebuild

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('amount', amount);
    await prefs.setInt('years', years);
    await prefs.setDouble('rate', rate);
  }

  // Load saved values at launch, falling back to the defaults.
  static Future<MortgageModel> load() async {
    final prefs = await SharedPreferences.getInstance();
    return MortgageModel(
      amount: prefs.getDouble('amount') ?? 100000.0,
      years: prefs.getInt('years') ?? 30,
      rate: prefs.getDouble('rate') ?? 0.035,
    );
  }
}

// ============================================================
// LEFT SCREEN: display the mortgage data (reads the shared model)
// ============================================================
class MortgageHomeScreen extends StatefulWidget {
  const MortgageHomeScreen({super.key});

  @override
  State<MortgageHomeScreen> createState() => _MortgageHomeScreenState();
}

class _MortgageHomeScreenState extends State<MortgageHomeScreen> {
  bool agreedToTerms = false;

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: const Text(
              'Do you accept the terms and conditions of this mortgage?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => agreedToTerms = false);
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => agreedToTerms = true);
                Navigator.pop(context);
              },
              child: const Text('I Agree'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mortgage calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        // Consumer rebuilds these rows whenever the model changes.
        child: Consumer<MortgageModel>(
          builder: (context, model, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dataRow('Amount', model.formattedAmount),
                _dataRow('Years', '${model.years}'),
                _dataRow('Interest Rate', model.formattedRate),
                const Divider(color: Colors.red, thickness: 2, height: 8),
                const SizedBox(height: 8),
                _dataRow('Monthly Payment', model.formattedMonthly),
                _dataRow('Total Payment', model.formattedTotal),
                const SizedBox(height: 8),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('Terms and Conditions'),
                  value: agreedToTerms,
                  onChanged: (_) => _showTermsDialog(),
                ),

                const SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    // No data passed: the next screen reads the same model.
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ModifyScreen(),
                      ),
                    ),
                    child: const Text('MODIFY DATA'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// ============================================================
// RIGHT SCREEN: edit Years (radio), Amount (field), Rate (ListView)
// ============================================================
class ModifyScreen extends StatefulWidget {
  const ModifyScreen({super.key});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  late final TextEditingController amountController;
  late int selectedYears;
  late double selectedRatePercent;

  final List<double> rates = List<double>.generate(53, (i) => 2 + i * 0.25);

  @override
  void initState() {
    super.initState();
    // Seed the inputs from the current shared model (read-only access).
    final model = context.read<MortgageModel>();
    amountController =
        TextEditingController(text: model.amount.toStringAsFixed(2));
    selectedYears = model.years;
    selectedRatePercent = model.rate * 100;
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _done() {
    final double amount = double.tryParse(amountController.text) ??
        context.read<MortgageModel>().amount;
    // Write back to the shared model AND persist to SharedPreferences.
    context.read<MortgageModel>().updateAndSave(
          amount: amount,
          years: selectedYears,
          rate: selectedRatePercent / 100,
        );
    Navigator.pop(context); // back to the display screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mortgage calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 80, child: Text('Years')),
                Expanded(
                  child: RadioGroup<int>(
                    groupValue: selectedYears,
                    onChanged: (val) => setState(() => selectedYears = val!),
                    child: Row(
                      children: const [
                        _YearOption(10),
                        _YearOption(15),
                        _YearOption(30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 80, child: Text('Amount')),
                Expanded(
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Interest Rate',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Expanded(
              child: ListView.builder(
                itemCount: rates.length,
                itemBuilder: (context, i) {
                  final pct = rates[i];
                  final bool selected =
                      (pct - selectedRatePercent).abs() < 0.001;
                  return ListTile(
                    dense: true,
                    title: Text('${pct.toStringAsFixed(2)}%'),
                    selected: selected,
                    selectedTileColor: Colors.indigo.withValues(alpha: 0.12),
                    trailing:
                        selected ? const Icon(Icons.check, size: 18) : null,
                    onTap: () => setState(() => selectedRatePercent = pct),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _done,
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YearOption extends StatelessWidget {
  final int value;
  const _YearOption(this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(value: value),
        Text('$value'),
        const SizedBox(width: 8),
      ],
    );
  }
}