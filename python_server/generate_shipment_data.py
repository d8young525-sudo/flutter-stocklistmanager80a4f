import pandas as pd
import os
import sys

# 기본 경로 설정 (인자가 없으면 기본값 사용)
default_excel_path = '../../uploaded_files/수정본 2 Enquiries_20251223_25.03월~26.01월_생산분.xlsx'
output_path = '../lib/models/shipment_data.dart'

# 커맨드라인 인자로 파일 경로 받기
if len(sys.argv) > 1:
    excel_path = sys.argv[1]
else:
    excel_path = default_excel_path

def clean_date(date_val):
    if pd.isna(date_val):
        return ''
    # 전체 날짜 문자열 반환 (YYYY-MM-DD)
    s = str(date_val).strip()
    if ' ' in s:
        return s.split(' ')[0]
    return s

try:
    # 엑셀 파일 읽기
    print(f"Reading excel file from: {excel_path}")
    df = pd.read_excel(excel_path, sheet_name='Sheet 1')
    
    # 데이터 구조: Key -> { 'prodDates': [], 'delivDates': [] }
    data_map = {}
    
    for _, row in df.iterrows():
        # 컬럼명에 점(.)이 포함되어 있음: 'Model Desc.'
        model = str(row['Model Desc.']).strip()
        my = str(row['Model Yr.']).strip()
        color = str(row['Colour']).strip()
        trim = str(row['Trim']).strip()
        
        if pd.isna(row['Model Desc.']) or model == 'nan': continue
        
        prod_date = clean_date(row['Prod. Date'])
        deliv_date = clean_date(row['Plan.Deliv.Date'])
        
        # 키 생성: Model_MY_Color_Trim
        key = f"{model}_{my}_{color}_{trim}"
        
        if key not in data_map:
            data_map[key] = {
                'prodDates': [],
                'delivDates': []
            }
        
        # 날짜 추가 (빈 값도 순서 유지를 위해 추가할지, 제외할지 결정 필요)
        # 여기서는 존재하는 날짜만 리스트에 추가
        if prod_date:
            data_map[key]['prodDates'].append(prod_date)
        if deliv_date:
            data_map[key]['delivDates'].append(deliv_date)

    # Dart 코드 생성
    dart_code = f"""// 입항일정표 내장 데이터 (2025.03 ~ 2026.01 생산분)
// 수정본 Enquiries_20251223_25.03월~26.01월_생산분.xlsx
// 총 {len(data_map)}개 조합

class ShipmentDetailPair {{
  final List<String> prodDates;      // 생산일자 리스트 (YYYY-MM-DD)
  final List<String> delivDates;     // 도착예정일 리스트 (YYYY-MM-DD)

  const ShipmentDetailPair({{
    required this.prodDates,
    required this.delivDates,
  }});
}}

class ShipmentData {{
  // 입항일정 데이터 (모델명_MY_색상_트림 → 일정 리스트)
  static const Map<String, ShipmentDetailPair> _data = {{
"""

    # 키 정렬하여 출력
    for key in sorted(data_map.keys()):
        val = data_map[key]
        
        # 중복 제거 및 정렬
        prod_list = sorted(list(set(val['prodDates'])))
        deliv_list = sorted(list(set(val['delivDates'])))
        
        # Dart 문자열 리스트로 변환
        prod_list_str = '[' + ', '.join([f"'{d}'" for d in prod_list]) + ']'
        deliv_list_str = '[' + ', '.join([f"'{d}'" for d in deliv_list]) + ']'
        
        dart_code += f"    '{key}': ShipmentDetailPair(\n"
        dart_code += f"      prodDates: {prod_list_str},\n"
        dart_code += f"      delivDates: {deliv_list_str},\n"
        dart_code += f"    ),\n"

    dart_code += """  };

  /// 입항일정 조회 (모델명, MY, 색상, 트림)
  static ShipmentDetailPair? getShipment(String model, String my, String color, String trim) {
    // 키 생성 시 특수문자 이스케이프 주의 (여기서는 단순 문자열 결합)
    final key = '$model\\_$my\\_$color\\_$trim';
    return _data[key];
  }

  /// 전체 조합 수
  static int get totalCombinations => _data.length;
}
"""

    # 파일 쓰기
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(dart_code)
        
    print(f"Successfully generated {output_path} with {len(data_map)} entries.")

except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
