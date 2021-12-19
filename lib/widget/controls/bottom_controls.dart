import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tunnel_funnel/game/player.dart';
import 'package:tunnel_funnel/game/tunnel_funnel.dart';

class BottomControls extends StatelessWidget {
  static const id = 'BottomControls';

  final TunnelFunnel gameRef;

  const BottomControls(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 32, 40),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Wrap(
            children: [
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0XFF00001b),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0XFF00F2FC), width: 0.5),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  onPressed: () {
                    gameRef.children.whereType<Player>().first.jump();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: 25,
                      color: Color(0XFF00F2FC),
                    ),
                  )),
              const SizedBox(width: 35),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0XFF00001b),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0XFF00F2FC), width: 0.5),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                  onPressed: () {
                    gameRef.children.whereType<Player>().first.attack();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.flare_sharp,
                      size: 25,
                      color: Color(0XFF00F2FC),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
