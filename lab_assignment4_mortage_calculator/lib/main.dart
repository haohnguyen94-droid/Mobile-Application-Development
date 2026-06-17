/* 
Name: Hong Nguyen 
Date: 6/16/2026 
Assignment: Mortgage Calculator  
 */

import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MortgageApp());

class MortgageApp extends StatelessWidget {
  const MortgageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const MortgageHomeScreen(),
    );
  }
}

// ============================================================
// MODEL: the Mortgage class (ported from the Kotlin sample)
// rate is stored as a decimal fraction, e.g. 0.035 for 3.5%
// ============================================================
class Mortgage {
  double amount;
  int years;
  double rate;

  Mortgage({this.amount = 100000.0, this.years = 30, this.rate = 0.035});

  double monthlyPayment() {
    final double mRate = rate / 12; // monthly interest rate
    if (mRate == 0) {
      return years > 0 ? amount / (years * 12) : 0;
    }
    // amount * mRate / (1 - (1 / (1 + mRate))^(years*12))
    final double temp = pow(1 / (1 + mRate), years * 12).toDouble();
    return amount * mRate / (1 - temp);
  }

  double totalPayment() {
    // Round the monthly payment to whole cents before multiplying,
    // matching how a real payment schedule (and the sample) behaves.
    final double monthly = double.parse(monthlyPayment().toStringAsFixed(2));
    return monthly * years * 12;
  }

  // Formatting helpers
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  String get formattedRate => '${(rate * 100).toStringAsFixed(2)}%';
  String get formattedMonthly => '\$${monthlyPayment().toStringAsFixed(2)}';
  String get formattedTotal => '\$${totalPayment().toStringAsFixed(2)}';
}

// ============================================================
// LEFT SCREEN: display the mortgage data
// ============================================================
class MortgageHomeScreen extends StatefulWidget {
  const MortgageHomeScreen({super.key});

  @override
  State<MortgageHomeScreen> createState() => _MortgageHomeScreenState();
}

class _MortgageHomeScreenState extends State<MortgageHomeScreen> {
  // The shared data lives here, with the default values from the model.
  Mortgage mortgage = Mortgage();

  bool agreedToTerms = false;

  // MODIFY DATA -> open the input screen, then receive the updated
  // Mortgage back through Navigator.pop's result.
  Future<void> _modifyData() async {
    final updated = await Navigator.push<Mortgage>(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyScreen(initial: mortgage),
      ),
    );
    if (updated != null && mounted) {
      setState(() => mortgage = updated);
    }
  }

  // Terms & Conditions checkbox -> confirm with an AlertDialog.
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
      appBar: AppBar(title: const Text('Mortgage Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dataRow('Amount', mortgage.formattedAmount),
            _dataRow('Years', '${mortgage.years}'),
            _dataRow('Interest Rate', mortgage.formattedRate),
            // Red underline under the interest rate
            const Divider(color: Colors.red, thickness: 2, height: 8),
            const SizedBox(height: 8),
            _dataRow('Monthly Payment', mortgage.formattedMonthly),
            _dataRow('Total Payment', mortgage.formattedTotal),
            const SizedBox(height: 8),

            // Terms and Conditions checkbox -> AlertDialog
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
                onPressed: _modifyData,
                child: const Text('MODIFY DATA'),
              ),
            ),
          ],
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
  final Mortgage initial;

  const ModifyScreen({super.key, required this.initial});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  late final TextEditingController amountController;
  late int selectedYears;
  late double selectedRatePercent; // stored as a percent, e.g. 3.5

  // Interest rates from 2% to 15% in steps of 0.25 (53 values)
  final List<double> rates =
      List<double>.generate(53, (i) => 2 + i * 0.25);

  @override
  void initState() {
    super.initState();
    // Pre-fill the inputs from the data passed in via the constructor.
    amountController =
        TextEditingController(text: widget.initial.amount.toStringAsFixed(2));
    selectedYears = widget.initial.years;
    selectedRatePercent = widget.initial.rate * 100;
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _done() {
    final double amount =
        double.tryParse(amountController.text) ?? widget.initial.amount;
    // Send the updated Mortgage back to the left screen.
    Navigator.pop(
      context,
      Mortgage(
        amount: amount,
        years: selectedYears,
        rate: selectedRatePercent / 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mortgage Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Years as 10 / 15 / 30 radio buttons
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

            // Amount text field
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

            // Interest rate as a scrollable ListView of selectable values
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

// A single year radio option (10 / 15 / 30) shown inline.
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