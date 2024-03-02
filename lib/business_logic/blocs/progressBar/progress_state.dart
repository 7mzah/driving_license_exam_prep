import 'package:equatable/equatable.dart';

abstract class ProgressState extends Equatable {
  const ProgressState(int i);
}

class ProgressInitial extends ProgressState {
  const ProgressInitial() : super(0);
  @override
  List<Object?> get props => [0];
}


class ProgressUpdated extends ProgressState {
  final int progressPercentage;
  final int progress; // Renamed to a generic 'progress'

  ProgressUpdated(this.progressPercentage)
      : progress = progressPercentage.clamp(0, 100), super(0);

  @override
  String toString() {
    return 'ProgressUpdated{progressPercentage: $progressPercentage, progress: $progress}';
  }

  @override
  List<Object?> get props => [progressPercentage];
}
