import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  final String levelName;
  late TiledComponent level;
  final Player player;
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName', Vector2.all(16));

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>("spawnpoint");
    add(level);
    for (final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          player.position = Vector2(spawnPoint.x, spawnPoint.y);
          add(player);

          break;
        default:
      }
    }

    return super.onLoad();
  }
}
