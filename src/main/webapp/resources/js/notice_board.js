$(document).ready(function() {
	 
	let username = "<c:out value='${username}'/>";
	let bName = $('#uname').val();
	
	
	if ( username == "" || username != bName ) {
		$('#title').attr('readonly',true);
		$('#content').attr('readonly',true);
	}
	
	
	$('#modBtn').click(function(e) {
		e.preventDefault();
		
		$('input#title').attr('readonly', false);
		$('textarea#content').attr('readonly', false);
		$(this).css('display', 'none');
		$('#modDoBtn').removeClass('d-none');
	});

	$('#modDoBtn').click(function() {
		if ( confirm('게시글을 수정할까요?') == false ) {
			return false;
		}
	});


	$('#delBtn').click(function(e) {
		e.preventDefault();
		
		if ( confirm('게시글을 삭제할까요?') == true ) {
			location.href = $(this).attr('href');			
		} else {
			return false;
		}
	});

	$('#rv').click(function(e) {
		e.preventDefault();
		
		$.ajax({
			url: $(this).attr('href'),
			type: 'get',
			success: function(data) {
				$('#main').html(data);
				
			},
			error: function(data) {
				console.log(data);
			}
		});
	});
	
	$('#loginBtn').click(function() {
		$('#loginModalBtn').trigger('click');
	});
	
	$('.anFeed').click(function() {
		$('#loginModalBtn').trigger('click');
	});
});