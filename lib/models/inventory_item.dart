// 재고 아이템 모델
class InventoryItem {
  final String model;
  final String my; // Model Year
  final String color;
  final String trim;
  final String? price;

  // Allocation 데이터
  int allocationTotal = 0;
  int allocationContract = 0;
  int allocationAvailable = 0;
  int allocationBlocked = 0;
  int allocationWaiting = 0;

  // 온라인재고 데이터
  int onlineTotal = 0;
  int onlineContract = 0;
  int onlineAvailable = 0;
  int onlineBlocked = 0;
  int onlineWaiting = 0;

  // 입항일정 데이터
  String? earliestProdDate;
  String? latestProdDate;
  String? earliestDelivDate;
  String? latestDelivDate;
  List<ShipmentDetail> shipmentDetails = [];

  InventoryItem({
    required this.model,
    required this.my,
    required this.color,
    required this.trim,
    this.price,
  });

  // 고유 키 생성 (모델, 연식, 색상, 트림 조합)
  String get uniqueKey => '$model|$my|$color|$trim';

  // 현재 미계약 재고 계산
  int get allocationAvailableCalculated =>
      allocationTotal - allocationContract - allocationBlocked;
  int get onlineAvailableCalculated =>
      onlineTotal - onlineContract - onlineBlocked;

  // 가격 포맷팅
  String get formattedPrice {
    if (price == null || price!.isEmpty) return '가격 정보 없음';
    try {
      int priceValue = int.parse(price!.replaceAll(RegExp(r'[^0-9]'), ''));
      return '₩${_formatNumber(priceValue)}';
    } catch (e) {
      return price!;
    }
  }

  String _formatNumber(int number) {
    String numStr = number.toString();
    String result = '';
    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      result = numStr[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = ',$result';
        count = 0;
      }
    }
    return result;
  }

  @override
  String toString() {
    return 'InventoryItem{model: $model, my: $my, color: $color, trim: $trim}';
  }
}

// 입항일정 상세 정보
class ShipmentDetail {
  final String model;
  final String modelYear;
  final String colour;
  final String trim;
  final String? prodDate;
  final String? planDelivDate;

  ShipmentDetail({
    required this.model,
    required this.modelYear,
    required this.colour,
    required this.trim,
    this.prodDate,
    this.planDelivDate,
  });

  @override
  String toString() {
    return 'ShipmentDetail{model: $model, prodDate: $prodDate, delivDate: $planDelivDate}';
  }
}
