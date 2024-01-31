// MultiSelect.dart
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:yjg/theme/pallete.dart';

class MultiSelect extends StatefulWidget {
  final Function(List<String>) onSelectionChanged;

  const MultiSelect({Key? key, required this.onSelectionChanged})
      : super(key: key);

  @override
  _MultiSelectState createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  List<String> items = ['커트', '펌', '염색'];
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: MultiSelectDialogField(
        backgroundColor: Pallete.backgroundColor,
        title: Text('태그 선택',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        searchHint: '태그를 검색하세요',
        confirmText: Text(
          '확인',
          style: TextStyle(color: Pallete.textColor),
        ),
        cancelText: Text(
          '취소',
          style: TextStyle(color: Pallete.stateColor3),
        ),
        searchable: true,
        selectedItemsTextStyle:
            TextStyle(color: Pallete.textColor, fontWeight: FontWeight.bold),
        items:
            items.map((item) => MultiSelectItem<String>(item, item)).toList(),
        listType: MultiSelectListType.CHIP,
        selectedColor: Pallete.mainColor.withOpacity(0.3),
        buttonText: Text('Pilih Item'),
        onConfirm: (values) {
          setState(() {
            selectedItems = values.cast<String>();
          });
          widget.onSelectionChanged(selectedItems);
        },
      ),
    );
  }
}



