import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../bloc/history/history_state.dart';
import '../models/qr_history.dart';
import '../models/qr_person_info.dart';
import '../models/course_type.dart';
import '../widgets/manual_entry_dialog.dart';
import '../widgets/history_detail_dialog.dart';
import '../widgets/history_item_card.dart';
import '../utils/dialog_helpers.dart';
import 'course_type_selection_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryBloc()..add(const LoadHistory()),
      child: const _HistoryScreenView(),
    );
  }
}

class _HistoryScreenView extends StatelessWidget {
  const _HistoryScreenView();

  Future<void> _handleDeleteItem(BuildContext context, String id) async {
    context.read<HistoryBloc>().add(DeleteHistoryItem(id));

    if (context.mounted) {
      DialogHelpers.showSuccessSnackBar(context, 'Đã xóa khỏi lịch sử');
    }
  }

  Future<void> _handleDeleteSelectedItems(
    BuildContext context,
    List<String> ids,
  ) async {
    if (ids.isEmpty) return;

    final confirmed = await DialogHelpers.showDeleteConfirmationDialog(
      context,
      title: 'Xác nhận',
      message: 'Bạn có chắc chắn muốn xóa ${ids.length} hồ sơ đã chọn?',
    );

    if (confirmed == true && context.mounted) {
      context.read<HistoryBloc>().add(DeleteSelectedItems(ids));

      DialogHelpers.showSuccessSnackBar(
        context,
        'Đã xóa ${ids.length} hồ sơ',
      );
    }
  }

  Future<void> _handleClearAll(BuildContext context) async {
    final confirmed = await DialogHelpers.showDeleteConfirmationDialog(
      context,
      title: 'Xác nhận',
      message: 'Bạn có chắc chắn muốn xóa toàn bộ lịch sử?',
    );

    if (confirmed == true && context.mounted) {
      context.read<HistoryBloc>().add(const ClearHistory());

      DialogHelpers.showSuccessSnackBar(context, 'Đã xóa toàn bộ lịch sử');
    }
  }

  Future<void> _handleCreateProfile(
    BuildContext context,
    List<QRHistory> selectedItems,
  ) async {
    if (selectedItems.isEmpty) return;

    if (context.mounted) {
      final selectedCourseType = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CourseTypeSelectionScreen(
            selectedProfiles: selectedItems,
          ),
        ),
      );

      if (selectedCourseType != null && context.mounted) {
        final courseType = selectedCourseType as CourseType;
        // TODO: Xử lý tiếp theo với courseType và selectedItems
        DialogHelpers.showSuccessSnackBar(
          context,
          'Đã chọn hạng đào tạo: ${courseType.title} cho ${selectedItems.length} hồ sơ',
        );
      }
    }
  }

  Future<void> _handleOpenUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showDetailDialog(
    BuildContext context,
    QRHistory item,
    QRPersonInfo? personInfo,
  ) {
    showDialog(
      context: context,
      builder: (context) => HistoryDetailDialog(
        item: item,
        personInfo: personInfo,
        onCreateProfile: () => _handleCreateProfile(context, [item]),
      ),
    );
  }

  void _showManualEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ManualEntryDialog(parentContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final history = state is HistoryLoaded ? state.history : <QRHistory>[];
        final isLoading = state is HistoryLoading;
        final isSelectionMode =
            state is HistoryLoaded ? state.isSelectionMode : false;
        final selectedItems =
            state is HistoryLoaded ? state.selectedItems : <String>{};

        return Scaffold(
          appBar: _buildAppBar(
            context,
            isSelectionMode,
            selectedItems,
            history,
          ),
          body: _buildBody(
            context,
            isLoading,
            history,
            isSelectionMode,
            selectedItems,
          ),
          floatingActionButton: !isSelectionMode
              ? FloatingActionButton.extended(
                  onPressed: () => _showManualEntryDialog(context),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Thêm hồ sơ thủ công'),
                )
              : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isSelectionMode,
    Set<String> selectedItems,
    List<QRHistory> history,
  ) {
    return AppBar(
      title: isSelectionMode
          ? Text(
              'Đã chọn: ${selectedItems.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )
          : const Text(
              'Lịch sử Quét Thông Tin Học Viên',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      actions: _buildAppBarActions(
        context,
        isSelectionMode,
        selectedItems,
        history,
      ),
    );
  }

  List<Widget> _buildAppBarActions(
    BuildContext context,
    bool isSelectionMode,
    Set<String> selectedItems,
    List<QRHistory> history,
  ) {
    if (isSelectionMode) {
      return [
        IconButton(
          icon: const Icon(Icons.select_all),
          onPressed: selectedItems.length == history.length
              ? () {
                  context.read<HistoryBloc>().add(const DeselectAll());
                }
              : () {
                  context
                      .read<HistoryBloc>()
                      .add(SelectAll(history.map((e) => e.id).toList()));
                },
          tooltip:
              selectedItems.length == history.length ? 'Bỏ chọn tất cả' : 'Chọn tất cả',
        ),
        if (selectedItems.isNotEmpty) ...[
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              final selectedHistoryItems = history
                  .where((item) => selectedItems.contains(item.id))
                  .toList();
              _handleCreateProfile(context, selectedHistoryItems);
            },
            tooltip: 'Tạo hồ sơ',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDeleteSelectedItems(
              context,
              selectedItems.toList(),
            ),
            tooltip: 'Xóa đã chọn',
          ),
        ],
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.read<HistoryBloc>().add(const ToggleSelectionMode());
          },
          tooltip: 'Hủy chọn',
        ),
      ];
    }

    return [
      if (history.isNotEmpty) ...[
        IconButton(
          icon: const Icon(Icons.checklist),
          onPressed: () {
            context.read<HistoryBloc>().add(const ToggleSelectionMode());
          },
          tooltip: 'Chọn hồ sơ',
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep),
          onPressed: () => _handleClearAll(context),
          tooltip: 'Xóa tất cả',
        ),
      ],
    ];
  }

  Widget _buildBody(
    BuildContext context,
    bool isLoading,
    List<QRHistory> history,
    bool isSelectionMode,
    Set<String> selectedItems,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (history.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HistoryBloc>().add(const LoadHistory());
      },
      child: CustomScrollView(
        slivers: [
          _buildHistoryInfoCard(history.length),
          _buildHistoryList(
            context,
            history,
            isSelectionMode,
            selectedItems,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Chưa có lịch sử quét',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Quét QR code để bắt đầu',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryInfoCard(int count) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tổng số hồ sơ: $count',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    List<QRHistory> history,
    bool isSelectionMode,
    Set<String> selectedItems,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = history[index];
            final isPersonInfo = QRPersonInfo.isPersonInfoQR(item.content);
            final personInfo =
                isPersonInfo ? QRPersonInfo.fromQRContent(item.content) : null;
            final isUrl = item.content.startsWith('http://') ||
                item.content.startsWith('https://');
            final isSelected = selectedItems.contains(item.id);

            return HistoryItemCard(
              item: item,
              personInfo: personInfo,
              isSelected: isSelected,
              isSelectionMode: isSelectionMode,
              onTap: () {
                if (isSelectionMode) {
                  context
                      .read<HistoryBloc>()
                      .add(ToggleItemSelection(item.id));
                } else {
                  _showDetailDialog(context, item, personInfo);
                }
              },
              onLongPress: () {
                if (!isSelectionMode) {
                  context.read<HistoryBloc>().add(const ToggleSelectionMode());
                  context
                      .read<HistoryBloc>()
                      .add(ToggleItemSelection(item.id));
                }
              },
              onToggleSelection: () {
                context.read<HistoryBloc>().add(ToggleItemSelection(item.id));
              },
              onCreateProfile: () => _handleCreateProfile(context, [item]),
              onOpenUrl: isUrl ? () => _handleOpenUrl(item.content) : null,
              onDelete: () => _handleDeleteItem(context, item.id),
            );
          },
          childCount: history.length,
        ),
      ),
    );
  }
}
