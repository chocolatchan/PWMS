import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inbound_models.dart';
import 'inbound_controller.dart';

class InboundScreen extends ConsumerWidget {
  const InboundScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inboundControllerProvider);
    final controller = ref.read(inboundControllerProvider.notifier);

    // Show Snackbar on Error
    ref.listen<AsyncValue<InboundItem?>>(
      inboundControllerProvider,
      (previous, next) {
        if (next is AsyncError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error.toString()),
              backgroundColor: Colors.red.shade800,
            ),
          );
        } else if (next is AsyncData && next.value == null && previous?.value != null && previous is! AsyncError) {
             ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item successfully received and bound to Staging!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbound Receiving (GSP)'),
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: state.when(
        data: (item) {
          if (item == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text('Waiting for scan...', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600)),
                    const SizedBox(height: 32),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Nhập mã vạch thủ công (Dự phòng)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.keyboard),
                      ),
                      onSubmitted: (value) => controller.processScan(value),
                    ),
                  ],
                ),
              ),
            );
          }
          return _buildScanForm(context, item, controller);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) {
          // If error but we have previous data, show form with error
          final item = state.value;
          if (item != null) {
             return _buildScanForm(context, item, controller);
          }
          return Center(child: Text('Error: $e'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.mockScan(),
        icon: const Icon(Icons.qr_code),
        label: const Text('Mock Scan'),
        backgroundColor: Colors.blueGrey.shade800,
      ),
    );
  }

  Widget _buildScanForm(BuildContext context, InboundItem item, InboundController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receipt: PO-2023-10-01', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Supplier: Mega Lifesciences', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Main Scan Card
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: item.isOverReceiving ? Colors.red.shade300 : Colors.transparent, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.barcode, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
                      if (item.isToxic)
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(4)),
                           child: Text('TOXIC', style: TextStyle(color: Colors.purple.shade800, fontWeight: FontWeight.bold)),
                         )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(item.productName, style: Theme.of(context).textTheme.bodyLarge),
                  const Divider(height: 32),

                  // Qty Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: item.expectedQty.toString(),
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Expected Qty',
                            border: OutlineInputBorder(),
                            fillColor: Colors.black12,
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.actualQty == 0 ? '' : item.actualQty.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (val) => controller.updateActualQty(int.tryParse(val) ?? 0),
                          decoration: InputDecoration(
                            labelText: 'Actual Qty',
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: item.isOverReceiving ? Colors.red : Theme.of(context).primaryColor)),
                            errorText: item.isOverReceiving ? 'Nhập lố PO!' : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // UOM Calculation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text('Conversion Rate: x${item.uomRate}', style: TextStyle(color: Colors.blueGrey.shade700)),
                         Text('Base Qty: ${item.baseQty}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey.shade900, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Condition (Exceptions / Status)
                  Text('Tình trạng / Status', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<QuarantineReason>(
                    value: item.reasonCode,
                    decoration: const InputDecoration(
                      labelText: 'Trạng thái kiểm tra ngoại quan *',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: QuarantineReason.normal, child: Text('Bình thường (Chờ QC)')),
                      DropdownMenuItem(value: QuarantineReason.missingDocs, child: Text('Thiếu COA (Missing COA)')),
                      DropdownMenuItem(value: QuarantineReason.physicalDamage, child: Text('Hàng móp méo (Damaged)')),
                    ],
                    onChanged: (val) {
                      if (val != null) controller.setReasonCode(val);
                    },
                  ),

                  const Divider(height: 32),

                  // GSP Mixed Batch Rule
                  Container(
                    decoration: BoxDecoration(
                      color: item.noMixedBatch ? Colors.green.shade50 : Colors.yellow.shade50,
                      border: Border.all(color: item.noMixedBatch ? Colors.green : Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CheckboxListTile(
                      title: const Text('Tôi xác nhận đã kiểm tra vật lý, không trộn lô (No Mixed Batch)', 
                        style: TextStyle(fontWeight: FontWeight.bold)),
                      value: item.noMixedBatch,
                      onChanged: (val) => controller.toggleNoMixedBatch(val ?? false),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tote Assignment Card
          Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      const Text('Tote Binding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      Chip(
                        label: Text('Required: ${item.requiredToteCategory.prefix}***'),
                        backgroundColor: item.requiredToteCategory == ToteCategory.std ? Colors.blue.shade100 : Colors.orange.shade100,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onChanged: controller.setToteCode,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      labelText: 'Scan Tote Barcode',
                      prefixIcon: const Icon(Icons.shopping_basket),
                      border: const OutlineInputBorder(),
                      errorText: (item.toteCode.isNotEmpty && !item.toteCode.toUpperCase().startsWith(item.requiredToteCategory.prefix)) 
                                  ? 'Tote must start with ${item.requiredToteCategory.prefix}' : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Submit Button
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: item.isValid ? controller.submit : null,
              icon: const Icon(Icons.check_circle),
              label: const Text('SUBMIT TO STAGING', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade800,
                disabledBackgroundColor: Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
