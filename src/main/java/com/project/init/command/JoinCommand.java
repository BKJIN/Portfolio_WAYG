package com.project.init.command;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;

import com.project.init.dao.UserDao;
import com.project.init.util.Constant;

public class JoinCommand implements ICommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		BCryptPasswordEncoder passwordEncoder = Constant.passwordEncoder;
		UserDao udao = Constant.udao;
		
		String UEmail = request.getParameter("uEmail");
		String UPw = request.getParameter("uPw1");
		String UNickName = request.getParameter("uNickName");
		String UBirth = request.getParameter("uBirth");
		String UGender = request.getParameter("uGender");
		String UPst = request.getParameter("uPst");
		String UAddr1 = request.getParameter("uAddr1");
		String UAddr2 = request.getParameter("uAddr2");
		
		Map<String, Object> map = model.asMap();
		String basicImg = (String) map.get("basicImg");
		System.out.println("basicImg: " + basicImg);
		
		String UPw_org = UPw; //암호화 되기전 password를 UPw_org에 저장
		UPw = passwordEncoder.encode(UPw_org); //암호화
		System.out.println(UPw + " size " + UPw.length());
		
		String result = udao.join(UEmail,UPw,UNickName,UBirth,UGender,UPst,UAddr1,basicImg,UAddr2);
		
		request.setAttribute("result", result); //controller에서 결과 사용
	}
	
}