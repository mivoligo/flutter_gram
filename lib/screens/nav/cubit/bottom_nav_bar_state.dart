part of 'bottom_nav_bar_cubit.dart';

class BottomNavBarState extends Equatable {
  const BottomNavBarState({required this.selectedItem});

  final BottomNavItem selectedItem;

  @override
  List<Object> get props => [selectedItem];
}
