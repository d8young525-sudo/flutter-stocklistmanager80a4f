import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/inventory_provider.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../widgets/inventory_card.dart';
import 'login_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _startSessionValidation();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showFileUploadDialog,
        backgroundColor: Colors.blue[700],
        icon: const Icon(Icons.add, size: 28),
        label: const Text('파일 업로드', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        elevation: 6,
      ),
      body: SafeArea(
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

                      // 필터 토글
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                provider.toggleAvailableFilter();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: provider.showOnlyAvailable
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      provider.showOnlyAvailable
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      size: 20,
                                      color: provider.showOnlyAvailable
                                          ? Colors.blue[700]
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '현재미계약 재고만 보기',
                                      style: TextStyle(
                                        color: provider.showOnlyAvailable
                                            ? Colors.blue[700]
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
    );
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
          case 'price':
            await provider.uploadPriceFile(bytes, fileName);
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
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _uploadFile('shipment'),
                  icon: const Icon(Icons.local_shipping, size: 24),
                  label: const Text('입항일정표 업로드', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _uploadFile('price'),
                  icon: const Icon(Icons.attach_money, size: 24),
                  label: const Text('가격표 업로드', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
