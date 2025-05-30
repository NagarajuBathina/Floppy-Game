import 'dart:async';

import 'package:first_game/component/hidden_coin.dart';
import 'package:first_game/component/pipe.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Dash extends PositionComponent with CollisionCallbacks {
  Dash()
      : super(
            position: Vector2(0, 0),
            size: Vector2.all(80),
            anchor: Anchor.center,
            priority: 10);

  late Sprite _dashSprite;

  final Vector2 _gravity = Vector2(0, 1400.0);
  Vector2 _velocity = Vector2(0, 0);
  final Vector2 _jumpForce = Vector2(0, -500);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _dashSprite = await Sprite.load('dash.png');
    final radius = size.x / 2;
    final center = size / 2;
    add(CircleHitbox(
        radius: radius * 0.77, position: center * 1.1, anchor: Anchor.center));
  }

  @override
  void update(double dt) {
    super.update(dt);
    // delto time --> time passed since the last frame
    // 10 frames per second --> 0.1 -> 100ms
    // 5 frames per second --> 0.2 -> 200ms
    _velocity += _gravity * dt;
    position += _velocity * dt;
  }

  void jump() {
    _velocity = _jumpForce;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _dashSprite.render(canvas, size: size);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    print('test print');
    if (other is HiddenCoin) {
      print('lets increase the coin');
      other.removeFromParent();
    } else if (other is Pipe) {
      print('GAME IS OVER!!!!');
    }
  }
}
