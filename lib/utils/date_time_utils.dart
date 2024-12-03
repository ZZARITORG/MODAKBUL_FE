import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class DateTimeUtils {
  static Future<String> getKoreaTimeForUrl() async {
    try {
      // UTC 시간 가져오기
      DateTime utcTime = await NTP.now();
      // UTC -> KST 변환
      DateTime koreaTime = utcTime.add(const Duration(hours: 9));

      // 밀리초까지 포함한 포맷 (예: yyyy-MM-dd_HH:mm:ss.SSS)
      String formattedDate = DateFormat('yyyy-MM-dd-HH-mm-ss-SSS').format(koreaTime);
      return formattedDate;
    } catch (e) {
      // NTP 실패 시, 로컬 시간 반환 (예외 처리)
      DateTime koreaTime = DateTime.now().toUtc().add(const Duration(hours: 9));

      // 로컬 시간 포맷 (밀리초 포함)
      String formattedDate = DateFormat('yyyy-MM-dd-HH-mm-ss-SSS').format(koreaTime);
      return formattedDate;
    }
  }
}