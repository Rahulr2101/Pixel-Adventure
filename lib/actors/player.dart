import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String Character;
  Player({position, this.Character = 'Ninja Frog'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  final double stepTime = 0.05;

  PlayerDirection direction = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isleftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    if (isleftKeyPressed && isRightKeyPressed) {
      direction = PlayerDirection.none;
    } else if (isleftKeyPressed) {
      direction = PlayerDirection.left;
    } else if (isRightKeyPressed) {
      direction = PlayerDirection.right;
    } else {
      direction = PlayerDirection.none;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAnimations() {
    idleAnimation = _spriteanimation('Idle', 11);

    runningAnimation = _spriteanimation('Run', 12);

// List of all animation
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

// Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteanimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$Character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    double dirx = 0.0;
    switch (direction) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirx -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirx += moveSpeed;
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        dirx = 0.0;
        break;
    }
    velocity = Vector2(dirx, 0.0);
    position += velocity * dt;
  }
}
