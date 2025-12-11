import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:http/http.dart' as http;
import '../models/inventory_item.dart';
import '../models/price_data.dart';
import '../models/shipment_data.dart';

class ExcelService {
  // .xlsb 파일을 .xlsx로 변환하는 API 엔드포인트
  // 개발 환경: localhost:5061
  // 프로덕션 환경: 동일 도메인의 변환 서버
  String get _converterApiUrl {
    if (kDebugMode) {
      return 'http://localhost:5061/convert';
    }
    // 프로덕션에서는 동일 도메인 사용 (Firebase Hosting + Cloud Functions)
    return '/api/convert-xlsb';
  }
  
  /// .xlsb 파일을 .xlsx로 자동 변환
  /// 
  /// [xlsbBytes]: .xlsb 파일의 바이너리 데이터
  /// Returns: 변환된 .xlsx 파일의 바이너리 데이터
  Future<Uint8List> _convertXlsbToXlsx(Uint8List xlsbBytes) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 .xlsb → .xlsx 변환 시작 (파일 크기: ${xlsbBytes.length} bytes)');
      }
      
      final response = await http.post(
        Uri.parse(_converterApiUrl),
        headers: {
          'Content-Type': 'application/octet-stream',
        },
        body: xlsbBytes,
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        if (kDebugMode) {
          debugPrint('✅ .xlsb → .xlsx 변환 완료 (결과 크기: ${response.bodyBytes.length} bytes)');
        }
        return response.bodyBytes;
      } else {
        throw Exception('변환 서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ .xlsb 변환 실패: $e');
      }
      throw Exception('파일 변환 중 오류가 발생했습니다: $e');
    }
  }

  /// 파일명에서 확장자 확인
  bool _isXlsbFile(String fileName) {
    return fileName.toLowerCase().endsWith('.xlsb');
  }
  // 재고현황표 파일명에서 날짜 추출
  String? extractDateFromFilename(String filename) {
    final datePattern = RegExp(r'(\d{4})[-_]?(\d{2})[-_]?(\d{2})');
    final match = datePattern.firstMatch(filename);
    
    if (match != null) {
      return '${match.group(1)}-${match.group(2)}-${match.group(3)}';
    }
    return null;
  }

  // 셀 값 가져오기 (완전히 안전한 방식 - 모든 에러 무시)
  String _getCellValue(SpreadsheetTable table, int row, int col) {
    try {
      if (row < 0 || col < 0) return '';
      if (row >= table.maxRows || col >= table.maxCols) return '';
      
      var rowData = table.rows[row];
      if (rowData == null) return '';
      if (col >= rowData.length) return '';
      
      var value = rowData[col];
      if (value == null) return '';
      
      // 다양한 타입 처리
      if (value is String) return value.trim();
      if (value is int) return value.toString();
      if (value is double) return value.toString();
      if (value is bool) return value.toString();
      
      return value.toString().trim();
    } catch (e) {
      return '';
    }
  }

  // 날짜 문자열에서 시간 부분 제거 (YYYY-MM-DD만 추출)
  String _cleanDateString(String dateStr) {
    if (dateStr.isEmpty) return '';
    
    try {
      // "2024-04-19 00:00:00" 또는 "2025-11-13T00:32:08.000" 형식에서 날짜만 추출
      if (dateStr.contains(' ')) {
        return dateStr.split(' ')[0]; // 공백 기준으로 분리
      }
      if (dateStr.contains('T')) {
        return dateStr.split('T')[0]; // T 기준으로 분리
      }
      return dateStr;
    } catch (e) {
      return dateStr;
    }
  }

  // 컬럼 인덱스 찾기 (정확한 매칭)
  Map<String, int> _findColumnIndices(SpreadsheetTable table, Map<String, List<String>> searchTermsMap) {
    Map<String, int> columnIndex = {};
    int headerRow = -1;
    
    try {
      // 처음 20행 내에서 헤더 찾기
      for (int rowIdx = 0; rowIdx < table.maxRows && rowIdx < 20; rowIdx++) {
        try {
          Map<String, int> tempIndex = {};
          
          for (int colIdx = 0; colIdx < table.maxCols && colIdx < 50; colIdx++) {
            try {
              String cellValue = _getCellValue(table, rowIdx, colIdx);
              if (cellValue.isEmpty) continue;
              
              // 각 검색어 그룹과 정확히 매칭 (부분 문자열이 아닌 완전 매칭)
              for (var entry in searchTermsMap.entries) {
                String key = entry.key;
                List<String> terms = entry.value;
                
                for (var term in terms) {
                  // 정확히 일치하거나 포함하는 경우만 매칭
                  if (cellValue == term || cellValue.trim() == term) {
                    tempIndex[key] = colIdx;
                    break;
                  }
                }
              }
            } catch (e) {
              continue;
            }
          }
          
          // 여러 컬럼이 발견되면 헤더로 간주
          if (tempIndex.length >= 3) {
            columnIndex = tempIndex;
            headerRow = rowIdx;
            break;
          }
        } catch (e) {
          continue;
        }
      }
      
      if (headerRow != -1) {
        columnIndex['_headerRow'] = headerRow;
      }
    } catch (e) {
      // 전체 검색 실패 시 빈 맵 반환
    }
    
    return columnIndex;
  }

  // 재고현황표 파싱 (.xlsb 자동 변환 지원)
  Future<Map<String, InventoryItem>> parseInventoryFile(
    Uint8List bytes,
    Map<String, InventoryItem> existingItems,
    {String? fileName}
  ) async {
    // .xlsb 파일인 경우 자동 변환
    Uint8List processedBytes = bytes;
    if (fileName != null && _isXlsbFile(fileName)) {
      if (kDebugMode) {
        debugPrint('📦 .xlsb 파일 감지 - 자동 변환 시작');
      }
      processedBytes = await _convertXlsbToXlsx(bytes);
    }
    // ✅ 재고 데이터 초기화 (중복 카운팅 방지)
    // 기존 아이템의 입항일정/가격 정보는 유지하되, 재고 카운터는 0으로 리셋
    Map<String, InventoryItem> items = {};
    for (var entry in existingItems.entries) {
      var oldItem = entry.value;
      items[entry.key] = InventoryItem(
        model: oldItem.model,
        my: oldItem.my,
        color: oldItem.color,
        trim: oldItem.trim,
        price: oldItem.price,
        earliestProdDate: oldItem.earliestProdDate,
        latestProdDate: oldItem.latestProdDate,
        earliestDelivDate: oldItem.earliestDelivDate,
        latestDelivDate: oldItem.latestDelivDate,
        // 재고 카운터는 0으로 초기화 (새 파일에서 다시 계산)
        allocationTotal: 0,
        allocationContract: 0,
        allocationBlocked: 0,
        allocationWaiting: 0,
        allocationAvailable: 0,
        onlineTotal: 0,
        onlineContract: 0,
        onlineBlocked: 0,
        onlineWaiting: 0,
        onlineAvailable: 0,
      );
    }
    
    try {
      var decoder = SpreadsheetDecoder.decodeBytes(processedBytes);
      
      // allocation 시트
      try {
        var allocationTable = decoder.tables['allocation'];
        if (allocationTable != null) {
          _parseInventoryTable(allocationTable, items, isAllocation: true);
        }
      } catch (e) {
        print('⚠️ allocation 시트 파싱 실패: $e');
      }

      // 온라인재고 시트
      try {
        var onlineTable = decoder.tables['온라인재고'];
        if (onlineTable != null) {
          _parseInventoryTable(onlineTable, items, isAllocation: false);
        }
      } catch (e) {
        print('⚠️ 온라인재고 시트 파싱 실패: $e');
      }

      if (items.isEmpty && existingItems.isEmpty) {
        throw Exception('데이터를 읽을 수 없습니다. allocation 또는 온라인재고 시트가 있는지 확인해주세요.');
      }

      return items;
    } catch (e) {
      throw Exception('파일을 읽는 중 오류가 발생했습니다. 엑셀 파일을 다른 이름으로 저장한 후 다시 시도해주세요.');
    }
  }

  void _parseInventoryTable(
    SpreadsheetTable table,
    Map<String, InventoryItem> items,
    {required bool isAllocation}
  ) {
    try {
      // 컬럼 검색어 정의 (정확한 매칭을 위해 순서 중요)
      var searchTerms = {
        'CommNo': ['Comm.No.', 'CommNo'],
        'Model': ['Model'],
        'MY': ['MY'],
        'Color': ['Color', 'Colour'],
        'Trim': ['Trim'],
        'Customer': ['COSTOMER', 'CUSTOMER'],
        'Memo': ['MEMO', 'Memo'],
      };

      var columnIndex = _findColumnIndices(table, searchTerms);
      
      int headerRow = columnIndex['_headerRow'] ?? -1;
      if (headerRow == -1) return;

      int? modelCol = columnIndex['Model'];
      int? myCol = columnIndex['MY'];
      int? colorCol = columnIndex['Color'];
      int? trimCol = columnIndex['Trim'];
      int? commNoCol = columnIndex['CommNo'];
      int? customerCol = columnIndex['Customer'];
      int? memoCol = columnIndex['Memo'];

      if (modelCol == null || myCol == null || colorCol == null || trimCol == null) {
        return;
      }

      // 데이터 행 파싱
      for (int rowIdx = headerRow + 1; rowIdx < table.maxRows && rowIdx < 10000; rowIdx++) {
        try {
          String model = _getCellValue(table, rowIdx, modelCol);
          String my = _getCellValue(table, rowIdx, myCol);
          String color = _getCellValue(table, rowIdx, colorCol);
          String trim = _getCellValue(table, rowIdx, trimCol);
          
          // Model Desc 제외
          if (model.contains('Desc') || model.contains('Model')) continue;
          if (model.isEmpty || my.isEmpty || color.isEmpty || trim.isEmpty) continue;

          String commNo = commNoCol != null ? _getCellValue(table, rowIdx, commNoCol) : '';
          String customer = customerCol != null ? _getCellValue(table, rowIdx, customerCol) : '';
          String memo = memoCol != null ? _getCellValue(table, rowIdx, memoCol) : '';

          String key = '$model|$my|$color|$trim';

          // 가격표에서 가격 자동 매칭
          String? priceStr;
          int? priceValue = PriceData.getPrice(my, model);
          if (priceValue != null) {
            priceStr = priceValue.toString();
          }

          InventoryItem item = items.putIfAbsent(
            key,
            () => InventoryItem(model: model, my: my, color: color, trim: trim, price: priceStr),
          );

          bool hasCommNo = commNo.isNotEmpty;
          bool hasCustomer = customer.isNotEmpty;
          bool isBlocked = memo.contains('선출고불가') || memo.contains('출고차단');
          bool isReleased = memo.contains('해제');

          if (isAllocation) {
            if (hasCommNo) {
              item.allocationTotal++;
              if (hasCustomer) {
                item.allocationContract++;
              } else if (isBlocked && !isReleased) {
                item.allocationBlocked++;
              }
            } else {
              item.allocationWaiting++;
            }
            item.allocationAvailable = item.allocationTotal - item.allocationContract - item.allocationBlocked;
          } else {
            if (hasCommNo) {
              item.onlineTotal++;
              if (hasCustomer) {
                item.onlineContract++;
              } else if (isBlocked && !isReleased) {
                item.onlineBlocked++;
              }
            } else {
              item.onlineWaiting++;
            }
            item.onlineAvailable = item.onlineTotal - item.onlineContract - item.onlineBlocked;
          }
        } catch (e) {
          continue;
        }
      }
    } catch (e) {
      // 시트 전체 파싱 실패 무시
    }
  }

  // 입항일정표 파싱 (.xlsb 자동 변환 지원)
  Future<Map<String, InventoryItem>> parseShipmentFile(
    Uint8List bytes,
    Map<String, InventoryItem> existingItems,
    {String? fileName}
  ) async {
    // .xlsb 파일인 경우 자동 변환
    Uint8List processedBytes = bytes;
    if (fileName != null && _isXlsbFile(fileName)) {
      if (kDebugMode) {
        debugPrint('📦 .xlsb 파일 감지 - 자동 변환 시작');
      }
      processedBytes = await _convertXlsbToXlsx(bytes);
    }
    
    Map<String, InventoryItem> items = Map.from(existingItems);
    
    try {
      if (kDebugMode) {
        debugPrint('🚢 입항일정표 파싱 시작...');
      }
      
      var decoder = SpreadsheetDecoder.decodeBytes(processedBytes);

      SpreadsheetTable? sheet1;
      if (decoder.tables.containsKey('Sheet 1')) {
        sheet1 = decoder.tables['Sheet 1'];
      } else if (decoder.tables.containsKey('Sheet1')) {
        sheet1 = decoder.tables['Sheet1'];
      }

      if (sheet1 == null) {
        if (kDebugMode) {
          debugPrint('❌ Sheet 1을 찾을 수 없습니다. 사용 가능한 시트: ${decoder.tables.keys}');
        }
        throw Exception('Sheet 1을 찾을 수 없습니다');
      }

      var searchTerms = {
        'ModelDesc': ['Model Desc.', 'Model Desc'],
        'ModelYr': ['Model Yr.', 'Model Yr'],
        'Colour': ['Colour', 'Color'],
        'Trim': ['Trim'],
        'ProdDate': ['Prod. Date', 'Prod Date'],
        'PlanDelivDate': ['Plan.Deliv.Date', 'Plan Deliv Date'],
      };

      var columnIndex = _findColumnIndices(sheet1, searchTerms);
      
      if (kDebugMode) {
        debugPrint('📊 컬럼 인덱스: $columnIndex');
      }
      
      int headerRow = columnIndex['_headerRow'] ?? -1;
      if (headerRow == -1) {
        if (kDebugMode) {
          debugPrint('❌ 헤더 행을 찾을 수 없습니다');
        }
        return items;
      }

      int? modelDescCol = columnIndex['ModelDesc'];
      int? modelYrCol = columnIndex['ModelYr'];
      int? colourCol = columnIndex['Colour'];
      int? trimCol = columnIndex['Trim'];
      int? prodDateCol = columnIndex['ProdDate'];
      int? planDelivDateCol = columnIndex['PlanDelivDate'];

      if (kDebugMode) {
        debugPrint('📍 ModelDesc 컬럼: $modelDescCol');
        debugPrint('📍 ModelYr 컬럼: $modelYrCol');
        debugPrint('📍 Colour 컬럼: $colourCol');
        debugPrint('📍 Trim 컬럼: $trimCol');
        debugPrint('📍 ProdDate 컬럼: $prodDateCol');
        debugPrint('📍 PlanDelivDate 컬럼: $planDelivDateCol');
      }

      if (modelDescCol == null || modelYrCol == null || colourCol == null || trimCol == null) {
        if (kDebugMode) {
          debugPrint('❌ 필수 컬럼을 찾을 수 없습니다');
        }
        return items;
      }

      int matchedCount = 0;
      int unmatchedCount = 0;
      
      for (int rowIdx = headerRow + 1; rowIdx < sheet1.maxRows && rowIdx < 10000; rowIdx++) {
        try {
          String modelDesc = _getCellValue(sheet1, rowIdx, modelDescCol);
          String modelYr = _getCellValue(sheet1, rowIdx, modelYrCol);
          String colour = _getCellValue(sheet1, rowIdx, colourCol);
          String trim = _getCellValue(sheet1, rowIdx, trimCol);
          
          if (modelDesc.isEmpty || modelYr.isEmpty || colour.isEmpty || trim.isEmpty) continue;

          String prodDate = prodDateCol != null ? _cleanDateString(_getCellValue(sheet1, rowIdx, prodDateCol)) : '';
          String planDelivDate = planDelivDateCol != null ? _cleanDateString(_getCellValue(sheet1, rowIdx, planDelivDateCol)) : '';

          String key = '$modelDesc|$modelYr|$colour|$trim';

          // 기존 항목이 있으면 매칭, 없으면 새로 생성
          InventoryItem item;
          if (items.containsKey(key)) {
            matchedCount++;
            item = items[key]!;
            if (kDebugMode && matchedCount <= 3) {
              debugPrint('✅ 매칭 성공: $modelDesc | ProdDate: $prodDate | PlanDelivDate: $planDelivDate');
            }
          } else {
            unmatchedCount++;
            // 입항일정표만 업로드된 경우: 새로운 아이템 생성
            // 가격표에서 가격 자동 매칭
            String? priceStr;
            int? priceValue = PriceData.getPrice(modelYr, modelDesc);
            if (priceValue != null) {
              priceStr = priceValue.toString();
            }
            
            item = InventoryItem(
              model: modelDesc, 
              my: modelYr, 
              color: colour, 
              trim: trim,
              price: priceStr,
            );
            items[key] = item;
            if (kDebugMode && unmatchedCount <= 3) {
              debugPrint('🆕 새 항목 생성: $key');
            }
          }
          
          // 입항일정 상세 정보 추가
          item.shipmentDetails.add(ShipmentDetail(
            model: modelDesc,
            modelYear: modelYr,
            colour: colour,
            trim: trim,
            prodDate: prodDate,
            planDelivDate: planDelivDate,
          ));

          // 생산일자 업데이트
          if (prodDate.isNotEmpty) {
            if (item.earliestProdDate == null || _compareDates(prodDate, item.earliestProdDate!) < 0) {
              item.earliestProdDate = prodDate;
            }
            if (item.latestProdDate == null || _compareDates(prodDate, item.latestProdDate!) > 0) {
              item.latestProdDate = prodDate;
            }
          }

          // 도착예정일 업데이트
          if (planDelivDate.isNotEmpty) {
            if (item.earliestDelivDate == null || _compareDates(planDelivDate, item.earliestDelivDate!) < 0) {
              item.earliestDelivDate = planDelivDate;
            }
            if (item.latestDelivDate == null || _compareDates(planDelivDate, item.latestDelivDate!) > 0) {
              item.latestDelivDate = planDelivDate;
            }
          }
        } catch (e) {
          continue;
        }
      }

      if (kDebugMode) {
        debugPrint('🎯 입항일정표 파싱 완료: 기존 항목 매칭 $matchedCount건, 신규 항목 생성 $unmatchedCount건');
      }

      return items;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ 입항일정표 파싱 오류: ${e.toString()}');
      }
      throw Exception('입항일정표를 읽을 수 없습니다: ${e.toString()}');
    }
  }

  // 내장된 입항일정 데이터를 items에 적용
  Map<String, InventoryItem> applyEmbeddedShipmentData(
    Map<String, InventoryItem> items,
  ) {
    try {
      int matchedCount = 0;
      int unmatchedCount = 0;
      
      // 기존 items를 순회하면서 내장 데이터에서 입항일정 찾기
      for (var entry in items.entries) {
        String key = entry.key;
        InventoryItem item = entry.value;
        
        // ShipmentData에서 입항일정 조회
        ShipmentInfo? shipmentInfo = ShipmentData.getShipment(
          item.my,
          item.model,
          item.color,
          item.trim,
        );
        
        if (shipmentInfo != null) {
          matchedCount++;
          
          // 입항일정 상세 정보 추가 (각 생산일-입항일 쌍)
          for (var detailPair in shipmentInfo.details) {
            item.shipmentDetails.add(ShipmentDetail(
              model: item.model,
              modelYear: item.my,
              colour: item.color,
              trim: item.trim,
              prodDate: detailPair.prodDate,
              planDelivDate: detailPair.delivDate,
            ));
          }
          
          // 최소/최대 날짜 업데이트
          item.earliestProdDate = shipmentInfo.earliestProdDate.isNotEmpty 
              ? shipmentInfo.earliestProdDate 
              : null;
          item.latestProdDate = shipmentInfo.latestProdDate.isNotEmpty 
              ? shipmentInfo.latestProdDate 
              : null;
          item.earliestDelivDate = shipmentInfo.earliestDelivDate.isNotEmpty 
              ? shipmentInfo.earliestDelivDate 
              : null;
          item.latestDelivDate = shipmentInfo.latestDelivDate.isNotEmpty 
              ? shipmentInfo.latestDelivDate 
              : null;
          
          if (kDebugMode && matchedCount <= 5) {
            debugPrint('✅ 입항일정 매칭: ${item.model} (${item.my}) - Prod: ${item.earliestProdDate} ~ ${item.latestProdDate}');
          }
        } else {
          unmatchedCount++;
          if (kDebugMode && unmatchedCount <= 3) {
            debugPrint('⚠️ 입항일정 없음: ${item.model} | ${item.my} | ${item.color} | ${item.trim}');
          }
        }
      }
      
      if (kDebugMode) {
        debugPrint('🎯 내장 입항일정 적용 완료: 매칭 $matchedCount건, 미매칭 $unmatchedCount건');
      }
      
      return items;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ 입항일정 적용 오류: ${e.toString()}');
      }
      return items;
    }
  }

  // 가격표 파싱 (.xlsb 자동 변환 지원)
  Future<Map<String, InventoryItem>> parsePriceFile(
    Uint8List bytes,
    Map<String, InventoryItem> existingItems,
    {String? fileName}
  ) async {
    // .xlsb 파일인 경우 자동 변환
    Uint8List processedBytes = bytes;
    if (fileName != null && _isXlsbFile(fileName)) {
      if (kDebugMode) {
        debugPrint('📦 .xlsb 파일 감지 - 자동 변환 시작');
      }
      processedBytes = await _convertXlsbToXlsx(bytes);
    }
    
    Map<String, InventoryItem> items = Map.from(existingItems);
    
    try {
      var decoder = SpreadsheetDecoder.decodeBytes(processedBytes);

      SpreadsheetTable? priceTable;
      if (decoder.tables.containsKey('PRICECHART')) {
        priceTable = decoder.tables['PRICECHART'];
      } else if (decoder.tables.containsKey('PriceChart')) {
        priceTable = decoder.tables['PriceChart'];
      }

      if (priceTable == null) {
        throw Exception('PRICECHART 시트를 찾을 수 없습니다');
      }

      var searchTerms = {
        'MY': ['MY'],
        'Model': ['Model'],
        'Price': ['PRICE', 'Price'],
      };

      var columnIndex = _findColumnIndices(priceTable, searchTerms);
      
      int headerRow = columnIndex['_headerRow'] ?? -1;
      if (headerRow == -1) return items;

      int? myCol = columnIndex['MY'];
      int? modelCol = columnIndex['Model'];
      int? priceCol = columnIndex['Price'];

      if (myCol == null || modelCol == null || priceCol == null) {
        return items;
      }

      for (int rowIdx = headerRow + 1; rowIdx < priceTable.maxRows && rowIdx < 10000; rowIdx++) {
        try {
          String my = _getCellValue(priceTable, rowIdx, myCol);
          String model = _getCellValue(priceTable, rowIdx, modelCol);
          String price = _getCellValue(priceTable, rowIdx, priceCol);

          if (my.isEmpty || model.isEmpty || price.isEmpty) continue;

          for (var entry in items.entries) {
            InventoryItem item = entry.value;
            if (item.model == model && item.my == my) {
              items[entry.key] = InventoryItem(
                model: item.model,
                my: item.my,
                color: item.color,
                trim: item.trim,
                price: price,
              )
                ..allocationTotal = item.allocationTotal
                ..allocationContract = item.allocationContract
                ..allocationAvailable = item.allocationAvailable
                ..allocationBlocked = item.allocationBlocked
                ..allocationWaiting = item.allocationWaiting
                ..onlineTotal = item.onlineTotal
                ..onlineContract = item.onlineContract
                ..onlineAvailable = item.onlineAvailable
                ..onlineBlocked = item.onlineBlocked
                ..onlineWaiting = item.onlineWaiting
                ..earliestProdDate = item.earliestProdDate
                ..latestProdDate = item.latestProdDate
                ..earliestDelivDate = item.earliestDelivDate
                ..latestDelivDate = item.latestDelivDate
                ..shipmentDetails = item.shipmentDetails;
            }
          }
        } catch (e) {
          continue;
        }
      }

      return items;
    } catch (e) {
      throw Exception('가격표를 읽을 수 없습니다: ${e.toString()}');
    }
  }

  int _compareDates(String date1, String date2) {
    try {
      String normalized1 = date1.replaceAll(RegExp(r'[^0-9]'), '');
      String normalized2 = date2.replaceAll(RegExp(r'[^0-9]'), '');
      return normalized1.compareTo(normalized2);
    } catch (e) {
      return 0;
    }
  }
}
