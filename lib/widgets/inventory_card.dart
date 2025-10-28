import 'package:flutter/material.dart';
import '../models/inventory_item.dart';
import '../models/color_mapping.dart';
import 'shipment_detail_dialog.dart';

class InventoryCard extends StatefulWidget {
  final InventoryItem item;

  const InventoryCard({super.key, required this.item});

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 기본 정보 (항상 표시)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 모델명과 가격
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.item.model,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.item.price != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[50],
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Text(
                                  widget.item.formattedPrice,
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 연식
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              '연식: ${widget.item.my}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // 외장색상 (코드 + 색상명 + 색상칩)
                        Row(
                          children: [
                            const Icon(Icons.palette, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              '외장: ${widget.item.color}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (ColorMapping.getColorName(widget.item.color) != null) ..[
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '(${ColorMapping.getColorName(widget.item.color)})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _parseColor(ColorMapping.getColorHex(widget.item.color) ?? '#808080'),
                                  border: Border.all(color: Colors.grey[400]!, width: 1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        // 시트색상 (코드 + 트림명)
                        Row(
                          children: [
                            const Icon(Icons.event_seat, size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              '트림: ${widget.item.trim}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (ColorMapping.getTrimName(widget.item.trim) != null) ..[
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '(${ColorMapping.getTrimName(widget.item.trim)})',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),

              // 확장된 정보
              if (_isExpanded) ...[
                const Divider(height: 24),
                
                // Allocation 현황
                _buildInventorySection(
                  title: 'Allocation 현황',
                  total: widget.item.allocationTotal,
                  contract: widget.item.allocationContract,
                  available: widget.item.allocationAvailable,
                  blocked: widget.item.allocationBlocked,
                  waiting: widget.item.allocationWaiting,
                ),
                const SizedBox(height: 16),

                // 온라인재고 현황
                _buildInventorySection(
                  title: '온라인재고 현황',
                  total: widget.item.onlineTotal,
                  contract: widget.item.onlineContract,
                  available: widget.item.onlineAvailable,
                  blocked: widget.item.onlineBlocked,
                  waiting: widget.item.onlineWaiting,
                ),

                // 입항일정 정보
                if (widget.item.earliestProdDate != null ||
                    widget.item.earliestDelivDate != null) ...[
                  const Divider(height: 24),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '입항일정 정보',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (widget.item.earliestProdDate != null)
                          Row(
                            children: [
                              Icon(Icons.factory, size: 16, color: Colors.blue[700]),
                              const SizedBox(width: 6),
                              Text(
                                '생산일자: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${widget.item.earliestProdDate} ~ ${widget.item.latestProdDate ?? widget.item.earliestProdDate}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        if (widget.item.earliestDelivDate != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.local_shipping, size: 16, color: Colors.blue[700]),
                              const SizedBox(width: 6),
                              Text(
                                '도착예정일: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '${widget.item.earliestDelivDate} ~ ${widget.item.latestDelivDate ?? widget.item.earliestDelivDate}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (widget.item.shipmentDetails.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ShipmentDetailDialog(
                                    item: widget.item,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.list_alt, size: 18),
                              label: const Text('자세히보기'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventorySection({
    required String title,
    required int total,
    required int contract,
    required int available,
    required int blocked,
    required int waiting,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildInventoryColumn('전체재고', total, Colors.blue),
              ),
              _buildDivider(),
              Expanded(
                child: _buildInventoryColumn('현재계약', contract, Colors.orange),
              ),
              _buildDivider(),
              Expanded(
                child: _buildInventoryColumn('현재미계약', available, Colors.green),
              ),
              _buildDivider(),
              Expanded(
                child: _buildInventoryColumn('선출고불가', blocked, Colors.red),
              ),
              _buildDivider(),
              Expanded(
                child: _buildInventoryColumn('대기', waiting, Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInventoryColumn(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(horizontal: 6),
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
}
