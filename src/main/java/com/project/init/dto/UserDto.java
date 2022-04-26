package com.project.init.dto;

import java.sql.Timestamp;

public class UserDto {
	private String userEmail;
	private String userPw;
	private String userNick;
	private String userBirth;
	private int userAge;
	private String userGender;
	private int userPst;
	private String userAddress1;
	private String userProfileImg;
	private String userProfileMsg;
	private String userFollower;
	private String userFollowing;
	private String userAuthority;
	private Timestamp userJoinDate;
	private Timestamp userVisitDate;
	private String userAddress2;
	private String userDate;
	private String agegroup;
	private String count;
	private static boolean userEnabled;
	
	public UserDto() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public UserDto(String userEmail, String userPw, String userNick, String userBirth, int userAge, String userGender,
			int userPst, String userAddress1, String userProfileImg, String userProfileMsg, String userFollower,
			String userFollowing, String userAuthority, Timestamp userJoinDate, Timestamp userVisitDate,
			String userAddress2) {
		super();
		this.userEmail = userEmail;
		this.userPw = userPw;
		this.userNick = userNick;
		this.userBirth = userBirth;
		this.userAge = userAge;
		this.userGender = userGender;
		this.userPst = userPst;
		this.userAddress1 = userAddress1;
		this.userProfileImg = userProfileImg;
		this.userProfileMsg = userProfileMsg;
		this.userFollower = userFollower;
		this.userFollowing = userFollowing;
		this.userAuthority = userAuthority;
		this.userJoinDate = userJoinDate;
		this.userVisitDate = userVisitDate;
		this.userAddress2 = userAddress2;
	}
	
	// useAdmin
	public UserDto(String userEmail, String userPw, String userNick, String userBirth, int userAge, String userGender,
			int userPst, String userAddress1, String userProfileImg, String userProfileMsg, String userFollower,
			String userFollowing, String userAuthority, Timestamp userJoinDate, Timestamp userVisitDate,
			String userAddress2, String userDate, String agegroup, String count) {
		super();
		this.userEmail = userEmail;
		this.userPw = userPw;
		this.userNick = userNick;
		this.userBirth = userBirth;
		this.userAge = userAge;
		this.userGender = userGender;
		this.userPst = userPst;
		this.userAddress1 = userAddress1;
		this.userProfileImg = userProfileImg;
		this.userProfileMsg = userProfileMsg;
		this.userFollower = userFollower;
		this.userFollowing = userFollowing;
		this.userAuthority = userAuthority;
		this.userJoinDate = userJoinDate;
		this.userVisitDate = userVisitDate;
		this.userAddress2 = userAddress2;
		this.userDate = userDate;
		this.agegroup = agegroup;
		this.count = count;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getUserNick() {
		return userNick;
	}
	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}
	public String getUserBirth() {
		return userBirth;
	}
	public void setUserBirth(String userBirth) {
		this.userBirth = userBirth;
	}
	public int getUserAge() {
		return userAge;
	}
	public void setUserAge(int userAge) {
		this.userAge = userAge;
	}
	public String getUserGender() {
		return userGender;
	}
	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}
	public int getUserPst() {
		return userPst;
	}
	public void setUserPst(int userPst) {
		this.userPst = userPst;
	}
	public String getUserAddress1() {
		return userAddress1;
	}
	public void setUserAddress1(String userAddress1) {
		this.userAddress1 = userAddress1;
	}
	public String getUserProfileImg() {
		return userProfileImg;
	}
	public void setUserProfileImg(String userProfileImg) {
		this.userProfileImg = userProfileImg;
	}
	public String getUserProfileMsg() {
		return userProfileMsg;
	}
	public void setUserProfileMsg(String userProfileMsg) {
		this.userProfileMsg = userProfileMsg;
	}
	public String getUserFollower() {
		return userFollower;
	}
	public void setUserFollower(String userFollower) {
		this.userFollower = userFollower;
	}
	public String getUserFollowing() {
		return userFollowing;
	}
	public void setUserFollowing(String userFollowing) {
		this.userFollowing = userFollowing;
	}
	public String getUserAuthority() {
		return userAuthority;
	}
	public void setUserAuthority(String userAuthority) {
		this.userAuthority = userAuthority;
	}
	public Timestamp getUserJoinDate() {
		return userJoinDate;
	}
	public void setUserJoinDate(Timestamp userJoinDate) {
		this.userJoinDate = userJoinDate;
	}
	public Timestamp getUserVisitDate() {
		return userVisitDate;
	}
	public void setUserVisitDate(Timestamp userVisitDate) {
		this.userVisitDate = userVisitDate;
	}
	public String getUserAddress2() {
		return userAddress2;
	}
	public void setUserAddress2(String userAddress2) {
		this.userAddress2 = userAddress2;
	}
	public String getUserDate() {
		return userDate;
	}
	public void setUserDate(String userDate) {
		this.userDate = userDate;
	}
	public String getAgegroup() {
		return agegroup;
	}
	public void setAgegroup(String agegroup) {
		this.agegroup = agegroup;
	}
	public String getCount() {
		return count;
	}
	public void setCount(String count) {
		this.count = count;
	}
    public static boolean isEnabled() {
        return userEnabled;
    }
}