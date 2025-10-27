import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isLoaded = false;

  // Getters
  Map<String, InventoryItem> get items => _items;
  String? get inventoryFileName => _inventoryFileName;
  String? get inventoryFileDate => _inventoryFileDate;
  String? get shipmentFileName => _shipmentFileName;
  String? get priceFileName => _priceFileName;
  bool get showOnlyAvailable => _showOnlyAvailable;
  String get searchQuery => _searchQuery;
  // 필터링된 아이템 목록 (모델명 검색만)
  List<InventoryItem> get filteredItems {
    List<InventoryItem> filtered = _items.values.toList();

    // 검색어 필터 (모델명만 검색)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      
      filtered = filtered.where((item) {
        return item.model.toLowerCase().contains(query);
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

  // 🔄 앱 시작 시 저장된 데이터 불러오기
  Future<void> loadSavedData() async {
    if (_isLoaded) return; // 이미 로드됨
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 파일명 불러오기
      _inventoryFileName = prefs.getString('inventory_file_name');
      _inventoryFileDate = prefs.getString('inventory_file_date');
      _shipmentFileName = prefs.getString('shipment_file_name');
      _priceFileName = prefs.getString('price_file_name');
      
      // 아이템 데이터 불러오기
      final itemsJson = prefs.getString('inventory_items');
      if (itemsJson != null) {
        final Map<String, dynamic> decoded = json.decode(itemsJson);
        _items = decoded.map((key, value) => MapEntry(
          key,
          InventoryItem.fromJson(value),
        ));
        
        debugPrint('✅ 저장된 데이터 로드 완료: ${_items.length}개 아이템');
      }
      
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ 데이터 로드 실패: $e');
      _isLoaded = true; // 실패해도 다시 시도하지 않음
    }
  }

  // 💾 데이터 저장하기
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 파일명 저장
      if (_inventoryFileName != null) {
        await prefs.setString('inventory_file_name', _inventoryFileName!);
      }
      if (_inventoryFileDate != null) {
        await prefs.setString('inventory_file_date', _inventoryFileDate!);
      }
      if (_shipmentFileName != null) {
        await prefs.setString('shipment_file_name', _shipmentFileName!);
      }
      if (_priceFileName != null) {
        await prefs.setString('price_file_name', _priceFileName!);
      }
      
      // 아이템 데이터 저장 (JSON 형식)
      final itemsMap = _items.map((key, value) => MapEntry(key, value.toJson()));
      await prefs.setString('inventory_items', json.encode(itemsMap));
      
      debugPrint('💾 데이터 저장 완료: ${_items.length}개 아이템');
    } catch (e) {
      debugPrint('⚠️ 데이터 저장 실패: $e');
    }
  }

  // 재고현황표 업로드
  Future<void> uploadInventoryFile(Uint8List bytes, String fileName) async {
    try {
      _items = await _excelService.parseInventoryFile(bytes, _items);
      _inventoryFileName = fileName;
      _inventoryFileDate = _excelService.extractDateFromFilename(fileName);
      await _saveData(); // 데이터 저장
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
      await _saveData(); // 데이터 저장
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
      await _saveData(); // 데이터 저장
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
  Future<void> clearAllData() async {
    _items.clear();
    _inventoryFileName = null;
    _inventoryFileDate = null;
    _shipmentFileName = null;
    _priceFileName = null;
    _searchQuery = '';
    _showOnlyAvailable = false;
    
    // SharedPreferences에서도 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('inventory_file_name');
    await prefs.remove('inventory_file_date');
    await prefs.remove('shipment_file_name');
    await prefs.remove('price_file_name');
    await prefs.remove('inventory_items');
    
    notifyListeners();
  }
}
