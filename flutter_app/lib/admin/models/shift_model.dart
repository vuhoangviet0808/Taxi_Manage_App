// ignore_for_file: non_constant_identifier_names

class Shift {
  final String ID;
  final String shift_start_time;

  Shift(this.ID, this.shift_start_time);
}

class FullShift {
  final String ID;
  final String Driver_id;
  final String cab_id;
  final String shift_start_time;
  final String shift_end_time;
  final String login_time;
  final String logout_time;

  FullShift(this.ID, this.Driver_id, this.cab_id, this.shift_start_time,
      this.shift_end_time, this.login_time, this.logout_time);
}
