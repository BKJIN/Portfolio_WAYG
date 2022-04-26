package com.project.init.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.init.command.AdminMypageCommand;
import com.project.init.command.ICommand;
import com.project.init.command.MdfMyPageCommand;
import com.project.init.dao.AdminIDao;
import com.project.init.dao.UserDao;
import com.project.init.dao.UserIDao;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

@Controller
public class AdminController {
	private static final Logger logger = LoggerFactory.getLogger(FeedController.class);
	
	@Autowired
	private AdminIDao dao;
	
	private ICommand comm;
	
    //===== DashBoard =====
	@RequestMapping("/admin") 
	public String admin() { 
		System.out.println("admin");
		return "admin/admin_main"; 
	}
	
	@RequestMapping("/u_admin") 
	public String u_admin() {
		System.out.println("u_admin");
		return "admin/user_admin"; 
	}
	
	// 장소 별 통계
	@ResponseBody 
	@RequestMapping(value = "/placesDashBoard", produces="application/json; charset=UTF-8")
	public ArrayList<PlanDtDto> placesDashBoard(HttpServletRequest request, Model model) {
		logger.info("placesDashBoard() in >>>>");
		
		String value1 = request.getParameter("value1");
		String value2 = request.getParameter("value2");
		Map<String, String> map = new HashMap<>();
		map.put("value1", value1);
		map.put("value2", value2);
		
		ArrayList<PlanDtDto> placesDashBoard = dao.selectDashBoardPlaces(map);
		
		request.setAttribute("topPlaces", placesDashBoard);
		System.out.println(placesDashBoard);
		
		return placesDashBoard;
	}
	
	// 년도, 월, 일 별 회원수 통계
	@ResponseBody
	@RequestMapping(value = "/userDashBoard", produces="application/json; charset=UTF-8")
	public ArrayList<UserDto> userDashBoard(HttpServletRequest request, Model model){
		logger.info(" userDashBoard() in >>>>");
		
		String value1 = request.getParameter("value1");
		String value2 = request.getParameter("value2");
		String value3 = request.getParameter("value3");
		String value4 = request.getParameter("value4");
		Map<String, String> map = new HashMap<>();
		map.put("value1", value1);
		map.put("value2", value2);
		map.put("value3", value3);
		map.put("value4", value4);
		
		ArrayList<UserDto> userDashBoard = dao.selectDashBoardUser(map);
		
		request.setAttribute("userStatistics", userDashBoard);
		System.out.println(userDashBoard);
		
		return userDashBoard;
	}
	
	// 회원 성별 통계
	@ResponseBody
	@RequestMapping(value = "/userDashBoardGender", produces="application/json; charset=UTF-8")
	public ArrayList<UserDto> userDashBoardGender(Model model){
		logger.info("userDashBoardGender() in >>>>");
		
		ArrayList<UserDto> userDashBoardGender = dao.selectDashBoardUserGender();
		model.addAttribute("userGender", userDashBoardGender);
		
		return userDashBoardGender;
	}
	
	// 회원 연령별 통계
	@ResponseBody
	@RequestMapping(value = "/userDashBoardAge", produces="application/json; charset=UTF-8")
	public ArrayList<UserDto> userDashBoardAge(Model model){
		logger.info("userDashBoardAge() in >>>>");
		
		ArrayList<UserDto> userDashBoardAge = dao.selectDashBoardUserAge();
		model.addAttribute("userAge", userDashBoardAge);
		
		return userDashBoardAge;
	}
	
	/*
	@ResponseBody
	@RequestMapping(value="/searchNick")
	public UserDto searchNick(HttpServletRequest request) {
		System.out.println("searchNick");
		String nick = request.getParameter("nick");
		System.out.println(nick);
		UserDto result = dao.searchNick(nick);
		return result;
	}*/
	
	@ResponseBody
	@RequestMapping(value="/deleteUser")
	public UserDto deleteUser(HttpServletRequest request) {
		System.out.println("deleteUser");
		String nick = request.getParameter("nick");
		System.out.println(nick);
		UserDto result = dao.deleteUser(nick);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/banUser")
	public UserDto banUser(HttpServletRequest request) {
		System.out.println("banUser");
		String nick = request.getParameter("nick");
		System.out.println(nick);
		UserDto result = dao.banUser(nick);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/activateUser")
	public UserDto activateUser(HttpServletRequest request) {
		System.out.println("activateUser");
		String nick = request.getParameter("nick");
		System.out.println(nick);
		UserDto result = dao.activateUser(nick);
		return result;
	}
	
	@RequestMapping("adminMyPage")
	public String adminMyPage(HttpServletRequest request, HttpServletResponse response, Model model) {
		logger.info("adminMyPage() in >>>>");
		
		comm = new AdminMypageCommand();
		comm.execute(request, model);
		
		return "feed/feed_user_info";
	}
	
	@RequestMapping("adminModifyMyPage")
	@ResponseBody
	public String modifyMyPage(@RequestParam(value="userNick") String userNick, 
							   @RequestParam(value="userBio") String userProfileMsg, 
							   @RequestParam(value="userPst") String userPst, 
							   @RequestParam(value="userAddr1") String userAddress1, 
							   @RequestParam(value="userAddr2") String userAddress2, 
							   @RequestParam(value="useremail") String uemail, 
							   HttpServletRequest request, Model model) {
		
		logger.info("modifyMyPage() in >>>>");
		int UserPst = Integer.parseInt(userPst);
			
		UserDto udto = new UserDto(uemail, null, userNick, null, 0, null, UserPst, userAddress1, null, userProfileMsg, null, null, null, null, null, userAddress2);
		
		request.setAttribute("udto", udto);
		comm = new MdfMyPageCommand();
		comm.execute(request, model);
		
		String result = (String) request.getAttribute("result");
		
		
		logger.info("adminModifyMyPage() result : " + result);
		
		if(result.equals("success"))
			return "modified";
		else
			return "not-modified";
	}
	
	@PostMapping("adminEraseImg")
	@ResponseBody
	public String adminEraseImg(@RequestParam(value="userEmail") String uId) {
		UserDao udao = Constant.udao;
		
		String olduPrfImg = udao.getolduPrfImg(uId);
		
		long prename = System.currentTimeMillis();
		String basicImg = prename + "nulluser.svg";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("uId",uId);
		map.put("basicImg", basicImg);
		udao.deletePrfImg(map);

		//String path = "C:/Users/310-08/git/projectTest/project_init/src/main/webapp/resources/profileImg/";
		//String path1 = "C:/Users/310-08/git/projectTest/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/profileImg/";
		
		String path = "C:/ecl/workspace/project_init/src/main/webapp/resources/profileImg/";
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/profileImg/";
		//기존 저장돼있던 사진 삭제
		File file = new File(path + olduPrfImg);
		File file1 = new File(path1 + olduPrfImg);
		if(file.exists()) {
			file.delete();
		}
		if(file1.exists()) {
			file1.delete();
		}
		
		return "success";
	}

}
