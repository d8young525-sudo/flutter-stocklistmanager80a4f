import pandas as pd
import os

# 파일 경로 설정
excel_path = '../../uploaded_files/수정본 2 Enquiries_20251223_25.03월~26.01월_생산분.xlsx'
output_path = '../lib/models/shipment_data.dart'

def clean_date(date_val):
    if pd.isna(date_val):
        return ''
    return str(date_val).split(' ')[0]

try:
    # 엑셀 파일 읽기
    print(f"Reading excel file from: {excel_path}")
    df = pd.read_excel(excel_path, sheet_name='Sheet 1')
    
    # 필요한 컬럼 확인 및 이름 매핑
    # 엑셀 컬럼: Model Desc, Model Yr., Colour, Trim, Prod. Date, Plan.Deliv.Date
    # 코드 매핑: model, my, color, trim, prodDate, delivDate
    
    data_map = {}
    
    for _, row in df.iterrows():
        model = str(row['Model Desc.']).strip()
        my = str(row['Model Yr.']).strip()
        color = str(row['Colour']).strip()
        trim = str(row['Trim']).strip()
        
        if pd.isna(row['Model Desc.']) or model == 'nan': continue
        
        prod_date = clean_date(row['Prod. Date'])
        deliv_date = clean_date(row['Plan.Deliv.Date'])
        
        # Prod. Date에서 연도 추출 (YYYY)
        prod_year = prod_date.split('-')[0] if '-' in prod_date else prod_date
        
        # Plan.Deliv.Date에서 월 추출 (MM)
        deliv_month = ''
        if '-' in deliv_date:
            parts = deliv_date.split('-')
            if len(parts) >= 2:
                deliv_month = parts[1]
        
        # 키 생성: Model_MY_Color_Trim (공백은 유지하되 코드상에서는 문자열로 처리)
        # 단, 기존 코드에서는 '_'로 구분했지만, 모델명 자체에 '_'가 있을 수 있으므로 주의해야 함.
        # 기존 코드를 보면: 'A 220_Compact_149_101' 형태임.
        # 키 형식: f"{model}_{my}_{color}_{trim}"
        
        key = f"{model}_{my}_{color}_{trim}"
        
        if key not in data_map:
            data_map[key] = {
                'earliestProd': prod_year,
                'latestProd': prod_year,
                'earliestDeliv': deliv_month,
                'latestDeliv': deliv_month
            }
        else:
            curr = data_map[key]
            
            # 생산연도 비교 (문자열 비교)
            if prod_year and (not curr['earliestProd'] or prod_year < curr['earliestProd']):
                curr['earliestProd'] = prod_year
            if prod_year and (not curr['latestProd'] or prod_year > curr['latestProd']):
                curr['latestProd'] = prod_year
                
            # 도착월 비교 (문자열 비교)
            if deliv_month and (not curr['earliestDeliv'] or deliv_month < curr['earliestDeliv']):
                curr['earliestDeliv'] = deliv_month
            if deliv_month and (not curr['latestDeliv'] or deliv_month > curr['latestDeliv']):
                curr['latestDeliv'] = deliv_month

    # Dart 코드 생성
    dart_code = f"""// 입항일정표 내장 데이터 (2025.03 ~ 2026.01 생산분)
// 수정본 Enquiries_20251223_25.03월~26.01월_생산분.xlsx
// 총 {len(data_map)}개 조합

class ShipmentDetailPair {{
  final String earliestProdDate;
  final String latestProdDate;
  final String earliestDelivDate;
  final String latestDelivDate;

  const ShipmentDetailPair({{
    required this.earliestProdDate,
    required this.latestProdDate,
    required this.earliestDelivDate,
    required this.latestDelivDate,
  }});
}}

class ShipmentData {{
  // 입항일정 데이터 (모델명_MY_색상_트림 → 일정)
  static const Map<String, ShipmentDetailPair> _data = {{
"""

    # 키 정렬하여 출력
    for key in sorted(data_map.keys()):
        val = data_map[key]
        dart_code += f"    '{key}': ShipmentDetailPair(\n"
        dart_code += f"      earliestProdDate: '{val['earliestProd']}',\n"
        dart_code += f"      latestProdDate: '{val['latestProd']}',\n"
        dart_code += f"      earliestDelivDate: '{val['earliestDeliv']}',\n"
        dart_code += f"      latestDelivDate: '{val['latestDeliv']}',\n"
        dart_code += f"    ),\n"

    dart_code += """  };

  /// 입항일정 조회 (모델명, MY, 색상, 트림)
  static ShipmentDetailPair? getShipment(String model, String my, String color, String trim) {
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
