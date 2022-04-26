package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.project.init.dao.BoardDao;
import com.project.init.util.Constant;

public class BoardWriteCommand implements ICommand {
	
	private BoardDao boardDao = Constant.bdao;
	
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		
		String bName = request.getParameter("bName");
		
		System.out.println(bName);
		
		boardDao.write(request.getParameter("bName"), 
					   request.getParameter("bTitle"), 
					   request.getParameter("bContent"));

	}

}
