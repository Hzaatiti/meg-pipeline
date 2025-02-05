lib = lsl_loadlib();

disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'TNT_MarkerStream','Markers',1,0,'cf_int32', ...
    'myuniquesourceid23443');
disp('Opening an outlet...');
outlet = lsl_outlet(info);

markers = struct('Marker_1', 1);

% Creates a windows that waits for clic before continue
message = 'Cliquez sur OK pour continuer';
title = 'Waiting Box';
waitfor(msgbox(message,title));

disp('Sending Marker');
outlet.push_sample((markers.Marker_1));
disp('Marker Sent');