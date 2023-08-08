class UserProfile {
  String? userName;
  String? userId;
  String? memberId;
  String? memberRef;
  String? firstName;
  String? onlineId;
  String? message;
  bool? loginSuccess;
  String? accessToken;

  UserProfile(
      {this.userName,
      this.userId,
      this.memberId,
      this.memberRef,
      this.firstName,
      this.onlineId,
      this.message,
      this.loginSuccess,
      this.accessToken});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userName: json['Username'],
      userId: json['UserId'],
      memberId: json['MemberId'],
      memberRef: json['MemberRef'],
      firstName: json['Firstname'],
      onlineId: json['OnlineId'],
      message: json['Message'],
      loginSuccess: json['LoginSuccess'],
      accessToken: json['accessToken'],
    );
  }
}
