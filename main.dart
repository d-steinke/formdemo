import 'package:flutter/material.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;

  User({required this.id, required this.firstName, required this.lastName});

  String get fullName => '$firstName $lastName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $fullName)';
  }
}

enum FormOptions { optionA, optionB, optionC }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Input Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> userList = List.generate(
      10,
          (index) => User(
        id: 'user_${index + 1}',
        firstName: 'First${index + 1}',
        lastName: 'Last${index + 1}',
      ),
    );

    final Map<String, dynamic> initialFormValues = {
      'doubleValue': 4.5,
      'stringValue': 'Hello',
      'optionValue': FormOptions.optionB,
      'checkbox1': true,
      'checkbox2': false,
      'checkbox3': true,
      'userValue': userList[3],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Input Assignment'),
      ),
      body: MyFormWidget(
        initialValues: initialFormValues,
        userList: userList,
      ),
    );
  }
}

class MyFormWidget extends StatefulWidget {
  final Map<String, dynamic> initialValues;

  final List<User> userList;

  const MyFormWidget({
    super.key,
    required this.initialValues,
    required this.userList,
  });

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _doubleController;
  late TextEditingController _stringController;

  FormOptions? _selectedOption;

  bool _checkbox1 = false;
  bool _checkbox2 = false;
  bool _checkbox3 = false;

  User? _selectedUser;

  @override
  void initState() {
    super.initState();

    _doubleController = TextEditingController(
      text: widget.initialValues['doubleValue']?.toString() ?? '',
    );
    _stringController = TextEditingController(
      text: widget.initialValues['stringValue'] ?? '',
    );
    _selectedOption = widget.initialValues['optionValue'] as FormOptions?;
    _checkbox1 = widget.initialValues['checkbox1'] ?? false;
    _checkbox2 = widget.initialValues['checkbox2'] ?? false;
    _checkbox3 = widget.initialValues['checkbox3'] ?? false;
    _selectedUser = widget.initialValues['userValue'] as User?;
  }

  @override
  void dispose() {
    _doubleController.dispose();
    _stringController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> formValues = {
        'doubleValue': double.tryParse(_doubleController.text),
        'stringValue': _stringController.text,
        'optionValue': _selectedOption,
        'checkbox1': _checkbox1,
        'checkbox2': _checkbox2,
        'checkbox3': _checkbox3,
        'userValue': _selectedUser,
      };

      debugPrint('--- Form Values ---');
      formValues.forEach((key, value) {
        debugPrint('$key: $value (${value.runtimeType})');
      });
      debugPrint('---------------------');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted! Check your console.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _doubleController,
            decoration: const InputDecoration(
              labelText: 'Double (Must be > 3.00 and < 10.00)',
            ),
            keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number';
              }
              final n = double.tryParse(value);
              if (n == null) {
                return 'Please enter a valid number (e.g., 5.5)';
              }
              if (n <= 3.00) {
                return 'Number must be above 3.00';
              }
              if (n >= 10.00) {
                return 'Number must be below 10.00';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _stringController,
            decoration: const InputDecoration(
              labelText: 'String (Min 5, Max 20 chars)',
            ),
            maxLength: 20,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              if (value.length < 5) {
                return 'Minimum 5 characters required';
              }

              if (value.length > 20) {
                return 'Maximum 20 characters allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          const Text('Select an Option',
              style: TextStyle(fontWeight: FontWeight.bold)),

          RadioGroup<FormOptions>(
            groupValue: _selectedOption,
            onChanged: (FormOptions? value) {
              setState(() {
                _selectedOption = value;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<FormOptions>(
                  title: const Text('Option A'),
                  value: FormOptions.optionA,
                ),
                RadioListTile<FormOptions>(
                  title: const Text('Option B'),
                  value: FormOptions.optionB,
                ),
                RadioListTile<FormOptions>(
                  title: const Text('Option C'),
                  value: FormOptions.optionC,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Text('Select Checkboxes',
              style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: const Text('Checkbox 1'),
            value: _checkbox1,
            onChanged: (bool? value) {
              setState(() {
                _checkbox1 = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Checkbox 2'),
            value: _checkbox2,
            onChanged: (bool? value) {
              setState(() {
                _checkbox2 = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Checkbox 3'),
            value: _checkbox3,
            onChanged: (bool? value) {
              setState(() {
                _checkbox3 = value ?? false;
              });
            },
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<User>(
            initialValue: _selectedUser,
            decoration: const InputDecoration(labelText: 'Select User'),
            items: widget.userList.map<DropdownMenuItem<User>>((User user) {
              return DropdownMenuItem<User>(
                value: user,
                child: Text(user.fullName),
              );
            }).toList(),
            onChanged: (User? newValue) {
              setState(() {
                _selectedUser = newValue;
              });
            },
            validator: (value) =>
            value == null ? 'Please select a user' : null,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Save and Print to Console'),
          ),
        ],
      ),
    );
  }
}