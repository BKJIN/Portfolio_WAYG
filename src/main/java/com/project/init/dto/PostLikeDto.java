package com.project.init.dto;

public class PostLikeDto {
	private String postLikeNo;
	private String postNo;
	private String email;
	private int like;	
	
	public PostLikeDto(String postNo, String email) {
		super();
		this.postNo = postNo;
		this.email = email;
	}
	
	
	public PostLikeDto() {
		super();
	}
	public String getPostLikeNo() {
		return postLikeNo;
	}
	public void setPostLikeNo(String postLikeNo) {
		this.postLikeNo = postLikeNo;
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
	public int getLike() {
		return like;
	}
	public void setLike(int like) {
		this.like = like;
	}
	
	
}
