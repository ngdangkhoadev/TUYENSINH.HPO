import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class DeleteHistoryItem extends HistoryEvent {
  final String id;
  
  const DeleteHistoryItem(this.id);
  
  @override
  List<Object?> get props => [id];
}

class DeleteSelectedItems extends HistoryEvent {
  final List<String> ids;
  
  const DeleteSelectedItems(this.ids);
  
  @override
  List<Object?> get props => [ids];
}

class ClearHistory extends HistoryEvent {
  const ClearHistory();
}

class ToggleSelectionMode extends HistoryEvent {
  const ToggleSelectionMode();
}

class ToggleItemSelection extends HistoryEvent {
  final String id;
  
  const ToggleItemSelection(this.id);
  
  @override
  List<Object?> get props => [id];
}

class SelectAll extends HistoryEvent {
  final List<String> allIds;
  
  const SelectAll(this.allIds);
  
  @override
  List<Object?> get props => [allIds];
}

class DeselectAll extends HistoryEvent {
  const DeselectAll();
}

