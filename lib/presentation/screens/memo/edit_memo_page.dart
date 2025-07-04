import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uangsakuku/models/memo_model.dart';
import 'package:uangsakuku/services/auth_service.dart';
import 'package:uangsakuku/services/category_service.dart';
import 'package:uangsakuku/services/memo_service.dart';

class EditMemoPage extends StatefulWidget {
  final Memo memo;
  final String memoId;
  const EditMemoPage({super.key, required this.memo, required this.memoId});

  @override
  State<EditMemoPage> createState() => _EditMemoState();
}

class _EditMemoState extends State<EditMemoPage> {
  final MemoService memoService = MemoService();
  final CategoryService categoryService = CategoryService();
  final Auth auth = Auth();

  late final _descController = TextEditingController();
  late final _amountController = TextEditingController();
  late bool isIncome = true;
  String? _selectedCategory;

  void initState() {
    super.initState();
    // mengambil data produk yang dikirim untuk mengisi formnya
    _descController.text = widget.memo.description;
    _amountController.text = widget.memo.amount.toString();
    isIncome = widget.memo.isIncome;
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Memo"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _categoryDropdown(),
            SwitchListTile(
              title: Text("Is Income"),
              value: isIncome,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = null;
                  isIncome = value;
                });
              },
            ),
            Spacer(),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    if (_selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a category')),
                      );
                      return;
                    }
                    memoService.updateMemo(
                        widget.memoId,
                        widget.memo.copyWith(
                          description: _descController.text,
                          amount: double.parse(_amountController.text),
                          isIncome: isIncome,
                          category: _selectedCategory,
                          updatedAt: Timestamp.now(),
                        ));
                    Navigator.pop(context);
                  },
                  child: Text("Save")),
            )
          ],
        ),
      ),
    );
  }

  Widget _categoryDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryService.getCategoriesByType(isIncome),
      builder: (context, snapshot) {
        // Kondisi jika gagal
        if (snapshot.hasError) {
          print(snapshot.error);
          return InputDecorator(
            decoration: InputDecoration(
              labelText: "Category",
              errorText: 'Failed to load categories',
              border: OutlineInputBorder(),
            ),
            child: const Text('Try again later',
                style: TextStyle(color: Colors.red)),
          );
        }

        // Kondisi jika loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const InputDecorator(
            decoration: InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
            ),
            child: SizedBox(
              height: 20,
              width: 20,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          );
        }

        // Jika ada data, maka akan mengisi list kategori
        List<DropdownMenuItem<String>> categoryItems = [];
        if (snapshot.hasData) {
          final categories = snapshot.data!.docs;
          for (var category in categories) {
            categoryItems.add(
              DropdownMenuItem<String>(
                value: category['name'],
                child: Text(category['name']),
              ),
            );
          }
        }

        // Tombol dropdown nya
        return DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(labelText: "Category"),
          items: categoryItems,
          onChanged: (String? value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          hint: Text('Select a category'),
        );
      },
    );
  }
}
