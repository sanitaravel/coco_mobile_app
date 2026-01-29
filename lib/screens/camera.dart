import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CaptureMode { photo, video }
enum CapturedType { photo, video }

class CaptureResult {
  final File file;
  final CapturedType type;

  CaptureResult({required this.file, required this.type});
}

class CameraCapturePage extends StatelessWidget {
  const CameraCapturePage({
    super.key,
    this.initialMode = CaptureMode.photo,
  });

  final CaptureMode initialMode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CameraCubit()..init(initialMode: initialMode),
      child: const _CameraView(),
    );
  }
}

class CameraState {
  final bool isReady;
  final bool isRecording;
  final String? error;
  final CaptureMode mode;
  final int selectedCameraIndex;
  final String teleprompterText;
  final String originalTeleprompterText;
  final double teleprompterFontSize;
  final double teleprompterOpacity;
  final double teleprompterScrollSpeed;

  const CameraState({
    this.isReady = false,
    this.isRecording = false,
    this.error,
    this.mode = CaptureMode.photo,
    this.selectedCameraIndex = 0,
    this.teleprompterText = 'No text',
    this.originalTeleprompterText = '',
    this.teleprompterFontSize = 32.0,
    this.teleprompterOpacity = 0.6,
    this.teleprompterScrollSpeed = 1.0,
  });

  CameraState copyWith({
    bool? isReady,
    bool? isRecording,
    String? error,
    CaptureMode? mode,
    int? selectedCameraIndex,
    String? teleprompterText,
    String? originalTeleprompterText,
    double? teleprompterFontSize,
    double? teleprompterOpacity,
    double? teleprompterScrollSpeed,
  }) {
    return CameraState(
      isReady: isReady ?? this.isReady,
      isRecording: isRecording ?? this.isRecording,
      error: error,
      mode: mode ?? this.mode,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      teleprompterText: teleprompterText ?? this.teleprompterText,
      originalTeleprompterText: originalTeleprompterText ?? this.originalTeleprompterText,
      teleprompterFontSize: teleprompterFontSize ?? this.teleprompterFontSize,
      teleprompterOpacity: teleprompterOpacity ?? this.teleprompterOpacity,
      teleprompterScrollSpeed: teleprompterScrollSpeed ?? this.teleprompterScrollSpeed,
    );
  }
}

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(const CameraState());

  List<CameraDescription> _cameras = const [];
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<void> init({required CaptureMode initialMode}) async {
    try {
      emit(state.copyWith(isReady: false, error: null, mode: initialMode));
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        emit(state.copyWith(error: 'No cameras available'));
        return;
      }

      await _startController(cameraIndex: 0);
      emit(state.copyWith(isReady: true, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _startController({required int cameraIndex}) async {
    await _controller?.dispose();

    final cam = _cameras[cameraIndex];
    final ctrl = CameraController(
      cam,
      ResolutionPreset.high,
      enableAudio: true,
    );

    _controller = ctrl;
    emit(state.copyWith(selectedCameraIndex: cameraIndex));

    await ctrl.initialize();
  }

  Future<void> flipCamera() async {
    if (_cameras.length < 2) return;
    final next = (state.selectedCameraIndex + 1) % _cameras.length;

    emit(state.copyWith(isReady: false));
    await _startController(cameraIndex: next);
    emit(state.copyWith(isReady: true));
  }

  void setMode(CaptureMode mode) {
    if (state.isRecording) return;
    emit(state.copyWith(mode: mode));
  }

  void setTeleprompterText(String text) {
    final processedText = _processTeleprompterText(text);
    emit(state.copyWith(
      teleprompterText: processedText,
      originalTeleprompterText: text,
    ));
  }

  String _processTeleprompterText(String input, [double? fontSize]) {
    final effectiveFontSize = fontSize ?? state.teleprompterFontSize;
    
    if (input.trim().isEmpty) return 'No text';

    // Step 1: Trim and normalize whitespace
    String processed = input.trim();

    // Step 2: Normalize line breaks
    processed = processed.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Step 3: Remove excessive whitespace
    processed = processed.replaceAll(RegExp(r' +'), ' ');

    // Step 4: Split into lines and process each line
    final lines = processed.split('\n');
    final processedLines = <String>[];

    for (final line in lines) {
      if (line.trim().isEmpty) {
        // Preserve empty lines (paragraph breaks)
        processedLines.add('');
        continue;
      }

      // Calculate max characters per line based on font size
      int maxLength;
      if (effectiveFontSize <= 32) {
        maxLength = 30; // Small font
      } else if (effectiveFontSize <= 48) {
        maxLength = 20; // Medium font
      } else {
        maxLength = 7; // Large font
      }

      final chunks = _breakIntoChunks(line.trim(), maxLength: maxLength);
      processedLines.addAll(chunks);
    }

    // Step 5: Remove consecutive empty lines (keep max 1)
    final cleanedLines = <String>[];
    bool lastWasEmpty = false;

    for (final line in processedLines) {
      if (line.isEmpty) {
        if (!lastWasEmpty) {
          cleanedLines.add(line);
        }
        lastWasEmpty = true;
      } else {
        cleanedLines.add(line);
        lastWasEmpty = false;
      }
    }

    return cleanedLines.join('\n').trim();
  }

  List<String> _breakIntoChunks(String text, {int maxLength = 50}) {
    if (text.length <= maxLength) {
      return [text];
    }

    final chunks = <String>[];
    final words = text.split(' ');
    final buffer = StringBuffer();

    for (final word in words) {
      if (buffer.isEmpty) {
        buffer.write(word);
      } else if (buffer.length + word.length + 1 <= maxLength) {
        buffer.write(' $word');
      } else {
        // Current buffer is full, save it and start new one
        chunks.add(buffer.toString());
        buffer.clear();
        buffer.write(word);
      }
    }

    // Add remaining buffer
    if (buffer.isNotEmpty) {
      chunks.add(buffer.toString());
    }

    return chunks;
  }

  void setTeleprompterFontSize(double size) {
    // Use the original text to re-process with new font size
    final originalText = state.originalTeleprompterText;
    
    if (originalText.isNotEmpty) {
      final reprocessedText = _processTeleprompterText(originalText, size);
      emit(state.copyWith(teleprompterText: reprocessedText, teleprompterFontSize: size));
    } else {
      emit(state.copyWith(teleprompterFontSize: size));
    }
  }

  void setTeleprompterOpacity(double opacity) {
    emit(state.copyWith(teleprompterOpacity: opacity));
  }

  void setTeleprompterScrollSpeed(double speed) {
    emit(state.copyWith(teleprompterScrollSpeed: speed));
  }

  Future<CaptureResult?> onShutterPressed() async {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return null;

    try {
      if (state.mode == CaptureMode.photo) {
        final XFile file = await ctrl.takePicture();
        return CaptureResult(file: File(file.path), type: CapturedType.photo);
      }

      // VIDEO
      if (!state.isRecording) {
        await ctrl.prepareForVideoRecording();
        await ctrl.startVideoRecording();
        emit(state.copyWith(isRecording: true));
        return null; // no result yet
      } else {
        final XFile file = await ctrl.stopVideoRecording();
        emit(state.copyWith(isRecording: false));
        return CaptureResult(file: File(file.path), type: CapturedType.video);
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      return null;
    }
  }

  @override
  Future<void> close() async {
    await _controller?.dispose();
    return super.close();
  }
}

class _CameraView extends StatefulWidget {
  const _CameraView();

  @override
  State<_CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<_CameraView> with TickerProviderStateMixin {

  static const _overlay = Color(0xB34A5A3B); // olive-ish translucent
  static const _text = Colors.white;

  ScrollController? _scrollController;
  AnimationController? _animationController;
  bool _isScrolling = false;
  int _currentLineIndex = 0;
  Timer? _lineTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _animationController?.dispose();
    _lineTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll(CameraState state) {
    _lineTimer?.cancel();
    _currentLineIndex = 0;
    _isScrolling = true;

    final lines = state.teleprompterText.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    if (lines.isEmpty) {
      _isScrolling = false;
      return;
    }

    final lineDuration = Duration(milliseconds: (3000 / state.teleprompterScrollSpeed).round());

    void showNextLine() {
      if (_currentLineIndex >= lines.length - 1) {
        // Reached the end, stop
        _isScrolling = false;
        return;
      }

      _currentLineIndex++;
      setState(() {}); // Trigger rebuild to show new line

      _lineTimer = Timer(lineDuration, showNextLine);
    }

    // Start with first line
    setState(() {});
    _lineTimer = Timer(lineDuration, showNextLine);
  }

  void _stopAutoScroll() {
    _lineTimer?.cancel();
    _isScrolling = false;
    _currentLineIndex = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocConsumer<CameraCubit, CameraState>(
        listenWhen: (p, c) => p.error != c.error && c.error != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        },
        builder: (context, state) {
          final cubit = context.read<CameraCubit>();
          final ctrl = cubit.controller;

          // Start auto-scroll when text changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.teleprompterText != 'No text' && !_isScrolling) {
              _startAutoScroll(state);
            } else if (state.teleprompterText == 'No text') {
              _stopAutoScroll();
            }
          });

          // Get current line to display
          final lines = state.teleprompterText == 'No text' 
              ? ['No text'] 
              : state.teleprompterText.split('\n').where((line) => line.trim().isNotEmpty).toList();
          final currentLine = lines.isEmpty ? 'No text' : lines[_currentLineIndex.clamp(0, lines.length - 1)];

          return Stack(
            children: [
              Positioned.fill(
                child: state.isReady && ctrl != null && ctrl.value.isInitialized
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: ctrl.value.previewSize!.height,
                          height: ctrl.value.previewSize!.width,
                          child: CameraPreview(ctrl),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),

              // Close X (top-left)
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 38),
                    color: _text,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              // Teleprompter
              Positioned(
                top: 80,
                left: 20,
                right: 20,
                child: Opacity(
                  opacity: state.teleprompterOpacity,
                  child: Container(
                    height: 200, // Fixed height for consistency
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF364027),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        currentLine,
                        style: TextStyle(
                          color: const Color(0xFFDFE1D3),
                          fontFamily: 'Wix Madefor Text',
                          fontSize: state.teleprompterFontSize,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.02 * (state.teleprompterFontSize / 16),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom controls bar
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: const BoxDecoration(
                    color: _overlay,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Flip camera
                        IconButton(
                          icon: const Icon(Icons.cameraswitch, size: 34),
                          color: _text,
                          onPressed: cubit.flipCamera,
                        ),

                        // Shutter
                        _ShutterButton(
                          isRecording: state.isRecording,
                          onTap: () async {
                            final result = await cubit.onShutterPressed();
                            if (result != null) {
                              Navigator.pop(context, result);
                            }
                          },
                        ),

                        // Settings (placeholder)
                        IconButton(
                          icon: const Icon(Icons.settings, size: 34),
                          color: _text,
                          onPressed: () => _showSettings(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Mode toggle (photo/video) above bottom bar
              Positioned(
                left: 0,
                right: 0,
                bottom: 126,
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: _ModeToggle(
                      mode: state.mode,
                      isRecording: state.isRecording,
                      onModeSelected: cubit.setMode,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSettings(BuildContext context) {
    final cubit = context.read<CameraCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _SettingsSheet(cubit: cubit),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  final CameraCubit cubit;

  const _SettingsSheet({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Container(
            padding: const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFDFE1D3),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Text Size',
                  style: TextStyle(
                    color: Color(0xFF364027),
                    fontFamily: 'Wix Madefor Text',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    height: 0.75,
                    letterSpacing: -0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SizeOption(size: 32, cubit: cubit),
                    _SizeOption(size: 48, cubit: cubit),
                    _SizeOption(size: 64, cubit: cubit),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  'Opacity',
                  style: TextStyle(
                    color: Color(0xFF364027),
                    fontFamily: 'Wix Madefor Text',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    height: 0.75,
                    letterSpacing: -0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Slider(
                  value: state.teleprompterOpacity,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  activeColor: const Color(0xFF73AE50),
                  inactiveColor: const Color(0xFF364027).withOpacity(0.3),
                  onChanged: (value) {
                    cubit.setTeleprompterOpacity(value);
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  'Scroll Speed',
                  style: TextStyle(
                    color: Color(0xFF364027),
                    fontFamily: 'Wix Madefor Text',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    height: 0.75,
                    letterSpacing: -0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Slider(
                  value: state.teleprompterScrollSpeed,
                  min: 0.5,
                  max: 3.0,
                  divisions: 10,
                  activeColor: const Color(0xFF73AE50),
                  inactiveColor: const Color(0xFF364027).withOpacity(0.3),
                  onChanged: (value) {
                    cubit.setTeleprompterScrollSpeed(value);
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  'Preview',
                  style: TextStyle(
                    color: Color(0xFF364027),
                    fontFamily: 'Wix Madefor Text',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    height: 0.75,
                    letterSpacing: -0.32,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: state.teleprompterOpacity,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF364027),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: state.teleprompterText.isEmpty || state.teleprompterText == 'No text'
                        ? ElevatedButton(
                            onPressed: () => _showTextInputDialog(context, cubit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF73AE50),
                              foregroundColor: const Color(0xFFDFE1D3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              'Add text',
                              style: TextStyle(
                                fontFamily: 'Wix Madefor Text',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _showTextInputDialog(context, cubit),
                            child: Text(
                              state.teleprompterText.split('\n').firstWhere(
                                (line) => line.trim().isNotEmpty,
                                orElse: () => 'No text',
                              ),
                              style: TextStyle(
                                color: const Color(0xFFDFE1D3),
                                fontFamily: 'Wix Madefor Text',
                                fontSize: state.teleprompterFontSize,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.02 * (state.teleprompterFontSize / 16),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        cubit.setTeleprompterText('');
                        cubit.setTeleprompterFontSize(48.0);
                        cubit.setTeleprompterOpacity(0.6);
                        cubit.setTeleprompterScrollSpeed(1.0);
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Color(0xFF364027),
                          fontFamily: 'Wix Madefor Text',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Color(0xFF364027),
                          fontFamily: 'Wix Madefor Text',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTextInputDialog(BuildContext context, CameraCubit cubit) {
    final TextEditingController controller = TextEditingController(
      text: cubit.state.originalTeleprompterText
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFDFE1D3),
          title: const Text(
            'Enter Teleprompter Text',
            style: TextStyle(
              color: Color(0xFF364027),
              fontFamily: 'Wix Madefor Text',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Paste your text here...',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF73AE50)),
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF364027),
              fontFamily: 'Wix Madefor Text',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF364027),
                  fontFamily: 'Wix Madefor Text',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                cubit.setTeleprompterText(controller.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF73AE50),
                  fontFamily: 'Wix Madefor Text',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SizeOption extends StatelessWidget {
  final double size;
  final CameraCubit cubit;

  const _SizeOption({required this.size, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isActive = cubit.state.teleprompterFontSize == size;
    return GestureDetector(
      onTap: () {
        cubit.setTeleprompterFontSize(size);
      },
      child: Text(
        'A',
        style: TextStyle(
          color: isActive ? const Color(0xFF73AE50) : const Color(0xFF364027),
          fontFamily: 'Wix Madefor Text',
          fontSize: size,
          fontWeight: FontWeight.w600,
          height: 24 / size,
          letterSpacing: -0.03 * (size / 16),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({
    required this.mode,
    required this.isRecording,
    required this.onModeSelected,
  });

  final CaptureMode mode;
  final bool isRecording;
  final void Function(CaptureMode) onModeSelected;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isRecording,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0x66000000),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ModePill(
              label: 'PHOTO',
              selected: mode == CaptureMode.photo,
              onTap: () => onModeSelected(CaptureMode.photo),
            ),
            const SizedBox(width: 8),
            _ModePill(
              label: 'VIDEO',
              selected: mode == CaptureMode.video,
              onTap: () => onModeSelected(CaptureMode.video),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: selected ? Colors.black : Colors.white,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShutterButton extends StatelessWidget {
  const _ShutterButton({
    required this.isRecording,
    required this.onTap,
  });

  final bool isRecording;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.9),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: isRecording ? 26 : 56,
            height: isRecording ? 26 : 56,
            decoration: BoxDecoration(
              shape: isRecording ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isRecording ? BorderRadius.circular(6) : null,
              color: isRecording ? Colors.redAccent : Colors.white,
              border: Border.all(color: Colors.black12, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}