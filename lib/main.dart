import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:tunnel_funnel/widget/controls/bottom_controls.dart';
import 'package:tunnel_funnel/widget/controls/hud.dart';
import 'package:tunnel_funnel/widget/main_menu.dart';

import 'game/tunnel_funnel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const TunnelFunnelApp());
}

class TunnelFunnelApp extends StatelessWidget {
  const TunnelFunnelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tunnel Funnel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: GameWidget(
          loadingBuilder: (conetxt) => const Center(
            child: SizedBox(
              width: 200,
              child: LinearProgressIndicator(),
            ),
          ),
          overlayBuilderMap: {
            MainMenu.id: (_, TunnelFunnel gameRef) => MainMenu(gameRef),
            BottomControls.id: (_, TunnelFunnel gameRef) =>
                BottomControls(gameRef),
            Hud.id: (_, TunnelFunnel gameRef) => Hud(gameRef: gameRef),
          },
          initialActiveOverlays: const [MainMenu.id],
          game: TunnelFunnel(),
        ),
      ),
    );
  }
}
