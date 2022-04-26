package com.project.init.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.init.dto.PostDto;
import com.project.init.dto.SearchDto;
import com.project.init.util.Constant;

@Component
public class SearchDao implements SearchIDao {

	private static final Logger logger = LoggerFactory.getLogger(SearchDao.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	@Autowired
	public SearchDao (SqlSession sqlSession) {
		logger.info("PostDao Const in >>>");
		this.sqlSession = sqlSession;
		Constant.searchDao = this;
		
		logger.info("PostDao Const result : sqlSession getConn success ? " + sqlSession.toString());
	}
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public ArrayList<PostDto> search(SearchDto dto) {
		
		System.out.println(dto.getKeyword());
		
		ArrayList<PostDto> dtos = new ArrayList<PostDto>();
		PostDto tmp = new PostDto();
		ArrayList<String> arr = new ArrayList<String>();
		String keyword = dto.getKeyword();
		String email="";
		String location="";
		
		if (keyword.equals("Hashtag")) {
			System.out.println(dto.getSearchVal());
			dtos =(ArrayList)sqlSession.selectList("searchHashtag", dto);
			System.out.println("dtos : " + dtos);
			return dtos;

		} else if (keyword.equals("NickName")) {			
			arr =(ArrayList) sqlSession.selectList("checkNickName", dto);
			
			if(arr.size()!=0) {			
				for(int i=0; i<arr.size(); i++) {	
					email = arr.get(i);
					System.out.println(email);
					ArrayList<PostDto> tmpArr = (ArrayList)sqlSession.selectList("searchNickName",email);
					dtos.addAll(tmpArr);
				}
				System.out.println("SIZE()"+dtos.size());
				return dtos;	
			}			
		} else {
			
			arr =(ArrayList) sqlSession.selectList("checkLocation", dto);
			
			if (arr.size()!=0) {		
				for(int i=0; i<arr.size(); i++) {	
					location = arr.get(i);
					System.out.println(location);
					ArrayList<PostDto> tmpArr = (ArrayList)sqlSession.selectList("searchLocation", location);	
					dtos.addAll(tmpArr);
				}
				return dtos;	
			}
			
		}
		
		return dtos;		
	}
}
