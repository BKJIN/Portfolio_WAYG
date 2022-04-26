package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.project.init.dao.UserDao;
import com.project.init.dto.UserDto;
import com.project.init.util.Constant;

public class AddPrfImgCommand implements ICommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		UserDao udao = Constant.udao;
		UserDto udto = (UserDto) request.getAttribute("udto");
		
		String result = udao.addPrfImg(udto);
		
		model.addAttribute("result",result);
	}

}
