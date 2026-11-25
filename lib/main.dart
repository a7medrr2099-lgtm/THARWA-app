
import 'package:flutter/material.dart';

void main() {
  runApp(const TharwaApp());
}

class Animal {
  final String number;
  final String type;
  final String sex;
  final String breed;
  final String birthDate;
  final String weight;
  final String health;
  final String source;
  final String price;
  final String notes;

  Animal({
    required this.number,
    required this.type,
    required this.sex,
    required this.breed,
    required this.birthDate,
    required this.weight,
    required this.health,
    required this.source,
    required this.price,
    required this.notes,
  });
}

class TharwaApp extends StatelessWidget {
  const TharwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ثروة',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38A96B),
        ),
        fontFamily: 'Arial',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Animal> animals = [];

  Future<void> addAnimal() async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddAnimalPage(),
      ),
    );

    if (animal != null) {
      setState(() => animals.add(animal));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ثروة | THARWA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFA8EFC7),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addAnimal,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مرحباً بك في ثروة',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('إدارة مزرعتك وحيواناتك بسهولة'),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.pets,
                    color: Colors.green,
                    size: 35,
                  ),
                  title: const Text('إجمالي الحيوانات'),
                  trailing: Text(
                    '${animals.length}',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'سجل الحيوانات',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: animals.isEmpty
                    ? const Center(
                        child: Text('لا توجد حيوانات مسجلة'),
                      )
                    : ListView.builder(
                        itemCount: animals.length,
                        itemBuilder: (context, index) {
                          final animal = animals[index];
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.pets),
                              ),
                              title: Text(
                                '${animal.type} - ${animal.number}',
                              ),
                              subtitle: Text(
                                '${animal.sex} | ${animal.weight.isEmpty ? "الوزن غير مسجل" : animal.weight + " كجم"}',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AnimalDetailsPage(
                                      animal: animal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddAnimalPage extends StatefulWidget {
  const AddAnimalPage({super.key});

  @override
  State<AddAnimalPage> createState() => _AddAnimalPageState();
}

class _AddAnimalPageState extends State<AddAnimalPage> {
  final number = TextEditingController();
  final breed = TextEditingController();
  final birthDate = TextEditingController();
  final weight = TextEditingController();
  final source = TextEditingController();
  final price = TextEditingController();
  final notes = TextEditingController();

  String type = 'أغنام';
  String sex = 'ذكر';
  String health = 'سليم';

  @override
  void dispose() {
    number.dispose();
    breed.dispose();
    birthDate.dispose();
    weight.dispose();
    source.dispose();
    price.dispose();
    notes.dispose();
    super.dispose();
  }

  Widget field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget dropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  void save() {
    if (number.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل رقم الحيوان أولاً')),
      );
      return;
    }

    Navigator.pop(
      context,
      Animal(
        number: number.text.trim(),
        type: type,
        sex: sex,
        breed: breed.text,
        birthDate: birthDate.text,
        weight: weight.text,
        health: health,
        source: source.text,
        price: price.text,
        notes: notes.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('إضافة حيوان جديد')),
        body: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            field('رقم الحيوان أو الوسم *', number),
            dropdown(
              'نوع الحيوان',
              type,
              ['أغنام', 'ماعز', 'إبل'],
              (v) => setState(() => type = v!),
            ),
            dropdown(
              'الجنس',
              sex,
              ['ذكر', 'أنثى'],
              (v) => setState(() => sex = v!),
            ),
            field('السلالة', breed),
            field('تاريخ الميلاد أو العمر', birthDate),
            field(
              'الوزن بالكيلوجرام',
              weight,
              keyboard: TextInputType.number,
            ),
            dropdown(
              'الحالة الصحية',
              health,
              ['سليم', 'مريض', 'حامل', 'مباع', 'نافق'],
              (v) => setState(() => health = v!),
            ),
            field('مصدر الحيوان أو البائع', source),
            field(
              'سعر الشراء',
              price,
              keyboard: TextInputType.number,
            ),
            field('ملاحظات', notes),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('حفظ الحيوان'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalDetailsPage extends StatelessWidget {
  final Animal animal;

  const AnimalDetailsPage({
    super.key,
    required this.animal,
  });

  Widget info(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Text(value.isEmpty ? 'غير مسجل' : value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الحيوان')),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            info('رقم الحيوان', animal.number),
            info('النوع', animal.type),
            info('الجنس', animal.sex),
            info('السلالة', animal.breed),
            info('تاريخ الميلاد أو العمر', animal.birthDate),
            info('الوزن بالكيلوجرام', animal.weight),
            info('الحالة الصحية', animal.health),
            info('مصدر الحيوان', animal.source),
            info('سعر الشراء', animal.price),
            info('الملاحظات', animal.notes),
          ],
        ),
      ),
    );
  }
}
