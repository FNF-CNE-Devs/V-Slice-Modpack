function onEvent(_) {
	switch (_.event.name){
		case 'Base Game Camera Movement':
            var char = _.event.params[0];
            var v1 = _.event.params[1];
            var v2 = _.event.params[2];

            curCameraTarget = char;

            if(v1 != null || v1 != ""){
                strumLines.members[char].characters[0].cameraOffset.x = _.event.params[1];
            } else {
                strumLines.members[char].characters[0].cameraOffset.x = 0;
            }
            if(v2 != null || v2 != ""){
                strumLines.members[char].characters[0].cameraOffset.y = _.event.params[2];
            } else {
                strumLines.members[char].characters[0].cameraOffset.y = 0;
            }
        case "Camera Movement":
            strumLines.members[_.event.params[0]].characters[0].cameraOffset.set(0, 0);  
    }
}