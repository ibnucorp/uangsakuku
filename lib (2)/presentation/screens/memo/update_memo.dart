import 'package:flutter/material.dart';

class UpdateMemo extends StatelessWidget {
  final String memoId;
  const UpdateMemo({
    super.key,
    required this.memoId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    return const Placeholder();
  }
}
