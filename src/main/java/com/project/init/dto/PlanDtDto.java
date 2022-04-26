package com.project.init.dto;


public class PlanDtDto {
	
	private int planDtNum;
	private int planNum;
	private String userId;
	private String placeName;
	private String placeCount;
	private String planDay;
	private String planDate;
	private String startTime;
	private String endTime;
	private String theme;
	private String latitude;
	private String longitude;
	private String address;
	private String category;
	private String transportation;
	private String details;
	private String count;
	
	public PlanDtDto() {
		super();
	}

	public PlanDtDto(int planDtNum, int planNum, String userId, String placeName, String placeCount, String planDay,
			String planDate, String startTime, String endTime, String theme, String latitude, String longitude,
			String address, String category, String transportation, String details) {
		super();
		this.planDtNum = planDtNum;
		this.planNum = planNum;
		this.userId = userId;
		this.placeName = placeName;
		this.placeCount = placeCount;
		this.planDay = planDay;
		this.planDate = planDate;
		this.startTime = startTime;
		this.endTime = endTime;
		this.theme = theme;
		this.latitude = latitude;
		this.longitude = longitude;
		this.address = address;
		this.category = category;
		this.transportation = transportation;
		this.details = details;
	}
	
	//useAdmin
	public PlanDtDto(int planDtNum, int planNum, String userId, String placeName, String placeCount, String planDay,
			String planDate, String startTime, String endTime, String theme, String latitude, String longitude,
			String address, String category, String transportation, String details, String count) {
		super();
		this.planDtNum = planDtNum;
		this.planNum = planNum;
		this.userId = userId;
		this.placeName = placeName;
		this.placeCount = placeCount;
		this.planDay = planDay;
		this.planDate = planDate;
		this.startTime = startTime;
		this.endTime = endTime;
		this.theme = theme;
		this.latitude = latitude;
		this.longitude = longitude;
		this.address = address;
		this.category = category;
		this.transportation = transportation;
		this.details = details;
		this.count = count;
	}

	public int getPlanDtNum() {
		return planDtNum;
	}

	public void setPlanDtNum(int planDtNum) {
		this.planDtNum = planDtNum;
	}

	public int getPlanNum() {
		return planNum;
	}

	public void setPlanNum(int planNum) {
		this.planNum = planNum;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPlaceName() {
		return placeName;
	}

	public void setPlaceName(String placeName) {
		this.placeName = placeName;
	}

	public String getPlaceCount() {
		return placeCount;
	}

	public void setPlaceCount(String placeCount) {
		this.placeCount = placeCount;
	}

	public String getPlanDay() {
		return planDay;
	}

	public void setPlanDay(String planDay) {
		this.planDay = planDay;
	}

	public String getPlanDate() {
		return planDate;
	}

	public void setPlanDate(String planDate) {
		this.planDate = planDate;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getTheme() {
		return theme;
	}

	public void setTheme(String theme) {
		this.theme = theme;
	}

	public String getLatitude() {
		return latitude;
	}

	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getTransportation() {
		return transportation;
	}

	public void setTransportation(String transportation) {
		this.transportation = transportation;
	}

	public String getDetails() {
		return details;
	}

	public void setDetails(String details) {
		this.details = details;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}
	
}
