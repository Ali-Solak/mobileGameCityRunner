import 'package:flame/components.dart';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';

enum PlayerAnimationState { hit, run, death, fall, jump, attack, idle }

class Player extends PositionBodyComponent {
  int id = 1;
  bool colliding = false;
  bool dead = false;
  bool attacking = false;
  bool jumping = false;
  bool flippedleft = false;
  bool flippedright = true;
  bool inAir = false;
  Vector2 position;
  Vector2 playerSize;
  SpriteAnimationGroupComponent<PlayerAnimationState> component;
  JoystickComponent joysticks;
  int playerScore = 0;

  Player(
      {required this.position,
      required this.joysticks,
      required this.component,
      required this.playerSize})
      : super(
          positionComponent: component,
          size: playerSize,
        );

  void setPlayerScore(int score) {
    playerScore = score;
  }

  @override
  Body createBody() {
    final shape = PolygonShape();

    shape.setAsBoxXY(3, 3);

    final fixtureDef = FixtureDef(shape)
      ..userData = this
      ..density = 0.0
      ..friction = 0.0;

    final bodyDef = BodyDef()
      ..position = position
      ..type = BodyType.dynamic
      ..userData = this;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onMount() async {
    return super.onMount();
  }

  @override
  void update(double dt) {
    double bottom = gameRef.camera.viewport.effectiveSize.y.abs();
    if (!colliding && body.position.y <= bottom && !jumping && !dead) {
      inAir = true;
      component.current = PlayerAnimationState.fall;
    }
    if (!joysticks.delta.isZero() && !dead) {
      body.applyLinearImpulse(
          Vector2((joysticks.relativeDelta * 60 * dt).x, 0));

      component.current = PlayerAnimationState.run;

      if (joysticks.direction == JoystickDirection.right && !flippedright) {
        flippedright = true;
        component.flipHorizontally();
        flippedleft = false;
      }

      if (joysticks.direction == JoystickDirection.left && !flippedleft) {
        flippedleft = true;
        component.flipHorizontally();
        flippedright = false;
      }
    } else if (joysticks.delta.isZero() && colliding && !dead && !attacking) {
      body.linearVelocity.x = 0;
      component.current = PlayerAnimationState.idle;
    }

    super.update(dt);
  }

  void attack() {
    if (!dead && !attacking) {
      attacking = true;

      component.current = PlayerAnimationState.attack;
      Future.delayed(const Duration(milliseconds: 400), () {
        if (colliding) {
          component.current = PlayerAnimationState.idle;
          attacking = false;
        } else {
          component.current = PlayerAnimationState.fall;
          attacking = false;
        }
        attacking = false;
      });
    }
  }

  void jump() {
    if (!jumping && !dead) {
      body.applyLinearImpulse(Vector2(0, 15));
      jumping = true;
      component.current = PlayerAnimationState.jump;
      Future.delayed(const Duration(milliseconds: 200), () {
        component.current = PlayerAnimationState.fall;
      });
    }
  }
}
