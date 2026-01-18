import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class Item {
  final int id;
  String name;
  Item({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Item.fromJson(Map<String, dynamic> json) => Item(id: json['id'], name: json['name']);
}

class InventoryEntry {
  final DateTime date;
  final int itemId;
  final String itemName;
  final int quantity;
  InventoryEntry({required this.date, required this.itemId, required this.itemName, required this.quantity});

  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'itemId': itemId, 'itemName': itemName, 'quantity': quantity};
  factory InventoryEntry.fromJson(Map<String, dynamic> json) => InventoryEntry(
        date: DateTime.parse(json['date']),
        itemId: json['itemId'],
        itemName: json['itemName'],
        quantity: json['quantity'],
      );
}

// マスタデータ
List<Item> masterItems = [];

// 在庫データ
List<InventoryEntry> inventoryEntries = [];

int _nextItemId = 1;

int getNextItemId() => _nextItemId++;

// データ読み込み関数
Future<void> loadData() async {
  try {
    // assetsからCSVを読み込み
    final csvString = await rootBundle.loadString('assets/data.csv');
    final csvData = const CsvToListConverter().convert(csvString);

    masterItems.clear();
    inventoryEntries.clear();

    for (var row in csvData) {
      if (row[0] == 'master' && row.length >= 3) {
        masterItems.add(Item(id: int.parse(row[1]), name: row[2]));
      } else if (row[0] == 'inventory' && row.length >= 5) {
        inventoryEntries.add(InventoryEntry(
          date: DateTime.parse(row[1]),
          itemId: int.parse(row[2]),
          itemName: row[3],
          quantity: int.parse(row[4]),
        ));
      } else if (row[0] == 'config' && row[1] == 'nextItemId' && row.length >= 3) {
        _nextItemId = int.parse(row[2]);
      }
    }
  } catch (e) {
    // エラーの場合は初期データをそのまま使う
  }
}