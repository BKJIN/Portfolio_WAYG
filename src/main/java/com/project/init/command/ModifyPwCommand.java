package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;

import com.project.init.dao.UserDao;
import com.project.init.util.Constant;

public class ModifyPwCommand implements ICommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		BCryptPasswordEncoder passwordEncoder = Constant.passwordEncoder;
		UserDao udao = Constant.udao;
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		String Npw = request.getParameter("npw");
		
		String Npw_org = Npw; //암호화 되기전 password를 Npw_org에 저장
		Npw = passwordEncoder.encode(Npw_org); //암호화
		System.out.println(Npw + " size " + Npw.length());
		
		String result = udao.modifyPw(Npw, uId);
		
		request.setAttribute("result", result); //controller에서 결과 사용
	}

}
