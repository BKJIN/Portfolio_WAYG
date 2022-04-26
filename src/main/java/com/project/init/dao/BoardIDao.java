package com.project.init.dao;

import java.util.ArrayList;

import com.project.init.dto.NoticeBoardDto;

public interface BoardIDao {
	
	// 전체 공지사항 게시글 불러오기
	ArrayList<NoticeBoardDto> getBoardList();
	
	// 공지사항 게시판 글 작성
	public void write(String bName, String bTitle, String bContent);
	
	// 공지사항 게시글 조회
	NoticeBoardDto contentView(String bid);
	
	// 공지사항 게시글 수정
	void noticeModify(NoticeBoardDto dto);
	
	// 공지사항 게시글 삭제
	void noticeDelete(int bId);
}
