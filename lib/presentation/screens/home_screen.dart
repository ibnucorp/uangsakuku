import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangsakuku/models/memo_model.dart';
import 'package:uangsakuku/services/category_service.dart';
import 'package:uangsakuku/services/memo_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MemoService memoService = MemoService();
  final CategoryService categoryService = CategoryService();

  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [Expanded(child: _memoListView())],
    ));
  }

  Widget _balanceOverview(double incomeAmount, double outcomeAmount) {
    double? saldoAkhir = incomeAmount - outcomeAmount;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, border: Border.all(color: Colors.black)),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Pemasukan"),
                Text(
                  "+ ${incomeAmount}",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Pengeluaran"),
                Text(
                  "- ${outcomeAmount}",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Saldo Akhir"), Text("${saldoAkhir}")],
            ),
          ],
        ),
      ),
    );
  }

  Widget _memoListView() {
    return StreamBuilder(
        stream: memoService.getMemos(),
        builder: (context, snapshot) {
          List memos = snapshot.data?.docs ?? [];
          if (memos.isEmpty) {
            return Text("Add a memo");
          }
          // Untuk ringkasan saldo
          double incomeAmount = 0;
          double outcomeAmount = 0;

          // Untuk mengambil nilai saldo berdasarkan isIncome dari tiap memo
          for (var memo in memos) {
            Memo memoData = memo.data();
            double amount = memoData.amount;
            bool isIncome = memoData.isIncome;

            if (isIncome) {
              incomeAmount += amount;
            } else {
              outcomeAmount += amount;
            }
          }
          return Column(
            children: [
              _balanceOverview(incomeAmount, outcomeAmount),
              Expanded(
                child: ListView.builder(
                    itemCount: memos.length,
                    itemBuilder: (context, index) {
                      Memo memo = memos[index].data();
                      String memoId = memos[index].id;
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: ListTile(
                          tileColor: Colors.white,
                          title: Text(DateFormat(
                            "E, d MMMM y - HH:mm",
                          ).format(memo.transactionDate.toDate())),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${memo.description}"),
                              Text(
                                "${memo.isIncome ? "+" : "-"} ${memo.amount}",
                                style: TextStyle(
                                    color: memo.isIncome
                                        ? Colors.green
                                        : Colors.red),
                              )
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _displayEditDialog(context, memo, memoId);
                              } else if (value == 'delete') {
                                memoService.deleteMemo(memoId);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 'edit', child: Text('Edit')),
                              PopupMenuItem(
                                  value: 'delete', child: Text('Delete')),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          );
        });
  }

  void _displayEditDialog(BuildContext context, Memo memo, String memoId) {
    final _descController = TextEditingController(text: memo.description);
    final _categoryController = TextEditingController(text: memo.category);
    final _amountController =
        TextEditingController(text: memo.amount.toString());
    bool isIncome = memo.isIncome;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Edit Memo"),
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
                _categoryDropdown(),
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  memoService.updateMemo(
                    memoId,
                    Memo(
                        description: _descController.text,
                        amount: double.parse(_amountController.text),
                        isIncome: isIncome,
                        category: _categoryController.text,
                        transactionDate: memo.transactionDate,
                        createdAt: memo.createdAt,
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

  Widget _categoryDropdown() {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

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
