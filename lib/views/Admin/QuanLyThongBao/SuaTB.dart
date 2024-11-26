import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/models/ThongBao.dart';

class EditNotificationDialog extends StatefulWidget {
  final ThongBao thongBao;
  final Function(ThongBao) onSave;

  const EditNotificationDialog({Key? key, required this.thongBao, required this.onSave}) : super(key: key);

  @override
  _EditNotificationDialogState createState() => _EditNotificationDialogState();
}

class _EditNotificationDialogState extends State<EditNotificationDialog> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: utf8.decode (widget.thongBao.noiDung.runes.toList()));
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sửa thông báo'),
      content: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: 'Nội dung thông báo',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Hủy'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Lưu'),
          onPressed: () {
            final updatedThongBao = ThongBao(
              maTB: widget.thongBao.maTB,
              noiDung: _descriptionController.text,
              ngayTB: widget.thongBao.ngayTB,
            );
            widget.onSave(updatedThongBao);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

