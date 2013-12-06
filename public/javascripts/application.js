$('#login').click(function(){
	mpmetrics.track_funnel("signup",2,"go to twitter");
	$('#loading').show('slow');
});

function twitter_cb(posts){
	var div = $('#feed').append('<h4><a href="http://twitter.com/' + posts[0].user.screen_name  +'">' + posts[0].user.name + '\'s latest tweets</a></h4>');
	var ul = $('<ul></ul>');
	for (var i=0; i < posts.length; i++) {
		var post = posts[i]; 
		var li = $('<li></li>');

		if(i==0){
			div.append('<a href="http://twitter.com/' + post.user.screen_name + '"><img src="' + post.user.profile_image_url + '" alt="' + post.user.screen_name + '" /></a>');
		}
	
		li.append(link_text(post.text));
		
		li.append('<div class="time"><a href="http://twitter.com/' + 
			post.user.screen_name + 'statuses/' + post.id + '">' +
			relative_created_at(post.created_at) + '</a></div>');
		
		ul.append(li);
	}
	div.append(ul);
}

function relative_created_at(time_value) {
	var created_at_time = Date.parse(time_value.replace(" +0000",""));
	var relative_time = ( arguments.length > 1 ) ? arguments[1] : new Date();
	var wordy_time = parseInt(( relative_time.getTime() - created_at_time ) / 1000) + (relative_time.getTimezoneOffset()*60);
	if ( wordy_time < 59 ) {
	  return 'less then 1 minute ago';
	} 
	else if ( wordy_time < 119 ) {
	  return 'about 1 minute ago';
	} 
	else if ( wordy_time < 3000 ) {         // < 50 minutes ago
	  return ( parseInt( wordy_time / 60 )).toString() + ' minutes ago';
	} 
	else if ( wordy_time < 5340 ) {         // < 89 minutes ago
	  return 'about 1 hour ago';
	} 
	else if ( wordy_time < 9000 ) {          // < 150 minutes ago
	  return 'about 2 hours ago';  
	}
	else if ( wordy_time < 82800 ) {         // < 23 hours ago
	  return 'about ' + ( parseInt( wordy_time / 3600 )).toString() + ' hours ago';
	} 
	else if ( wordy_time < 129600 ) {       //  < 36 hours
	  return '1 day ago';
	}
	else if ( wordy_time < 172800 ) {       // < 48 hours
	  return 'about 2 days ago ';
	}
	else {
	  return ( parseInt(wordy_time / 86400)).toString() + ' days ago';
	}
}

var un_re = /@([a-z])/i; // reg expression to pull out twitter usernames

function link_text(text){
	words = text.split(' ');
	for(var i=0; i < words.length; i++){
		var word = words[i];
		if(word.substr(0,4) == 'http'){
			words[i] = '<a href="' + word + '">' + word + '</a>';
		}
		else if(word.substr(0,1) == '@'){
			// this method should allow for gramar after usernames
			var un = un.match(un_re);
			if(un.length >= 2){ // the first portion is the entire match including the at, the second is without the @
				words[i] = word.replace(un[0], '<a href="http://twitter.com/' + un[1] + '">' + un[0] + '</a>');
			}
		}
	}
	return words.join(' ');
}