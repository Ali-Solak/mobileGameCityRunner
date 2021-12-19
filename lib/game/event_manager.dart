import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:tunnel_funnel/game/platform.dart';
import 'package:tunnel_funnel/game/player.dart';
import 'package:tunnel_funnel/game/tunnel_funnel.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends Component with HasGameRef<TunnelFunnel> {
  // A list to hold data for all the enemies.
  final List<Platform> _data = [];

  final Random _random = Random();
  int levelScore = 0;

  Timer _timer = Timer(1.22, repeat: true);

  EnemyManager() {
    _timer.onTick = () => spawnRandomEnemy(-20);
  }

  Future<void> spawnRandomEnemy(double speed) async {
    double ySpawn = _random.nextDouble() * (-50 - -5) + -5;

    final position = Vector2(200.96011904761905, ySpawn);
    final platformImage = await gameRef.loadSprite("tiles/tile.png");
    final size = Vector2(20, 2);
    SpriteComponent component = SpriteComponent(
      size: size,
      sprite: platformImage,
      position: position,
    );

    gameRef.add(Platform(component, position, size,
        speed: speed.toInt(), velocity: true, nonMoveable: false));
  }

  @override
  void onMount() {
    shouldRemove = false;

    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);

    if (levelScore < gameRef.playerData.score) {
      levelScore = gameRef.playerData.score;

      int speed = -30 - (levelScore * 0.83).toInt();

      print(speed);

      _timer.stop();
      _timer = Timer(1.55,
          repeat: true, onTick: () => spawnRandomEnemy(speed.toDouble()));
      _timer.start();
    }
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Platform>();
    for (var element in enemies) {
      element.remove;
    }
  }
}
