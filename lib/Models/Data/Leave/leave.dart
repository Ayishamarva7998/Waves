class LeaveListModel {
  String? leaveType;
  String? status;
  String? leaveDate;
  bool? isApproved;
  LeaveListModel(
      {this.leaveDate, this.leaveType, this.status, this.isApproved});
  Map<String, dynamic> tomap() {
    return {
      'leaveType': leaveType.toString(),
      'leaveDate': leaveDate.toString(),
      'status': status.toString(),
      'isApproved': isApproved
    };
  }
}
