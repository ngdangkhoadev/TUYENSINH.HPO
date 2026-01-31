import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/history/history_bloc.dart';
import '../bloc/history/history_event.dart';
import '../bloc/history/history_state.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import '../models/qr_history.dart';
import '../models/qr_person_info.dart';
import '../models/course_type.dart';
import '../widgets/history_detail_dialog.dart';
import '../widgets/history_item_card.dart';
import '../widgets/manual_entry_dialog.dart';
import '../services/flushbar_service.dart';
import 'qr_scanner_screen.dart';
import 'history_screen.dart';
import 'course_type_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: context.read<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => HistoryBloc()..add(const LoadHistory()),
        ),
      ],
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatelessWidget {
  const _HomeScreenView();

  Future<void> _handleOpenScanner(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (result == true && context.mounted) {
      context.read<HistoryBloc>().add(const LoadHistory());
    }
  }

  Future<void> _handleDeleteItem(BuildContext context, String id) async {
    context.read<HistoryBloc>().add(DeleteHistoryItem(id));

    if (context.mounted) {
      FlushbarService.showSuccess(
        context,
        'Đã xóa khỏi lịch sử',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _handleCreateProfile(BuildContext context, String text) async {
    if (context.mounted) {
      final selectedCourseType = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CourseTypeSelectionScreen(qrContent: text),
        ),
      );

      if (selectedCourseType != null && context.mounted) {
        final courseType = selectedCourseType as CourseType;
        // TODO: Xử lý tiếp theo với courseType
        FlushbarService.showSuccess(
          context,
          'Đã chọn hạng đào tạo: ${courseType.title}',
          duration: const Duration(seconds: 2),
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
        onCreateProfile: () => _handleCreateProfile(context, item.content),
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
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthUnauthenticated,
      listener: (context, state) {
        if (state is AuthUnauthenticated && context.mounted) {
          FlushbarService.showInfo(
            context,
            'Đã đăng xuất thành công',
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showManualEntryDialog(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Thêm hồ sơ thủ công'),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      title: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated && authState.user != null) {
            final userName = authState.user!.fullName;
            return Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Xin chào, $userName',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'QR Scanner',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Text(
            'QR Scanner',
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                )
                .then((_) {
              if (context.mounted) {
                context.read<HistoryBloc>().add(const LoadHistory());
              }
            });
          },
          tooltip: 'Xem tất cả lịch sử',
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => _showLogoutDialog(context),
          tooltip: 'Đăng xuất',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final history = state is HistoryLoaded ? state.history : <QRHistory>[];
        final isLoading = state is HistoryLoading;

        return Column(
          children: [
            _buildScannerButton(context),
            _buildHistorySection(context, isLoading, history),
          ],
        );
      },
    );
  }

  Widget _buildScannerButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 155,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade800,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _handleOpenScanner(context),
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quét Thông Tin Học Viên',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chạm để bắt đầu quét',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildHistoryHeader(context),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        final history = state is HistoryLoaded ? state.history : <QRHistory>[];
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lịch sử quét',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (history.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => const HistoryScreen(),
                        ),
                      )
                      .then((_) {
                    if (context.mounted) {
                      context.read<HistoryBloc>().add(const LoadHistory());
                    }
                  });
                },
                child: const Text('Xem tất cả'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHistorySection(
    BuildContext context,
    bool isLoading,
    List<QRHistory> history,
  ) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<HistoryBloc>().add(const LoadHistory());
        },
        child: _buildHistoryList(context, isLoading, history),
      ),
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    bool isLoading,
    List<QRHistory> history,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (history.isEmpty) {
      return _buildEmptyState();
    }

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= history.length) return null;
              final item = history[index];
              final isPersonInfo = QRPersonInfo.isPersonInfoQR(item.content);
              final personInfo =
                  isPersonInfo ? QRPersonInfo.fromQRContent(item.content) : null;
              final isUrl = item.content.startsWith('http://') ||
                  item.content.startsWith('https://');

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: HistoryItemCard(
                  item: item,
                  personInfo: personInfo,
                  isSelected: false,
                  isSelectionMode: false,
                  onTap: () => _showDetailDialog(context, item, personInfo),
                  onCreateProfile: () => _handleCreateProfile(context, item.content),
                  onOpenUrl: isUrl ? () => _handleOpenUrl(item.content) : null,
                  onDelete: () => _handleDeleteItem(context, item.id),
                ),
              );
            },
            childCount: history.length > 10 ? 10 : history.length,
          ),
        ),
      ],
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
}
