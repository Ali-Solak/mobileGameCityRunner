import 'package:flame/palette.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:tunnel_funnel/game/platform.dart';

import 'package:tunnel_funnel/game/player.dart';
import 'package:tunnel_funnel/game/tunnel_funnel.dart';
import 'package:tunnel_funnel/game/wall.dart';

class PlayerPlatformContactCallback extends ContactCallback<Player, Platform> {
  @override
  void begin(Player player, Platform rec, Contact contact) {
    player.component.current = PlayerAnimationState.idle;
    player.colliding = true;
    player.jumping = false;
    player.inAir = false;
    rec.isCharacterOnPlatform = true;

    if (rec.playerScored == false && rec.nonMoveable == false && !player.dead) {
      (player.gameRef as TunnelFunnel).playerData.currentScore++;
      rec.playerScored = true;
    }
    rec.component.tint(const Color(0XFF00F2FC).withOpacity(0.4));
    print("contacto");
  }

  @override
  void end(Player player, Platform rec, Contact contact) {
    player.colliding = false;
    rec.isCharacterOnPlatform = false;
    rec.component.tint(Colors.transparent);
  }
}

class PlayerWallContactCallback extends ContactCallback<Player, Wall> {
  @override
  void begin(Player player, Wall rec, Contact contact) {
    if (rec.id == "bottom") {
      player.component.current = PlayerAnimationState.death;
      player.jumping = false;
      //player.colliding = true;
      player.dead = true;
      print("contact");
    }
  }

  @override
  void end(Player player, Wall wall, Contact contact) {
    player.colliding = false;
  }
}
