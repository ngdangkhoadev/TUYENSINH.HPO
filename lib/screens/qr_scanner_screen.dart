import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import '../bloc/qr_scanner/qr_scanner_bloc.dart';
import '../bloc/qr_scanner/qr_scanner_event.dart';
import '../bloc/qr_scanner/qr_scanner_state.dart';
import '../models/qr_person_info.dart';
import '../widgets/person_info_card.dart';
import 'history_screen.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRScannerBloc()..add(const InitializeCamera()),
      child: const _QRScannerView(),
    );
  }
}

class _QRScannerView extends StatelessWidget {
  const _QRScannerView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<QRScannerBloc, QRScannerState>(
      listener: (context, state) {
        if (state is QRScannerCameraInitialized) {
          context.read<QRScannerBloc>().add(const StartCamera());
        } else if (state is QRScannerSuccess) {
          _showResultDialog(context, state.qrHistory);
        } else if (state is QRScannerInvalidQR) {
          _showInvalidQRDialog(context);
        } else if (state is QRScannerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Quét QR Code',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              },
              tooltip: 'Lịch sử',
            ),
          ],
        ),
        body: BlocBuilder<QRScannerBloc, QRScannerState>(
          builder: (context, state) {
            if (state is QRScannerLoading || state is QRScannerInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is QRScannerCameraInitialized) {
              return Stack(
                children: [
                  // Camera preview
                  Positioned.fill(
                    child: CameraPreview(state.cameraController),
                  ),
                  // Overlay với khung quét
                  Positioned.fill(
                    child: CustomPaint(
                      painter: QRScannerOverlay(),
                    ),
                  ),
                  // Hướng dẫn
                  Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Chỉ chấp nhận QR code từ căn cước',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, qrHistory) {
    final qrContent = qrHistory.displayValue ?? qrHistory.content ?? '';
    final isPersonInfo = QRPersonInfo.isPersonInfoQR(qrContent);
    final personInfo = isPersonInfo ? QRPersonInfo.fromQRContent(qrContent) : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isPersonInfo && personInfo != null && !personInfo.isEmpty)
                        PersonInfoCard(personInfo: personInfo, qrContent: qrContent)
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SelectableText(
                            qrContent,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Định dạng: ${qrHistory.format}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Thời gian: ${_formatDateTime(qrHistory.scannedAt)}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<QRScannerBloc>().add(const ResetScanner());
                      context.read<QRScannerBloc>().add(const InitializeCamera());
                    },
                    child: const Text('Quét lại'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(true); // Return to home screen with success
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Xong'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInvalidQRDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade700,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'QR Code không hợp lệ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Chỉ chấp nhận QR code từ căn cước.\nVui lòng quét lại.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<QRScannerBloc>().add(const ResetScanner());
                  context.read<QRScannerBloc>().add(const InitializeCamera());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Quét lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Custom painter để vẽ khung quét QR
class QRScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);

    // Tính toán kích thước khung quét (250x250)
    final scanAreaSize = 250.0;
    final left = (size.width - scanAreaSize) / 2;
    final top = (size.height - scanAreaSize) / 2 - 50;
    final right = left + scanAreaSize;
    final bottom = top + scanAreaSize;

    // Vẽ overlay tối xung quanh bằng cách vẽ 4 hình chữ nhật
    // Trên
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), overlayPaint);
    // Dưới
    canvas.drawRect(Rect.fromLTWH(0, bottom, size.width, size.height - bottom), overlayPaint);
    // Trái
    canvas.drawRect(Rect.fromLTWH(0, top, left, scanAreaSize), overlayPaint);
    // Phải
    canvas.drawRect(Rect.fromLTWH(right, top, size.width - right, scanAreaSize), overlayPaint);

    // Vẽ khung quét với góc bo tròn
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(left + 20, top)
      ..lineTo(right - 20, top)
      ..quadraticBezierTo(right, top, right, top + 20)
      ..lineTo(right, bottom - 20)
      ..quadraticBezierTo(right, bottom, right - 20, bottom)
      ..lineTo(left + 20, bottom)
      ..quadraticBezierTo(left, bottom, left, bottom - 20)
      ..lineTo(left, top + 20)
      ..quadraticBezierTo(left, top, left + 20, top);

    canvas.drawPath(path, paint);

    // Vẽ góc vuông ở 4 góc
    final cornerLength = 30.0;
    final cornerPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Góc trên trái
    canvas.drawLine(
      Offset(left, top + 20),
      Offset(left, top + cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + 20, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Góc trên phải
    canvas.drawLine(
      Offset(right, top + 20),
      Offset(right, top + cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right - 20, top),
      Offset(right - cornerLength, top),
      cornerPaint,
    );

    // Góc dưới trái
    canvas.drawLine(
      Offset(left, bottom - 20),
      Offset(left, bottom - cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + 20, bottom),
      Offset(left + cornerLength, bottom),
      cornerPaint,
    );

    // Góc dưới phải
    canvas.drawLine(
      Offset(right, bottom - 20),
      Offset(right, bottom - cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right - 20, bottom),
      Offset(right - cornerLength, bottom),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
