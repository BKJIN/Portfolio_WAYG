package com.project.init.dao;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PlanMstDto;

public interface PlanIDao {
	// main map에 모든 일정 불러오기
	ArrayList<PlanDtDto> selectPlanList();
	
	// main map filter 처리
	ArrayList<PlanDtDto> filter(Map<String, String> map);
	
	// userId로 planMst 불러오기
	ArrayList<PlanMstDto> selectAllPlan(String userId);

	// planNum으로 planDt 불러오기
	ArrayList<PlanDtDto> selectPlanDt(String planNum, String userId);
	
	// modal에서 수정한 planMst 처리
	String modifyPlanMst(PlanMstDto mstDto, List<PlanDtDto> updatePlanDt, List<PlanDtDto> deletePlanDt, List<PlanDtDto> insertPlanDt, String userId);
	
	// modal창에서 planMst를 삭제했을 때 처리
	String deletePlanMst(String planNum, String userId);
	
	// planNum으로 PlanMst 불러오기
	PlanMstDto selectPlanMst(String planNum, String userId);	
	
	// planDt insert
	String insertPlanDtDo(PlanMstDto mstDto, ArrayList<PlanDtDto> dtDtos);
	
	// planDt modify (update, insert, delete)
	String detailModifyDo(ArrayList<PlanDtDto> deleteDtDtos, ArrayList<PlanDtDto> insertDtDtos, ArrayList<PlanDtDto> updateDtDtos);
	
	// feedMap 에 표시할 상세 일정(PlanDt) 불러오기
	ArrayList<PlanDtDto> selectPlanDtMap(Map<String, String> map);
	
	// myfeed 상단에 일정 개수 표시
	int countPlanMst(String email);
}
