package com.project.init.command;

import java.util.ArrayList;
import java.util.List;

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
import com.project.init.util.Constant;

public class PlanDtModifyCommand implements ICommand {

	private static final Logger logger = LoggerFactory.getLogger(PlanDtModifyCommand.class);
	
	@Autowired
	private PlanIDao planDao = Constant.pdao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		logger.info("detailModifyDo() in >>> ");
		
		String result = null;

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		// 상세 일정(PlanDt) 수정된 내용으로 구분해서 담을 배열 선언
		ArrayList<PlanDtDto> deleteDtDtos = new ArrayList<PlanDtDto>();
		ArrayList<PlanDtDto> insertDtDtos = new ArrayList<PlanDtDto>();
		ArrayList<PlanDtDto> updateDtDtos = new ArrayList<PlanDtDto>();
		
		// 1. deleteDtNum : 상세 일정(PlanDt) 수정할 때 기존 db에 저정된 일정이 삭제된 경우
		if(! request.getParameter("deleteDtNum").equals("") ) {
			logger.info("detailModifyDo deleteNum is exist");
			
			// 삭제된 상세 일정 번호(PlanDtNum)을 배열에 저장
			String[] deleteDtNums = request.getParameter("deleteDtNum").split("/");
			
			// 삭제된 상세 일정 번호(PlanDtNum)와 아이디를 추가한 dto를 deleteDtDtos add
			for ( int i = 0; i < deleteDtNums.length; i++ ) {
				
				PlanDtDto dto = new PlanDtDto();
				dto.setUserId(uId);
				dto.setPlanDtNum(Integer.parseInt(deleteDtNums[i]));
				
				deleteDtDtos.add(dto);
			}
			logger.info("detailModifyDo result1: deleteDtDtos.size() ? " + deleteDtDtos.size());
			
		// 삭제된 일정이 없으면 처리하지 않음
		} else {
			logger.info("detailModifyDo deleteNum is null");
		}
		
		// 2. 상세 일정(PlanDt) 수정 후 submit된 전체 일정 정보를 불러옴
		int planNum = Integer.parseInt(request.getParameter("planNum"));
		ArrayList<PlanDtDto> dtos = (ArrayList)Constant.planDtDtoParser(planNum, uId, request);

		for ( int i = 0 ; i < dtos.size(); i++ ) {
			// planDtNum == 0 : 상세 일정 수정하면서 새로 추가된 일정은 insertDtDtos add
			if ( dtos.get(i).getPlanDtNum() == 0 ) {
				insertDtDtos.add(dtos.get(i));
				
			// planDtNum != 0 : 상세 일정 수정하면서 기존에 있던 일정은 updateDtDtos add
			} else {
				updateDtDtos.add(dtos.get(i));
			}
		};
		
		result = planDao.detailModifyDo(deleteDtDtos, insertDtDtos, updateDtDtos);
		
		request.setAttribute("result", result);
	}

}
