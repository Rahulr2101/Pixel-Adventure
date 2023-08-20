import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  Player player = Player(Character: 'Pink Man');
  late JoystickComponent joystick;
  bool showJoystick = false;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    final world = Level(levelName: 'Level-01.tmx', player: player);
    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    if (showJoystick) {
      addJoyStick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick();
    }

    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent.fromImage(
        images.fromCache('HUD/Knob.png'),
        size: Vector2(50, 50),
      ),
      background: SpriteComponent.fromImage(
        images.fromCache('HUD/Joystick.png'),
        size: Vector2(100, 100),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left || JoystickDirection.upLeft:
        player.direction = PlayerDirection.left;
        break;
      case JoystickDirection.right || JoystickDirection.upRight:
        player.direction = PlayerDirection.right;
        break;
      default:
        player.direction = PlayerDirection.none;
        break;
    }
  }
}
