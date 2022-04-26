package com.project.init.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import com.project.init.dto.CommentsDto;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PlanMstDto;
import com.project.init.dto.PostDtDto;
import com.project.init.dto.PostDto;
import com.project.init.dto.PostLikeDto;
import com.project.init.dto.PostViewDto;
import com.project.init.util.Constant;

@Component
public class PostDao implements PostIDao {

	private static final Logger logger = LoggerFactory.getLogger(PostDao.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	public PostDao (SqlSession sqlSession) {
		logger.info("PostDao Const in >>>");
		this.sqlSession = sqlSession;
		Constant.postDao = this;
		
		logger.info("PostDao Const result : sqlSession getConn success ? " + sqlSession.toString());
	}
	
	@Override
	@Transactional
	public void write(PostDto dto, ArrayList<PostDtDto> dtDtos) {
		logger.info("write(" + dto.getEmail() + ") in >>>");
		
		sqlSession.insert("write", dto);
		
		if ( dtDtos.size() != 0 ) {
			for(int i = 0; i < dtDtos.size(); i++ ) {
				dtDtos.get(i).setPostNo(Integer.parseInt(dto.getPostNo()));
			}
			
			sqlSession.insert("insertPostDt", dtDtos);
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ArrayList<PostDto> list(String email) {
		logger.info("list(" + email + ") in >>>");
				
		ArrayList<PostDto> list =  (ArrayList)sqlSession.selectList("list",email);
		
		logger.info("PostDao list result : list.isEmpty() ? " + list.isEmpty());
		return list;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ArrayList<PostDto> mylist(String email, Model model) {
		logger.info("mylist(" + email + ") in >>>");

		ArrayList<PostDto> list =  (ArrayList)sqlSession.selectList("mylist", email);
		
		logger.info("PostDao mylist result : list.isEmpty() ? " + list.isEmpty());
		
		return list;
	}
	
	@Override
	public String addView(PostViewDto dto) {
		logger.info("addView(" + dto.getEmail() + ") in >>>");
		
		String result = null;
		
		int tmp = sqlSession.selectOne("view", dto);	
		
		if(tmp == 0) {
			sqlSession.insert("addView", dto);
			
			logger.info("addView() result 1 : addview");
		
		}else {			
			logger.info("addView() result 1 : not-work");
		}
		
		return "success";
	}
	
	@Override
	public ArrayList<CommentsDto> getcomments(String postNo) {
		logger.info("getcomments(" + postNo + ") in >>>");
		
		ArrayList<CommentsDto> dto =(ArrayList)sqlSession.selectList("getcomments",postNo);

		return dto;
	}
	
	@Override
	public void addReplyComments(CommentsDto dto){
		logger.info("addReplyComments(" + dto.getEmail() + ") in >>>");
		
		int res1 = sqlSession.update("beforeAddReply", dto);
		
		logger.info("addReplyComments(" + dto.getEmail() + ") result 1 : " + (res1 > 0 ? "update-success": "update-failed"));
		
		int res2 = sqlSession.insert("addReplyComments", dto);
		
		logger.info("addReplyComments(" + dto.getEmail() + ") result 1 : " + (res2 > 0 ? "insert-success": "insert-failed"));
	}
	
	@Override
	public void deleteReplyComments(String commentNo) {
		logger.info("deleteReplyComments(" + commentNo + ") in >>>");
		
		int res = sqlSession.update("deleteReplyComments", commentNo);
		
		logger.info("deleteReplyComments(" + commentNo + ") result : " + (res > 0 ? "update-success": "update-failed"));
	}

	@Override
	public void addcomments(CommentsDto dto) {
		logger.info("addcomments(" + dto.getEmail() + ") in >>>");
		
		int res = sqlSession.insert("addcomments", dto);
		
		logger.info("addcomments(" + dto.getEmail() + ") result : " + (res > 0 ? "update-success": "update-failed"));
	}
	
	@Override
	public String addLike(PostLikeDto dto) {
		logger.info("addLike(" + dto.getPostNo() + ") in >>>");
		
		int tmp =sqlSession.selectOne("like", dto);
		String result ="";
		
		if(tmp ==0) {
			sqlSession.insert("addLike", dto);	
			result = "add";
			
		}else {
			sqlSession.delete("deleteLike", dto);
			result = "delete";
		}
		
		logger.info("addLike(" + dto.getPostNo() + ") result : " + result);
		
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public PostDto getlist(PostDto tmp) {
		logger.info("getlist(" + tmp.getPostNo() + ") in >>>");
		
		PostDto dto = sqlSession.selectOne("getlist",tmp);
		
		ArrayList<PostDtDto> dtList = (ArrayList)sqlSession.selectList("selectPostDt", Integer.parseInt(tmp.getPostNo()));
		if ( dtList.size() != 0 ) {
			dto.setPostDt(dtList);
		}
		
		logger.info("getlist(" + tmp.getPostNo() + ") result : " + dto.getPlan());
		
		return dto;
	}
	
	@Override
	@Transactional
	public void modifyExcute(PostDto dto, ArrayList<PostDtDto> insertDtDtos, ArrayList<PostDtDto> deleteDtDtos) {
		
		if ( dto != null ) { 
			sqlSession.update("modifyExcute", dto);
		}
		
		if ( deleteDtDtos.size() != 0 ) {
			sqlSession.delete("deletePostDt", deleteDtDtos);
		}
		
		if ( insertDtDtos.size() != 0 ) {
			sqlSession.insert("insertPostDt", insertDtDtos);
		}		
	}
	
	@Override
	public void deletePost(String postNo) {
		sqlSession.delete("deletePost", postNo);
		sqlSession.delete("deleteComments", postNo);
		sqlSession.delete("deletePostDt2", Integer.parseInt(postNo));
		sqlSession.delete("deleteLikes", postNo);
		sqlSession.delete("deleteViews", postNo);
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ArrayList<PostDto> likeList(String email) {

		ArrayList<PostDto> list =  (ArrayList)sqlSession.selectList("likeList",email);
		
		return list;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ArrayList<PostDto> viewList(String email) {
		ArrayList<PostDto> list =  (ArrayList)sqlSession.selectList("viewList",email);
		return list;
	}
	
	public ArrayList<PostDtDto> getMapPost(ArrayList<PlanDtDto> dtDtos) {
		logger.info("getMapPost(dtDtos) in >>>");
		
		ArrayList<PostDtDto> mapPost = new ArrayList<PostDtDto>();
		if ( dtDtos.size() != 0 ) {
			mapPost = (ArrayList)sqlSession.selectList("getMapPost", dtDtos);
		}
		
		logger.info("getMapPost(dtDtos) result : mapPost.size() ? " + mapPost.size());
		return mapPost;
	}
	
	public int countPost (String email) {
		int res = sqlSession.selectOne("countPost", email);
		System.out.println(res);

		return res;
	}
	
	
	
	/* unset

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ArrayList<PostDto> search(String keyword, String searchVal) {
		ArrayList<PostDto> dto = new ArrayList<PostDto>();
		
		if(searchVal.equals("writer")) {
			dto = (ArrayList)sqlSession.selectList("searchWriter", keyword);
			return dto;
		}else if(searchVal.equals("content")) {
			dto = (ArrayList)sqlSession.selectList("searchContent", keyword);
			return dto;
		}
		else if(searchVal.equals("location")) {
			dto = (ArrayList)sqlSession.selectList("searchLocation", keyword);
			return dto;
		}else {
			dto = (ArrayList)sqlSession.selectList("searchHashtag", keyword);			
			return dto;
		}
		
		
	}

*/

}
