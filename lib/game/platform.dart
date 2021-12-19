import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:tunnel_funnel/game/player.dart';
import 'package:tunnel_funnel/game/tunnel_funnel.dart';

class Platform extends PositionBodyComponent with Draggable {
  final Vector2 position;
  final bool? velocity;
  final bool nonMoveable;
  final SpriteComponent component;
  final Vector2 compSize;
  final int speed;
  bool isCharacterOnPlatform = false;
  bool playerScored = false;

  Vector2? dragDeltaPosition;

  Platform(this.component, this.position, this.compSize,
      {this.velocity, required this.nonMoveable, required this.speed})
      : super(positionComponent: component, size: compSize);
  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(compSize.x / 2, compSize.y / 2);
    final fixtureDef = FixtureDef(shape)
      ..userData = this
      ..density = 0
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2(position.x, position.y)
      ..type = BodyType.kinematic;

    final platformworld = world.createBody(bodyDef);
    platformworld.createFixture(fixtureDef);

    return platformworld;
  }

  @override
  Future<void> onMount() {
    if (velocity ?? false) body.linearVelocity = Vector2(speed.toDouble(), 0);

    return super.onMount();
  }

  @override
  void update(double dt) {
    if (body.position.x < -5) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo details) {
    dragDeltaPosition = details.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo details) {
    if (parent is! TunnelFunnel) {
      return true;
    }
    final dragDeltaPosition = this.dragDeltaPosition;
    if (dragDeltaPosition == null) {
      return false;
    }

    final worldDelta = Vector2(1, -1)..multiply(details.delta.game);
    Vector2 da = Vector2(0, worldDelta.y);
    body.linearVelocity = da * 100;
    if (gameRef.children.whereType<Player>().first.colliding &&
        isCharacterOnPlatform) {
      gameRef.children.whereType<Player>().first.body.linearVelocity = da * 100;
    }
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!nonMoveable) {
        body.linearVelocity = Vector2(-20, 0);
        gameRef.children.whereType<Player>().first.body.linearVelocity =
            Vector2(0, 0);
      } else {
        body.linearVelocity = Vector2(0, 0);
      }
    });

    return false;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo details) {
    return true;
  }
}
