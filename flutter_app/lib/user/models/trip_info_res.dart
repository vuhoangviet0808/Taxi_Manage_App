import '../models/step_res.dart';

class TripInfoRes{
   final int distance;
   final List<StepsRes> steps;
   
   TripInfoRes(this.distance, this.steps);
}