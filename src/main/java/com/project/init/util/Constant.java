package com.project.init.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.project.init.dao.BoardDao;
import com.project.init.dao.ChatDao;
import com.project.init.dao.PlanDao;
import com.project.init.dao.PostDao;
import com.project.init.dao.SearchDao;
import com.project.init.dao.UserDao;
import com.project.init.dto.PlanDtDto;
import com.project.init.dto.PlanMstDto;
import com.project.init.dto.UserDto;

public class Constant {
	
	public static PlanDao pdao;
	public static PostDao postDao;
	public static UserDao udao;
	public static SearchDao searchDao;
	public static BCryptPasswordEncoder passwordEncoder;
	public static String username;
	public static BoardDao bdao;
	public static ChatDao cdao;
	
	public static UserDto getUserInfo(Authentication authentication) {
		
		String uId = authentication.getPrincipal().toString();
		UserDto dto = null;
		if ( uId == "" || uId == null || uId != "anonymousUser" ) {
			User user = (User)authentication.getPrincipal();
			uId = user.getUsername();
			dto = udao.login(uId);
		}
		
		return dto;
	}
	
	
	
	// parameter로 넘어온 PlanMstDto 정보를 PlanMst dto로 생성해주는 메서드
	public static PlanMstDto planMstDtoParser(HttpServletRequest request, String userId) {
		int planNum = Integer.parseInt(request.getParameter("planNum"));
		String planName = request.getParameter("planName");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String dateCount = request.getParameter("dateCount");
		String eventColor = request.getParameter("eventColor");
		
		PlanMstDto mstDto = new PlanMstDto(planNum, userId, planName, startDate, endDate, dateCount, eventColor);
		
		return mstDto;
	}
	
	// parameter로 넘어온 PlanDtDto 정보를 PlanDt dto ArrayList로 생성해주는 메서드
	public static List<PlanDtDto> planDtDtoParser(int planNum, String userId, HttpServletRequest request) {
		String[] planDtNum = request.getParameterValues("planDtNum");
		String[] placeName = request.getParameterValues("placeName");
		String[] placeCount = request.getParameterValues("placeCount");
		String[] planDay = request.getParameterValues("planDay");
		String[] planDate = request.getParameterValues("planDate");
		String[] startTime = request.getParameterValues("startTime");
		String[] endTime = request.getParameterValues("endTime");
		String[] theme = request.getParameterValues("theme");
		String[] latitude = request.getParameterValues("latitude");
		String[] longitude = request.getParameterValues("longitude");
		String[] address = request.getParameterValues("address");
		String[] category = request.getParameterValues("category");
		String[] transportation = request.getParameterValues("transportation");
		String[] details = request.getParameterValues("details");

		List<PlanDtDto> planDtDtos = new ArrayList<PlanDtDto>();
		
		for ( int i = 0 ; i < planDtNum.length; i++ ) {
			PlanDtDto dtDto = new PlanDtDto(Integer.parseInt(planDtNum[i]),
										  planNum,
										  userId,
										  placeName[i],
										  placeCount[i],
										  planDay[i],
										  planDate[i],
										  startTime[i],
										  endTime[i],
										  theme[i],
										  latitude[i],
										  longitude[i],
										  address[i],
										  category[i],
										  transportation[i],
										  details[i]);
			
			planDtDtos.add(dtDto);
		};
		
		return planDtDtos;
	}
	
	// modal창에서 PlanMst 수정시 수정된 일정(PlanMst)으로 상세 일정을 수정하기 위한 메서드
	public static List<PlanDtDto> getUpdateDtos(int planNum, String userId, String startDate, int dateCount) {
		List<PlanDtDto> dtos = new ArrayList<PlanDtDto>();
		
		// startDate Calendar 객체로 변환
		int y = Integer.parseInt(startDate.substring(0, 4));
		int m = Integer.parseInt(startDate.substring(5, 7)) - 1;;
		int d = Integer.parseInt(startDate.substring(8));
		
		Date date = new Date((y-1900), m, d);
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		
		for ( int i = 0; i < dateCount; i++ ) {
			if ( i == 0 ) {
				// startDate 일 때
				cal.add(Calendar.DATE, i);
			} else {
				// Calendar 1씩 더해진 날짜를 만듦
				cal.add(Calendar.DATE, 1);
			}
			
			// planDate를 db 포맷으로 변환
			String r = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			
			// planNum, planDay, planDate 를 갖는 PlanDtDto를 생성해서 ArrayList add
			PlanDtDto dtDto = new PlanDtDto();
			dtDto.setUserId(userId);
			dtDto.setPlanNum(planNum);
			dtDto.setPlanDay("day"+(i+1));
			dtDto.setPlanDate(r);
			
			dtos.add(dtDto);
		}
		
		return dtos;
		
	}
	
}
