package com.project.init.dto;

public class PostViewDto {

	private String postViewNo;
	private String postNo;
	private String email;
	private int View;
	
	public PostViewDto(String postNo, String email) {
		super();
		this.postNo = postNo;
		this.email = email;
	}
	public String getPostViewNo() {
		return postViewNo;
	}
	public void setPostViewNo(String postViewNo) {
		this.postViewNo = postViewNo;
	}
	public String getPostNo() {
		return postNo;
	}
	public void setPostNo(String postNo) {
		this.postNo = postNo;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getView() {
		return View;
	}
	public void setView(int view) {
		View = view;
	}	
	
}
