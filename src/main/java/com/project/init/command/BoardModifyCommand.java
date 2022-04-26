package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.project.init.dao.BoardDao;
import com.project.init.dto.NoticeBoardDto;
import com.project.init.util.Constant;

public class BoardModifyCommand implements ICommand {

	private BoardDao boardDao = Constant.bdao;
	
	@Override
	public void execute(HttpServletRequest request, Model model) {
		String bId = request.getParameter("bId");
		String bTitle = request.getParameter("bTitle");
		String bContent = request.getParameter("bContent");
		
		System.out.println(bContent);
		
		
		NoticeBoardDto dto = new NoticeBoardDto();
		dto.setbId(Integer.parseInt(bId));
		dto.setbTitle(bTitle);
		dto.setbContent(bContent);
		
		boardDao.noticeModify(dto);
	}

}
