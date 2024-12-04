import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class DateTimeUtils {
  static Future<String> getKoreaTimeForUrl() async {
    DateTime koreaTime = await getKoreaTime();

    // 밀리초까지 포함한 포맷 (예: yyyy-MM-dd_HH:mm:ss.SSS)
    String formattedDate =
        DateFormat('yyyy-MM-dd-HH-mm-ss-SSS').format(koreaTime);
    return formattedDate;
  }

  static Future<DateTime> getKoreaTime() async {
    try {
      // UTC 시간 가져오기
      DateTime utcTime = await NTP.now();
      // UTC -> KST 변환
      return utcTime.add(const Duration(hours: 9));
    } catch (e) {
      ///로컬 시간 반환 대신 다른 방법 생각해봐야함
      // NTP 실패 시, 로컬 시간 반환 (예외 처리)
      return DateTime.now().toUtc().add(const Duration(hours: 9));
    }
  }
}
