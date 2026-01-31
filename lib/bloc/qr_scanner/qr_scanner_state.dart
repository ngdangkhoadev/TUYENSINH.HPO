import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';
import '../../models/qr_history.dart';

abstract class QRScannerState extends Equatable {
  const QRScannerState();

  @override
  List<Object?> get props => [];
}

class QRScannerInitial extends QRScannerState {
  const QRScannerInitial();
}

class QRScannerLoading extends QRScannerState {
  const QRScannerLoading();
}

class QRScannerCameraInitialized extends QRScannerState {
  final CameraController cameraController;
  
  const QRScannerCameraInitialized(this.cameraController);
  
  @override
  List<Object?> get props => [cameraController];
}

class QRScannerSuccess extends QRScannerState {
  final QRHistory qrHistory;
  
  const QRScannerSuccess(this.qrHistory);
  
  @override
  List<Object?> get props => [qrHistory];
}

class QRScannerInvalidQR extends QRScannerState {
  const QRScannerInvalidQR();
}

class QRScannerError extends QRScannerState {
  final String message;
  
  const QRScannerError(this.message);
  
  @override
  List<Object?> get props => [message];
}

