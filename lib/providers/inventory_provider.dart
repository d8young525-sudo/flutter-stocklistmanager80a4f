import 'package:flutter/foundation.dart';
import '../models/inventory_item.dart';
import '../services/excel_service.dart';

class InventoryProvider with ChangeNotifier {
  final ExcelService _excelService = ExcelService();
  
  Map<String, InventoryItem> _items = {};
  String? _inventoryFileName;
  String? _inventoryFileDate;
  String? _shipmentFileName;
  String? _priceFileName;
  
  bool _showOnlyAvailable = false;
  String _searchQuery = '';

  // Getters
  Map<String, InventoryItem> get items => _items;
  String? get inventoryFileName => _inventoryFileName;
  String? get inventoryFileDate => _inventoryFileDate;
  String? get shipmentFileName => _shipmentFileName;
  String? get priceFileName => _priceFileName;
  bool get showOnlyAvailable => _showOnlyAvailable;
  String get searchQuery => _searchQuery;

  // 필터링된 아이템 목록
  List<InventoryItem> get filteredItems {
    List<InventoryItem> filtered = _items.values.toList();

    // 검색어 필터
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.model.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 현재미계약 재고 필터
    if (_showOnlyAvailable) {
      filtered = filtered.where((item) {
        return (item.allocationAvailable > 0 || item.onlineAvailable > 0);
      }).toList();
    }

    // 모델명으로 정렬
    filtered.sort((a, b) => a.model.compareTo(b.model));

    return filtered;
  }

  // 모델명 자동완성 목록
  List<String> get modelNames {
    Set<String> models = {};
    for (var item in _items.values) {
      models.add(item.model);
    }
    return models.toList()..sort();
  }

  // 재고현황표 업로드
  Future<void> uploadInventoryFile(Uint8List bytes, String fileName) async {
    try {
      _items = await _excelService.parseInventoryFile(bytes, _items);
      _inventoryFileName = fileName;
      _inventoryFileDate = _excelService.extractDateFromFilename(fileName);
      notifyListeners();
    } catch (e) {
      throw Exception('재고현황표 업로드 실패: $e');
    }
  }

  // 입항일정표 업로드
  Future<void> uploadShipmentFile(Uint8List bytes, String fileName) async {
    try {
      _items = await _excelService.parseShipmentFile(bytes, _items);
      _shipmentFileName = fileName;
      notifyListeners();
    } catch (e) {
      throw Exception('입항일정표 업로드 실패: $e');
    }
  }

  // 가격표 업로드
  Future<void> uploadPriceFile(Uint8List bytes, String fileName) async {
    try {
      _items = await _excelService.parsePriceFile(bytes, _items);
      _priceFileName = fileName;
      notifyListeners();
    } catch (e) {
      throw Exception('가격표 업로드 실패: $e');
    }
  }

  // 검색어 설정
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // 현재미계약 필터 토글
  void toggleAvailableFilter() {
    _showOnlyAvailable = !_showOnlyAvailable;
    notifyListeners();
  }

  // 모든 데이터 초기화
  void clearAllData() {
    _items.clear();
    _inventoryFileName = null;
    _inventoryFileDate = null;
    _shipmentFileName = null;
    _priceFileName = null;
    _searchQuery = '';
    _showOnlyAvailable = false;
    notifyListeners();
  }
}
