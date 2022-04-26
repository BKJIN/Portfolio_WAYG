package com.project.init.dto;

public class SearchDto {
	private String keyword;
	private String searchVal;
	
	public SearchDto(String keyword, String searchVal) {
		super();
		this.keyword = keyword;
		this.searchVal = searchVal;
	}
	public String getKeyword() {
		return keyword;
	}
	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	public String getSearchVal() {
		return searchVal;
	}
	public void setSearchVal(String searchVal) {
		this.searchVal = searchVal;
	}
}
