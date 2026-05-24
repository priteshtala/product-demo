part of 'bottom_nav_view.dart';

final class BottomState extends Equatable {
  final int currentIndex;

  const BottomState({this.currentIndex = 0});

  BottomState copyWith({int? currentIndex}) {
    return BottomState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}
