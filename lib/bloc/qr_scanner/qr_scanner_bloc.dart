import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../../models/qr_history.dart';
import '../../models/qr_person_info.dart';
import '../../services/qr_history_service.dart';
import 'qr_scanner_event.dart';
import 'qr_scanner_state.dart';

class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  final QRHistoryService _historyService = QRHistoryService();
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.qrCode]);
  bool _isProcessing = false;

  QRScannerBloc() : super(const QRScannerInitial()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<ProcessBarcode>(_onProcessBarcode);
    on<ResetScanner>(_onResetScanner);
    on<StopCamera>(_onStopCamera);
    on<StartCamera>(_onStartCamera);
  }

  Future<void> _onInitializeCamera(
    InitializeCamera event,
    Emitter<QRScannerState> emit,
  ) async {
    emit(const QRScannerLoading());
    
    try {
      // Dispose camera cũ trước khi tạo mới
      await _disposeCamera();

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(const QRScannerError('Không tìm thấy camera'));
        return;
      }

      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFocusMode(FocusMode.auto);

      emit(QRScannerCameraInitialized(_cameraController!));
    } catch (e) {
      emit(QRScannerError('Lỗi khởi tạo camera: $e'));
      // Đảm bảo dispose camera nếu có lỗi
      await _disposeCamera();
    }
  }

  Future<void> _onProcessBarcode(
    ProcessBarcode event,
    Emitter<QRScannerState> emit,
  ) async {
    if (_isProcessing || event.barcode.rawValue == null) return;

    _isProcessing = true;
    
    // Dừng camera stream để tránh quét nhiều lần
    await _cameraController?.stopImageStream();

    try {
      final qrContent = event.barcode.displayValue ?? event.barcode.rawValue ?? '';
      
      // Kiểm tra xem QR code có phải là căn cước công dân không
      if (!QRPersonInfo.isPersonInfoQR(qrContent)) {
        emit(const QRScannerInvalidQR());
        _isProcessing = false;
        return;
      }

      final qrHistory = QRHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: event.barcode.rawValue!,
        format: event.barcode.format.name,
        scannedAt: DateTime.now(),
        displayValue: event.barcode.displayValue,
      );

      await _historyService.addToHistory(qrHistory);
      emit(QRScannerSuccess(qrHistory));
    } catch (e) {
      emit(QRScannerError('Lỗi xử lý QR code: $e'));
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _onResetScanner(
    ResetScanner event,
    Emitter<QRScannerState> emit,
  ) async {
    _isProcessing = false;
    
    // Stop image stream nếu đang chạy
    if (_cameraController != null && 
        _cameraController!.value.isInitialized &&
        _cameraController!.value.isStreamingImages) {
      try {
        await _cameraController!.stopImageStream();
      } catch (e) {
        // Bỏ qua lỗi
      }
    }
    
    if (state is QRScannerCameraInitialized && 
        _cameraController != null && 
        _cameraController!.value.isInitialized) {
      emit(QRScannerCameraInitialized(_cameraController!));
    } else {
      emit(const QRScannerInitial());
    }
  }

  Future<void> _onStopCamera(
    StopCamera event,
    Emitter<QRScannerState> emit,
  ) async {
    await _cameraController?.stopImageStream();
  }

  Future<void> _onStartCamera(
    StartCamera event,
    Emitter<QRScannerState> emit,
  ) async {
    if (_cameraController != null && 
        _cameraController!.value.isInitialized &&
        !_cameraController!.value.isStreamingImages) {
      try {
        await _cameraController!.startImageStream(_processCameraImage);
      } catch (e) {
        // Xử lý lỗi khi start stream
      }
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isProcessing) return;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        add(ProcessBarcode(barcodes.first));
      }
    } catch (e) {
      // Xử lý lỗi
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    try {
      final BytesBuilder bytesBuilder = BytesBuilder();
      for (final Plane plane in image.planes) {
        bytesBuilder.add(plane.bytes);
      }
      final bytes = bytesBuilder.takeBytes();

      final imageRotation = InputImageRotation.values.firstWhere(
        (rotation) =>
            rotation.rawValue ==
            _cameraController!.description.sensorOrientation,
        orElse: () => InputImageRotation.rotation0deg,
      );

      final inputImageData = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: inputImageData,
      );
    } catch (e) {
      return null;
    }
  }

  CameraController? get cameraController => _cameraController;

  /// Dispose camera controller một cách an toàn
  Future<void> _disposeCamera() async {
    if (_cameraController != null) {
      try {
        // Stop image stream trước khi dispose
        if (_cameraController!.value.isStreamingImages) {
          await _cameraController!.stopImageStream();
        }
        await _cameraController!.dispose();
      } catch (e) {
        // Bỏ qua lỗi khi dispose
      } finally {
        _cameraController = null;
      }
    }
  }

  @override
  Future<void> close() async {
    await _disposeCamera();
    await _barcodeScanner.close();
    return super.close();
  }
}

