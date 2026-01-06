// 입항일정표 내장 데이터 (2025.03 ~ 2026.01 생산분)
// 수정본 Enquiries_20251223_25.03월~26.01월_생산분.xlsx
// 총 249개 조합

class ShipmentDetailPair {
  final List<String> prodDates;      // 생산일자 리스트 (YYYY-MM-DD)
  final List<String> delivDates;     // 도착예정일 리스트 (YYYY-MM-DD)

  const ShipmentDetailPair({
    required this.prodDates,
    required this.delivDates,
  });
}

class ShipmentData {
  // 입항일정 데이터 (모델명_MY_색상_트림 → 일정 리스트)
  static const Map<String, ShipmentDetailPair> _data = {
    'A 220_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-09-03', '2025-09-04', '2025-09-24', '2025-11-12', '2025-11-25'],
      delivDates: ['2025-11-17', '2025-12-26', '2026-01-08', '2026-01-17'],
    ),
    'A 220_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-11-18'],
      delivDates: ['2026-01-02'],
    ),
    'A 220_2026_696_101': ShipmentDetailPair(
      prodDates: ['2025-08-30', '2025-11-03', '2025-11-19'],
      delivDates: ['2025-11-17', '2026-01-02', '2026-01-17'],
    ),
    'AMG A 45 S 4MATIC+_2026_149_277': ShipmentDetailPair(
      prodDates: ['2025-07-30', '2025-10-21'],
      delivDates: ['2025-11-03', '2026-01-17'],
    ),
    'AMG A 45 S 4MATIC+_2026_696_277': ShipmentDetailPair(
      prodDates: ['2025-08-12', '2025-10-14'],
      delivDates: ['2025-11-03', '2026-01-17'],
    ),
    'AMG A 45 S 4MATIC+_2026_696_651': ShipmentDetailPair(
      prodDates: ['2025-08-01'],
      delivDates: ['2025-11-21'],
    ),
    'AMG CLA 45 S 4MATIC+_2026_149_277': ShipmentDetailPair(
      prodDates: ['2025-09-08'],
      delivDates: ['2025-11-17'],
    ),
    'AMG CLA 45 S 4MATIC+_2026_149_654': ShipmentDetailPair(
      prodDates: ['2025-06-18'],
      delivDates: ['2026-01-10'],
    ),
    'AMG CLA 45 S 4MATIC+_2026_662_277': ShipmentDetailPair(
      prodDates: ['2025-09-02'],
      delivDates: ['2025-11-17'],
    ),
    'AMG CLE 53 4M Cabriolet_2026_197_851': ShipmentDetailPair(
      prodDates: ['2025-10-14', '2025-10-21', '2025-11-11'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-02-02'],
    ),
    'AMG CLE 53 4M Cabriolet_2026_197_887': ShipmentDetailPair(
      prodDates: ['2025-10-17', '2025-11-17', '2025-11-18'],
      delivDates: ['2025-12-22', '2026-02-02', '2026-02-09'],
    ),
    'AMG CLE 53 4M Cabriolet_2026_818_887': ShipmentDetailPair(
      prodDates: ['2025-10-10', '2025-11-14'],
      delivDates: ['2025-12-22', '2026-02-02'],
    ),
    'AMG CLE 53 4M Cabriolet_2026_885_851': ShipmentDetailPair(
      prodDates: ['2025-11-12'],
      delivDates: ['2026-01-25'],
    ),
    'AMG CLE 53 4M Cabriolet_2026_885_887': ShipmentDetailPair(
      prodDates: ['2025-08-13'],
      delivDates: ['2026-01-25'],
    ),
    'AMG CLE 53 4M Coupe_2026_197_851': ShipmentDetailPair(
      prodDates: ['2025-11-21'],
      delivDates: ['2026-02-02'],
    ),
    'AMG CLE 53 4M Coupe_2026_197_887': ShipmentDetailPair(
      prodDates: ['2025-10-16', '2025-10-24', '2025-10-27', '2025-10-30', '2025-11-04', '2025-11-18'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-01-25', '2026-02-09'],
    ),
    'AMG CLE 53 4M Coupe_2026_885_887': ShipmentDetailPair(
      prodDates: ['2025-10-24'],
      delivDates: ['2026-01-02'],
    ),
    'AMG E 53 Hybrid 4MATIC+_2026_149_854': ShipmentDetailPair(
      prodDates: ['2025-10-07', '2025-11-11'],
      delivDates: ['2026-01-17', '2026-02-04'],
    ),
    'AMG G 63_2026_197_501': ShipmentDetailPair(
      prodDates: ['2025-10-09'],
      delivDates: ['2026-01-17'],
    ),
    'AMG G 63_2026_197_545': ShipmentDetailPair(
      prodDates: ['2025-10-17'],
      delivDates: ['2026-01-17'],
    ),
    'AMG G 63_2026_197_575': ShipmentDetailPair(
      prodDates: ['2025-11-21'],
      delivDates: ['2026-01-05'],
    ),
    'AMG G 63_2026_197_927': ShipmentDetailPair(
      prodDates: ['2025-10-01', '2025-10-08', '2025-10-18'],
      delivDates: ['2025-12-31', '2026-01-17'],
    ),
    'AMG GLB 35 4MATIC_2026_149_651': ShipmentDetailPair(
      prodDates: ['2025-11-11'],
      delivDates: ['2025-12-26'],
    ),
    'AMG GLB 35 4MATIC_2026_149_654': ShipmentDetailPair(
      prodDates: ['2025-10-14'],
      delivDates: ['2025-12-23'],
    ),
    'AMG GLB 35 4MATIC_2026_696_654': ShipmentDetailPair(
      prodDates: ['2025-12-01'],
      delivDates: ['2026-01-15'],
    ),
    'AMG GLC 43 4M Coupe_2026_149_251': ShipmentDetailPair(
      prodDates: ['2025-11-04'],
      delivDates: ['2026-01-25'],
    ),
    'AMG GLC 43 4M Coupe_2026_197_251': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-12-01'],
      delivDates: ['2026-01-25', '2026-01-30'],
    ),
    'AMG GLC 43 4M Coupe_2026_956_251': ShipmentDetailPair(
      prodDates: ['2025-10-24'],
      delivDates: ['2026-01-02'],
    ),
    'AMG GLC 43 4M_2026_149_251': ShipmentDetailPair(
      prodDates: ['2025-11-25'],
      delivDates: ['2026-02-09'],
    ),
    'AMG GLC 43 4M_2026_197_251': ShipmentDetailPair(
      prodDates: ['2025-11-25'],
      delivDates: ['2026-02-09'],
    ),
    'AMG GLE 53 4MATIC+_2026_149_857': ShipmentDetailPair(
      prodDates: ['2025-11-12', '2025-11-13'],
      delivDates: ['2026-01-11'],
    ),
    'AMG GLE 53 4MATIC+_2026_197_857': ShipmentDetailPair(
      prodDates: ['2025-11-21'],
      delivDates: ['2026-01-05'],
    ),
    'AMG GLS 63 4MATIC+_2026_149_551': ShipmentDetailPair(
      prodDates: ['2025-09-12'],
      delivDates: ['2025-12-31'],
    ),
    'AMG GT 43 4MATIC+_2026_149_507': ShipmentDetailPair(
      prodDates: ['2025-11-11', '2025-11-28'],
      delivDates: ['2026-01-30', '2026-02-02'],
    ),
    'AMG GT 43 4MATIC+_2026_149_565': ShipmentDetailPair(
      prodDates: ['2025-10-24'],
      delivDates: ['2026-01-02'],
    ),
    'AMG GT 43 4MATIC+_2026_149_801': ShipmentDetailPair(
      prodDates: ['2025-11-26'],
      delivDates: ['2026-01-30'],
    ),
    'AMG GT 43 4MATIC+_2026_197_507': ShipmentDetailPair(
      prodDates: ['2025-10-31', '2025-11-03'],
      delivDates: ['2026-01-25'],
    ),
    'AMG GT 43 4MATIC+_2026_197_554': ShipmentDetailPair(
      prodDates: ['2025-10-29', '2025-11-05'],
      delivDates: ['2026-01-25'],
    ),
    'AMG GT 43 4MATIC+_2026_197_801': ShipmentDetailPair(
      prodDates: ['2025-10-22', '2025-11-27'],
      delivDates: ['2026-01-02', '2026-01-30'],
    ),
    'AMG GT 63 S e Performance_2026_190_807': ShipmentDetailPair(
      prodDates: ['2025-10-02'],
      delivDates: ['2025-12-22'],
    ),
    'AMG GT 63 S e Performance_2026_56_807': ShipmentDetailPair(
      prodDates: ['2025-11-08'],
      delivDates: ['2026-01-25'],
    ),
    'AMG GT 63 S e Performance_2026_818_967': ShipmentDetailPair(
      prodDates: ['2025-11-10'],
      delivDates: ['2026-01-25'],
    ),
    'AMG S 63 e Performance_2025_197_551': ShipmentDetailPair(
      prodDates: ['2025-03-24'],
      delivDates: ['2025-07-28'],
    ),
    'AMG S 63 e Performance_2026_885_557': ShipmentDetailPair(
      prodDates: ['2025-09-25'],
      delivDates: ['2025-12-26'],
    ),
    'AMG SL 43_2026_885_801': ShipmentDetailPair(
      prodDates: ['2025-10-29'],
      delivDates: ['2026-01-02'],
    ),
    'AMG SL 43_2026_885_804': ShipmentDetailPair(
      prodDates: ['2025-11-26'],
      delivDates: ['2026-02-02'],
    ),
    'AMG SL 43_2026_885_807': ShipmentDetailPair(
      prodDates: ['2025-11-20'],
      delivDates: ['2026-02-02'],
    ),
    'C 200 AMG Line_2026_149_118': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-11-07'],
      delivDates: ['2026-01-25'],
    ),
    'C 200 AMG Line_2026_149_194': ShipmentDetailPair(
      prodDates: ['2025-10-30', '2025-11-10'],
      delivDates: ['2026-01-02', '2026-01-25'],
    ),
    'C 200 AMG Line_2026_197_118': ShipmentDetailPair(
      prodDates: ['2025-11-20'],
      delivDates: ['2026-02-09'],
    ),
    'C 200 AMG Line_2026_197_194': ShipmentDetailPair(
      prodDates: ['2025-11-07'],
      delivDates: ['2026-01-25'],
    ),
    'C 200 Avantgarde_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-11-05'],
      delivDates: ['2026-01-25'],
    ),
    'C 200 Avantgarde_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-10-30', '2025-11-03', '2025-11-05', '2025-11-07', '2025-11-11', '2025-11-13'],
      delivDates: ['2026-01-02', '2026-01-25', '2026-02-09'],
    ),
    'C 200 Avantgarde_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-11-14'],
      delivDates: ['2026-01-25'],
    ),
    'C 200 Avantgarde_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-11-14'],
      delivDates: ['2026-01-02', '2026-01-25'],
    ),
    'C 200 Avantgarde_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-11-04'],
      delivDates: ['2026-01-02', '2026-01-25'],
    ),
    'CLA 250 4M AMG Line_2026_149_651': ShipmentDetailPair(
      prodDates: ['2025-09-02', '2025-09-04', '2025-10-01', '2025-11-05'],
      delivDates: ['2025-11-17', '2025-12-12', '2025-12-19', '2025-12-26'],
    ),
    'CLA 250 4M AMG Line_2026_149_654': ShipmentDetailPair(
      prodDates: ['2025-09-02', '2025-09-04', '2025-09-08', '2025-09-09', '2025-09-10', '2025-09-17', '2025-11-04', '2025-11-05'],
      delivDates: ['2025-11-17', '2025-12-08', '2025-12-12', '2025-12-19'],
    ),
    'CLA 250 4M AMG Line_2026_696_651': ShipmentDetailPair(
      prodDates: ['2025-09-02', '2025-11-18'],
      delivDates: ['2025-12-12', '2026-01-02'],
    ),
    'CLA 250 4M AMG Line_2026_696_654': ShipmentDetailPair(
      prodDates: ['2025-09-03', '2025-09-11', '2025-09-30'],
      delivDates: ['2025-12-12', '2025-12-26'],
    ),
    'CLE 200 Cabriolet_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-10-09'],
      delivDates: ['2025-12-22'],
    ),
    'CLE 200 Cabriolet_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-06', '2025-10-10', '2025-10-24', '2025-10-28', '2025-11-25', '2025-11-27', '2025-11-28'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-01-30', '2026-02-09'],
    ),
    'CLE 200 Cabriolet_2026_149_205': ShipmentDetailPair(
      prodDates: ['2025-10-21'],
      delivDates: ['2026-01-02'],
    ),
    'CLE 200 Cabriolet_2026_149_207': ShipmentDetailPair(
      prodDates: ['2025-10-17', '2025-10-23', '2025-10-24', '2025-11-18', '2025-11-25', '2025-11-26', '2025-11-28'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-01-30', '2026-02-02', '2026-02-09'],
    ),
    'CLE 200 Cabriolet_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-10-27', '2025-11-11', '2025-11-25', '2025-11-27', '2025-12-02'],
      delivDates: ['2026-01-02', '2026-01-30', '2026-02-02', '2026-02-09'],
    ),
    'CLE 200 Cabriolet_2026_197_207': ShipmentDetailPair(
      prodDates: ['2025-10-17', '2025-10-23', '2025-10-24', '2025-11-19', '2025-11-27', '2025-11-28'],
      delivDates: ['2026-01-02', '2026-01-30', '2026-02-02', '2026-02-09'],
    ),
    'CLE 200 Cabriolet_2026_818_105': ShipmentDetailPair(
      prodDates: ['2025-11-20'],
      delivDates: ['2026-02-09'],
    ),
    'CLE 200 Cabriolet_2026_831_105': ShipmentDetailPair(
      prodDates: ['2025-10-07'],
      delivDates: ['2025-12-22'],
    ),
    'CLE 200 Cabriolet_2026_956_105': ShipmentDetailPair(
      prodDates: ['2025-10-30'],
      delivDates: ['2026-01-02'],
    ),
    'CLE 200 Coupe_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-11-05'],
      delivDates: ['2026-01-25'],
    ),
    'CLE 200 Coupe_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-10-21', '2025-10-29', '2025-11-10'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-02-02'],
    ),
    'CLE 200 Coupe_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-01', '2025-10-07', '2025-10-14', '2025-10-17', '2025-11-17', '2025-11-27'],
      delivDates: ['2025-12-22', '2026-02-09'],
    ),
    'CLE 200 Coupe_2026_149_207': ShipmentDetailPair(
      prodDates: ['2025-11-19', '2025-11-28'],
      delivDates: ['2026-01-30', '2026-02-09'],
    ),
    'CLE 200 Coupe_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-10-23'],
      delivDates: ['2026-01-02'],
    ),
    'CLE 200 Coupe_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-10-28', '2025-11-03', '2025-11-11', '2025-11-26'],
      delivDates: ['2026-01-02', '2026-02-02', '2026-02-09'],
    ),
    'CLE 200 Coupe_2026_197_207': ShipmentDetailPair(
      prodDates: ['2025-11-18', '2025-11-26', '2025-11-28'],
      delivDates: ['2026-02-09'],
    ),
    'CLE 450 4M Cabriolet_2026_149_207': ShipmentDetailPair(
      prodDates: ['2025-11-11'],
      delivDates: ['2026-02-09'],
    ),
    'CLE 450 4M Coupe_2026_197_207': ShipmentDetailPair(
      prodDates: ['2025-11-17'],
      delivDates: ['2026-02-02'],
    ),
    'E 200 AMG Line_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-10-02', '2025-10-06', '2025-10-07', '2025-10-08', '2025-10-09', '2025-10-10', '2025-10-15', '2025-11-07', '2025-11-09', '2025-11-10', '2025-11-11', '2025-11-12', '2025-11-13', '2025-11-16', '2025-11-17', '2025-11-18', '2025-11-20', '2025-11-26', '2025-11-27', '2025-11-28', '2025-11-30', '2025-12-01', '2025-12-02', '2025-12-03', '2025-12-04', '2025-12-05', '2025-12-09', '2025-12-10'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-30', '2025-12-31', '2026-01-02', '2026-01-05', '2026-01-10', '2026-01-12', '2026-01-14', '2026-01-15', '2026-01-16', '2026-01-17', '2026-01-19', '2026-01-22', '2026-02-04', '2026-03-02'],
    ),
    'E 200 AMG Line_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-07', '2025-10-09', '2025-11-11', '2025-11-12', '2025-11-14', '2025-11-25', '2025-11-28', '2025-12-01', '2025-12-02', '2025-12-03', '2025-12-08', '2025-12-09'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-31', '2026-01-08', '2026-01-09', '2026-01-12', '2026-01-15', '2026-01-16', '2026-01-22', '2026-03-02'],
    ),
    'E 200 AMG Line_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-10-08', '2025-10-30', '2025-11-12', '2025-11-18', '2025-11-20', '2025-11-24', '2025-11-25', '2025-11-27', '2025-12-02'],
      delivDates: ['2025-12-26', '2025-12-31', '2026-01-02', '2026-01-05', '2026-01-08', '2026-01-09', '2026-01-12', '2026-01-16', '2026-02-04'],
    ),
    'E 200 AMG Line_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-10-07', '2025-10-10', '2025-11-07', '2025-11-11', '2025-11-21', '2025-11-25', '2025-11-27', '2025-12-02'],
      delivDates: ['2025-12-26', '2026-01-05', '2026-01-08', '2026-01-10', '2026-01-12', '2026-01-15', '2026-02-04'],
    ),
    'E 200 AMG Line_2026_831_104': ShipmentDetailPair(
      prodDates: ['2025-10-06', '2025-11-14', '2025-11-20', '2025-11-25', '2025-11-28', '2025-12-02', '2025-12-04'],
      delivDates: ['2025-12-26', '2025-12-29', '2026-01-05', '2026-01-08', '2026-01-12', '2026-01-16', '2026-01-19'],
    ),
    'E 200 AMG Line_2026_831_105': ShipmentDetailPair(
      prodDates: ['2025-12-04'],
      delivDates: ['2026-01-19'],
    ),
    'E 200 Avantgarde_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-10-22', '2025-10-23'],
      delivDates: ['2026-02-04'],
    ),
    'E 200 Avantgarde_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-09-26', '2025-09-28', '2025-09-29', '2025-09-30', '2025-10-01', '2025-10-06', '2025-10-13', '2025-10-14', '2025-10-16', '2025-10-17', '2025-10-20', '2025-10-21', '2025-10-24', '2025-10-27', '2025-10-28', '2025-10-29', '2025-11-17', '2025-11-18', '2025-11-20', '2025-11-21', '2025-11-24', '2025-11-25', '2025-11-26', '2025-11-28', '2025-12-01', '2025-12-02', '2025-12-03', '2025-12-04', '2025-12-05', '2025-12-07', '2025-12-08', '2025-12-11'],
      delivDates: ['2025-12-26', '2025-12-31', '2026-01-02', '2026-01-05', '2026-01-07', '2026-01-09', '2026-01-10', '2026-01-12', '2026-01-14', '2026-01-16', '2026-01-17', '2026-01-19', '2026-01-21', '2026-01-26', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-02', '2025-10-09', '2025-10-17', '2025-10-23', '2025-10-29', '2025-10-30', '2025-11-11', '2025-11-14', '2025-11-20', '2025-11-24', '2025-11-27', '2025-12-01', '2025-12-05', '2025-12-08', '2025-12-09'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-31', '2026-01-05', '2026-01-07', '2026-01-12', '2026-01-15', '2026-01-17', '2026-01-19', '2026-01-21', '2026-01-22', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_188_104': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-10-24', '2025-10-29'],
      delivDates: ['2025-12-26', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_197_101': ShipmentDetailPair(
      prodDates: ['2025-10-23'],
      delivDates: ['2026-02-04'],
    ),
    'E 200 Avantgarde_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-09-23', '2025-09-26', '2025-09-29', '2025-10-01', '2025-10-06', '2025-10-14', '2025-10-17', '2025-10-20', '2025-10-23', '2025-10-30', '2025-11-03', '2025-11-05', '2025-11-11', '2025-11-14', '2025-11-18', '2025-11-20', '2025-11-21', '2025-12-01', '2025-12-02', '2025-12-03'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-31', '2026-01-02', '2026-01-05', '2026-01-10', '2026-01-15', '2026-01-16', '2026-01-17', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-09-18', '2025-09-26', '2025-09-30', '2025-10-10', '2025-10-13', '2025-10-21', '2025-10-22', '2025-10-28', '2025-11-20', '2025-11-24', '2025-11-25', '2025-11-27'],
      delivDates: ['2025-12-12', '2025-12-26', '2025-12-31', '2026-01-05', '2026-01-08', '2026-01-09', '2026-01-10', '2026-01-12', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_771_104': ShipmentDetailPair(
      prodDates: ['2025-09-29', '2025-10-20', '2025-10-23', '2025-10-24'],
      delivDates: ['2026-01-10', '2026-01-17', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_831_104': ShipmentDetailPair(
      prodDates: ['2025-09-19', '2025-09-25', '2025-09-30', '2025-10-02', '2025-10-06', '2025-10-21', '2025-10-27', '2025-10-29', '2025-11-13', '2025-11-14', '2025-11-19', '2025-11-21', '2025-11-24'],
      delivDates: ['2025-12-26', '2025-12-29', '2026-01-05', '2026-01-07', '2026-02-04'],
    ),
    'E 200 Avantgarde_2026_922_104': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-10-17', '2025-10-29'],
      delivDates: ['2025-12-26', '2026-02-04'],
    ),
    'E 220 d 4MATIC Exclusive_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-11-11', '2025-12-05'],
      delivDates: ['2026-01-17', '2026-01-19'],
    ),
    'E 220 d 4MATIC Exclusive_2026_149_114': ShipmentDetailPair(
      prodDates: ['2025-10-22', '2025-10-27', '2025-11-13', '2025-11-18', '2025-12-01', '2025-12-02'],
      delivDates: ['2025-12-29', '2026-01-02', '2026-01-14', '2026-01-16', '2026-01-17'],
    ),
    'E 220 d 4MATIC Exclusive_2026_149_115': ShipmentDetailPair(
      prodDates: ['2025-11-07', '2025-11-13', '2025-11-17'],
      delivDates: ['2025-12-31', '2026-01-17'],
    ),
    'E 220 d 4MATIC Exclusive_2026_197_114': ShipmentDetailPair(
      prodDates: ['2025-10-24', '2025-10-28'],
      delivDates: ['2026-01-17'],
    ),
    'E 220 d 4MATIC Exclusive_2026_197_115': ShipmentDetailPair(
      prodDates: ['2025-09-26', '2025-11-28'],
      delivDates: ['2025-12-26', '2026-01-12'],
    ),
    'E 300 4M AMG Line_2026_149_205': ShipmentDetailPair(
      prodDates: ['2025-09-19', '2025-10-10', '2025-10-14', '2025-10-30', '2025-11-11', '2025-11-12', '2025-11-13', '2025-11-19', '2025-11-21', '2025-12-01', '2025-12-03', '2025-12-08'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-31', '2026-01-02', '2026-01-05', '2026-01-10', '2026-01-15', '2026-01-16', '2026-01-19', '2026-01-21', '2026-02-04'],
    ),
    'E 300 4M AMG Line_2026_149_214': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-09-23', '2025-10-07', '2025-10-22', '2025-11-07', '2025-11-17', '2025-11-18', '2025-11-20', '2025-11-24', '2025-11-25', '2025-11-27', '2025-11-28', '2025-12-01', '2025-12-03', '2025-12-04', '2025-12-08'],
      delivDates: ['2025-12-26', '2025-12-30', '2025-12-31', '2026-01-02', '2026-01-05', '2026-01-08', '2026-01-12', '2026-01-14', '2026-01-19', '2026-01-22', '2026-02-04'],
    ),
    'E 300 4M AMG Line_2026_197_205': ShipmentDetailPair(
      prodDates: ['2025-09-23', '2025-10-14', '2025-10-15', '2025-11-13', '2025-11-28', '2025-12-04', '2025-12-10'],
      delivDates: ['2025-12-26', '2025-12-29', '2026-01-10', '2026-01-12', '2026-01-17', '2026-01-19', '2026-01-26'],
    ),
    'E 300 4M AMG Line_2026_197_214': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-09-23', '2025-10-13', '2025-10-15', '2025-10-16', '2025-11-07', '2025-11-20', '2025-11-24', '2025-11-25', '2025-12-08'],
      delivDates: ['2025-12-26', '2025-12-31', '2026-01-05', '2026-01-07', '2026-01-08', '2026-01-22', '2026-02-04'],
    ),
    'E 300 4M AMG Line_2026_831_214': ShipmentDetailPair(
      prodDates: ['2025-09-24', '2025-09-25', '2025-10-14', '2025-10-24', '2025-11-18', '2025-11-19'],
      delivDates: ['2025-12-26', '2026-01-02', '2026-01-05', '2026-01-10', '2026-02-04'],
    ),
    'E 300 4M AMG Line_2026_956_205': ShipmentDetailPair(
      prodDates: ['2025-11-25'],
      delivDates: ['2026-01-08'],
    ),
    'E 300 4M AMG Line_2026_956_214': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-10-08', '2025-10-10', '2025-10-14', '2025-10-30'],
      delivDates: ['2025-12-26', '2025-12-30', '2026-01-10', '2026-01-17', '2026-02-04'],
    ),
    'E 300 4M AMG Line_2026_956_221': ShipmentDetailPair(
      prodDates: ['2025-09-22'],
      delivDates: ['2025-12-26', '2026-01-17'],
    ),
    'E 300 4M EX_2026_149_201': ShipmentDetailPair(
      prodDates: ['2025-11-12', '2025-11-27'],
      delivDates: ['2025-12-29', '2026-01-12'],
    ),
    'E 300 4M EX_2026_149_214': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-09-26', '2025-10-14', '2025-10-15', '2025-10-16', '2025-10-17', '2025-10-20', '2025-10-21', '2025-10-23', '2025-10-24', '2025-10-27', '2025-10-28', '2025-11-04', '2025-11-05', '2025-11-07', '2025-11-10', '2025-11-13', '2025-11-21', '2025-11-24', '2025-11-25', '2025-11-26', '2025-11-27', '2025-11-28', '2025-12-01', '2025-12-04', '2025-12-07', '2025-12-08', '2025-12-09'],
      delivDates: ['2025-12-26', '2025-12-29', '2026-01-05', '2026-01-07', '2026-01-08', '2026-01-10', '2026-01-12', '2026-01-15', '2026-01-17', '2026-01-19', '2026-01-21', '2026-01-22', '2026-02-04'],
    ),
    'E 300 4M EX_2026_149_215': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-10-17', '2025-10-22', '2025-10-27', '2025-11-12', '2025-11-17', '2025-11-20', '2025-12-01', '2025-12-08'],
      delivDates: ['2025-12-26', '2025-12-31', '2026-01-05', '2026-01-14', '2026-01-17', '2026-01-22', '2026-02-04'],
    ),
    'E 300 4M EX_2026_197_214': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-10-09', '2025-10-20', '2025-10-23', '2025-10-28', '2025-11-07', '2025-11-10', '2025-11-12', '2025-11-13', '2025-11-17', '2025-11-24', '2025-11-26', '2025-11-28', '2025-12-03', '2025-12-05'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-31', '2026-01-08', '2026-01-12', '2026-01-17', '2026-01-19', '2026-02-04'],
    ),
    'E 300 4M EX_2026_197_215': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-10-15', '2025-10-21', '2025-10-29', '2025-11-17', '2025-11-25', '2025-12-02'],
      delivDates: ['2025-12-26', '2025-12-31', '2026-01-08', '2026-01-16', '2026-02-04'],
    ),
    'E 300 4M EX_2026_771_214': ShipmentDetailPair(
      prodDates: ['2025-10-10', '2025-10-29'],
      delivDates: ['2025-12-31', '2026-02-04'],
    ),
    'E 300 4M EX_2026_831_214': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-10-07', '2025-10-13', '2025-10-28', '2025-10-30', '2025-11-14', '2025-11-18', '2025-11-24'],
      delivDates: ['2025-12-26', '2025-12-29', '2025-12-31', '2026-01-02', '2026-01-07', '2026-02-04'],
    ),
    'E 300 4M EX_2026_831_215': ShipmentDetailPair(
      prodDates: ['2025-10-23'],
      delivDates: ['2026-02-04'],
    ),
    'E 300 4M EX_2026_922_214': ShipmentDetailPair(
      prodDates: ['2025-10-13', '2025-10-16'],
      delivDates: ['2025-12-30', '2026-02-04'],
    ),
    'E 350 e 4MATIC_2026_149_214': ShipmentDetailPair(
      prodDates: ['2025-08-26', '2025-09-08', '2025-09-10', '2025-09-11', '2025-09-17', '2025-09-19', '2025-09-22', '2025-09-29', '2025-10-01', '2025-10-08', '2025-10-10', '2025-10-20', '2025-10-21', '2025-11-07', '2025-11-10', '2025-11-17', '2025-11-19', '2025-11-25', '2025-11-26', '2025-12-09', '2025-12-10'],
      delivDates: ['2025-11-07', '2025-11-17', '2025-12-08', '2025-12-12', '2025-12-26', '2025-12-31', '2026-01-02', '2026-01-08', '2026-01-10', '2026-01-12', '2026-01-17', '2026-01-22', '2026-01-23', '2026-01-26', '2026-02-04'],
    ),
    'E 350 e 4MATIC_2026_149_215': ShipmentDetailPair(
      prodDates: ['2025-09-05', '2025-10-09', '2025-10-24', '2025-11-06', '2025-11-13', '2025-11-26'],
      delivDates: ['2025-11-17', '2025-12-29', '2025-12-31', '2026-01-09', '2026-02-04'],
    ),
    'E 350 e 4MATIC_2026_188_215': ShipmentDetailPair(
      prodDates: ['2025-09-09'],
      delivDates: ['2025-11-17'],
    ),
    'E 350 e 4MATIC_2026_197_201': ShipmentDetailPair(
      prodDates: ['2025-12-03'],
      delivDates: ['2026-03-02'],
    ),
    'E 350 e 4MATIC_2026_197_214': ShipmentDetailPair(
      prodDates: ['2025-09-13', '2025-09-16', '2025-09-24', '2025-10-16', '2025-10-20', '2025-10-24', '2025-11-11', '2025-11-14', '2025-11-21', '2025-12-01'],
      delivDates: ['2025-12-08', '2025-12-12', '2025-12-29', '2026-01-05', '2026-01-15', '2026-01-17', '2026-02-04'],
    ),
    'E 350 e 4MATIC_2026_197_215': ShipmentDetailPair(
      prodDates: ['2025-11-16', '2025-12-05'],
      delivDates: ['2025-12-31', '2026-03-02'],
    ),
    'E 450 4MATIC Exclusive_2026_149_801': ShipmentDetailPair(
      prodDates: ['2025-09-25', '2025-10-02', '2025-10-08'],
      delivDates: ['2025-12-26', '2025-12-31'],
    ),
    'E 450 4MATIC Exclusive_2026_149_808': ShipmentDetailPair(
      prodDates: ['2025-10-07'],
      delivDates: ['2025-12-26'],
    ),
    'E 450 4MATIC Exclusive_2026_149_814': ShipmentDetailPair(
      prodDates: ['2025-09-25', '2025-09-29', '2025-10-02', '2025-10-16'],
      delivDates: ['2025-12-26', '2026-02-04'],
    ),
    'E 450 4MATIC Exclusive_2026_197_808': ShipmentDetailPair(
      prodDates: ['2025-09-22'],
      delivDates: ['2026-01-17'],
    ),
    'E 450 4MATIC Exclusive_2026_197_814': ShipmentDetailPair(
      prodDates: ['2025-09-29', '2025-10-01', '2025-10-02'],
      delivDates: ['2025-12-26'],
    ),
    'E 450 4MATIC Exclusive_2026_831_814': ShipmentDetailPair(
      prodDates: ['2025-09-23', '2025-09-29', '2025-10-02', '2025-10-10'],
      delivDates: ['2025-12-26', '2025-12-30', '2026-01-10'],
    ),
    'E 450 4MATIC Exclusive_2026_922_814': ShipmentDetailPair(
      prodDates: ['2025-09-29'],
      delivDates: ['2025-12-26'],
    ),
    'EQA 250 AMG Line_2026_149_651': ShipmentDetailPair(
      prodDates: ['2025-08-29', '2025-10-13', '2025-10-17', '2025-10-28'],
      delivDates: ['2025-11-17', '2026-01-10', '2026-01-17', '2026-02-04'],
    ),
    'EQA 250 Progressive_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-09-19', '2025-10-07'],
      delivDates: ['2025-12-08', '2025-12-31'],
    ),
    'EQA 250 Progressive_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-09-11', '2025-10-21'],
      delivDates: ['2025-12-26', '2026-02-04'],
    ),
    'EQB 300 4M AMG Line_2026_149_651': ShipmentDetailPair(
      prodDates: ['2025-09-15', '2025-09-26', '2025-10-01', '2025-10-06', '2025-10-10', '2025-10-14', '2025-10-16', '2025-10-17', '2025-11-11', '2025-11-12', '2025-11-25'],
      delivDates: ['2025-12-12', '2025-12-26', '2025-12-29', '2026-01-08', '2026-01-17', '2026-02-04'],
    ),
    'EQB 300 4M AMG Line_2026_696_651': ShipmentDetailPair(
      prodDates: ['2025-09-19', '2025-10-07', '2025-10-09', '2025-10-29', '2025-11-13'],
      delivDates: ['2025-12-08', '2025-12-29', '2025-12-30', '2025-12-31', '2026-02-04'],
    ),
    'EQB 300 4M Progressive_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-09-15', '2025-09-19', '2025-09-22', '2025-09-23', '2025-10-02', '2025-10-03', '2025-10-06', '2025-10-07', '2025-10-08', '2025-10-09', '2025-10-13', '2025-10-14', '2025-11-10', '2025-11-11', '2025-11-12', '2025-11-14', '2025-11-17'],
      delivDates: ['2025-12-08', '2025-12-26', '2025-12-29', '2025-12-30', '2025-12-31', '2026-01-17', '2026-02-04'],
    ),
    'EQB 300 4M Progressive_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-09-24', '2025-09-30', '2025-10-02', '2025-10-06', '2025-10-10'],
      delivDates: ['2025-12-26', '2025-12-30', '2025-12-31'],
    ),
    'EQB 300 4M Progressive_2026_696_101': ShipmentDetailPair(
      prodDates: ['2025-10-02', '2025-10-09', '2025-11-03', '2025-11-04', '2025-11-10', '2025-11-18'],
      delivDates: ['2025-12-17', '2025-12-18', '2025-12-26', '2025-12-30', '2026-01-02', '2026-02-04'],
    ),
    'EQB 300 4M Progressive_2026_696_105': ShipmentDetailPair(
      prodDates: ['2025-10-02', '2025-11-12'],
      delivDates: ['2025-12-30', '2026-02-04'],
    ),
    'EQB 300 4M Progressive_2026_787_101': ShipmentDetailPair(
      prodDates: ['2025-09-23', '2025-10-01'],
      delivDates: ['2025-12-26'],
    ),
    'EQB 300 4M Progressive_2026_922_101': ShipmentDetailPair(
      prodDates: ['2025-09-22', '2025-10-08'],
      delivDates: ['2025-12-30', '2025-12-31'],
    ),
    'EQE 350+ SUV_2026_149_109': ShipmentDetailPair(
      prodDates: ['2025-07-24', '2025-08-27', '2025-10-16'],
      delivDates: ['2025-10-24', '2026-01-11'],
    ),
    'EQE 350+ SUV_2026_149_111': ShipmentDetailPair(
      prodDates: ['2025-09-19', '2025-10-23'],
      delivDates: ['2025-12-05', '2025-12-31'],
    ),
    'EQE 350+ SUV_2026_149_119': ShipmentDetailPair(
      prodDates: ['2025-11-07'],
      delivDates: ['2026-01-11'],
    ),
    'EQE 350+ SUV_2026_149_121': ShipmentDetailPair(
      prodDates: ['2025-10-14'],
      delivDates: ['2025-12-16'],
    ),
    'EQE 350+ SUV_2026_197_109': ShipmentDetailPair(
      prodDates: ['2025-08-22'],
      delivDates: ['2025-10-24'],
    ),
    'EQE 350+ SUV_2026_197_111': ShipmentDetailPair(
      prodDates: ['2025-10-24'],
      delivDates: ['2025-12-08'],
    ),
    'EQE 350+ SUV_2026_197_121': ShipmentDetailPair(
      prodDates: ['2025-12-04'],
      delivDates: ['2026-01-19'],
    ),
    'EQE 350+_2026_149_209': ShipmentDetailPair(
      prodDates: ['2025-08-18', '2025-10-27'],
      delivDates: ['2025-12-05', '2026-01-02'],
    ),
    'EQE 350+_2026_831_209': ShipmentDetailPair(
      prodDates: ['2025-09-12', '2025-10-07'],
      delivDates: ['2025-12-05', '2025-12-22'],
    ),
    'EQE 500 4MATIC SUV_2026_149_201': ShipmentDetailPair(
      prodDates: ['2025-07-23'],
      delivDates: ['2025-10-10'],
    ),
    'EQE 500 4MATIC SUV_2026_149_209': ShipmentDetailPair(
      prodDates: ['2025-07-23', '2025-08-21'],
      delivDates: ['2025-10-10', '2025-10-24'],
    ),
    'EQE 500 4MATIC SUV_2026_197_209': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-05'],
    ),
    'EQE 500 4MATIC SUV_2026_771_209': ShipmentDetailPair(
      prodDates: ['2025-12-16'],
      delivDates: ['2026-01-30'],
    ),
    'EQE 500 4MATIC SUV_2026_956_209': ShipmentDetailPair(
      prodDates: ['2025-10-24'],
      delivDates: ['2026-01-11'],
    ),
    'EQS 450 4MATIC SUV_2026_149_209': ShipmentDetailPair(
      prodDates: ['2025-08-28', '2026-01-09'],
      delivDates: ['2025-10-24', '2025-12-30'],
    ),
    'EQS 450 4MATIC SUV_2026_197_201': ShipmentDetailPair(
      prodDates: ['2025-09-26'],
      delivDates: ['2025-12-05'],
    ),
    'EQS 450 4MATIC SUV_2026_197_209': ShipmentDetailPair(
      prodDates: ['2025-12-02'],
      delivDates: ['2026-01-15'],
    ),
    'G 450 d_2026_149_501': ShipmentDetailPair(
      prodDates: ['2025-11-22', '2025-11-24', '2025-11-26'],
      delivDates: ['2026-01-06', '2026-01-08', '2026-01-12'],
    ),
    'G 450 d_2026_149_545': ShipmentDetailPair(
      prodDates: ['2025-11-14'],
      delivDates: ['2025-12-29'],
    ),
    'G 450 d_2026_149_575': ShipmentDetailPair(
      prodDates: ['2025-11-07'],
      delivDates: ['2026-02-04'],
    ),
    'G 450 d_2026_149_927': ShipmentDetailPair(
      prodDates: ['2025-11-04', '2025-11-05', '2025-11-15', '2025-11-18', '2025-11-19', '2025-11-22'],
      delivDates: ['2025-12-30', '2026-01-02', '2026-01-06', '2026-02-04'],
    ),
    'G 450 d_2026_197_545': ShipmentDetailPair(
      prodDates: ['2025-10-30', '2025-10-31', '2025-11-14'],
      delivDates: ['2025-12-29', '2026-02-04'],
    ),
    'G 450 d_2026_197_575': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-11-06', '2025-11-25', '2025-11-28'],
      delivDates: ['2026-01-09', '2026-01-12', '2026-02-04'],
    ),
    'G 580 w/ EQ Technology_2026_197_927': ShipmentDetailPair(
      prodDates: ['2025-10-04'],
      delivDates: ['2025-12-31'],
    ),
    'GLA 250 4M AMG Line_2026_149_651': ShipmentDetailPair(
      prodDates: ['2025-09-08', '2025-09-22', '2025-11-11', '2025-11-19', '2025-11-30'],
      delivDates: ['2025-12-08', '2025-12-12', '2025-12-26', '2026-01-02', '2026-01-14'],
    ),
    'GLA 250 4M AMG Line_2026_696_654': ShipmentDetailPair(
      prodDates: ['2025-10-30'],
      delivDates: ['2025-12-15'],
    ),
    'GLB 250 4MATIC_2026_149_651': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-11-07', '2025-11-12'],
      delivDates: ['2025-12-18', '2025-12-26', '2025-12-29'],
    ),
    'GLB 250 4MATIC_2026_696_651': ShipmentDetailPair(
      prodDates: ['2025-11-07', '2025-11-10'],
      delivDates: ['2025-12-26'],
    ),
    'GLC 220 d 4MATIC_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-09-25', '2025-09-29', '2025-10-21', '2025-10-23', '2025-11-06', '2025-11-07'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-02-02'],
    ),
    'GLC 220 d 4MATIC_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-20'],
      delivDates: ['2025-12-22'],
    ),
    'GLC 220 d 4MATIC_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-09-29', '2025-10-21'],
      delivDates: ['2025-12-22', '2026-01-02'],
    ),
    'GLC 300 4M Coupe AMG Line_2026_149_111': ShipmentDetailPair(
      prodDates: ['2025-12-02', '2025-12-11'],
      delivDates: ['2026-01-30'],
    ),
    'GLC 300 4M Coupe AMG Line_2026_149_194': ShipmentDetailPair(
      prodDates: ['2025-11-06'],
      delivDates: ['2026-02-02'],
    ),
    'GLC 300 4M Coupe AMG Line_2026_197_111': ShipmentDetailPair(
      prodDates: ['2025-11-10'],
      delivDates: ['2026-01-25'],
    ),
    'GLC 300 4M Coupe AMG Line_2026_956_118': ShipmentDetailPair(
      prodDates: ['2025-10-14', '2025-10-16', '2025-11-24'],
      delivDates: ['2025-12-22', '2026-02-02'],
    ),
    'GLC 300 4M Coupe AMG Line_2026_956_194': ShipmentDetailPair(
      prodDates: ['2025-10-10', '2025-11-26'],
      delivDates: ['2025-12-22', '2026-02-02'],
    ),
    'GLC 300 4M Coupe AV_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-10-01', '2025-10-02', '2025-10-09', '2025-11-04', '2025-11-07', '2025-11-10', '2025-11-11', '2025-11-18', '2025-12-04', '2025-12-05', '2025-12-08'],
      delivDates: ['2025-12-22', '2026-01-25', '2026-01-30', '2026-02-02', '2026-02-08', '2026-02-09'],
    ),
    'GLC 300 4M Coupe AV_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-07', '2025-11-06', '2025-12-08'],
      delivDates: ['2025-12-22', '2026-02-02', '2026-02-08'],
    ),
    'GLC 300 4M Coupe AV_2026_197_101': ShipmentDetailPair(
      prodDates: ['2025-10-10', '2025-12-09'],
      delivDates: ['2025-12-22', '2026-02-08'],
    ),
    'GLC 300 4M Coupe AV_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-10-02', '2025-10-10', '2025-10-16', '2025-11-12', '2025-12-05'],
      delivDates: ['2025-12-22', '2026-01-25', '2026-01-30'],
    ),
    'GLC 300 4M Coupe AV_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-12-05'],
      delivDates: ['2026-02-08'],
    ),
    'GLC 300 4M Coupe AV_2026_831_104': ShipmentDetailPair(
      prodDates: ['2025-11-20'],
      delivDates: ['2026-02-02'],
    ),
    'GLC 300 4M Coupe AV_2026_956_104': ShipmentDetailPair(
      prodDates: ['2025-11-19'],
      delivDates: ['2026-02-09'],
    ),
    'GLC 300 4MATIC AMG Line_2026_149_111': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-22'],
    ),
    'GLC 300 4MATIC AMG Line_2026_149_118': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-11-20'],
      delivDates: ['2025-12-22', '2026-02-02'],
    ),
    'GLC 300 4MATIC AMG Line_2026_149_194': ShipmentDetailPair(
      prodDates: ['2025-09-25', '2025-10-09', '2025-10-10', '2025-10-16', '2025-10-23', '2025-10-29', '2025-11-07', '2025-11-16', '2025-11-19', '2025-11-20', '2025-11-21', '2025-11-25'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-01-25', '2026-02-02', '2026-02-09'],
    ),
    'GLC 300 4MATIC AMG Line_2026_197_111': ShipmentDetailPair(
      prodDates: ['2025-11-10'],
      delivDates: ['2026-01-25'],
    ),
    'GLC 300 4MATIC AMG Line_2026_197_118': ShipmentDetailPair(
      prodDates: ['2025-11-10', '2025-11-26'],
      delivDates: ['2026-01-25', '2026-02-09'],
    ),
    'GLC 300 4MATIC AMG Line_2026_197_194': ShipmentDetailPair(
      prodDates: ['2025-10-22', '2025-11-20', '2025-11-21', '2025-11-26'],
      delivDates: ['2026-01-02', '2026-02-09'],
    ),
    'GLC 300 4MATIC AMG Line_2026_956_194': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-22'],
    ),
    'GLC 300 4MATIC AV_2026_149_101': ShipmentDetailPair(
      prodDates: ['2025-10-23', '2025-10-29'],
      delivDates: ['2026-01-02'],
    ),
    'GLC 300 4MATIC AV_2026_149_104': ShipmentDetailPair(
      prodDates: ['2025-10-07', '2025-10-08', '2025-10-20', '2025-10-24', '2025-10-28', '2025-11-11', '2025-11-12', '2025-11-18', '2025-11-19', '2025-11-21', '2025-11-26'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-01-25', '2026-02-02'],
    ),
    'GLC 300 4MATIC AV_2026_149_105': ShipmentDetailPair(
      prodDates: ['2025-10-17', '2025-11-14', '2025-11-19'],
      delivDates: ['2025-12-22', '2026-01-25', '2026-02-02'],
    ),
    'GLC 300 4MATIC AV_2026_188_104': ShipmentDetailPair(
      prodDates: ['2025-10-06'],
      delivDates: ['2025-12-22'],
    ),
    'GLC 300 4MATIC AV_2026_197_101': ShipmentDetailPair(
      prodDates: ['2025-11-12'],
      delivDates: ['2026-01-25'],
    ),
    'GLC 300 4MATIC AV_2026_197_104': ShipmentDetailPair(
      prodDates: ['2025-10-01', '2025-10-07', '2025-10-09', '2025-10-20', '2025-10-23', '2025-10-30', '2025-11-12', '2025-11-19', '2025-11-21', '2025-11-24'],
      delivDates: ['2025-12-22', '2026-01-02', '2026-01-25', '2026-02-02'],
    ),
    'GLC 300 4MATIC AV_2026_197_105': ShipmentDetailPair(
      prodDates: ['2025-11-26'],
      delivDates: ['2026-02-02'],
    ),
    'GLC 300 4MATIC AV_2026_831_104': ShipmentDetailPair(
      prodDates: ['2025-10-21', '2025-11-13', '2025-11-14'],
      delivDates: ['2026-01-02', '2026-01-25'],
    ),
    'GLC 300 4MATIC AV_2026_831_105': ShipmentDetailPair(
      prodDates: ['2025-11-17'],
      delivDates: ['2026-01-25'],
    ),
    'GLC 300 4MATIC AV_2026_956_104': ShipmentDetailPair(
      prodDates: ['2025-11-25'],
      delivDates: ['2026-02-09'],
    ),
    'GLC 300 4MATIC AV_2026_956_105': ShipmentDetailPair(
      prodDates: ['2025-10-21'],
      delivDates: ['2026-01-02'],
    ),
    'GLE 300 d 4MATIC_2026_149_124': ShipmentDetailPair(
      prodDates: ['2025-10-20', '2025-10-28', '2025-10-31', '2025-11-06', '2025-11-10', '2025-11-11'],
      delivDates: ['2025-12-31', '2026-01-11'],
    ),
    'GLE 300 d 4MATIC_2026_197_124': ShipmentDetailPair(
      prodDates: ['2025-10-23', '2025-11-03', '2025-11-07', '2025-11-10'],
      delivDates: ['2025-12-31', '2026-01-11'],
    ),
    'GLE 300 d 4MATIC_2026_922_124': ShipmentDetailPair(
      prodDates: ['2025-10-28'],
      delivDates: ['2025-12-31'],
    ),
    'GLE 350 4MATIC_2026_149_111': ShipmentDetailPair(
      prodDates: ['2025-10-23'],
      delivDates: ['2025-12-31'],
    ),
    'GLE 350 4MATIC_2026_149_124': ShipmentDetailPair(
      prodDates: ['2025-10-23', '2025-10-29', '2025-10-30'],
      delivDates: ['2025-12-31'],
    ),
    'GLE 350 4MATIC_2026_197_111': ShipmentDetailPair(
      prodDates: ['2025-10-21'],
      delivDates: ['2025-12-31'],
    ),
    'GLE 350 4MATIC_2026_197_124': ShipmentDetailPair(
      prodDates: ['2025-10-22'],
      delivDates: ['2025-12-31'],
    ),
    'GLE 450 4M AMG Line_2026_149_951': ShipmentDetailPair(
      prodDates: ['2025-10-20', '2025-10-21', '2025-10-22', '2025-10-30', '2025-11-03', '2025-11-10', '2025-11-11', '2025-11-12', '2025-11-13', '2025-11-17', '2025-11-21', '2025-12-02'],
      delivDates: ['2025-12-31', '2026-01-05', '2026-01-11', '2026-01-16'],
    ),
    'GLE 450 4M AMG Line_2026_197_951': ShipmentDetailPair(
      prodDates: ['2025-10-22', '2025-10-27', '2025-10-30', '2025-11-11'],
      delivDates: ['2025-12-31', '2026-01-11'],
    ),
    'GLE 450 4M AMG Line_2026_922_951': ShipmentDetailPair(
      prodDates: ['2025-12-02'],
      delivDates: ['2026-01-16'],
    ),
    'GLE 450 4M AMG Line_2026_992_951': ShipmentDetailPair(
      prodDates: ['2025-10-16'],
      delivDates: ['2025-12-31'],
    ),
    'GLE 450 4MATIC_2026_149_111': ShipmentDetailPair(
      prodDates: ['2025-11-18'],
      delivDates: ['2026-01-02'],
    ),
    'GLE 450 4MATIC_2026_149_124': ShipmentDetailPair(
      prodDates: ['2025-10-20', '2025-10-22', '2025-11-03', '2025-11-04', '2025-11-05', '2025-11-12', '2025-11-19', '2025-11-20', '2025-11-24', '2025-11-25', '2025-12-02', '2025-12-03'],
      delivDates: ['2025-12-31', '2026-01-02', '2026-01-05', '2026-01-08', '2026-01-11', '2026-01-16'],
    ),
    'GLE 450 4MATIC_2026_197_111': ShipmentDetailPair(
      prodDates: ['2025-11-18', '2025-11-30'],
      delivDates: ['2026-01-02', '2026-01-14'],
    ),
    'GLE 450 4MATIC_2026_197_124': ShipmentDetailPair(
      prodDates: ['2025-11-03', '2025-11-19', '2025-11-20', '2025-11-24', '2025-11-25', '2025-12-02', '2025-12-03', '2025-12-04'],
      delivDates: ['2025-12-31', '2026-01-05', '2026-01-08', '2026-01-09', '2026-01-16', '2026-01-19'],
    ),
    'GLE 450 4MATIC_2026_922_111': ShipmentDetailPair(
      prodDates: ['2025-12-01'],
      delivDates: ['2026-01-15'],
    ),
    'GLS 580 4M AMG Line_2026_197_224': ShipmentDetailPair(
      prodDates: ['2025-10-15'],
      delivDates: ['2026-01-11'],
    ),
    'Maybach EQS 680 4M SUV_2026_149_514': ShipmentDetailPair(
      prodDates: ['2025-09-26'],
      delivDates: ['2025-12-05'],
    ),
    'Maybach EQS 680 4M SUV_2026_197_514': ShipmentDetailPair(
      prodDates: ['2025-09-19'],
      delivDates: ['2025-12-05'],
    ),
    'Maybach EQS 680 4M SUV_2026_771_514': ShipmentDetailPair(
      prodDates: ['2025-09-29'],
      delivDates: ['2025-12-16'],
    ),
    'Maybach GLS 600 4M Manufak_2026_385_972': ShipmentDetailPair(
      prodDates: ['2025-10-05', '2025-10-21'],
      delivDates: ['2025-12-31'],
    ),
    'Maybach GLS 600 4M Manufak_2026_922_514': ShipmentDetailPair(
      prodDates: ['2025-10-28'],
      delivDates: ['2026-01-11'],
    ),
    'Maybach GLS 600 4MATIC_2026_197_511': ShipmentDetailPair(
      prodDates: ['2025-10-02', '2025-10-12'],
      delivDates: ['2025-12-31'],
    ),
    'Maybach GLS 600 4MATIC_2026_197_514': ShipmentDetailPair(
      prodDates: ['2025-09-29', '2025-10-04', '2025-10-14', '2025-10-16', '2025-10-24', '2025-10-27'],
      delivDates: ['2025-11-27', '2025-12-31', '2026-01-11'],
    ),
    'Maybach GLS 600 4MATIC_2026_885_514': ShipmentDetailPair(
      prodDates: ['2025-10-11', '2025-10-31'],
      delivDates: ['2025-12-15', '2025-12-31'],
    ),
    'Maybach S 580 4M_2026_197_514': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-26'],
    ),
    'Maybach S 580 4M_2026_831_514': ShipmentDetailPair(
      prodDates: ['2025-09-18'],
      delivDates: ['2025-12-08'],
    ),
    'Maybach S 580 4M_2026_885_514': ShipmentDetailPair(
      prodDates: ['2025-10-17'],
      delivDates: ['2026-01-17'],
    ),
    'Maybach S 680 4M_2026_197_514': ShipmentDetailPair(
      prodDates: ['2025-09-10'],
      delivDates: ['2026-01-17'],
    ),
    'Maybach S 680 4M_2026_992_515': ShipmentDetailPair(
      prodDates: ['2025-11-04'],
      delivDates: ['2026-01-17'],
    ),
    'Maybach SL 680 Monogram Series_2026_659_509': ShipmentDetailPair(
      prodDates: ['2025-11-13', '2025-11-20'],
      delivDates: ['2026-02-02'],
    ),
    'S 350 d 4MATIC_2026_197_204': ShipmentDetailPair(
      prodDates: ['2025-09-16'],
      delivDates: ['2025-12-30'],
    ),
    'S 350 d 4MATIC_2026_197_205': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-26'],
    ),
    'S 350 d 4MATIC_2026_885_204': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-10-01'],
      delivDates: ['2025-12-26', '2025-12-30'],
    ),
    'S 450 4M SWB_2026_197_804': ShipmentDetailPair(
      prodDates: ['2025-09-16', '2025-09-17', '2025-09-19', '2025-09-23'],
      delivDates: ['2025-12-26', '2025-12-30'],
    ),
    'S 450 4M SWB_2026_197_805': ShipmentDetailPair(
      prodDates: ['2025-09-18', '2025-09-24'],
      delivDates: ['2025-12-26'],
    ),
    'S 450 4M SWB_2026_885_804': ShipmentDetailPair(
      prodDates: ['2025-09-29', '2025-10-20'],
      delivDates: ['2025-12-26', '2026-01-17'],
    ),
    'S 450 4M SWB_2026_885_805': ShipmentDetailPair(
      prodDates: ['2025-09-19'],
      delivDates: ['2025-12-26'],
    ),
    'S 450 4MATIC L_2026_197_804': ShipmentDetailPair(
      prodDates: ['2025-09-19', '2025-09-29', '2025-09-30', '2025-10-01', '2025-10-15'],
      delivDates: ['2025-12-26', '2025-12-30', '2026-01-17'],
    ),
    'S 450 4MATIC L_2026_831_804': ShipmentDetailPair(
      prodDates: ['2025-09-17'],
      delivDates: ['2025-12-30'],
    ),
    'S 450 4MATIC L_2026_885_804': ShipmentDetailPair(
      prodDates: ['2025-09-17', '2025-10-02'],
      delivDates: ['2025-12-26', '2025-12-30'],
    ),
    'S 450 4MATIC L_2026_885_805': ShipmentDetailPair(
      prodDates: ['2025-09-23'],
      delivDates: ['2025-12-30'],
    ),
    'S 500 4MATIC L_2026_197_804': ShipmentDetailPair(
      prodDates: ['2025-09-30', '2025-10-08', '2025-10-10'],
      delivDates: ['2025-12-26', '2025-12-30'],
    ),
    'S 500 4MATIC L_2026_197_805': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-26'],
    ),
    'S 500 4MATIC L_2026_885_804': ShipmentDetailPair(
      prodDates: ['2025-10-01'],
      delivDates: ['2025-12-26'],
    ),
    'S 580 4MATIC L_2026_197_501': ShipmentDetailPair(
      prodDates: ['2025-10-07'],
      delivDates: ['2025-12-30'],
    ),
    'S 580 4MATIC L_2026_197_504': ShipmentDetailPair(
      prodDates: ['2025-09-11'],
      delivDates: ['2025-12-12'],
    ),
    'S 580 4MATIC L_2026_197_507': ShipmentDetailPair(
      prodDates: ['2025-10-06'],
      delivDates: ['2025-12-26'],
    ),
  };

  /// 입항일정 조회 (모델명, MY, 색상, 트림)
  static ShipmentDetailPair? getShipment(String model, String my, String color, String trim) {
    // 키 생성 시 특수문자 이스케이프 주의 (여기서는 단순 문자열 결합)
    final key = '$model\_$my\_$color\_$trim';
    return _data[key];
  }

  /// 전체 조합 수
  static int get totalCombinations => _data.length;
}
