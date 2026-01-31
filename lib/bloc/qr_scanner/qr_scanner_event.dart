import 'package:equatable/equatable.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

abstract class QRScannerEvent extends Equatable {
  const QRScannerEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCamera extends QRScannerEvent {
  const InitializeCamera();
}

class ProcessBarcode extends QRScannerEvent {
  final Barcode barcode;
  
  const ProcessBarcode(this.barcode);
  
  @override
  List<Object?> get props => [barcode];
}

class ResetScanner extends QRScannerEvent {
  const ResetScanner();
}

class StopCamera extends QRScannerEvent {
  const StopCamera();
}

class StartCamera extends QRScannerEvent {
  const StartCamera();
}

