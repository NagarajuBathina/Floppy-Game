import 'package:first_game/component/hidden_coin.dart';
import 'package:first_game/component/pipe.dart';
import 'package:flame/components.dart';

class PipePair extends PositionComponent {
  final double gap;
  final double speed;
  PipePair({required super.position, this.gap = 200, this.speed = 200});

  @override
  void onLoad() {
    super.onLoad();
    addAll([
      Pipe(isFlipped: false, position: Vector2(0, gap / 2)),
      Pipe(isFlipped: true, position: Vector2(0, (-gap / 2))),
      HiddenCoin(position: Vector2(0, 0))
    ]);
  }

  @override
  void update(double dt) {
    position.x -= speed * dt;
    super.update(dt);
  }
}
