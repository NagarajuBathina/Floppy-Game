import 'dart:math';
import 'package:first_game/component/dash.dart';
import 'package:first_game/component/pipe_pair.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlappyDashGame extends FlameGame<FlappyDashWorld>
    with KeyboardEvents, HasCollisionDetection {
  FlappyDashGame()
      : super(
          world: FlappyDashWorld(),
          camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
        );

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      //jump
      world.onSpaceClicked();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class FlappyDashWorld extends World
    with TapCallbacks, HasGameReference<FlappyDashGame> {
  late Dash _dash;
  late PipePair _lastPipe;
  static const _lastPipeDistance = 400;
  int _score = 0;
  late TextComponent _scoreText;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    // add(FlappyDashBackground());
    add(_dash = Dash());
    _generatePipes(fromX: 320);

    //camera zoom
    // game.camera.viewfinder.zoom = 1.0;

    game.camera.viewfinder.add(_scoreText = TextComponent(
        position: Vector2(0, -(game.size.y / 2)), text: _score.toString()));
  }

  void _generatePipes({
    int count = 5,
    double fromX = 0.0,
  }) {
    for (var i = 0; i <= count; i++) {
      final area = 600;
      final y = (Random().nextDouble() * area) - (area / 2);
      add(_lastPipe = PipePair(
          position: Vector2(fromX + (i * _lastPipeDistance).toDouble(), y)));
    }
  }

  void _removeOldPipes() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 8, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _dash.jump();
  }

//space button clicked
  void onSpaceClicked() {
    _dash.jump();
  }

// increasing score
  void increaseScore() {
    _score += 1;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreText.text = _score.toString();
    if (_dash.x >= _lastPipe.x) {
      _generatePipes(fromX: _lastPipeDistance.toDouble());
    }
    _removeOldPipes();
  }
}
