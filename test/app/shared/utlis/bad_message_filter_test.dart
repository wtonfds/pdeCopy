import 'package:app_pde/app/shared/utlis/bad_message_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deve retornar a mensagem filtrada quando há número', () {
    const message = '0123456789';

    final result = BadMessageFilter.filter(message);

    expect(result.text, '**********');
    expect(result.hasNumber, true);
    expect(result.numberCount, 10);
    expect(result.isBad, true);
  });

  test('deve retornar a mensagem filtrada quando há palavrão', () {
    final messages = [
      'puta',
      'cu',
      'Vaca',
      'Xoxota',
      'Puxa-saco',
      'esta é uma mensagem de teste caralho',
    ];

    final results = messages.map((e) => BadMessageFilter.filter(e)).toList();

    expect(results.every((result) => result.text.contains('*')), true);
    expect(results.every((result) => result.isBad), true);
    expect(results.last.text, 'esta é uma mensagem de teste *******');
  });

  test('deve retornar a mensagem filtrada quando há contato', () {
    const messages = [
      'facebook',
      'instagram',
      'gmail',
      'zap',
      'me passa seu face ou seu whats',
    ];

    final results = messages.map((e) => BadMessageFilter.filter(e)).toList();

    expect(results.every((result) => result.text.contains('*')), true);
    expect(results.every((result) => result.isBad), true);
    expect(results.last.text, 'me passa seu **** ou seu *****');
  });

  test('deve retornar a mesma mensagem enviada quando não há badWord', () {
    const message = 'esta é uma mensagem de teste';

    final result = BadMessageFilter.filter(message);

    expect(result.text, message);
    expect(result.isBad, false);
  });
}
