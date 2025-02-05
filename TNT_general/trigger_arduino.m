clear 

s = serial('COM16', 'BaudRate', 9600, 'DataBits', 7); %check Arduino COM value
%If error. Use seriallist to check active COM ports
fopen(s);
fwrite (arduino,str2num(trigger),'uint8');
fwrite (s,1,'uint8');
disp('255')
%fprintf(s,'RS232?');
idn=fscanf(s);
fclose (s);


%fwrite (s,1,'uint8'); % Write 255 int value on s port with a 8 bit format.
%disp('255');
%fclose (s);


%myPort = serial('/dev/tty.usbmodem1421');
%port_handle = open_ns_port('COM15')
%set(myPort, 'BaudRate', 9600);
%trigger_val = 1
%fwrite(15, trigger_val); % trigger_val = any arbitrary trigger

