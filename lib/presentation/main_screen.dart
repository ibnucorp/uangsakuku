import 'package:flutter/material.dart';
import 'package:uangsakuku/models/category_model.dart';
import 'package:uangsakuku/presentation/screens/category_list_screen.dart';
import 'package:uangsakuku/presentation/screens/home_screen.dart';
import 'package:uangsakuku/presentation/screens/memo/add_memo_page.dart';
import 'package:uangsakuku/presentation/screens/settings_screen.dart';
import 'package:uangsakuku/services/auth_service.dart';
import 'package:uangsakuku/services/category_service.dart';
import 'package:uangsakuku/services/memo_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MemoService memoService = MemoService();
  final CategoryService categoryService = CategoryService();
  // untuk index bottom nav bar
  int _currentIndex = 0;

  // link untuk ke halaman
  final List<Widget> _pages = [
    HomeScreen(),
    CategoryListScreen(),
    SettingsScreen()
  ];

  // Judul untuk app bar
  final List<String> _titles = ["Transaksi", "Kategori", "Pengaturan"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(_titles[_currentIndex]),
      backgroundColor: Colors.grey[200],
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _currentIndex == 0
              ? _showAddMemoPage(context)
              : _showAddCategoryDialog(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
                _currentIndex = index;
              }),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Category"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ]),
    );
  }

  PreferredSizeWidget _appBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  void _showAddMemoPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMemoPage()),
    );
  }

  void _showAddCategoryDialog(
    BuildContext context,
  ) {
    final _nameController = TextEditingController();
    bool isIncome = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Add Category"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Category Name"),
                ),
                SwitchListTile(
                    title: Text("Is Income"),
                    value: isIncome,
                    onChanged: (value) {
                      setState(() {
                        isIncome = value;
                      });
                    }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final String? uid = Auth().currentUser?.uid;
                  if (uid != null) {
                    categoryService.addCategory(Category(
                        uid: uid,
                        name: _nameController.text,
                        isIncome: isIncome));
                  }
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          );
        });
      },
    );
  }
}
