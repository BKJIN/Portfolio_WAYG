package com.project.init.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.project.init.dao.PostIDao;
import com.project.init.dao.SearchDao;
import com.project.init.dao.UserDao;
import com.project.init.dto.PostDto;
import com.project.init.dto.SearchDto;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

@Controller
@RequestMapping("/search")
public class SearchController {
	
	@Autowired
	private SearchDao searchDao;
	
	@Autowired
	private UserDao udao;
	
	@Autowired
	private PostIDao postDao;
	
	
	private static final Logger logger = LoggerFactory.getLogger(SearchController.class);
	
	// 검색창 검색시 처리
	@RequestMapping("search")
	public String search(HttpServletRequest request, Model model) {
		logger.info("search() in >>>>");

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		UserDto udto = udao.login(uId);
		model.addAttribute("user", udto);
		
		String keyword = request.getParameter("keyword");
		String searchVal = request.getParameter("searchVal");
		SearchDto dto = new SearchDto(keyword, searchVal);
		
		ArrayList<PostDto> list = searchDao.search(dto);
		
		if(list.size()==0) {
			return "error/nullPage";			
		}
		model.addAttribute("list", list);
		
		return "search/searchResult";
	}
	
	// 추천포스트 1 - 최신 post 더보기 버튼 클릭 시 
	@RequestMapping("lastest")
	public String lastest(HttpServletRequest request, Model model) {
		logger.info("search() in >>>>");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		UserDto udto = udao.login(uId);
		model.addAttribute("user", udto);
		
		
		ArrayList<PostDto> post = postDao.list(udto.getUserEmail());
		
		if(post.size()==0) {
			return "error/nullPage";			
		}
		
		
		model.addAttribute("list", post);
		
		System.out.println(post.get(0).getLikes());
		
		return "search/searchResult";
	}
	
	// 추천포스트 2 - 좋아요 순 post 더보기 버튼 클릭 시
	@RequestMapping("bestLikes")
	public String bestLikes(HttpServletRequest request, Model model) {
		logger.info("search() in >>>>");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserDto dto = Constant.getUserInfo(authentication);

		ArrayList<PostDto> likeList = postDao.likeList(dto.getUserEmail());
		
		if(likeList.size()==0) {
			return "error/nullPage";			
		}
		
		model.addAttribute("list", likeList);
		
		return "search/searchResult";
	}
	
	// 추천포스트 3 - 조회수 순 post 더보기 버튼 클릭 시
	@RequestMapping("bestViews")
	public String bestViews(HttpServletRequest request, Model model) {
		logger.info("search() in >>>>");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		UserDto udto = udao.login(uId);
		model.addAttribute("user", udto);
		
		
		ArrayList<PostDto> viewList = postDao.viewList(udto.getUserEmail());
		
		if(viewList.size()==0) {
			return "error/nullPage";			
		}

		model.addAttribute("list", viewList);
		
		return "search/searchResult";
	}
	
}
