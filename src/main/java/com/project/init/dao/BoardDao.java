package com.project.init.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.init.dto.NoticeBoardDto;
import com.project.init.util.Constant;

@Component
public class BoardDao implements BoardIDao {
	private static final Logger logger = LoggerFactory.getLogger(PlanDao.class);
	
	private final SqlSession sqlSession;

	// sqlSession set-autowired
	@Autowired
	public BoardDao (SqlSession sqlSession) {
		logger.info("PlanDao Const in >>>");
		this.sqlSession = sqlSession;
		
		Constant.bdao = this;
		logger.info("PlanDao Const result : sqlSession getConn success ? " + sqlSession.toString());
	}
	
	// 전체 공지사항 게시글 불러오기
	@Override
	public ArrayList<NoticeBoardDto> getBoardList() {
		logger.info("getBoardList() in >>>>");
		
		ArrayList<NoticeBoardDto> result = (ArrayList)sqlSession.selectList("listNotice");
		
		logger.info("list() result.isEmpty() ? " + result.isEmpty());
		
		return result;
	}

	// 공지사항 게시판 글 작성
	@Override
	public void write(String bName, String bTitle, String bContent) {
		logger.info("write() in >>>>");
		
		NoticeBoardDto dto = new NoticeBoardDto();
		dto.setbName(bName);
		dto.setbTitle(bTitle);
		dto.setbContent(bContent);
		
		int res = sqlSession.insert("writeNotice", dto);
		logger.info("write() result : " + (res > 0 ? "success" : "failed"));
	}
	
	// 공지사항 게시글 조회
	public NoticeBoardDto contentView(String bid) {
		logger.info("contentView(" + bid + ") in >>>>");
		
		// 조회수 up
		upHit(bid);
		
		NoticeBoardDto dto = sqlSession.selectOne("contentViewNotice", Integer.parseInt(bid));
		
		logger.info("contentView result : " + dto.getbName());
		
		return dto;
	}
	
	// 게시글 조회시 조회수 올리기
	public void upHit(String bId) {
		logger.info("upHit(" + bId + ") in >>> ");	
		
		int res = sqlSession.update("upHitNotice", Integer.parseInt(bId));
		
		logger.info("upHit result : " + res);
	}
	
	// 공지사항 게시글 수정
	@Override
	public void noticeModify(NoticeBoardDto dto) {
		logger.info("noticeModify(" + dto.getbId() + ") in >>> ");
		
		int res = sqlSession.update("noticeModify", dto);
		
		logger.info("noticeModify result : " + res);
	}
	
	// 공지사항 게시글 삭제
	@Override
	public void noticeDelete(int bId) {
		logger.info("noticeDelete(" + bId + ") in >>> ");
		
		int res = sqlSession.update("noticeDelete", bId);
		
		logger.info("noticeDelete result : " + res);
	}
	
	
}
