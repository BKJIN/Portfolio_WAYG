package com.project.init.command;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.project.init.dao.PostIDao;
import com.project.init.dto.PostDtDto;
import com.project.init.dto.PostDto;
import com.project.init.util.Constant;

public class PostWriteCommand implements ICommand {
	
	private PostIDao postDao = Constant.postDao;
	
	public void execute(HttpServletRequest request, Model model) { 
		
		MultipartHttpServletRequest multi = (MultipartHttpServletRequest)request;
		
		String images = "";
		String titleImage="";
		String tmp="";
		int views =0;
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		User user = (User)authentication.getPrincipal();
		String uId = user.getUsername();
		
		
		List<MultipartFile> fileList = multi.getFiles("img");
		
		//String path = "C:/Users/310-08/git/projectTest/project_init/src/main/webapp/resources/images/";
		//String path = "C:/Users/310-08/git/projectTest/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/images/";
		
		String path = "C:/ecl/workspace/project_init/src/main/webapp/resources/images/";
		String path1 = "C:/ecl/apache-tomcat-9.0.56/wtpwebapps/project_init/resources/images/";
		
		for (MultipartFile mf : fileList) {
			String originalFileName = mf.getOriginalFilename();
			UUID prefix = UUID.randomUUID();
			
			try {
				mf.transferTo(new File(path + prefix + originalFileName));
				mf.transferTo(new File(path1 + prefix + originalFileName));
				
				tmp += prefix + originalFileName+"/";
				
			} catch (IllegalStateException | IOException e) {
				e.getMessage(); 
				System.out.println(e.getMessage());
			}
		}
		
		images = tmp;
		String[] test = images.split("/");
		
		titleImage = test[0];
		PostDto dto = new PostDto(uId,
								  multi.getParameter("planNum"),
								  multi.getParameter("content"),
								  multi.getParameter("hashtag"),
								  titleImage,
								  images,
								  views);
		
		ArrayList<PostDtDto> dtDtos = new ArrayList<PostDtDto>();
		
		if ( request.getParameterValues("planDtNum") != null) {
			String[] planDtNum = request.getParameterValues("planDtNum");
			String[] placeName = request.getParameterValues("placeName");
			
			int planNum = Integer.parseInt(multi.getParameter("planNum"));

			for(int i = 0; i < planDtNum.length; i++ ) {
				PostDtDto dtDto = new PostDtDto();
				
				dtDto.setPlanNum(planNum);
				dtDto.setPlanDtNum(Integer.parseInt(planDtNum[i]));
				dtDto.setLocation(placeName[i]);
				
				dtDtos.add(dtDto);
			}
			
		}
		
		postDao.write(dto, dtDtos);
		
		multi.setAttribute("result", dto);
	}
	
}
