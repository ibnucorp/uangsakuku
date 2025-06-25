import 'package:flutter/material.dart';
import 'package:uangsakuku/models/category_model.dart';
import 'package:uangsakuku/services/auth_service.dart'; //  Tambahkan ini
import 'package:uangsakuku/services/category_service.dart';

class CategoryListScreen extends StatelessWidget {
  CategoryListScreen({super.key});
  final CategoryService categoryService = CategoryService();
  final Auth auth = Auth(); //  Tambahkan ini

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [Expanded(child: _categoryListView())],
      ),
    );
  }

  Widget _categoryListView() {
    final uid = auth.currentUser?.uid; //  Ambil UID user login
    if (uid == null) {
      return Center(child: Text("User belum login."));
    }

    return StreamBuilder(
      stream: categoryService.getCategories(), //  Gunakan get by UID
      builder: (context, snapshot) {
        List categories = snapshot.data?.docs ?? [];
        if (categories.isEmpty) {
          return Center(child: Text("Tambahkan kategori."));
        }

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            Category category = categories[index].data();
            String categoryId = categories[index].id;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListTile(
                tileColor: Colors.white,
                title: Text(category.name),
                subtitle:
                    Text(category.isIncome ? "Pemasukan" : "Pengeluaran"),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _displayEditDialog(context, category, categoryId);
                    } else if (value == 'delete') {
                      categoryService.deleteCategory(categoryId);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _displayEditDialog(
      BuildContext context, Category category, String categoryId) {
    final _nameController = TextEditingController(text: category.name);
    bool isIncome = category.isIncome;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Category"),
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
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final uid = auth.currentUser?.uid;
                  if (uid != null) {
                    categoryService.updateCategory(
                      categoryId,
                      Category(
                        name: _nameController.text,
                        isIncome: isIncome,
                        uid: uid, //  Tambahkan UID ke data
                      ),
                    );
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
