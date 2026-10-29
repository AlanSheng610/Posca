import 'package:flutter_test/flutter_test.dart';
import 'package:posca/widgets/pickers.dart';

void main() {
  test('formatBirthdate uses year/month/day without padding', () {
    expect(formatBirthdate(DateTime(2001, 2, 3)), '2001/2/3');
  });
}
