import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiPath{
  ///static const String baseUrl = 'https://api.example.com';
  ///static const String exampleEndpoint = '/example';
  static String baseUrl = dotenv.env['BASE_URL'] ?? '';
  static String s3Url = dotenv.env['S3_URL'] ?? '';
  static String kakaoRestApiUrl = dotenv.env['KAKAO_REST_API_URL'] ?? '';
  static String appKey = dotenv.env['APP_KEY'] ?? '';

  //health check
  static String healthCheck = '/api/v0/health';

  //auth
  static const String signUp = '/api/v0/auth/sign-up';
  static const String login = '/api/v0/auth/login';
  static const String logout = '/api/v0/auth/logout';
  static const String tokenRefresh = '/api/v0/auth/refresh-token';
  static const String checkUserExists = '/api/v0/auth/phoneNo';
  static String checkIdDuplication(String userId) => '/api/v0/auth/$userId';

  //meeting
  static const String meeting = '/api/v0/meeting';
  static const String meetingHost = '/api/v0/meeting/host';
  static const String meetingAccept = '/api/v0/meeting/accept';
  static const String meetingPending = '/api/v0/meeting/pending';
  static const String meetingFriend = '/api/v0/meeting/friendId';
  static const String meetingGroup = '/api/v0/meeting/groupId';
  static const String meetingReject = '/api/v0/meeting/reject';
  static const String meetingCancel = '/api/v0/meeting/cancel';

  //notification
  static const String notification = '/api/v0/notification/notification-list';

  //friend
  static const String friend = '/api/v0/friend';
  static const String friendReq = '/api/v0/friend/friend-request';
  static const String friendAccept = '/api/v0/friend/friend-accept';
  static const String friendBlock = '/api/v0/friend/friend-block';
  static const String friendUnblock = '/api/v0/friend/friend-unblock';
  static const String friendReject = '/api/v0/friend/friend-reject';
  static const String friendList = '/api/v0/friend/friend-list';
  static const String friendReqList = '/api/v0/friend/friend-req-list';
  static const String friendSuggested = '/api/v0/friend/suggested-friends';
  static const String friendBlockList = '/api/v0/friend/friend-block-list';

  //group
  static const String group = '/api/v0/group';

  //user
  static const String user = '/api/v0/user';
  static const String userMe = '/api/v0/user/me';
  static String userCheck(String id) => '/api/v0/user/$id';



  //AWS
  static String getPresignedUrl(String userId) => '/api/v0/aws/presigned/$userId';

  //KaKao
  static String kakaoRestApi = kakaoRestApiUrl;
  static String keywordToAddress = '/local/search/keyword.json?';
  static String coordToAddress = '/local/geo/coord2address.json?';

}