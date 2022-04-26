package com.project.init.dao;

import java.util.Calendar;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.project.init.dto.UserDto;

@Component
public class UserDao implements UserIDao {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public int emailCheck(String id) {
		int result = sqlSession.selectOne("emailCheck",id); 
		return result;
	}
	
	@Override
	public int nickCheck(String nick) {
		int result = sqlSession.selectOne("nickCheck",nick);
		return result;
	}
	
	@Override
	public String join(String UEmail, String UPw, String UNickName, String UBirth, String UGender, String UPst, String uAddr1, String basicImg, String uAddr2) {
		int UAgeNum = getAgeByBirthDay(UBirth);
		int UPstNum = Integer.parseInt(UPst);
		
		UserDto dto = new UserDto(UEmail,UPw,UNickName,UBirth,UAgeNum,UGender,UPstNum,uAddr1,basicImg,null,null,null,"ROLE_USER",null,null,uAddr2);
		
		int res = sqlSession.insert("join",dto);
		
		String result = null;
		
		if(res > 0)
			result = "success";
		else
			result = "failed";
		
		return result;
	}
	
	//생년월일로 만나이 구하기
	private int getAgeByBirthDay(String UBirth) {
		//년,월,일 자르기
		int bir_year = Integer.parseInt(UBirth.substring(0,4));
		int bir_month = Integer.parseInt(UBirth.substring(4,6));
		int bir_day = Integer.parseInt(UBirth.substring(6));
		//현재년,월,일 get		
		Calendar current = Calendar.getInstance();
		int cur_year = current.get(Calendar.YEAR);
		int cur_month = current.get(Calendar.MONTH);
		int cur_day = current.get(Calendar.DAY_OF_MONTH);
		int age = cur_year - bir_year;
		//만나이
		if(bir_month*100+bir_day>cur_month*100+cur_day) {
			age--;
		}
		return age;
		
	}

	@Override
	public UserDto login(String uId) {
		System.out.println(uId);
		UserDto result = sqlSession.selectOne("login",uId);
		return result;
	}

	@Override
	public void userVisit(String uId) {
		sqlSession.insert("userVisit",uId);
	}
	
	@Override
	public UserDto myPage(String uId) {
		System.out.println("UserDao_myPage");
		
		UserDto result = sqlSession.selectOne("myPage",uId);
		
		return result;
	}
	
	@Override
	public String getolduPrfImg(String uId) {
		String result = sqlSession.selectOne("getolduPrfImg",uId);
		return result;
	}
	
	@Override
	public String addPrfImg(UserDto udto) {
		System.out.println("addPrfImg");
		String res;
		int result = sqlSession.update("addPrfImg",udto);
		if(result == 1 )
			res = "success";
		else
			res= "failed";
		return res;
	}
	
	@Override
	public void deletePrfImg(Map<String,Object> map) {
		sqlSession.update("deletePrfImg",map);
	}

	@Override
	public String mdfMyPage(UserDto udto) {
		System.out.println("UserDao_mdfMyPage");
		String res;
		int result = sqlSession.update("mdfMyPage",udto);
		if(result == 1)
			res = "success";
		else
			res = "failed";
		return res;
	}

	@Override
	public String pwcheck(String uId) {
		System.out.println("UserDao_pwcheck");
		String upw = sqlSession.selectOne("pwcheck",uId);
		return upw;
	}

	@Override
	public String modifyPw(String Npw, String uId) {
		UserDto udto = new UserDto(uId,Npw,null,null,0,null,0,null,null,null,null,null,null,null,null,null);
		int res = sqlSession.update("modifyPw",udto);
		System.out.println(res);
		String result = null;
		if(res > 0)
			result = "success";
		else
			result = "failed";
		
		return result;
	}

	@Override
	public void resign(String uId) {
		sqlSession.delete("resign",uId);
	}
	
	//메세지페이지 회원 찾기
	@Override
	public UserDto searchNick(Map<String, Object> map) {
		UserDto udto = sqlSession.selectOne("searchNick",map);
		return udto;
	}

	@Override
	public String searchImg(String uId) {
		String pubImg = sqlSession.selectOne("searchImg",uId);
		return pubImg;
	}
	
}