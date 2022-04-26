package com.project.init.command;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;

import com.project.init.dao.PlanIDao;
import com.project.init.dao.PostIDao;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PostDtDto;
import com.project.init.util.Constant;

public class PlanDtGetMapCommand implements ICommand {

	@Autowired
	private PlanIDao planDao = Constant.pdao;
	
	@Autowired
	private PostIDao postDao = Constant.postDao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		String userId = request.getParameter("userId");
		
		if ( userId == null || userId == "" ) {
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			User user = (User)authentication.getPrincipal();
			userId = user.getUsername();
		}
		
		String value1 = request.getParameter("value1");
		String value2 = request.getParameter("value2");
		String value3 = request.getParameter("value3");
		String value4 = request.getParameter("value4");
		
		Map<String, String> map = new HashMap<String, String>();
		
		map.put("userId", userId);
		map.put("value1", value1);
		map.put("value2", value2);
		map.put("value3", value3);
		map.put("value4", value4);
		
		ArrayList<PlanDtDto> result = planDao.selectPlanDtMap(map);

		ArrayList<PostDtDto> result2 = postDao.getMapPost(result);
		
		request.setAttribute("selectPlanDtMap", result);
		request.setAttribute("getMapPost", result2);
	}

}
