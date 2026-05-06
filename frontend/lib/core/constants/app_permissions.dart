class AppPermissions {
  // Inbound
  static const String inboundRead = 'inbound:read';
  static const String inboundWrite = 'inbound:write';

  // QC Inspection
  static const String qcInspect = 'qc:inspect';
  static const String qcRelease = 'qc:release';

  // Outbound
  static const String outboundRead = 'outbound:read';
  static const String outboundExecute = 'outbound:execute';

  // Critical Ops
  static const String recallExecute = 'recall:execute';
  static const String disposalApprove = 'disposal:approve';

  // Admin
  static const String userManage = 'user:manage';
  static const String auditRead = 'audit:read';

  static const String inventoryWrite = 'inventory:write';
  static const String putawayExecute = 'putaway:execute';
}
