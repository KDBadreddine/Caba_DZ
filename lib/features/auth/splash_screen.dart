import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/api/api_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final VideoPlayerController _videoCtrl;

  @override
  void initState() {
    super.initState();

    // Fade animation for the bottom button
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();

    // Video player setup
    _videoCtrl = VideoPlayerController.asset('assets/video/splash.mp4')
      ..setLooping(true)
      ..setVolume(0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _videoCtrl.play();
        }
      });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFB8DCF0),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Full-screen video background
            if (_videoCtrl.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _videoCtrl.value.size.width,
                    height: _videoCtrl.value.size.height,
                    child: VideoPlayer(_videoCtrl),
                  ),
                ),
              )
            else
              // Placeholder background colour while video loads
              const SizedBox.expand(),

            // Bottom gradient overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00B8DCF0),
                        Color(0x88B8DCF0),
                        Color(0xEEB8DCF0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Fade-in start button
            SafeArea(
              child: FadeTransition(
                opacity: _fade,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                  child: Column(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            final loggedIn = await restoreSession();
                            await getCountries();
                            if (!context.mounted) return;
                            Navigator.pushReplacementNamed(
                              context,
                              loggedIn ? AppRoutes.home : AppRoutes.login,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppStrings.startNowAr,
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
