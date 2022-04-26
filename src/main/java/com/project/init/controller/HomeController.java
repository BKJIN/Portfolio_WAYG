package com.project.init.controller;


import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.project.init.command.BoardContentCommand;
import com.project.init.command.BoardModifyCommand;
import com.project.init.command.BoardWriteCommand;
import com.project.init.command.ICommand;
import com.project.init.command.MainMapFilterCommand;
import com.project.init.dao.BoardIDao;
import com.project.init.dao.PlanIDao;
import com.project.init.dao.PostIDao;
import com.project.init.dao.UserDao;
import com.project.init.dto.NoticeBoardDto;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PostDto;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;


@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private PlanIDao dao;

	@Autowired
	private BoardIDao bdao;

	@Autowired
	private PostIDao postDao;

	
	private ICommand comm;
	private UserDao udao;
	
	@Autowired
	public void setUdao(UserDao udao) {
		this.udao = udao;
		Constant.udao = udao;
	}
	
	//index page
	@RequestMapping("/")
	public String index(Model model, HttpServletRequest request ) {
		logger.info("index() in >>>>");
		
		// redirectFlashAttribute에 담겨온 parameter를 Map으로 저장
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
		
		String uId = null;
		
		// securityContextHolder에 저장된 user정보로 dto 생성
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		UserDto dto = Constant.getUserInfo(authentication);
		
		// 로그인 된 회원일 때
		if ( dto != null ) {
			model.addAttribute("user", dto);
			uId = dto.getUserEmail();
		}
		
		// redirectFlashAttribute 값이 존재할 때
		if ( flashMap != null ) {
			model.addAttribute("error", (String)flashMap.get("error"));
		}
		
		// 최신포스트 가져오기
		ArrayList<PostDto> post = postDao.list(uId);
		model.addAttribute("post", post);
		
		// 좋아요 순 포스트 가져오기
		ArrayList<PostDto> likeList = postDao.likeList(uId);
		model.addAttribute("likeList", likeList);
		
		// 조회수 순 포스트 가져오기
		ArrayList<PostDto> viewList = postDao.viewList(uId);
		model.addAttribute("viewList", viewList);
		
		return "index";
	}
	
	@RequestMapping("/join")
	public String join() {
		logger.info("join() in >>>>");
		return "join/join";
	}
	
	@ResponseBody
	@RequestMapping(value = "/selectPlanList", produces="application/json; charset=UTF-8")
	public ArrayList<PlanDtDto> selectPlanList(Model model) {
		logger.info("selectPlanList() in >>>>");
		
		ArrayList<PlanDtDto> selectPlanList = dao.selectPlanList();
		model.addAttribute("latlng", selectPlanList);
		
		return selectPlanList;
	}

	
	@ResponseBody
	@RequestMapping(value = "/filter", produces="application/json; charset=UTF-8")
	public ArrayList<PlanDtDto> filter(HttpServletRequest request, Model model){
		logger.info("filter() in >>>>");
		comm = new MainMapFilterCommand();
		comm.execute(request, model);
		
		ArrayList<PlanDtDto> filterDtos = (ArrayList)request.getAttribute("filter");

		return filterDtos;
	}
	
	@RequestMapping("/notice_board")
	public String noticeBoard(Model model) {
		logger.info("noticeBoard() in >>>>");
		
		ArrayList<NoticeBoardDto> bdtos = bdao.getBoardList();
		
		model.addAttribute("boardList", bdtos);
		
		logger.info("noticeBoard() result : bdtos.isEmpty() ? " + bdtos.isEmpty());
		
		return "notice_board/notice_board";
	}
	
	@RequestMapping("/notice_board/write_view")
	public String writeView(Model model) {
		logger.info("writeView() in >>>>");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		model.addAttribute("bName", uId);
		logger.info("write_view result : bName ? " + uId);

		
		return "notice_board/notice_board_write";
	}
	
	@RequestMapping("/notice_board/write")
	public String write(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("write in >>>>");
		comm = new BoardWriteCommand();
		comm.execute(request, model);
		
		return "redirect:/notice_board";
	}
	
	@RequestMapping("/notice_board/contentView")
	public String content_view(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("content_view in >>>>");

		String result = "failed";
		
		comm = new BoardContentCommand();
		comm.execute(request, model);
		
		if ( model.containsAttribute("content_view") ) {
			result = "success";
		}

		logger.info("content_view result : " + result);
		
		return "notice_board/notice_board_content";
	}

	
	@RequestMapping("/notice_board/modify")
	public String modify(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("modify in >>>>");
		comm = new BoardModifyCommand();
		comm.execute(request, model);
		String redirect = request.getParameter("bId");
		
		return "redirect:/notice_board/contentView?bId="+redirect;
	}
	
	@RequestMapping("/notice_board/delete")
	public String delete(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("delete in >>>> " + request.getParameter("bId"));

		bdao.noticeDelete(Integer.parseInt(request.getParameter("bId")));
		
		return "redirect:/notice_board";
	}

		
}
