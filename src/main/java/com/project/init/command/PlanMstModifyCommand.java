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

import com.project.init.dao.PlanDao;
import com.project.init.dao.PlanIDao;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PlanMstDto;
import com.project.init.util.Constant;

public class PlanMstModifyCommand implements ICommand {

	private static final Logger logger = LoggerFactory.getLogger(PlanMstModifyCommand.class);
	
	@Autowired
	private PlanIDao planDao = Constant.pdao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		// pdao Parameter Setting
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String userId = user.getUsername();
		
		// 처리할 내용으로 구분하여 담을 arrayList 생성
		List<PlanDtDto> updatePlanDt = new ArrayList<PlanDtDto>();
		List<PlanDtDto> deletePlanDt = new ArrayList<PlanDtDto>();
		List<PlanDtDto> insertPlanDt = new ArrayList<PlanDtDto>();
		
		// 수정 전 dateCount 과 수정 된 dateCount
		String originDateCount = request.getParameter("originDateCount");
		String newDateCount = request.getParameter("newDateCount");
		
		// planMst update : submit된 parameter로 PlanMstDto 생성
		PlanMstDto mstDto = Constant.planMstDtoParser(request, userId);
		// dto의 DateCount를 수정된 dateCount로 설정
		mstDto.setDateCount(newDateCount);
		
		// 수정 전 dateCount를 int로 변환	
		int origin = Integer.parseInt(originDateCount);
		// 수정 된 dateCount를 int로 변환
		int newly = Integer.parseInt(newDateCount);
		
		/* PlanDtDto를 생성하여 변경된 dateCount와 planDate를 설정하여 DB 수정 */
		
		// 원래보다 짧은 일정으로 수정된 경우
		if ( origin > newly ) {
			// 수정된 날짜 수를 초과하는 기존 일정은 deletePlanDt add
			for (int i = (newly+1); i <= origin; i++) {
				PlanDtDto dtDto = new PlanDtDto();
				dtDto.setPlanNum(mstDto.getPlanNum());
				dtDto.setUserId(userId);
				dtDto.setPlanDay("day"+i);			
				// 삭제해야할 planDay를 가진 dto를 deletePlanDt add
				deletePlanDt.add(dtDto);
			}
			
			// 나머지 일정은 updatePlanDt add
			updatePlanDt = Constant.getUpdateDtos(mstDto.getPlanNum(), userId, mstDto.getStartDate(), newly);
		}		
		
		// 원래 일정 수와 수정된 일정 수가 같은 경우
		else if ( origin == newly ) {
			// 일정 수 만큼의 PlanDtDto를 생성하여 updatePlanDt add
			updatePlanDt = Constant.getUpdateDtos(mstDto.getPlanNum(), userId, mstDto.getStartDate(), newly);				
		}
			
		// 원래 일정보다 긴 일정으로 수정한 경우
		else if ( origin < newly ) {
			System.out.println(origin + " - " + newly );
			
			// 새로운 일정만큼의 dto를 생성하여 updatePlanDt add
			updatePlanDt = Constant.getUpdateDtos(mstDto.getPlanNum(), userId, mstDto.getStartDate(), newly);
			
			System.out.println("updateDt.size : " + updatePlanDt.size());
			
			// 기존 일정 수를 초과하는 날짜의 dto는 null 값으로 setting하여 insertPlanDt add / updatePlanDt에서는 삭제
			for(int i = (newly-1); i >= origin; i-- ) {
				updatePlanDt.get(i).setPlanDtNum(0);
				updatePlanDt.get(i).setTheme("방문");
				updatePlanDt.get(i).setTransportation("도보");
				updatePlanDt.get(i).setPlaceCount("0");
				System.out.println("updateDt.size : " + updatePlanDt.size());
				insertPlanDt.add(updatePlanDt.get(i));
				
				System.out.println("insertPlanDt.size : " + updatePlanDt.size());
				updatePlanDt.remove(i);
				System.out.println("updateDt.size : " + updatePlanDt.size());
			}
		}	
		String result = planDao.modifyPlanMst(mstDto, updatePlanDt, deletePlanDt, insertPlanDt, userId);
		
		request.setAttribute("result", result);
	}

}
