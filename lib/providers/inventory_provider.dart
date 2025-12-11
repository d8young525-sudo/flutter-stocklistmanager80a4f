import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/inventory_item.dart';
import '../services/excel_service.dart';
import '../services/auth_service.dart';

class InventoryProvider with ChangeNotifier {
  final ExcelService _excelService = ExcelService();
  final AuthService _authService = AuthService();
  
  Map<String, InventoryItem> _items = {};
  String? _inventoryFileName;
  String? _inventoryFileDate;
  String? _shipmentFileName;
  String? _priceFileName;
  
  bool _showOnlyAvailable = false;
  String _searchQuery = '';
  bool _isLoaded = false;
  
  // 색상/트림 필터
  Set<String> _selectedColorCodes = {};
  Set<String> _selectedTrimCodes = {};
  
  // 카드 레이아웃 (true: 세로형, false: 가로형)
  bool _isVerticalLayout = false;

  // Getters
  Map<String, InventoryItem> get items => _items;
  String? get inventoryFileName => _inventoryFileName;
  String? get inventoryFileDate => _inventoryFileDate;
  String? get shipmentFileName => _shipmentFileName;
  String? get priceFileName => _priceFileName;
  bool get showOnlyAvailable => _showOnlyAvailable;
  String get searchQuery => _searchQuery;
  Set<String> get selectedColorCodes => _selectedColorCodes;
  Set<String> get selectedTrimCodes => _selectedTrimCodes;
  bool get isVerticalLayout => _isVerticalLayout;
  // 필터링된 아이템 목록 (모델명 검색 + 색상/트림 필터)
  List<InventoryItem> get filteredItems {
    List<InventoryItem> filtered = _items.values.toList();

    // 검색어 필터 (모델명만 검색)
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      
      filtered = filtered.where((item) {
        return item.model.toLowerCase().contains(query);
      }).toList();
    }

    // 색상 코드 필터
    if (_selectedColorCodes.isNotEmpty) {
      filtered = filtered.where((item) {
        return _selectedColorCodes.contains(item.color);
      }).toList();
    }

    // 트림 코드 필터
    if (_selectedTrimCodes.isNotEmpty) {
      filtered = filtered.where((item) {
        return _selectedTrimCodes.contains(item.trim);
      }).toList();
    }

    // 현재미계약 재고 필터
    if (_showOnlyAvailable) {
      filtered = filtered.where((item) {
        return (item.allocationAvailable > 0 || item.onlineAvailable > 0);
      }).toList();
    }

    // 1차 정렬: 모델명, 2차 정렬: 외장색상 코드 오름차순
    filtered.sort((a, b) {
      // 1차: 모델명으로 정렬
      int modelCompare = a.model.compareTo(b.model);
      if (modelCompare != 0) return modelCompare;
      
      // 2차: 외장색상 코드를 숫자로 변환해서 정렬
      int colorA = int.tryParse(a.color) ?? 0;
      int colorB = int.tryParse(b.color) ?? 0;
      return colorA.compareTo(colorB);
    });

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

  // 현재 검색 결과에서 사용 가능한 색상 코드 목록 (개수 포함)
  Map<String, int> getAvailableColorCodes() {
    // 검색어만 적용한 아이템 목록
    List<InventoryItem> searchFiltered = _items.values.toList();
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      searchFiltered = searchFiltered.where((item) {
        return item.model.toLowerCase().contains(query);
      }).toList();
    }
    
    // 색상 코드별 개수 집계
    Map<String, int> colorCounts = {};
    for (var item in searchFiltered) {
      colorCounts[item.color] = (colorCounts[item.color] ?? 0) + 1;
    }
    
    return colorCounts;
  }

  // 현재 검색 결과에서 사용 가능한 트림 코드 목록 (개수 포함)
  Map<String, int> getAvailableTrimCodes() {
    // 검색어와 색상 필터만 적용한 아이템 목록
    List<InventoryItem> searchFiltered = _items.values.toList();
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      searchFiltered = searchFiltered.where((item) {
        return item.model.toLowerCase().contains(query);
      }).toList();
    }
    
    if (_selectedColorCodes.isNotEmpty) {
      searchFiltered = searchFiltered.where((item) {
        return _selectedColorCodes.contains(item.color);
      }).toList();
    }
    
    // 트림 코드별 개수 집계
    Map<String, int> trimCounts = {};
    for (var item in searchFiltered) {
      trimCounts[item.trim] = (trimCounts[item.trim] ?? 0) + 1;
    }
    
    return trimCounts;
  }

  // 사용자별 저장 키 생성
  String _getUserKey(String baseKey) {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return baseKey; // 로그인 안 됐으면 기본 키
    return '${baseKey}_$uid'; // 사용자별 키
  }

  // 🔄 앱 시작 시 저장된 데이터 불러오기
  Future<void> loadSavedData() async {
    if (_isLoaded) return; // 이미 로드됨
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 사용자별 파일명 불러오기
      _inventoryFileName = prefs.getString(_getUserKey('inventory_file_name'));
      _inventoryFileDate = prefs.getString(_getUserKey('inventory_file_date'));
      _shipmentFileName = prefs.getString(_getUserKey('shipment_file_name'));
      _priceFileName = prefs.getString(_getUserKey('price_file_name'));
      
      // 사용자별 아이템 데이터 불러오기
      final itemsJson = prefs.getString(_getUserKey('inventory_items'));
      if (itemsJson != null) {
        final Map<String, dynamic> decoded = json.decode(itemsJson);
        _items = decoded.map((key, value) => MapEntry(
          key,
          InventoryItem.fromJson(value),
        ));
        
        final uid = _authService.currentUser?.uid ?? 'unknown';
        debugPrint('✅ 사용자($uid) 저장된 데이터 로드 완료: ${_items.length}개 아이템');
        
        // 🔄 기존 데이터에 내장 입항일정 자동 적용
        if (_items.isNotEmpty) {
          debugPrint('🔄 내장 입항일정 데이터 자동 적용 시작...');
          
          // 기존 입항일정 데이터 초기화 (shipmentDetails 클리어)
          for (var item in _items.values) {
            item.shipmentDetails.clear();
            item.earliestProdDate = null;
            item.latestProdDate = null;
            item.earliestDelivDate = null;
            item.latestDelivDate = null;
          }
          
          // 내장 입항일정 적용
          _items = _excelService.applyEmbeddedShipmentData(_items);
          
          // 입항일정 파일명을 내장 데이터로 업데이트
          _shipmentFileName = '내장 데이터 (298개 조합)';
          
          // 변경사항 저장
          await _saveData();
          
          debugPrint('✅ 내장 입항일정 데이터 적용 완료!');
        }
      }
      
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ 데이터 로드 실패: $e');
      _isLoaded = true; // 실패해도 다시 시도하지 않음
    }
  }

  // 💾 데이터 저장하기 (사용자별)
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 사용자별 파일명 저장
      if (_inventoryFileName != null) {
        await prefs.setString(_getUserKey('inventory_file_name'), _inventoryFileName!);
      }
      if (_inventoryFileDate != null) {
        await prefs.setString(_getUserKey('inventory_file_date'), _inventoryFileDate!);
      }
      if (_shipmentFileName != null) {
        await prefs.setString(_getUserKey('shipment_file_name'), _shipmentFileName!);
      }
      if (_priceFileName != null) {
        await prefs.setString(_getUserKey('price_file_name'), _priceFileName!);
      }
      
      // 사용자별 아이템 데이터 저장 (JSON 형식)
      final itemsMap = _items.map((key, value) => MapEntry(key, value.toJson()));
      await prefs.setString(_getUserKey('inventory_items'), json.encode(itemsMap));
      
      final uid = _authService.currentUser?.uid ?? 'unknown';
      debugPrint('💾 사용자($uid) 데이터 저장 완료: ${_items.length}개 아이템');
    } catch (e) {
      debugPrint('⚠️ 데이터 저장 실패: $e');
    }
  }

  // 재고현황표 업로드
  Future<void> uploadInventoryFile(Uint8List bytes, String fileName) async {
    try {
      // .xlsb 파일 형식 체크
      if (fileName.toLowerCase().endsWith('.xlsb')) {
        throw Exception(
          '.xlsb 파일은 지원되지 않습니다.\n\n'
          '📋 해결 방법:\n'
          '1. Excel에서 파일 열기\n'
          '2. "다른 이름으로 저장" 선택\n'
          '3. 파일 형식을 "Excel 통합 문서 (*.xlsx)"로 선택\n'
          '4. 저장 후 다시 업로드\n\n'
          '💡 .xlsb는 바이너리 형식으로, .xlsx 변환 후 사용 가능합니다.'
        );
      }
      
      _items = await _excelService.parseInventoryFile(bytes, _items);
      
      // 재고현황표 업로드 후 자동으로 내장 입항일정 데이터 적용
      _items = _excelService.applyEmbeddedShipmentData(_items);
      
      _inventoryFileName = fileName;
      _inventoryFileDate = _excelService.extractDateFromFilename(fileName);
      
      // 입항일정 내장 데이터 사용 (파일명 설정)
      _shipmentFileName = '내장 데이터 (298개 조합)';
      
      await _saveData(); // 데이터 저장
      notifyListeners();
    } catch (e) {
      throw Exception('재고현황표 업로드 실패: $e');
    }
  }

  // 입항일정표 업로드
  Future<void> uploadShipmentFile(Uint8List bytes, String fileName) async {
    try {
      // .xlsb 파일 형식 체크
      if (fileName.toLowerCase().endsWith('.xlsb')) {
        throw Exception(
          '.xlsb 파일은 지원되지 않습니다.\n\n'
          '📋 해결 방법:\n'
          '1. Excel에서 파일 열기\n'
          '2. "다른 이름으로 저장" 선택\n'
          '3. 파일 형식을 "Excel 통합 문서 (*.xlsx)"로 선택\n'
          '4. 저장 후 다시 업로드\n\n'
          '💡 .xlsb는 바이너리 형식으로, .xlsx 변환 후 사용 가능합니다.'
        );
      }
      
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
      // .xlsb 파일 형식 체크
      if (fileName.toLowerCase().endsWith('.xlsb')) {
        throw Exception(
          '.xlsb 파일은 지원되지 않습니다.\n\n'
          '📋 해결 방법:\n'
          '1. Excel에서 파일 열기\n'
          '2. "다른 이름으로 저장" 선택\n'
          '3. 파일 형식을 "Excel 통합 문서 (*.xlsx)"로 선택\n'
          '4. 저장 후 다시 업로드\n\n'
          '💡 .xlsb는 바이너리 형식으로, .xlsx 변환 후 사용 가능합니다.'
        );
      }
      
      _items = await _excelService.parsePriceFile(bytes, _items);
      _priceFileName = fileName;
      await _saveData(); // 데이터 저장
      notifyListeners();
    } catch (e) {
      throw Exception('가격표 업로드 실패: $e');
    }
  }

  // 검색어 설정
  void setSearchQuery(String query) {
    _searchQuery = query;
    // 검색어가 변경되면 색상/트림 필터 초기화
    _selectedColorCodes.clear();
    _selectedTrimCodes.clear();
    
    if (kDebugMode) {
      print('🔍 검색어 설정: "$query"');
      print('📊 전체 아이템: ${_items.length}개');
    }
    notifyListeners();
    if (kDebugMode) {
      print('✅ 필터링 결과: ${filteredItems.length}개');
    }
  }

  // 현재미계약 재고 필터 토글
  void toggleAvailableFilter() {
    _showOnlyAvailable = !_showOnlyAvailable;
    notifyListeners();
  }

  // 카드 레이아웃 토글
  void toggleCardLayout() {
    _isVerticalLayout = !_isVerticalLayout;
    notifyListeners();
  }

  // 색상 코드 필터 토글
  void toggleColorFilter(String colorCode) {
    if (_selectedColorCodes.contains(colorCode)) {
      _selectedColorCodes.remove(colorCode);
    } else {
      _selectedColorCodes.add(colorCode);
    }
    // 색상 필터 변경 시 트림 필터 초기화
    _selectedTrimCodes.clear();
    notifyListeners();
  }

  // 트림 코드 필터 토글
  void toggleTrimFilter(String trimCode) {
    if (_selectedTrimCodes.contains(trimCode)) {
      _selectedTrimCodes.remove(trimCode);
    } else {
      _selectedTrimCodes.add(trimCode);
    }
    notifyListeners();
  }

  // 모든 필터 초기화
  void clearFilters() {
    _selectedColorCodes.clear();
    _selectedTrimCodes.clear();
    _showOnlyAvailable = false;
    notifyListeners();
  }

  // 모든 데이터 초기화 (사용자별)
  Future<void> clearAllData() async {
    _items.clear();
    _inventoryFileName = null;
    _inventoryFileDate = null;
    _shipmentFileName = null;
    _priceFileName = null;
    _searchQuery = '';
    _showOnlyAvailable = false;
    _selectedColorCodes.clear();
    _selectedTrimCodes.clear();
    
    // SharedPreferences에서 사용자별 데이터 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getUserKey('inventory_file_name'));
    await prefs.remove(_getUserKey('inventory_file_date'));
    await prefs.remove(_getUserKey('shipment_file_name'));
    await prefs.remove(_getUserKey('price_file_name'));
    await prefs.remove(_getUserKey('inventory_items'));
    
    final uid = _authService.currentUser?.uid ?? 'unknown';
    debugPrint('🗑️ 사용자($uid) 데이터 초기화 완료');
    
    notifyListeners();
  }
}
