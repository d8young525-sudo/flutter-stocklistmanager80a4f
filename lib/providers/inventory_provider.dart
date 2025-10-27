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

  // 필터링된 아이템 목록 (개선된 검색 로직)
  List<InventoryItem> get filteredItems {
    List<InventoryItem> filtered = _items.values.toList();

    // 검색어 필터 (개선: 모델명, 연식, 색상, 트림 모두 검색)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      
      filtered = filtered.where((item) {
        final model = item.model.toLowerCase();
        final my = item.my.toLowerCase();
        final color = item.color.toLowerCase();
        final trim = item.trim.toLowerCase();
        
        // 모델명, 연식, 색상, 트림 중 하나라도 일치하면 포함
        return model.contains(query) || 
               my.contains(query) || 
               color.contains(query) || 
               trim.contains(query);
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

  // 검색어 설정 (디버깅 로그 추가)
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (kDebugMode) {
      print('🔍 검색어 설정: "$query"');
      print('📊 전체 아이템: ${_items.length}개');
    }
    notifyListeners();
    if (kDebugMode) {
      print('✅ 필터링 결과: ${filteredItems.length}개');
    }
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
