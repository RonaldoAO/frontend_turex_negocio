import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyStatusListener {
  final String companyId;
  final void Function(String status, Map<String, dynamic> row) onChange;
  RealtimeChannel? _channel;

  CompanyStatusListener({
    required this.companyId,
    required this.onChange,
  });

  void start() {
    _channel = Supabase.instance.client
        .channel('company:$companyId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'companies',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: companyId,
          ),
          callback: (payload) {
            final newRow = payload.newRecord;
            if (newRow.isEmpty) return;
            onChange(newRow['status'] as String? ?? 'UNKNOWN', newRow);
          },
        )
        .subscribe();
  }

  Future<void> stop() async {
    if (_channel != null) {
      await Supabase.instance.client.removeChannel(_channel!);
      _channel = null;
    }
  }
}
