import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/qr_history_service.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final QRHistoryService _historyService = QRHistoryService();

  HistoryBloc() : super(const HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<DeleteHistoryItem>(_onDeleteHistoryItem);
    on<DeleteSelectedItems>(_onDeleteSelectedItems);
    on<ClearHistory>(_onClearHistory);
    on<ToggleSelectionMode>(_onToggleSelectionMode);
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<SelectAll>(_onSelectAll);
    on<DeselectAll>(_onDeselectAll);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    
    try {
      final history = await _historyService.getHistory();
      emit(HistoryLoaded(history: history));
    } catch (e) {
      emit(HistoryError('Lỗi tải lịch sử: $e'));
    }
  }

  Future<void> _onDeleteHistoryItem(
    DeleteHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _historyService.deleteFromHistory(event.id);
      
      if (state is HistoryLoaded) {
        final currentState = state as HistoryLoaded;
        final updatedHistory = currentState.history
            .where((item) => item.id != event.id)
            .toList();
        final updatedSelected = currentState.selectedItems..remove(event.id);
        
        emit(currentState.copyWith(
          history: updatedHistory,
          selectedItems: updatedSelected,
        ));
      }
    } catch (e) {
      emit(HistoryError('Lỗi xóa mục: $e'));
    }
  }

  Future<void> _onDeleteSelectedItems(
    DeleteSelectedItems event,
    Emitter<HistoryState> emit,
  ) async {
    if (event.ids.isEmpty) return;

    try {
      for (final id in event.ids) {
        await _historyService.deleteFromHistory(id);
      }
      
      if (state is HistoryLoaded) {
        final currentState = state as HistoryLoaded;
        final updatedHistory = currentState.history
            .where((item) => !event.ids.contains(item.id))
            .toList();
        
        emit(currentState.copyWith(
          history: updatedHistory,
          selectedItems: const {},
          isSelectionMode: false,
        ));
      }
    } catch (e) {
      emit(HistoryError('Lỗi xóa các mục: $e'));
    }
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      await _historyService.clearHistory();
      emit(const HistoryLoaded(history: []));
    } catch (e) {
      emit(HistoryError('Lỗi xóa lịch sử: $e'));
    }
  }

  void _onToggleSelectionMode(
    ToggleSelectionMode event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      emit(currentState.copyWith(
        isSelectionMode: !currentState.isSelectionMode,
        selectedItems: currentState.isSelectionMode ? const {} : currentState.selectedItems,
      ));
    }
  }

  void _onToggleItemSelection(
    ToggleItemSelection event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      final updatedSelected = Set<String>.from(currentState.selectedItems);
      
      if (updatedSelected.contains(event.id)) {
        updatedSelected.remove(event.id);
      } else {
        updatedSelected.add(event.id);
      }
      
      emit(currentState.copyWith(
        selectedItems: updatedSelected,
        isSelectionMode: updatedSelected.isNotEmpty || currentState.isSelectionMode,
      ));
    }
  }

  void _onSelectAll(
    SelectAll event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      emit(currentState.copyWith(
        selectedItems: event.allIds.toSet(),
        isSelectionMode: true,
      ));
    }
  }

  void _onDeselectAll(
    DeselectAll event,
    Emitter<HistoryState> emit,
  ) {
    if (state is HistoryLoaded) {
      final currentState = state as HistoryLoaded;
      emit(currentState.copyWith(
        selectedItems: const {},
        isSelectionMode: false,
      ));
    }
  }
}

