class DriverBooking {
  final String bookingID;
  final String driverID;
  final String status;
  final String statusChangedAt;

  DriverBooking(
    this.bookingID,
    this.driverID,
    this.status,
    this.statusChangedAt,
  );

  // Factory method to create a DriverBooking from JSON
  factory DriverBooking.fromJson(Map<String, dynamic> json) {
    return DriverBooking(
      json['booking_id']?.toString() ?? '',
      json['driver_id']?.toString() ?? '',
      json['status']?.toString() ?? '',
      json['status_changed_at']?.toString() ?? '',
    );
  }

  // Method to convert DriverBooking to JSON
  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingID,
      'driver_id': driverID,
      'status': status,
      'status_changed_at': statusChangedAt,
    };
  }
}
