package com.project.init.dto;

public class PostDtDto {
	private int postNo;
	private int planNum;
	private int planDtNum;
	private String location;
	
	public PostDtDto() {
		super();
	}
	
	public PostDtDto(int postNo, int planNum, int planDtNum, String location) {
		super();
		this.postNo = postNo;
		this.planNum = planNum;
		this.planDtNum = planDtNum;
		this.location = location;
	}
	
	public int getPostNo() {
		return postNo;
	}
	
	public void setPostNo(int postNo) {
		this.postNo = postNo;
	}
	
	public int getPlanNum() {
		return planNum;
	}
	
	public void setPlanNum(int planNum) {
		this.planNum = planNum;
	}
	
	public int getPlanDtNum() {
		return planDtNum;
	}
	
	public void setPlanDtNum(int planDtNum) {
		this.planDtNum = planDtNum;
	}
	
	public String getLocation() {
		return location;
	}
	
	public void setLocation(String location) {
		this.location = location;
	}
	
}
