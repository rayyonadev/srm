import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../dialog/toast_notification.dart';

class FaceCameraWidget extends StatefulWidget {
  final Function(String path)? onCapture;

  const FaceCameraWidget({super.key, this.onCapture});

  @override
  State<FaceCameraWidget> createState() => _FaceCameraWidgetState();
}

class _FaceCameraWidgetState extends State<FaceCameraWidget>
    with TickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraReady = false;

  late AnimationController _animController;
  late AnimationController _captureProgressController;

  bool _isProcessing = false;
  String _processingMessage = "";

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _captureProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();

    final frontCamera = _cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (!mounted) return;

    setState(() {
      _isCameraReady = true;
    });

    _startCaptureCycle();
  }

  void _startCaptureCycle() {
    if (!mounted || _controller == null || !_controller!.value.isInitialized) return;

    _captureProgressController.reset();
    _captureProgressController.forward().then((_) async {
      if (!mounted || _controller == null || !_controller!.value.isInitialized) return;

      setState(() {
        _isProcessing = true;
        _processingMessage = "Rasmga olinmoqda...";
      });

      try {
        final XFile file = await _controller!.takePicture();
        if (!mounted) return;

        widget.onCapture?.call(file.path);
      } catch (e) {
        debugPrint("Error in face capture: $e");
        AppToast.error(
          context: context,
          description: "Rasmga olishda xatolik yuz berdi: $e",
        );
        _retryCapture();
      }
    });
  }

  void _retryCapture() {
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
      _processingMessage = "";
    });
    _startCaptureCycle();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animController.dispose();
    _captureProgressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 320.w,
        height: 320.w, // 👈 MUHIM: square
        child: Stack(
          alignment: Alignment.center,
          children: [

            // 🔄 OUTER LOADING RING (camera'ni yopmaydi)
            AnimatedBuilder(
              animation: _animController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _animController.value * 2 * math.pi,
                  child: Container(
                    width: 320.w,
                    height: 320.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: SweepGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xff4894FE).withValues(alpha: 0.15),
                          const Color(0xff4894FE),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 0.7, 1.0],
                      ),
                    ),
                  ),
                );
              },
            ),

            // 🔵 NEON CAPTURE PROGRESS CIRCLE (Outer of preview)
            if (_isCameraReady)
              AnimatedBuilder(
                animation: _captureProgressController,
                builder: (context, child) {
                  return SizedBox(
                    width: 294.w,
                    height: 294.w,
                    child: CircularProgressIndicator(
                      value: _captureProgressController.value,
                      strokeWidth: 4.w,
                      backgroundColor: const Color(0xff4894FE).withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff4894FE)),
                    ),
                  );
                },
              ),

            // 🔵 CAMERA (CENTER CIRCLE)
            Container(
              width: 280.w, // 👈 kichikroq (loadingdan ichkarida)
              height: 280.w,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: _isCameraReady && _controller != null
                  ? ClipOval(
                      child: SizedBox(
                        width: 280.w,
                        height: 280.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: 280.w,
                                  height: 280.w * _controller!.value.aspectRatio,
                                  child: CameraPreview(_controller!),
                                ),
                              ),
                            ),
                            if (_isProcessing)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.black.withOpacity(0.6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(
                                        color: Color(0xff4894FE),
                                      ),
                                      SizedBox(height: 16.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                                        child: Text(
                                          _processingMessage,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                        color: const Color(0xFF1E293B), // Sleek dark slate color
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glowing pulsing circles
                            AnimatedBuilder(
                              animation: _animController,
                              builder: (context, child) {
                                final scale = 1.0 + (_animController.value * 0.25);
                                final opacity = 1.0 - _animController.value;
                                return Container(
                                  width: 140.w * scale,
                                  height: 140.w * scale,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xff4894FE).withValues(alpha: opacity * 0.2),
                                    border: Border.all(
                                      color: const Color(0xff4894FE).withValues(alpha: opacity * 0.4),
                                      width: 2.w,
                                    ),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: _animController,
                              builder: (context, child) {
                                final scale = 1.0 + (((_animController.value + 0.5) % 1.0) * 0.25);
                                final opacity = 1.0 - ((_animController.value + 0.5) % 1.0);
                                return Container(
                                  width: 140.w * scale,
                                  height: 140.w * scale,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xff4894FE).withValues(alpha: opacity * 0.15),
                                    border: Border.all(
                                      color: const Color(0xff4894FE).withValues(alpha: opacity * 0.3),
                                      width: 1.5.w,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Center Icon
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F172A),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.face_unlock_outlined,
                                color: Color(0xff4894FE),
                                size: 36,
                              ),
                            ),
                            // Loading text
                            Positioned(
                              bottom: 40.w,
                              child: Text(
                                "Kamera yuklanmoqda...",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
            ),

            // 🟢 LASER SCANNING OVERLAY (Only when camera is ready)
            if (_isCameraReady)
              IgnorePointer(
                child: ClipOval(
                  child: SizedBox(
                    width: 280.w,
                    height: 280.w,
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        // oscillate between -140.w and 140.w
                        final translation = math.sin(_animController.value * 2 * math.pi) * 140.w;
                        return Stack(
                          children: [
                            Positioned(
                              top: 140.w + translation,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 3.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xff4894FE).withValues(alpha: 0.8),
                                      blurRadius: 12,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xff4894FE),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

            // 🔵 INNER SOFT GLOW (optional nice UI)
            Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff4894FE).withValues(alpha: 0.2),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}