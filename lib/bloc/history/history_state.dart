import 'package:equatable/equatable.dart';
import '../../models/qr_history.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<QRHistory> history;
  final bool isSelectionMode;
  final Set<String> selectedItems;
  
  const HistoryLoaded({
    required this.history,
    this.isSelectionMode = false,
    Set<String>? selectedItems,
  }) : selectedItems = selectedItems ?? const {};

  HistoryLoaded copyWith({
    List<QRHistory>? history,
    bool? isSelectionMode,
    Set<String>? selectedItems,
  }) {
    return HistoryLoaded(
      history: history ?? this.history,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }

  @override
  List<Object?> get props => [history, isSelectionMode, selectedItems];
}

class HistoryError extends HistoryState {
  final String message;
  
  const HistoryError(this.message);
  
  @override
  List<Object?> get props => [message];
}

