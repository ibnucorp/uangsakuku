import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangsakuku/models/memo_model.dart';
import 'package:uangsakuku/services/auth_service.dart';
import 'package:uangsakuku/services/category_service.dart';
import 'package:uangsakuku/services/memo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MemoService memoService = MemoService();
  final CategoryService categoryService = CategoryService();
  final Auth auth = Auth();

  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.authStatechanges, // ✅ Gunakan auth state listener
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("User belum login."));
        }

        final uid = snapshot.data!.uid;
        return SafeArea(
          child: Column(
            children: [
              Expanded(child: _memoListView(uid)), // ✅ Kirim uid
            ],
          ),
        );
      },
    );
  }

  Widget _balanceOverview(double incomeAmount, double outcomeAmount) {
    double saldoAkhir = incomeAmount - outcomeAmount;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pemasukan"),
                Text(
                  "+ $incomeAmount",
                  style: const TextStyle(color: Colors.green),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Pengeluaran"),
                Text(
                  "- $outcomeAmount",
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Saldo Akhir"), Text("$saldoAkhir")],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Terima uid sebagai parameter
  Widget _memoListView(String uid) {
    return StreamBuilder<QuerySnapshot<Memo>>(
      stream: memoService.getMemos(), // ✅ Tidak perlu getMemosByUid karena getMemos sudah berdasarkan currentUser
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final memos = snapshot.data?.docs ?? [];
        if (memos.isEmpty) {
          return const Center(child: Text("Belum ada memo."));
        }

        double incomeAmount = 0;
        double outcomeAmount = 0;

        for (var memo in memos) {
          Memo memoData = memo.data();
          if (memoData.isIncome) {
            incomeAmount += memoData.amount;
          } else {
            outcomeAmount += memoData.amount;
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
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: ListTile(
                      tileColor: Colors.white,
                      title: Text(DateFormat("E, d MMMM y - HH:mm").format(memo.transactionDate.toDate())),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(memo.description),
                          Text(
                            "${memo.isIncome ? "+" : "-"} ${memo.amount}",
                            style: TextStyle(
                              color: memo.isIncome ? Colors.green : Colors.red,
                            ),
                          ),
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
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _displayEditDialog(BuildContext context, Memo memo, String memoId) {
    final _descController = TextEditingController(text: memo.description);
    final _amountController = TextEditingController(text: memo.amount.toString());
    bool isIncome = memo.isIncome;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Memo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                ),
                _categoryDropdown(),
                SwitchListTile(
                  title: const Text("Is Income"),
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
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final uid = auth.currentUser?.uid;
                  if (uid != null) {
                    memoService.updateMemo(
                      memoId,
                      Memo(
                        description: _descController.text,
                        amount: double.parse(_amountController.text),
                        isIncome: isIncome,
                        category: _selectedCategory ?? memo.category,
                        transactionDate: memo.transactionDate,
                        createdAt: memo.createdAt,
                        updatedAt: Timestamp.now(),
                        uid: uid,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _categoryDropdown() {
    final uid = auth.currentUser?.uid;
    if (uid == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: categoryService.getCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
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
          decoration: const InputDecoration(labelText: "Category"),
          items: categoryItems,
          onChanged: (String? value) {
            setState(() {
              _selectedCategory = value;
            });
          },
          hint: const Text('Select a category'),
        );
      },
    );
  }
}
