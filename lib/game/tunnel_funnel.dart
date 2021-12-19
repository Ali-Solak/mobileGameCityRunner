import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:tunnel_funnel/game/event_manager.dart';
import 'package:tunnel_funnel/game/gameCollisionHandlers.dart';
import 'package:tunnel_funnel/game/model/player_data.dart';
import 'package:tunnel_funnel/game/platform.dart';
import 'package:tunnel_funnel/game/player.dart';
import 'wall.dart';

class TunnelFunnel extends Forge2DGame with HasDraggables {
  TunnelFunnel()
      : super(
          gravity: Vector2(0, -15),
        ) {
    addContactCallback(PlayerWallContactCallback());
    addContactCallback(PlayerPlatformContactCallback());
  }

  PlayerData playerData = PlayerData();
  late JoystickComponent joystick;

  @override
  Future<void> onLoad() async {
    final boundaries = createBoundaries(this);

    await addParallax();

    await addJoySticks();
    boundaries.forEach(add);

    add(EnemyManager());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  Future<void> startGame() async {
    addPlayer(Vector2(20.96011904761905, -16.49203869047619));
    await addFirstPlatform();
  }

  Future<void> replay() async {
    final enemies = children.whereType<Platform>();
    for (var element in enemies) {
      element.removeFromParent();
    }

    final player = children.whereType<Player>();
    for (var element in player) {
      element.removeFromParent();
    }

    addPlayer(Vector2(20.96011904761905, -20.49203869047619));
    await addFirstPlatform();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
  }

  Future<void> addParallax() async {
    final parallaxBackground = await loadParallaxComponent(
      [
        ParallaxImageData('parallax/back-buildings.png'),
        ParallaxImageData('parallax/far-buildings.png'),
        ParallaxImageData('parallax/foreground.png'),
      ],
      size: size,
      baseVelocity: Vector2(2, 0),
      velocityMultiplierDelta: Vector2(2, 0),
    );

    add(parallaxBackground);
  }

  void addPlayer(Vector2 position) async {
    Map<PlayerAnimationState, SpriteAnimation>? animations = {
      PlayerAnimationState.run: await loadSpriteAnimation(
        "player/Run.png",
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
      PlayerAnimationState.hit: await loadSpriteAnimation(
        "player/Hit.png",
        SpriteAnimationData.sequenced(
          amount: 3,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
      PlayerAnimationState.jump: await loadSpriteAnimation(
        "player/Jump.png",
        SpriteAnimationData.sequenced(
          loop: false,
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
      PlayerAnimationState.fall: await loadSpriteAnimation(
        "player/Fall.png",
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
      PlayerAnimationState.death: await loadSpriteAnimation(
        "player/Death.png",
        SpriteAnimationData.sequenced(
          loop: false,
          amount: 7,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
      PlayerAnimationState.attack: await loadSpriteAnimation(
        "player/Attack.png",
        SpriteAnimationData.sequenced(
          loop: true,
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
      PlayerAnimationState.idle: await loadSpriteAnimation(
        "player/Idle.png",
        SpriteAnimationData.sequenced(
          amount: 4,
          stepTime: 0.1,
          textureSize: Vector2.all(200),
        ),
      ),
    };
    animations = animations;
    Vector2 size = Vector2.all(25);

    SpriteAnimationGroupComponent<PlayerAnimationState> component =
        SpriteAnimationGroupComponent<PlayerAnimationState>(
      animations: animations,
      position: position,
      size: size,
      current: PlayerAnimationState.idle,
    );

    add(Player(
        joysticks: joystick,
        position: position,
        component: component,
        playerSize: size));
  }

  Future<void> addFirstPlatform() async {
    final platformImage = await loadSprite('tiles/tile.png');

    final position = Vector2(20.96011904761905, -20.49203869047619);

    SpriteComponent component =
        SpriteComponent(sprite: platformImage, position: position);
    final size = Vector2(20, 2);

    add(Platform(component, position, size, nonMoveable: true, speed: -20));
  }

  Future<void> addJoySticks() async {
    final knobPaint = BasicPalette.white.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.white.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: -325),
    );

    add(joystick);
  }
}
