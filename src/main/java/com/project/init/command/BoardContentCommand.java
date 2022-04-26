package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.project.init.dao.BoardDao;
import com.project.init.dto.NoticeBoardDto;
import com.project.init.util.Constant;

public class BoardContentCommand implements ICommand {
	
	private BoardDao boardDao = Constant.bdao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {

		String bid = request.getParameter("bId");
		
		NoticeBoardDto dto = boardDao.contentView(bid);
		
		if ( dto != null ) {
			model.addAttribute("content_view", dto);
		}
	}

}
