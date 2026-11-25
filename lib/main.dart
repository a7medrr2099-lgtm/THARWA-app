
import 'package:flutter/material.dart';

void main() {
  runApp(const TharwaApp());
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
          seedColor: const Color(0xFF287A55),
        ),
        fontFamily: 'Arial',
      ),
      home: const HomePage(),
    );
  }
}

class Animal {
  String number;
  String type;
  String sex;
  String notes;

  Animal({
    required this.number,
    required this.type,
    required this.sex,
    required this.notes,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Animal> animals = [];
  int selectedIndex = 0;

  int getCount(String type) =>
      animals.where((animal) => animal.type == type).length;

  void addAnimal() {
    final numberController = TextEditingController();
    final notesController = TextEditingController();
    String type = 'أغنام';
    String sex = 'ذكر';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إضافة حيوان جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الحيوان أو الوسم',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(
                    labelText: 'نوع الحيوان',
                    border: OutlineInputBorder(),
                  ),
                  items: ['أغنام', 'ماعز', 'إبل']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => type = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: sex,
                  decoration: const InputDecoration(
                    labelText: 'الجنس',
                    border: OutlineInputBorder(),
                  ),
                  items: ['ذكر', 'أنثى']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => sex = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () {
                final number = numberController.text.trim();
                if (number.isEmpty) return;

                setState(() {
                  animals.add(Animal(
                    number: number,
                    type: type,
                    sex: sex,
                    notes: notesController.text.trim(),
                  ));
                });

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('تمت إضافة الحيوان')),
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, int count, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget dashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'مرحباً بك في ثروة',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        const Text('إدارة مزرعتك وحيواناتك بسهولة'),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            statCard('إجمالي الحيوانات', animals.length, Icons.pets),
            statCard('الأغنام', getCount('أغنام'), Icons.agriculture),
            statCard('الماعز', getCount('ماعز'), Icons.pets),
            statCard('الإبل', getCount('إبل'), Icons.landscape),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.green),
            title: const Text('إضافة حيوان جديد'),
            subtitle: const Text('تسجيل حيوان في سجلات المزرعة'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: addAnimal,
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('سجل الحيوانات'),
            subtitle: Text('عدد الحيوانات المسجلة: ${animals.length}'),
            onTap: () => setState(() => selectedIndex = 1),
          ),
        ),
      ],
    );
  }

  Widget animalList() {
    if (animals.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pets, size: 65, color: Colors.grey),
            SizedBox(height: 12),
            Text('لا توجد حيوانات مسجلة حتى الآن'),
            Text('اضغط + لإضافة أول حيوان'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.pets),
            ),
            title: Text('${animal.type} - ${animal.number}'),
            subtitle: Text(
              '${animal.sex}  ${animal.notes.isEmpty ? "" : "• ${animal.notes}"}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                setState(() => animals.removeAt(index));
              },
            ),
          ),
        );
      },
    );
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
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: selectedIndex == 0 ? dashboard() : animalList(),
        floatingActionButton: FloatingActionButton(
          onPressed: addAnimal,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.pets_outlined),
              selectedIcon: Icon(Icons.pets),
              label: 'الحيوانات',
            ),
          ],
        ),
      ),
    );
  }
}
