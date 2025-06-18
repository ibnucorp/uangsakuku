import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uangsakuku/models/category_model.dart';
import 'package:uangsakuku/models/memo_model.dart';
import 'package:uangsakuku/presentation/screens/category_list_screen.dart';
import 'package:uangsakuku/presentation/screens/home_screen.dart';
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
  final List<Widget> _pages = [HomeScreen(), CategoryListScreen()];

  // Judul untuk app bar
  final List<String> _titles = ["Transaksi", "Kategori"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(_titles[_currentIndex]),
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _currentIndex == 0
              ? _showAddMemoDialog(context)
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
                icon: Icon(Icons.category), label: "Category")
          ]),
    );
  }

  PreferredSizeWidget _appBar(String title) {
    return AppBar(
      title: Text(title),
    );
  }

  void _showAddMemoDialog(
    BuildContext context,
  ) {
    final _descController = TextEditingController();
    final _categoryController = TextEditingController();
    final _amountController = TextEditingController();
    bool isIncome = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Add Memo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: "Category"),
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
                  memoService.addMemo(
                    Memo(
                        description: _descController.text,
                        amount: double.parse(_amountController.text),
                        isIncome: isIncome,
                        category: _categoryController.text,
                        transactionDate: Timestamp.now(),
                        createdAt: Timestamp.now(),
                        updatedAt: Timestamp.now()),
                  );
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
                  categoryService.addCategory(
                      Category(name: _nameController.text, isIncome: isIncome));
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
