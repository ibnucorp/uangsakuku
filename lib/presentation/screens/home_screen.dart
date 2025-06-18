import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uangsakuku/models/memo_model.dart';
import 'package:uangsakuku/services/memo_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final MemoService memoService = MemoService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [Expanded(child: _memoListView())],
    ));
  }

  Widget _memoListView() {
    return StreamBuilder(
        stream: memoService.getMemos(),
        builder: (context, snapshot) {
          List memos = snapshot.data?.docs ?? [];
          if (memos.isEmpty) {
            return Text("Add a memo");
          }
          return ListView.builder(
              itemCount: memos.length,
              itemBuilder: (context, index) {
                Memo memo = memos[index].data();
                String memoId = memos[index].id;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text(DateFormat(
                      "EEE, d/MM/y h:mm",
                    ).format(memo.transactionDate.toDate())),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${memo.description}"),
                        Text(
                          "${memo.isIncome ? "+" : "-"} ${memo.amount}",
                          style: TextStyle(
                              color: memo.isIncome ? Colors.green : Colors.red),
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
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              });
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
}
