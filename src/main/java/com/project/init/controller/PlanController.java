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
import org.springframework.web.bind.annotation.ResponseBody;

import com.project.init.command.ICommand;
import com.project.init.command.PlanDtInsertCommand;
import com.project.init.command.PlanDtModifyCommand;
import com.project.init.dao.PlanIDao;
import com.project.init.dao.UserDao;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PlanMstDto;
import com.project.init.util.Constant;

@Controller
@RequestMapping("/plan")
public class PlanController {

	
	private static final Logger logger = LoggerFactory.getLogger(FeedController.class);
	
	@Autowired
	private PlanIDao dao;
	private ICommand comm;
	private UserDao udao;
	@Autowired
	public void setUdao(UserDao udao) {
		this.udao = udao;
		Constant.udao = udao;
	}

	@RequestMapping("")
	public String planmstDo(PlanMstDto dto, Model model) {
		logger.info("planmst.do(" + dto.getPlanName() + ") in >>>>");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		
		// 상세 일정 생성페이지로 넘어갈 때, feed_calendar에서 생성한 planMst 정보 model에 싣어서 보냄
		model.addAttribute("plan", dto);
		model.addAttribute("id", uId);

		return "plan/plan_detail";
	}
	
	// 상세일정 생성 완료시 db 저장
	@ResponseBody
	@RequestMapping(value = "detail.do", produces = "application/text; charset=UTF-8")
	public String detailDo(HttpServletRequest request, Model model) {
		logger.info("detail.do() in >>>>");
		comm = new PlanDtInsertCommand();
		comm.execute(request, model);

		String result = (String)request.getAttribute("result");
		
		return result;
	}

	
	// modal창에서 상세일정 수정 페이지로 이동
	@RequestMapping("detail_modify")
	public String detail_modify(String planNum, Model model) {
		logger.info("detail_modify(" + planNum + ") in >>>>");
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		// planNum이 일치하는 planMst 정보를 가져와서 model에 담음
		PlanMstDto result1= dao.selectPlanMst(planNum, uId);
		model.addAttribute("plan1", result1);
		
		// planNum이 일치하는 planDt 정보를 가져와서 model에 담음
		ArrayList<PlanDtDto> result2= dao.selectPlanDt(planNum, uId);
		model.addAttribute("plan2", result2);
		
		return "plan/plan_modify";
	}
	
	
	// 상세 수정 페이지에서 수정한 내용 db insert
	@ResponseBody
	@RequestMapping(value="detail_modify.do", produces="application/text; charset=UTF-8")
	public String detailModifyDo(HttpServletRequest request) {
		logger.info("detail_modify(" + request.getParameter("planNum") + ") in >>>>");
		
		comm = new PlanDtModifyCommand();
		comm.execute(request, null);
		
		String result = (String)request.getAttribute("result");
		
		logger.info("detail_modify(" + request.getParameter("planNum") + ") result : " + result);

		return result;
	}
	
}
