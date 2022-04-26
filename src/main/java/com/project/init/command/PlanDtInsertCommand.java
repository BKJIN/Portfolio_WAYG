package com.project.init.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;

import com.project.init.dao.PlanIDao;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PlanMstDto;
import com.project.init.util.Constant;

public class PlanDtInsertCommand implements ICommand {

	private static final Logger logger = LoggerFactory.getLogger(PlanDtInsertCommand.class);
	
	@Autowired
	private PlanIDao planDao = Constant.pdao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		logger.info("PlanDtInsertCommand in >>> ");
		
		String result = null;
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		PlanMstDto mstDto = Constant.planMstDtoParser(request, uId);
		logger.info("PlanDtInsertCommand result1 : mstDto.planName ? " + mstDto.getPlanName());
		
		ArrayList<PlanDtDto> dtDtos = (ArrayList)Constant.planDtDtoParser(mstDto.getPlanNum(), uId, request);
		logger.info("PlanDtInsertCommand result2 : dtDtos.isEmpty() ? " + dtDtos.isEmpty());		
		
		result = planDao.insertPlanDtDo(mstDto, dtDtos);
		logger.info("PlanDtInsertCommand result3 : PlanDtInsert " + result);		
	
		request.setAttribute("result", result);
		
	}

}
