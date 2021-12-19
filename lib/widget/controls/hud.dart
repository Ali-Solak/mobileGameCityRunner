import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tunnel_funnel/game/model/player_data.dart';

import 'package:tunnel_funnel/game/tunnel_funnel.dart';

class Hud extends StatefulWidget {
  final TunnelFunnel gameRef;
  const Hud({Key? key, required this.gameRef}) : super(key: key);

  static const id = 'Hud';

  @override
  State<Hud> createState() => _HudState();
}

class _HudState extends State<Hud> {
  bool paused = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.gameRef.playerData,
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            children: [
              Selector<PlayerData, int>(
                selector: (_, playerData) => playerData.currentScore,
                builder: (_, highScore, __) {
                  return SafeArea(
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 8),
                          child: Text(
                            'Score: $highScore',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (paused) {
                                widget.gameRef.resumeEngine();
                              } else {
                                widget.gameRef.pauseEngine();
                              }
                              setState(() {
                                paused = !paused;
                              });
                            },
                            icon: Icon(
                              paused ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                            )),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              widget.gameRef.playerData.currentScore = 0;
                              widget.gameRef.replay();
                            },
                            icon: const Icon(
                              Icons.replay,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
