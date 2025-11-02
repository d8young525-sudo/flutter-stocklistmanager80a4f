import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/inventory_provider.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../widgets/inventory_card.dart';
import '../models/color_mapping.dart';
import 'login_screen.dart';
// Web용 import (조건부)
import 'dart:html' as html show window;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final SessionService _sessionService = SessionService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isFileInfoExpanded = true;
  bool _showDropdown = false;
  List<String> _suggestions = [];
  bool _isFabMenuOpen = false; // FAB 메뉴 열림 상태

  @override
  void initState() {
    super.initState();
    _startSessionValidation();
    _loadSavedData(); // 저장된 데이터 불러오기
  }

  // 저장된 데이터 불러오기
  void _loadSavedData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      provider.loadSavedData();
    });
  }

  @override
  void dispose() {
    _sessionService.stopValidation();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// 세션 검증 시작 (5초마다 자동 확인)
  void _startSessionValidation() {
    // ignore: avoid_print
    print('✅ 세션 검증 시작!');
    
    // 세션 무효 시 로그아웃 콜백 설정
    _sessionService.onSessionInvalidated = () async {
      if (!mounted) return;
      
      // ignore: avoid_print
      print('🚨 다른 기기 로그인 감지! 로그아웃 실행...');
      
      // 로그아웃 실행
      await _authService.signOut();
      
      // 알림 표시
      if (!mounted) return;
      _showLogoutDialog();
    };
    
    // 세션 검증 시작 (5초마다)
    _sessionService.startValidation();
  }

  /// 다른 기기 로그인 알림
  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('다른 기기에서 로그인됨'),
          ],
        ),
        content: const Text(
          '다른 기기에서 로그인하여 현재 세션이 종료되었습니다.\n\n'
          '동시에 하나의 기기에서만 로그인할 수 있습니다.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  /// 자동완성 옵션 생성 (디버깅 강화 버전)
  List<String> _getAutocompleteSuggestions(TextEditingValue textEditingValue, InventoryProvider provider) {
    final query = textEditingValue.text.trim().toLowerCase();
    
    // 디버깅: 검색어 확인
    debugPrint('🔍 자동완성 검색어: "$query"');
    
    if (query.isEmpty) {
      debugPrint('❌ 검색어 비어있음');
      return [];
    }
    
    // 모든 고유한 모델명 추출 (Set으로 중복 제거)
    final allModels = provider.items.values
        .map((item) => item.model)
        .toSet()
        .toList();
    
    // 디버깅: 전체 모델 개수
    debugPrint('📊 전체 모델 개수: ${allModels.length}개');
    debugPrint('📋 모델 리스트: ${allModels.take(5).join(", ")}...');
    
    // 검색어로 시작하는 모델명 우선
    final startsWith = allModels
        .where((model) => model.toLowerCase().startsWith(query))
        .toList();
    
    // 검색어를 포함하는 모델명 (시작하는 것 제외)
    final contains = allModels
        .where((model) => 
          !model.toLowerCase().startsWith(query) && 
          model.toLowerCase().contains(query)
        )
        .toList();
    
    final result = [...startsWith, ...contains].take(10).toList();
    
    // 디버깅: 자동완성 결과
    debugPrint('✅ 자동완성 결과: ${result.length}개');
    debugPrint('📝 결과 리스트: ${result.join(", ")}');
    
    return result;
  }


  Future<void> _handleLogout() async {
    try {
      // 로그아웃 전에 현재 사용자 재고 데이터 초기화
      final provider = Provider.of<InventoryProvider>(context, listen: false);
      provider.clearAllData();
      
      await _authService.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그아웃 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFileUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => const FileUploadDialog(),
    );
  }

  // 카탈로그 열기 (외부 링크)
  void _openCatalog() {
    const url = 'https://www.mercedes-benz.co.kr/passengercars/models/catalog.html';
    
    // Web 플랫폼에서 새 탭으로 열기
    if (kIsWeb) {
      html.window.open(url, '_blank');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('카탈로그 페이지를 새 탭에서 엽니다'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // 모바일에서는 안내 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('카탈로그 링크가 복사되었습니다'),
          action: SnackBarAction(
            label: '확인',
            onPressed: () {},
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // 패치 노트 표시
  void _showPatchNotes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.new_releases, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('업데이트 공지'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '버전 3.5 업데이트',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 16),
              _buildPatchItem('🚢', '입항일정표 내장 적용 (NEW!)', 
                '재고현황표만 업로드하면 입항일정이 자동으로 표시됩니다! 2024년 4월 ~ 2026년 1월 생산분 입항일정 총 331개 조합이 앱에 내장되어 있습니다.'),
              _buildPatchItem('💰', '가격표 기본 내장 (2025.11.02 업데이트)', 
                '2024/2025/2026 MY 가격표가 앱에 기본 탑재되어 더 이상 가격표 파일을 업로드할 필요가 없습니다! 총 180개 모델의 가격이 자동으로 표시됩니다.'),
              _buildPatchItem('🏷️', '항목명 개선', 
                '더 직관적인 용어로 변경: "현재계약" → "배정", "현재미계약" → "배정가능"'),
              _buildPatchItem('🌐', '색상/트림명 한글 적용', 
                '외장색상과 트림명이 한글로 표시되어 이해하기 쉬워졌습니다. (예: designo mocha black → 폴라 화이트)'),
              _buildPatchItem('📊', '정렬 기능 개선', 
                '1차: 모델명 정렬, 2차: 외장색상 코드 오름차순 정렬로 더욱 체계적으로 재고를 확인할 수 있습니다.'),
              _buildPatchItem('🎨', 'UI 간소화', 
                '컬러칩을 제거하여 화면이 깔끔해졌습니다. 텍스트 정보만으로도 충분히 확인 가능합니다.'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.contact_support, size: 20, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          '문의 및 제안',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '카카오톡: dalgr88',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '이메일: kimu0288@gmail.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildPatchItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 외장 색상 드롭다운
  Widget _buildColorDropdown(InventoryProvider provider) {
    final colorCounts = provider.getAvailableColorCodes();
    final sortedColorCodes = colorCounts.keys.toList()..sort();
    
    return PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: provider.selectedColorCodes.isNotEmpty
              ? Colors.white
              : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.palette,
              size: 16,
              color: provider.selectedColorCodes.isNotEmpty
                  ? Colors.blue[700]
                  : Colors.white,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                provider.selectedColorCodes.isEmpty
                    ? '외장 색상'
                    : '외장 (${provider.selectedColorCodes.length})',
                style: TextStyle(
                  color: provider.selectedColorCodes.isNotEmpty
                      ? Colors.blue[700]
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: provider.selectedColorCodes.isNotEmpty
                  ? Colors.blue[700]
                  : Colors.white,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return sortedColorCodes.map((colorCode) {
          final isSelected = provider.selectedColorCodes.contains(colorCode);
          final count = colorCounts[colorCode] ?? 0;
          
          return PopupMenuItem<String>(
            value: colorCode,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: isSelected ? Colors.blue[700] : Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Text(
                  colorCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($count)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () {
              provider.toggleColorFilter(colorCode);
            },
          );
        }).toList();
      },
    );
  }

  // 트림 드롭다운
  Widget _buildTrimDropdown(InventoryProvider provider) {
    final trimCounts = provider.getAvailableTrimCodes();
    final sortedTrimCodes = trimCounts.keys.toList()..sort();
    
    // 트림은 색상 선택 후에만 활성화
    final isEnabled = provider.selectedColorCodes.isNotEmpty && trimCounts.isNotEmpty;
    
    return PopupMenuButton<String>(
      enabled: isEnabled,
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: !isEnabled
              ? Colors.white.withValues(alpha: 0.1)
              : provider.selectedTrimCodes.isNotEmpty
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_seat,
              size: 16,
              color: !isEnabled
                  ? Colors.white.withValues(alpha: 0.3)
                  : provider.selectedTrimCodes.isNotEmpty
                      ? Colors.blue[700]
                      : Colors.white,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                provider.selectedTrimCodes.isEmpty
                    ? '트림'
                    : '트림 (${provider.selectedTrimCodes.length})',
                style: TextStyle(
                  color: !isEnabled
                      ? Colors.white.withValues(alpha: 0.3)
                      : provider.selectedTrimCodes.isNotEmpty
                          ? Colors.blue[700]
                          : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: !isEnabled
                  ? Colors.white.withValues(alpha: 0.3)
                  : provider.selectedTrimCodes.isNotEmpty
                      ? Colors.blue[700]
                      : Colors.white,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        if (!isEnabled) return [];
        
        return sortedTrimCodes.map((trimCode) {
          final isSelected = provider.selectedTrimCodes.contains(trimCode);
          final count = trimCounts[trimCode] ?? 0;
          
          return PopupMenuItem<String>(
            value: trimCode,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  size: 18,
                  color: isSelected ? Colors.blue[700] : Colors.grey[400],
                ),
                const SizedBox(width: 8),
                Text(
                  trimCode,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($count)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () {
              provider.toggleTrimFilter(trimCode);
            },
          );
        }).toList();
      },
    );
  }

  // HEX 색상 코드를 Color 객체로 변환
  Color _parseColor(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('재고 관리 시스템'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
            onPressed: _handleLogout,
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 공지사항 버튼
          if (_isFabMenuOpen) ...[
            FloatingActionButton.extended(
              heroTag: 'notice',
              onPressed: () {
                setState(() => _isFabMenuOpen = false);
                _showPatchNotes();
              },
              backgroundColor: Colors.orange[700],
              icon: const Icon(Icons.campaign, size: 20),
              label: const Text('공지사항'),
            ),
            const SizedBox(height: 10),
            // 카탈로그 버튼
            FloatingActionButton.extended(
              heroTag: 'catalog',
              onPressed: () {
                setState(() => _isFabMenuOpen = false);
                _openCatalog();
              },
              backgroundColor: Colors.green[700],
              icon: const Icon(Icons.menu_book, size: 20),
              label: const Text('카탈로그'),
            ),
            const SizedBox(height: 10),
            // 파일 업로드 버튼
            FloatingActionButton.extended(
              heroTag: 'upload',
              onPressed: () {
                setState(() => _isFabMenuOpen = false);
                _showFileUploadDialog();
              },
              backgroundColor: Colors.blue[700],
              icon: const Icon(Icons.upload_file, size: 20),
              label: const Text('파일 업로드'),
            ),
            const SizedBox(height: 10),
          ],
          // 메인 + 버튼
          FloatingActionButton(
            heroTag: 'main',
            onPressed: () {
              setState(() => _isFabMenuOpen = !_isFabMenuOpen);
            },
            backgroundColor: _isFabMenuOpen ? Colors.grey[600] : Colors.blue[700],
            child: Icon(_isFabMenuOpen ? Icons.close : Icons.add, size: 28),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // FAB 메뉴 열려있으면 닫기
          if (_isFabMenuOpen) {
            setState(() => _isFabMenuOpen = false);
          }
          // 포커스 해제
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
          children: [
            // 상단 정보 영역
            Consumer<InventoryProvider>(
              builder: (context, provider, child) {
                return Container(
                  color: Colors.blue[700],
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 파일 정보 표시
                      if (provider.inventoryFileName != null ||
                          provider.shipmentFileName != null ||
                          provider.priceFileName != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isFileInfoExpanded = !_isFileInfoExpanded;
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      '현재 적용된 파일',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      _isFileInfoExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                              if (_isFileInfoExpanded) const SizedBox(height: 10),
                              if (_isFileInfoExpanded && provider.inventoryFileName != null) ...[
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        size: 16, color: Colors.white70),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '재고현황표: ${provider.inventoryFileName}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                if (provider.inventoryFileDate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 24),
                                    child: Text(
                                      '${provider.inventoryFileDate} 기준 재고현황',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                              if (_isFileInfoExpanded && provider.shipmentFileName != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        size: 16, color: Colors.white70),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '입항일정표: ${provider.shipmentFileName}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (_isFileInfoExpanded && provider.priceFileName != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle,
                                        size: 16, color: Colors.white70),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        '가격표: ${provider.priceFileName}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      const SizedBox(height: 12),

                      // 검색 바 - Autocomplete 위젯 사용 (공식 위젯)
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return _getAutocompleteSuggestions(textEditingValue, provider);
                        },
                        onSelected: (String selection) {
                          debugPrint('👆 자동완성 선택: $selection');
                          provider.setSearchQuery(selection);
                          _searchFocusNode.unfocus();
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          
                          return TextField(
                            controller: fieldTextEditingController,
                            focusNode: fieldFocusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: '모델명으로 검색...',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                              prefixIcon: const Icon(Icons.search, color: Colors.white70),
                              suffixIcon: fieldTextEditingController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.white70),
                                      onPressed: () {
                                        fieldTextEditingController.clear();
                                        provider.setSearchQuery('');
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                            onChanged: (value) {
                              provider.setSearchQuery(value);
                              setState(() {});
                            },
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 8.0,
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                constraints: const BoxConstraints(maxHeight: 250),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder: (context, index) {
                                    final suggestion = options.elementAt(index);
                                    return ListTile(
                                      leading: const Icon(Icons.search, size: 20, color: Colors.grey),
                                      title: Text(
                                        suggestion,
                                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                                      ),
                                      onTap: () {
                                        onSelected(suggestion);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // 통합 필터 - 한 줄에 모든 필터 표시
                      Row(
                        children: [
                          // 현재미계약 재고 체크박스
                          InkWell(
                            onTap: () {
                              provider.toggleAvailableFilter();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: provider.showOnlyAvailable
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    provider.showOnlyAvailable
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: 18,
                                    color: provider.showOnlyAvailable
                                        ? Colors.blue[700]
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '배정가능',
                                    style: TextStyle(
                                      color: provider.showOnlyAvailable
                                          ? Colors.blue[700]
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // 카드 레이아웃 토글 버튼
                          InkWell(
                            onTap: () {
                              provider.toggleCardLayout();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                provider.isVerticalLayout
                                    ? Icons.view_stream
                                    : Icons.view_agenda,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          // 재고가 있으면 색상/트림 필터 표시 (검색 여부 무관)
                          if (provider.items.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            // 외장 색상 드롭다운
                            Expanded(
                              child: _buildColorDropdown(provider),
                            ),
                            const SizedBox(width: 8),
                            // 트림 드롭다운
                            Expanded(
                              child: _buildTrimDropdown(provider),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // 재고 카드 리스트
            Expanded(
              child: Consumer<InventoryProvider>(
                builder: (context, provider, child) {
                  if (provider.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '파일을 업로드해주세요',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _showFileUploadDialog,
                            icon: const Icon(Icons.upload_file, size: 28),
                            label: const Text('파일 업로드', style: TextStyle(fontSize: 18)),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredItems = provider.filteredItems;

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '검색 결과가 없습니다',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return InventoryCard(item: filteredItems[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ), // GestureDetector
    ); // Scaffold
  }
}

// 파일 업로드 다이얼로그
class FileUploadDialog extends StatefulWidget {
  const FileUploadDialog({super.key});

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  bool _isUploading = false;

  Future<void> _uploadFile(String fileType) async {
    try {
      setState(() {
        _isUploading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        if (!mounted) return;
        final provider = Provider.of<InventoryProvider>(context, listen: false);

        switch (fileType) {
          case 'inventory':
            await provider.uploadInventoryFile(bytes, fileName);
            break;
          case 'shipment':
            await provider.uploadShipmentFile(bytes, fileName);
            break;
        }

        if (!mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context);
        
        messenger.showSnackBar(
          const SnackBar(
            content: Text('파일이 성공적으로 업로드되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
        navigator.pop();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('파일 업로드 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('파일 업로드'),
      content: _isUploading
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('파일을 업로드하는 중...'),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _uploadFile('inventory'),
                  icon: const Icon(Icons.inventory, size: 24),
                  label: const Text('재고현황표 업로드', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 12),
                // 입항일정표는 내장 데이터로 자동 적용됨
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '입항일정표는 앱에 내장되어 있어\n재고현황표만 업로드하면 자동으로 적용됩니다',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      actions: [
        if (!_isUploading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
      ],
    );
  }
}
