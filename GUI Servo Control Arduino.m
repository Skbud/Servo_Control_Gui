% Servo Motor control for 9Dof Humanoid robot.
% Author:Sanjay 
% Date:13/09/21
%  This matlab script provides a gui to control servo motors and get angle
%  values of respective motors, which can  be used to write arduino code
%  for desired functions like walking,sitting etc for 8dof humanoid
%  robot or any mechanical structure which utlilizes generic servos.
% Before using this script you need to install arduino support package for
% Matlab.
% This script is tested with arduino mega  and MG996R servo motors on
% Matlab R018a.



clear all;
global a;
a=arduino; % Arduino object created.For using this you need to first install arduino suppoer package for Matlab 
           %Have tested this script with arduino mega and MG996R Servo
           %motors
           
global motorlf;   %Variable for left feet motor 
global motorll;  % ,, for left leg 
global motorlh;  % ,, for left hand
global motorla;  % ,, for left arm

global motorrf;  % Variable for right feet motor 
global motorrl;  % ,, for right leg 
global motorrh;  % ,, for right hand
global motorra;  % ,, for right arm 

global motorh;  % Variable for head motor


% Defining pins for servo motors
% If using servo other than MG996R, Change 'MinPulseDuration' &
% 'MaxPulseDuration' accordingly from the datascheet of servo.
motorlf= servo(a, 'D2', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorll= servo(a, 'D3', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorlh= servo(a, 'D4', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorla= servo(a, 'D5', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorrf= servo(a, 'D6', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorrl= servo(a, 'D7', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorrh= servo(a, 'D8', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorra= servo(a, 'D9', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);
motorh= servo(a,'D10', 'MinPulseDuration', 5*10^-4, 'MaxPulseDuration', 25*10^-4);


% Constructing GUI components
fig = uifigure('Position',[680 293 1003 1005]); %constructing Figure window

%Labels for Displaying Angle values of respective servo motor
%Label left feet
lblf = uilabel(fig);
lblf.FontSize = 20;
lblf.Position = [601 118 278 35];
lblf.Text='Left Feet';

%Label left leg
lbll = uilabel(fig);
lbll.FontSize = 20;
lbll.Position = [601 265 278 35];
lbll.Text='Left Leg';

%Label left hand
lblh = uilabel(fig);
lblh.FontSize = 20;
lblh.Position = [601 415 278 35];
lblh.Text='Left Hand';

%Label left arm
lbla = uilabel(fig);
lbla.FontSize = 20;
lbla.Position = [601 565 278 35];
lbla.Text='Left Arm';

%Label right feet
lbrf = uilabel(fig);
lbrf.FontSize = 20;
lbrf.Position = [101 118 278 35];
lbrf.Text='Right Feet';

%Label right leg
lbrl = uilabel(fig);
lbrl.FontSize = 20;
lbrl.Position = [101 265 278 35];
lbrl.Text='Right Leg';

%Label right hand
lbrh = uilabel(fig);
lbrh.FontSize = 20;
lbrh.Position = [101 415 278 35];
lbrh.Text='Right Hand';

%Label right arm
lbra = uilabel(fig);
lbra.FontSize = 20;
lbra.Position = [101 565 278 35];
lbra.Text='Right Arm';

%Label Head
lbh = uilabel(fig);
lbh.FontSize = 20;
lbh.Position = [351 670 278 35];
lbh.Text='Head';

% Sliders for altering servo angles
% Slider left feet
sldlf = uislider(fig,'Position',[601 105 301 52],'ValueChangedFcn',@(sldlf,event) movemotorlf(sldlf,lblf));
sldlf.Limits = [0,1];


% Slider left leg
sldll = uislider(fig,'Position',[601 255 301 52],'ValueChangedFcn',@(sldll,event) movemotorll(sldll,lbll));
sldll.Limits = [0,1];

% Slider left hand
sldlh = uislider(fig,'Position',[601 405 301 52],'ValueChangedFcn',@(sldlh,event) movemotorlh(sldlh,lblh));
sldlh.Limits = [0,1];

% Slider left arm
sldla = uislider(fig,'Position',[601 555 301 52],'ValueChangedFcn',@(sldla,event) movemotorla(sldla,lbla));
sldla.Limits = [0,1];

% Slider right feet
sldrf = uislider(fig,'Position',[101 105 301 52],'ValueChangedFcn',@(sldrf,event) movemotorrf(sldrf,lbrf));
sldrf.Limits = [0,1];

% Slider right leg
sldrl = uislider(fig,'Position',[101 255 301 52],'ValueChangedFcn',@(sldrl,event) movemotorrl(sldrl,lbrl));
sldrl.Limits = [0,1];

% Slider right hand
sldrh = uislider(fig,'Position',[101 405 301 52],'ValueChangedFcn',@(sldrh,event) movemotorrh(sldrh,lbrh));
sldrh.Limits = [0,1];

% Slider right arm
sldra = uislider(fig,'Position',[101 555 301 52],'ValueChangedFcn',@(sldra,event) movemotorra(sldra,lbra));
sldra.Limits = [0,1];

% Slider head
sldh = uislider(fig,'Position',[351 660 301 52],'ValueChangedFcn',@(sldh,event) movemotorh(sldh,lbh));
sldh.Limits = [0,1];

% Button for initilizing Servos
initbtn = uibutton(fig,'push','Text','Initialize Motors','Position',[101, 640, 200, 35],...
               'ButtonPushedFcn', @(initbtn,event) initButtonPushed(initbtn,sldlf,sldll,sldlh,sldla,sldrf,sldrl,sldrh,sldra,sldh,lblf,lbll,lblh,lbla,lbrf,lbrl,lbrh,lbra,lbh) );
initbtn.FontSize=20;


function movemotorlf(sldlf,lblf)
global motorlf;
writePosition(motorlf,sldlf.Value);
current_pos = readPosition(motorlf);
current_pos = round(current_pos*180);
str=sprintf('Left Feet Angle: %d',current_pos);
lblf.Text =str;
disp(str);
end

function movemotorll(sldll,lbll)
global motorll;
writePosition(motorll,sldll.Value);
current_pos = readPosition(motorll);
current_pos = round(current_pos*180);
str=sprintf('Left Leg Angle: %d',current_pos);
lbll.Text =str;
disp(str);
end

function movemotorlh(sldlh,lblh)
global motorlh;
writePosition(motorlh,sldlh.Value);
current_pos = readPosition(motorlh);
current_pos = round(current_pos*180);
str=sprintf('Left Hand Angle: %d',current_pos);
lblh.Text =str;
disp(str);
end

function movemotorla(sldla,lbla)
global motorla;
writePosition(motorla,sldla.Value);
current_pos = readPosition(motorla);
current_pos = round(current_pos*180);
str=sprintf('Left Arm Angle: %d',current_pos);
lbla.Text =str;
disp(str);
end

function movemotorrf(sldrf,lbrf)
global motorrf;
writePosition(motorrf,sldrf.Value);
current_pos = readPosition(motorrf);
current_pos = round(current_pos*180);
str=sprintf('Right Feet Angle: %d',current_pos);
lbrf.Text =str;
disp(str);
end

function movemotorrl(sldrl,lbrl)
global motorrl;
writePosition(motorrl,sldrl.Value);
current_pos = readPosition(motorrl);
current_pos = round(current_pos*180);
str=sprintf('Right Leg Angle: %d',current_pos);
lbrl.Text =str;
disp(str);
end

function movemotorrh(sldrh,lbrh)
global motorrh;
writePosition(motorrh,sldrh.Value);
current_pos = readPosition(motorrh);
current_pos = round(current_pos*180);
str=sprintf('Right Hand Angle: %d',current_pos);
lbrh.Text =str;
disp(str);
end

function movemotorra(sldra,lbra)
global motorra;
writePosition(motorra,sldra.Value);
current_pos = readPosition(motorra);
current_pos = round(current_pos*180);
str=sprintf('Right Arm Angle: %d',current_pos);
lbra.Text =str;
disp(str);
end

function movemotorh(sldh,lbh)
global motorh;
writePosition(motorh,sldh.Value);
current_pos = readPosition(motorh);
current_pos = round(current_pos*180);
str=sprintf('Head Angle: %d',current_pos);
lbh.Text =str;
disp(str);
end


function initButtonPushed(initbtn,sldlf,sldll,sldlh,sldla,sldrf,sldrl,sldrh,sldra,sldh,lblf,lbll,lblh,lbla,lbrf,lbrl,lbrh,lbra,lbh)
 global motorlf;
 global motorll;
 global motorlh;
 global motorla;
 global motorrf;
 global motorrl;
 global motorrh;
 global motorra;
 global motorh;
 
%  Servo which need to be at 180 degree
 writePosition(motorlh,1);
 sldlh.Value=readPosition(motorlh);
 lblh.Text='Left Hand Angle: 180';
 
 %  Servo which need to be at 180 degree
 writePosition(motorrh,0);
 sldrh.Value=readPosition(motorrh);
 lbrh.Text='Right Hand Angle: 0';
 
%  Servos which need to be at 90 degree
 writePosition(motorlf,0.5);
 sldlf.Value=readPosition(motorlf);
 lblf.Text='Left Feet Angle: 90';    
 
 writePosition(motorll,0.5);
 sldll.Value=readPosition(motorll);
 lbll.Text='Left Leg Angle: 90';  
 
 writePosition(motorla,0.5);
 sldla.Value=readPosition(motorla);
 lbla.Text='Left Arm Angle: 90';  
 
 writePosition(motorrf,0.5);
 sldrf.Value=readPosition(motorrf);
 lbrf.Text='Right Feet Angle: 90';
 
 writePosition(motorrl,0.5);
 sldrl.Value=readPosition(motorrl);
 lbrl.Text='Right Leg Angle: 90';
 
 writePosition(motorra,0.5);
 sldra.Value=readPosition(motorra);
 lbra.Text='Right Arm Angle: 90';
 
 writePosition(motorh,0.5);
 sldh.Value=readPosition(motorh);
 lbh.Text='Head Angle: 90';
 
end
