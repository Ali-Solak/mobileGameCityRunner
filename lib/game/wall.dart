import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;
  String id;

  Wall(this.start, this.end, this.id);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..friction = 0.3;

    final bodyDef = BodyDef()
      ..userData = this // To be able to determine object in collision
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

List<Wall> createBoundaries(Forge2DGame game) {
  final topLeft = Vector2.zero();
  final bottomRight = game.screenToWorld(game.camera.viewport.effectiveSize);
  final topRight = Vector2(bottomRight.x, topLeft.y);
  final bottomLeft = Vector2(topLeft.x, bottomRight.y);

  return [
    Wall(topLeft, topRight, "top"),
    Wall(topRight, bottomRight, "top"),
    Wall(bottomRight, bottomLeft, "bottom"),
    Wall(bottomLeft, topLeft, "top"),
  ];
}
