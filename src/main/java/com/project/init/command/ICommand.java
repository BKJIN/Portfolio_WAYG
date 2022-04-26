package com.project.init.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface ICommand {

	void execute(HttpServletRequest request, Model model);
	
}
