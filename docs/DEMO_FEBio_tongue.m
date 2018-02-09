%% DEMO_FEBio_tongue
% Below is a demonstration for: 
% 1) Creating a simple model in MATLAB
% 2) The specification of boundary conditions for FEBio 
% 4) Running an FEBio job with MATLAB
% 5) Importing FEBio results into MATLAB

%%

clear; close all; clc;

%%
% Plot settings
fontSize=15;
faceAlpha1=0.2;
faceAlpha2=1;
edgeColor=0.25*ones(1,3);
edgeWidth=1.5;
markerSize=35;

%%
% Control parameters

% path names
defaultFolder = fileparts(fileparts(mfilename('fullpath')));
savePath=fullfile(defaultFolder,'data','temp');

modelNameEnd='tempModel';
modelName=fullfile(savePath,modelNameEnd);

%Material parameter set
c1=1e-3;
m1=12;
ksi=c1*100;
beta=3;
k_factor=1e3;
alphaFib=0.25*pi;
k=0.5.*(c1+ksi)*k_factor;

T0=-1e-3; %Active stress

% FEA control settings
numTimeSteps=20; %Number of time steps desired
max_refs=25; %Max reforms
max_ups=0; %Set to zero to use full-Newton iterations
opt_iter=10; %Optimum number of iterations
max_retries=5; %Maximum number of retires
dtmin=(1/numTimeSteps)/100; %Minimum time step size
dtmax=1/numTimeSteps; %Maximum time step size

%% BUILD TONGUE MODEL
% The model geometry was obtained from the Artisynth project (see www.)

E=[1,6,7,2,56,61,62,57;2,7,8,3,57,62,63,58;3,8,9,4,58,63,64,59;4,9,10,5,59,64,65,60;6,11,12,7,61,66,67,62;7,12,13,8,62,67,68,63;8,13,14,9,63,68,69,64;9,14,15,10,64,69,70,65;11,16,17,12,66,71,72,67;12,17,18,13,67,72,73,68;13,18,19,14,68,73,74,69;14,19,20,15,69,74,75,70;16,21,22,17,71,76,77,72;17,22,23,18,72,77,78,73;18,23,24,19,73,78,79,74;19,24,25,20,74,79,80,75;21,26,27,22,76,81,82,77;22,27,28,23,77,82,83,78;23,28,29,24,78,83,84,79;24,29,30,25,79,84,85,80;26,31,32,27,81,86,87,82;27,32,33,28,82,87,88,83;28,33,34,29,83,88,89,84;29,34,35,30,84,89,90,85;31,36,37,32,86,91,92,87;32,37,38,33,87,92,93,88;33,38,39,34,88,93,94,89;34,39,40,35,89,94,95,90;36,41,42,37,91,96,97,92;37,42,43,38,92,97,98,93;38,43,44,39,93,98,99,94;39,44,45,40,94,99,100,95;41,46,47,42,96,101,102,97;42,47,48,43,97,102,103,98;43,48,49,44,98,103,104,99;44,49,50,45,99,104,105,100;46,51,52,47,101,106,107,102;47,52,53,48,102,107,108,103;48,53,54,49,103,108,109,104;49,54,55,50,104,109,110,105;56,61,62,57,111,116,117,112;57,62,63,58,112,117,118,113;58,63,64,59,113,118,119,114;59,64,65,60,114,119,120,115;61,66,67,62,116,121,122,117;62,67,68,63,117,122,123,118;63,68,69,64,118,123,124,119;64,69,70,65,119,124,125,120;66,71,72,67,121,126,127,122;67,72,73,68,122,127,128,123;68,73,74,69,123,128,129,124;69,74,75,70,124,129,130,125;71,76,77,72,126,131,132,127;72,77,78,73,127,132,133,128;73,78,79,74,128,133,134,129;74,79,80,75,129,134,135,130;76,81,82,77,131,136,137,132;77,82,83,78,132,137,138,133;78,83,84,79,133,138,139,134;79,84,85,80,134,139,140,135;81,86,87,82,136,141,142,137;82,87,88,83,137,142,143,138;83,88,89,84,138,143,144,139;84,89,90,85,139,144,145,140;86,91,92,87,141,146,147,142;87,92,93,88,142,147,148,143;88,93,94,89,143,148,149,144;89,94,95,90,144,149,150,145;91,96,97,92,146,151,152,147;92,97,98,93,147,152,153,148;93,98,99,94,148,153,154,149;94,99,100,95,149,154,155,150;96,101,102,97,151,156,157,152;97,102,103,98,152,157,158,153;98,103,104,99,153,158,159,154;99,104,105,100,154,159,160,155;101,106,107,102,156,161,162,157;102,107,108,103,157,162,163,158;103,108,109,104,158,163,164,159;104,109,110,105,159,164,165,160;111,116,117,112,166,171,172,167;112,117,118,113,167,172,173,168;113,118,119,114,168,173,174,169;114,119,120,115,169,174,175,170;116,121,122,117,171,176,177,172;117,122,123,118,172,177,178,173;118,123,124,119,173,178,179,174;119,124,125,120,174,179,180,175;121,126,127,122,176,181,182,177;122,127,128,123,177,182,183,178;123,128,129,124,178,183,184,179;124,129,130,125,179,184,185,180;126,131,132,127,181,186,187,182;127,132,133,128,182,187,188,183;128,133,134,129,183,188,189,184;129,134,135,130,184,189,190,185;131,136,137,132,186,191,192,187;132,137,138,133,187,192,193,188;133,138,139,134,188,193,194,189;134,139,140,135,189,194,195,190;136,141,142,137,191,196,197,192;137,142,143,138,192,197,198,193;138,143,144,139,193,198,199,194;139,144,145,140,194,199,200,195;141,146,147,142,196,201,202,197;142,147,148,143,197,202,203,198;143,148,149,144,198,203,204,199;144,149,150,145,199,204,205,200;146,151,152,147,201,206,207,202;147,152,153,148,202,207,208,203;148,153,154,149,203,208,209,204;149,154,155,150,204,209,210,205;151,156,157,152,206,211,212,207;152,157,158,153,207,212,213,208;153,158,159,154,208,213,214,209;154,159,160,155,209,214,215,210;156,161,162,157,211,216,217,212;157,162,163,158,212,217,218,213;158,163,164,159,213,218,219,214;159,164,165,160,214,219,220,215;166,171,172,167,221,226,227,222;167,172,173,168,222,227,228,223;168,173,174,169,223,228,229,224;169,174,175,170,224,229,230,225;171,176,177,172,226,231,232,227;172,177,178,173,227,232,233,228;173,178,179,174,228,233,234,229;174,179,180,175,229,234,235,230;176,181,182,177,231,236,237,232;177,182,183,178,232,237,238,233;178,183,184,179,233,238,239,234;179,184,185,180,234,239,240,235;181,186,187,182,236,241,242,237;182,187,188,183,237,242,243,238;183,188,189,184,238,243,244,239;184,189,190,185,239,244,245,240;186,191,192,187,241,246,247,242;187,192,193,188,242,247,248,243;188,193,194,189,243,248,249,244;189,194,195,190,244,249,250,245;191,196,197,192,246,251,252,247;192,197,198,193,247,252,253,248;193,198,199,194,248,253,254,249;194,199,200,195,249,254,255,250;196,201,202,197,251,256,257,252;197,202,203,198,252,257,258,253;198,203,204,199,253,258,259,254;199,204,205,200,254,259,260,255;201,206,207,202,256,261,262,257;202,207,208,203,257,262,263,258;203,208,209,204,258,263,264,259;204,209,210,205,259,264,265,260;206,211,212,207,261,266,267,262;207,212,213,208,262,267,268,263;208,213,214,209,263,268,269,264;209,214,215,210,264,269,270,265;211,216,217,212,266,271,272,267;212,217,218,213,267,272,273,268;213,218,219,214,268,273,274,269;214,219,220,215,269,274,275,270;221,226,227,222,276,281,282,277;222,227,228,223,277,282,283,278;223,228,229,224,278,283,284,279;224,229,230,225,279,284,285,280;226,231,232,227,281,286,287,282;227,232,233,228,282,287,288,283;228,233,234,229,283,288,289,284;229,234,235,230,284,289,290,285;231,236,237,232,286,291,292,287;232,237,238,233,287,292,293,288;233,238,239,234,288,293,294,289;234,239,240,235,289,294,295,290;236,241,242,237,291,296,297,292;237,242,243,238,292,297,298,293;238,243,244,239,293,298,299,294;239,244,245,240,294,299,300,295;241,246,247,242,296,301,302,297;242,247,248,243,297,302,303,298;243,248,249,244,298,303,304,299;244,249,250,245,299,304,305,300;246,251,252,247,301,306,307,302;247,252,253,248,302,307,308,303;248,253,254,249,303,308,309,304;249,254,255,250,304,309,310,305;251,256,257,252,306,311,312,307;252,257,258,253,307,312,313,308;253,258,259,254,308,313,314,309;254,259,260,255,309,314,315,310;256,261,262,257,311,316,317,312;257,262,263,258,312,317,318,313;258,263,264,259,313,318,319,314;259,264,265,260,314,319,320,315;261,266,267,262,316,321,322,317;262,267,268,263,317,322,323,318;263,268,269,264,318,323,324,319;264,269,270,265,319,324,325,320;266,271,272,267,321,326,327,322;267,272,273,268,322,327,328,323;268,273,274,269,323,328,329,324;269,274,275,270,324,329,330,325;276,281,282,277,331,336,337,332;277,282,283,278,332,337,338,333;278,283,284,279,333,338,339,334;279,284,285,280,334,339,340,335;281,286,287,282,336,341,342,337;282,287,288,283,337,342,343,338;283,288,289,284,338,343,344,339;284,289,290,285,339,344,345,340;286,291,292,287,341,346,347,342;287,292,293,288,342,347,348,343;288,293,294,289,343,348,349,344;289,294,295,290,344,349,350,345;291,296,297,292,346,351,352,347;292,297,298,293,347,352,353,348;293,298,299,294,348,353,354,349;294,299,300,295,349,354,355,350;296,301,302,297,351,356,357,352;297,302,303,298,352,357,358,353;298,303,304,299,353,358,359,354;299,304,305,300,354,359,360,355;301,306,307,302,356,361,362,357;302,307,308,303,357,362,363,358;303,308,309,304,358,363,364,359;304,309,310,305,359,364,365,360;306,311,312,307,361,366,367,362;307,312,313,308,362,367,368,363;308,313,314,309,363,368,369,364;309,314,315,310,364,369,370,365;311,316,317,312,366,371,372,367;312,317,318,313,367,372,373,368;313,318,319,314,368,373,374,369;314,319,320,315,369,374,375,370;316,321,322,317,371,376,377,372;317,322,323,318,372,377,378,373;318,323,324,319,373,378,379,374;319,324,325,320,374,379,380,375;321,326,327,322,376,381,382,377;322,327,328,323,377,382,383,378;323,328,329,324,378,383,384,379;324,329,330,325,379,384,385,380];
V=[0.481048000000000,-0.400000000000000,-1.50000000000000;0.118145000000000,-0.400000000000000,-1;-0.164396000000000,-0.400000000000000,0;0.118145000000000,-0.400000000000000,1;0.481048000000000,-0.400000000000000,1.50000000000000;0.531452000000000,-0.150000000000000,-1.50000000000000;0.178629000000000,-0.150000000000000,-1;-0.0330650000000000,-0.150000000000000,0;0.178629000000000,-0.150000000000000,1;0.531452000000000,-0.150000000000000,1.50000000000000;0.612097000000000,0.100000000000000,-1.50000000000000;0.218952000000000,0.100000000000000,-1;0.00725800000000000,0.100000000000000,0;0.218952000000000,0.100000000000000,1;0.612097000000000,0.100000000000000,1.50000000000000;0.571774000000000,0.350000000000000,-1.50000000000000;0.168548000000000,0.350000000000000,-1;0.0274190000000000,0.350000000000000,0;0.168548000000000,0.350000000000000,1;0.571774000000000,0.350000000000000,1.50000000000000;0.612097000000000,0.600000000000000,-1.50000000000000;0.239113000000000,0.600000000000000,-1;0.0173390000000000,0.577419000000000,0;0.239113000000000,0.600000000000000,1;0.612097000000000,0.600000000000000,1.50000000000000;0.632258000000000,0.850000000000000,-1.50000000000000;0.168548000000000,0.850000000000000,-1;-0.0733870000000000,0.850000000000000,0;0.168548000000000,0.850000000000000,1;0.632258000000000,0.850000000000000,1.50000000000000;0.612097000000000,1.10000000000000,-1.50000000000000;0.148387000000000,1.10000000000000,-1;-0.113710000000000,1.10000000000000,0;0.148387000000000,1.10000000000000,1;0.612097000000000,1.10000000000000,1.50000000000000;0.629174000000000,1.38312800000000,-1.50000000000000;0.0879030000000000,1.35000000000000,-1;-0.199508000000000,1.35000000000000,0;0.0879030000000000,1.35000000000000,1;0.629174000000000,1.38312800000000,1.50000000000000;0.622144000000000,1.65729300000000,-1.50000000000000;0.0778230000000000,1.60000000000000,-1;-0.322402000000000,1.60000000000000,0;0.0778230000000000,1.60000000000000,1;0.622144000000000,1.65729300000000,1.50000000000000;0.586995000000000,1.92442900000000,-1.50000000000000;-0.00282300000000000,1.85000000000000,-1;-0.462851000000000,1.85000000000000,0;-0.00282300000000000,1.85000000000000,1;0.586995000000000,1.92442900000000,1.50000000000000;0.481547000000000,2.13532500000000,-1.50000000000000;-0.0431450000000000,2.10000000000000,-1;-0.678226000000000,2.10000000000000,0;-0.0431450000000000,2.10000000000000,1;0.481547000000000,2.13532500000000,1.50000000000000;1.27240800000000,-0.479789000000000,-1.60000000000000;0.712903000000000,-0.458065000000000,-1;0.608076000000000,-0.460674000000000,0;0.712903000000000,-0.458065000000000,1;1.27240800000000,-0.479789000000000,1.60000000000000;1.38239200000000,0.0559910000000000,-1.62064800000000;0.842784000000000,-0.0155190000000000,-1;0.697523000000000,-0.0311330000000000,0;0.842784000000000,-0.0155190000000000,1;1.38239200000000,0.0559910000000000,1.62064800000000;1.41093500000000,0.532142000000000,-1.62570000000000;0.882649000000000,0.413501000000000,-1;0.750210000000000,0.385971000000000,0;0.882649000000000,0.413501000000000,1;1.41093500000000,0.532142000000000,1.62570000000000;1.41300500000000,0.943761000000000,-1.61983800000000;0.886513000000000,0.826754000000000,-1;0.755336000000000,0.796670000000000,0;0.886513000000000,0.826754000000000,1;1.41300500000000,0.943761000000000,1.61983800000000;1.39543100000000,1.29525500000000,-1.61421900000000;0.859938000000000,1.21960200000000,-1;0.698955000000000,1.19422100000000,0;0.859938000000000,1.21960200000000,1;1.39543100000000,1.29525500000000,1.61421900000000;1.32513200000000,1.69947300000000,-1.61399700000000;0.786863000000000,1.58126300000000,-1;0.574238000000000,1.55962900000000,0;0.786863000000000,1.58126300000000,1;1.32513200000000,1.69947300000000,1.61399700000000;1.21968400000000,2.03339200000000,-1.61715400000000;0.660570000000000,1.89517200000000,-0.999999000000000;0.386003000000000,1.86565800000000,0;0.660570000000000,1.89517200000000,0.999999000000000;1.21968400000000,2.03339200000000,1.61715400000000;1.04393700000000,2.31458700000000,-1.61941500000000;0.480792000000000,2.15567300000000,-0.999996000000000;0.133206000000000,2.09722900000000,0;0.480792000000000,2.15567300000000,0.999996000000000;1.04393700000000,2.31458700000000,1.61941500000000;0.815466000000000,2.50790900000000,-1.61947700000000;0.244715000000000,2.36615100000000,-0.999991000000000;-0.176901000000000,2.26857400000000,0;0.244715000000000,2.36615100000000,0.999991000000000;0.815466000000000,2.50790900000000,1.61947700000000;0.586995000000000,2.64850600000000,-1.61397800000000;-0.0286990000000000,2.53296900000000,-0.999991000000000;-0.504705000000000,2.41331800000000,0;-0.0286990000000000,2.53296900000000,0.999991000000000;0.586995000000000,2.64850600000000,1.61397800000000;0.219298000000000,2.69298200000000,-1.60000000000000;-0.324561000000000,2.69298200000000,-1;-0.780702000000000,2.53508800000000,0;-0.324561000000000,2.69298200000000,1;0.219298000000000,2.69298200000000,1.60000000000000;2.01054500000000,-0.374341000000000,-1.70000000000000;1.51935500000000,-0.516129000000000,-1;1.39810400000000,-0.494382000000000,0;1.51935500000000,-0.516129000000000,1;2.01054500000000,-0.374341000000000,1.70000000000000;2.16136400000000,0.276925000000000,-1.78288500000000;1.56627000000000,0.156202000000000,-1;1.44191800000000,0.111755000000000,0;1.56627000000000,0.156202000000000,1;2.16136400000000,0.276925000000000,1.78288500000000;2.16939800000000,0.918400000000000,-1.77624200000000;1.59517800000000,0.752239000000000,-1;1.48331500000000,0.680813000000000,0;1.59517800000000,0.752239000000000,1;2.16939800000000,0.918400000000000,1.77624200000000;2.14278000000000,1.54436400000000,-1.75524500000000;1.58426400000000,1.31808500000000,-1;1.46866100000000,1.24493900000000,0;1.58426400000000,1.31808500000000,1;2.14278000000000,1.54436400000000,1.75524500000000;2.03898100000000,2.10675800000000,-1.73706200000000;1.51535500000000,1.84778200000000,-0.999999000000000;1.36560200000000,1.78118300000000,0;1.51535500000000,1.84778200000000,0.999999000000000;2.03898100000000,2.10675800000000,1.73706200000000;1.83943200000000,2.56049900000000,-1.73681200000000;1.36904600000000,2.31494900000000,-0.999994000000000;1.15823100000000,2.24426600000000,0;1.36904600000000,2.31494900000000,0.999994000000000;1.83943200000000,2.56049900000000,1.73681200000000;1.54457900000000,2.88761000000000,-1.74681000000000;1.13123400000000,2.68344200000000,-0.999964000000000;0.843493000000000,2.58967700000000,0;1.13123400000000,2.68344200000000,0.999964000000000;1.54457900000000,2.88761000000000,1.74681000000000;1.16439400000000,3.09770600000000,-1.75319800000000;0.792773000000000,2.93848400000000,-0.999862000000000;0.428680000000000,2.79625000000000,0;0.792773000000000,2.93848400000000,0.999862000000000;1.16439400000000,3.09770600000000,1.75319800000000;0.762742000000000,3.24604600000000,-1.75469900000000;0.342868000000000,3.11772700000000,-0.999703000000000;-0.0740960000000000,2.90087400000000,0;0.342868000000000,3.11772700000000,0.999703000000000;0.762742000000000,3.24604600000000,1.75469900000000;0.342105000000000,3.30701800000000,-1.75357600000000;-0.184837000000000,3.19120300000000,-0.999704000000000;-0.630517000000000,2.97887100000000,0;-0.184837000000000,3.19120300000000,0.999704000000000;0.342105000000000,3.30701800000000,1.75357600000000;-0.0964910000000000,3.28947400000000,-1.70000000000000;-0.552632000000000,3.27193000000000,-1;-1.02631600000000,3.09649100000000,0;-0.552632000000000,3.27193000000000,1;-0.0964910000000000,3.28947400000000,1.70000000000000;2.67838300000000,-0.268893000000000,-2.10000000000000;2.30564500000000,-0.380645000000000,-1;2.11790700000000,-0.393258000000000,0;2.30564500000000,-0.380645000000000,1;2.67838300000000,-0.268893000000000,2.10000000000000;2.84255100000000,0.495315000000000,-1.95916200000000;2.31508400000000,0.378392000000000,-1;2.14302400000000,0.291540000000000,0;2.31508400000000,0.378392000000000,1;2.84255100000000,0.495315000000000,1.95916200000000;2.84310000000000,1.25775000000000,-1.92663700000000;2.31951100000000,1.11237400000000,-1;2.18062900000000,0.993179000000000,0;2.31951100000000,1.11237400000000,1;2.84310000000000,1.25775000000000,1.92663700000000;2.77243800000000,2.00618000000000,-1.88734900000000;2.27857600000000,1.81565800000000,-1;2.13821600000000,1.69546500000000,0;2.27857600000000,1.81565800000000,1;2.77243800000000,2.00618000000000,1.88734900000000;2.58845700000000,2.68421200000000,-1.85319200000000;2.14887700000000,2.47252200000000,-0.999996000000000;1.97305500000000,2.35414900000000,0;2.14887700000000,2.47252200000000,0.999996000000000;2.58845700000000,2.68421200000000,1.85319200000000;2.27956400000000,3.22250600000000,-1.85259400000000;1.90071900000000,3.03339000000000,-0.999942000000000;1.66785900000000,2.90002900000000,0;1.90071900000000,3.03339000000000,0.999942000000000;2.27956400000000,3.22250600000000,1.85259400000000;1.85326900000000,3.58186000000000,-1.86941700000000;1.52300500000000,3.43661800000000,-0.999639000000000;1.22487800000000,3.27134900000000,0;1.52300500000000,3.43661800000000,0.999639000000000;1.85326900000000,3.58186000000000,1.86941700000000;1.32545600000000,3.76683700000000,-1.87891700000000;1.01620200000000,3.65369500000000,-0.998614000000000;0.658544000000000,3.44443300000000,0;1.01620200000000,3.65369500000000,0.998614000000000;1.32545600000000,3.76683700000000,1.87891700000000;0.704865000000000,3.83029200000000,-1.87999200000000;0.370629000000000,3.71517100000000,-0.996662000000000;-0.0232260000000000,3.47786100000000,0;0.370629000000000,3.71517100000000,0.996662000000000;0.704865000000000,3.83029200000000,1.87999200000000;-0.0256380000000000,3.82403500000000,-1.89094500000000;-0.424585000000000,3.65354300000000,-0.996306000000000;-0.820556000000000,3.44828800000000,0;-0.424585000000000,3.65354300000000,0.996306000000000;-0.0256380000000000,3.82403500000000,1.89094500000000;-0.885965000000000,3.62280700000000,-2;-1.39473700000000,3.37719300000000,-1;-1.79824600000000,3.23684200000000,0;-1.39473700000000,3.37719300000000,1;-0.885965000000000,3.62280700000000,2;3.36411300000000,-0.196774000000000,-2.10000000000000;3.07177400000000,-0.245161000000000,-1;2.66854800000000,-0.322581000000000,0;3.07177400000000,-0.245161000000000,1;3.36411300000000,-0.196774000000000,2.10000000000000;3.49257900000000,0.728268000000000,-2.05431200000000;3.03835000000000,0.630803000000000,-1;2.79763200000000,0.499753000000000,0;3.03835000000000,0.630803000000000,1;3.49257900000000,0.728268000000000,2.05431200000000;3.47469400000000,1.58460500000000,-2.01842700000000;3.03342600000000,1.48253600000000,-1;2.84699200000000,1.32719300000000,0;3.03342600000000,1.48253600000000,1;3.47469400000000,1.58460500000000,2.01842700000000;3.34521600000000,2.42762100000000,-1.97582900000000;2.96018900000000,2.31934100000000,-1;2.77080800000000,2.16070600000000,0;2.96018900000000,2.31934100000000,1;3.34521600000000,2.42762100000000,1.97582900000000;3.06458000000000,3.20305800000000,-1.93778100000000;2.75277200000000,3.10665400000000,-0.999991000000000;2.53094100000000,2.93951200000000,0;2.75277200000000,3.10665400000000,0.999991000000000;3.06458000000000,3.20305800000000,1.93778100000000;2.63624400000000,3.81405800000000,-1.93427700000000;2.37755200000000,3.75543100000000,-0.999833000000000;2.11939500000000,3.56689500000000,0;2.37755200000000,3.75543100000000,0.999833000000000;2.63624400000000,3.81405800000000,1.93427700000000;2.08499200000000,4.19754500000000,-1.94909600000000;1.84286800000000,4.17513400000000,-0.998521000000000;1.54900400000000,3.95722700000000,0;1.84286800000000,4.17513400000000,0.998521000000000;2.08499200000000,4.19754500000000,1.94909600000000;1.43134200000000,4.35486300000000,-1.95465900000000;1.17028200000000,4.33526800000000,-0.993475000000000;0.841524000000000,4.08412400000000,0;1.17028200000000,4.33526800000000,0.993475000000000;1.43134200000000,4.35486300000000,1.95465900000000;0.685540000000000,4.34090100000000,-1.94466200000000;0.357978000000000,4.28452300000000,-0.982224000000000;0.00935700000000000,4.02437700000000,0;0.357978000000000,4.28452300000000,0.982224000000000;0.685540000000000,4.34090100000000,1.94466200000000;-0.164215000000000,4.19974200000000,-1.93652500000000;-0.615872000000000,4.07915400000000,-0.972652000000000;-0.964254000000000,3.85733200000000,0;-0.615872000000000,4.07915400000000,0.972652000000000;-0.164215000000000,4.19974200000000,1.93652500000000;-1.11403500000000,3.88596500000000,-2;-1.74561400000000,3.65789500000000,-1;-2.07894700000000,3.48245600000000,0;-1.74561400000000,3.65789500000000,1;-1.11403500000000,3.88596500000000,2;4.24274200000000,0.102151000000000,-2.10000000000000;3.66653200000000,-0.0612900000000000,-1;3.27338700000000,-0.206452000000000,0;3.66653200000000,-0.0612900000000000,1;4.24274200000000,0.102151000000000,2.10000000000000;4.18787700000000,1.01046100000000,-2.05293400000000;3.72331600000000,0.892487000000000,-1;3.46519500000000,0.729757000000000,0;3.72331600000000,0.892487000000000,1;4.18787700000000,1.01046100000000,2.05293400000000;4.12059300000000,1.92478600000000,-2.03305700000000;3.74437400000000,1.85188400000000,-1;3.53712800000000,1.67440400000000,0;3.74437400000000,1.85188400000000,1;4.12059300000000,1.92478600000000,2.03305700000000;3.93239500000000,2.85655600000000,-2.00713200000000;3.66902000000000,2.85371800000000,-1;3.42572800000000,2.64982800000000,0;3.66902000000000,2.85371800000000,1;3.93239500000000,2.85655600000000,2.00713200000000;3.53347700000000,3.74466200000000,-1.98314800000000;3.37788100000000,3.81701600000000,-0.999991000000000;3.09213200000000,3.58307300000000,0;3.37788100000000,3.81701600000000,0.999991000000000;3.53347700000000,3.74466200000000,1.98314800000000;2.96253600000000,4.42908000000000,-1.97815200000000;2.83445000000000,4.57511100000000,-0.999812000000000;2.56460300000000,4.33129700000000,0;2.83445000000000,4.57511100000000,0.999812000000000;2.96253600000000,4.42908000000000,1.97815200000000;2.28948800000000,4.82062400000000,-1.98426300000000;2.12419700000000,5.00584600000000,-0.997985000000000;1.86819800000000,4.74513000000000,0;2.12419700000000,5.00584600000000,0.997985000000000;2.28948800000000,4.82062400000000,1.98426300000000;1.52104600000000,4.94398900000000,-1.97702700000000;1.29268500000000,5.08782900000000,-0.984338000000000;1.01750100000000,4.79051000000000,0;1.29268500000000,5.08782900000000,0.984338000000000;1.52104600000000,4.94398900000000,1.97702700000000;0.669486000000000,4.84840300000000,-1.94624100000000;0.343965000000000,4.89228800000000,-0.948356000000000;0.0549220000000000,4.58664700000000,0;0.343965000000000,4.89228800000000,0.948356000000000;0.669486000000000,4.84840300000000,1.94624100000000;-0.253708000000000,4.56251800000000,-1.86389700000000;-0.722061000000000,4.49493800000000,-0.892845000000000;-1.00614200000000,4.26472000000000,0;-0.722061000000000,4.49493800000000,0.892845000000000;-0.253708000000000,4.56251800000000,1.86389700000000;-1.23684200000000,4.07894800000000,-1.80000000000000;-1.88596500000000,3.86842100000000,-0.900000000000000;-2.21929800000000,3.76315800000000,0;-1.88596500000000,3.86842100000000,0.900000000000000;-1.23684200000000,4.07894800000000,1.80000000000000;5.12137100000000,0.401075000000000,-2;4.29153200000000,0.209677000000000,-1;3.99919300000000,0.00645200000000000,0;4.29153200000000,0.209677000000000,1;5.12137100000000,0.401075000000000,2;4.91036900000000,1.36555400000000,-2;4.40242000000000,1.12903200000000,-1;4.18064500000000,0.954839000000000,0;4.40242000000000,1.12903200000000,1;4.91036900000000,1.36555400000000,2;4.84596800000000,2.27096800000000,-2;4.47298400000000,2.14516100000000,-1;4.36509800000000,1.98314600000000,0;4.47298400000000,2.14516100000000,1;4.84596800000000,2.27096800000000,2;4.66451600000000,3.23871000000000,-2;4.52338700000000,3.41290300000000,-1;4.24220500000000,3.16292100000000,0;4.52338700000000,3.41290300000000,1;4.66451600000000,3.23871000000000,2;4.11008100000000,4.44838700000000,-2;4.24112900000000,4.72903200000000,-1;3.73307600000000,4.32584300000000,0;4.24112900000000,4.72903200000000,1;4.11008100000000,4.44838700000000,2;3.24314500000000,5.24193500000000,-2;3.27338700000000,5.65806400000000,-1;3.07177400000000,5.38709700000000,0;3.27338700000000,5.65806400000000,1;3.24314500000000,5.24193500000000,2;2.55766100000000,5.53225800000000,-2;2.43669300000000,6.11290300000000,-1;2.28467700000000,5.82580700000000,0;2.43669300000000,6.11290300000000,1;2.55766100000000,5.53225800000000,2;1.63024200000000,5.66774200000000,-2;1.44879000000000,6.05483900000000,-1;1.23387100000000,5.67741900000000,0;1.44879000000000,6.05483900000000,1;1.63024200000000,5.66774200000000,2;0.569420000000000,5.39015800000000,-1.90000000000000;0.319758000000000,5.60967700000000,-0.900000000000000;0.0882720000000000,5.20000000000000,0;0.319758000000000,5.60967700000000,0.900000000000000;0.569420000000000,5.39015800000000,1.90000000000000;-0.397188000000000,5.02109000000000,-1.90000000000000;-0.728629000000000,4.99032300000000,-0.800000000000000;-0.947542000000000,4.62696600000000,0;-0.728629000000000,4.99032300000000,0.800000000000000;-0.397188000000000,5.02109000000000,1.90000000000000;-1.37379000000000,4.35161300000000,-1.20000000000000;-2.01895200000000,4.08064500000000,-0.500000000000000;-2.13602500000000,4.07191000000000,0;-2.01895200000000,4.08064500000000,0.500000000000000;-1.37379000000000,4.35161300000000,1.20000000000000];
V=V(:,[1 3 2]);
V=V.*25.4; %inch to mm

[F,~]=element2patch(E,[]);

%Get top and bottom faces for boundary conditions
Fb=E(:,[1 4 8 5]);
Ft=E(:,[2 3 7 6]);

X=V(:,1); Y=V(:,2); Z=V(:,3);

XE=mean(X(E),2);
YE=mean(Y(E),2);
ZE=mean(Z(E),2);
VE=[XE(:) YE(:) ZE(:)];

XFb=mean(X(Fb),2);
YFb=mean(Y(Fb),2);
ZFb=mean(Z(Fb),2);
VFb=[XFb(:) YFb(:) ZFb(:)];

XFt=mean(X(Ft),2);
YFt=mean(Y(Ft),2);
ZFt=mean(Z(Ft),2);
VFt=[XFt(:) YFt(:) ZFt(:)];

VF=[VFt-VFb];

[Fq,Vq,Cq]=quiver3Dpatch(VE(:,1),VE(:,2),VE(:,3),VF(:,1),VF(:,2),VF(:,3),ones(size(VF,1),1),[20 20]);

F_bottom=Fb([1:(10*4):size(Fb,1) 2:(10*4):size(Fb,1) 3:(10*4):size(Fb,1) 4:(10*4):size(Fb,1)],:);
F_top=Ft([size(Ft,1):-(10*4):1 size(Ft,1)-1:-(10*4):1 size(Ft,1)-2:-(10*4):1 size(Ft,1)-3:-(10*4):1],:);

bcFixList=unique(F_bottom(:));

elementMaterialIndices=ones(size(E,1),1);

E=[fliplr(E(:,1:4)) fliplr(E(:,5:end))];

%% VISUALIZING MODEL

% Plotting model
hf=cFigure;
subplot(1,2,1); hold on;
title('Tongue model geometry and fibres','FontSize',fontSize);
gpatch(F,V,0.5*ones(1,3),'k',1);
plotV(V(bcFixList,:),'r.','MarkerSize',markerSize);
axisGeom(gca,fontSize);
camlight headlight;

subplot(1,2,2); hold on;
title('Tongue model geometry and fibres','FontSize',fontSize);
gpatch(F,V,0.5*ones(1,3),'none',0.1);
gpatch(Fq,Vq,'k','none',1);
plotV(V(bcFixList,:),'r.','MarkerSize',markerSize);
axisGeom(gca,fontSize);
camlight headlight;

drawnow; 

%% CONSTRUCTING FEB MODEL

FEB_struct.febio_spec.version='2.0';
FEB_struct.Module.Type='solid';

% Defining file names
FEB_struct.run_filename=[modelName,'.feb']; %FEB file name
FEB_struct.run_logname=[modelName,'.txt']; %FEBio log file name

%Geometry section
FEB_struct.Geometry.Nodes=V;
FEB_struct.Geometry.Elements={E}; %The element sets
FEB_struct.Geometry.ElementType={'hex8'}; %The element types
FEB_struct.Geometry.ElementMat={elementMaterialIndices};
FEB_struct.Geometry.ElementsPartName={'Tongue'};

% DEFINING MATERIALS
FEB_struct.Materials{1}.Type='solid mixture';
% FEB_struct.Materials{1}.AnisoType='mat_axis';

FEB_struct.Materials{1}.Solid{1}.Type='Ogden unconstrained';
FEB_struct.Materials{1}.Solid{1}.Properties={'c1','m1','cp'};
FEB_struct.Materials{1}.Solid{1}.Values={c1,m1,k};

FEB_struct.Materials{1}.Solid{2}.Type='prescribed uniaxial active contraction';
FEB_struct.Materials{1}.Solid{2}.Properties={'T0','theta','phi'};
FEB_struct.Materials{1}.Solid{2}.Values={T0,0,0};
FEB_struct.Materials{1}.Solid{2}.AnisoType='mat_axis';

FEB_struct.Materials{1}.Solid{2}.PropAttrName=cell(1,numel(FEB_struct.Materials{1}.Solid{2}.Properties));
FEB_struct.Materials{1}.Solid{2}.PropAttrName{1}='lc';
FEB_struct.Materials{1}.Solid{2}.PropAttrVal{1}=1;

%Adding fibre direction, construct local orthonormal basis vectors
[a,d]=vectorOrthogonalPair(VF);

VF_E=zeros(size(VF,1),size(VF,2),2);
VF_E(:,:,1)=a; %a1 ~ e1 ~ X or first direction
VF_E(:,:,2)=d; %a2 ~ e2 ~ Y or second direction
%Vf_E %a3 ~ e3 ~ Z, third direction, or fibre direction

FEB_struct.Geometry.ElementData.MatAxis.ElementIndices=1:1:size(E,1);
FEB_struct.Geometry.ElementData.MatAxis.Basis=VF_E;

%Control section
FEB_struct.Control.AnalysisType='static';
FEB_struct.Control.Properties={'time_steps','step_size',...
    'max_refs','max_ups',...
    'dtol','etol','rtol','lstol'};
FEB_struct.Control.Values={numTimeSteps,1/numTimeSteps,...
    max_refs,max_ups,...
    0.001,0.01,0,0.9};
FEB_struct.Control.TimeStepperProperties={'dtmin','dtmax','max_retries','opt_iter'};
FEB_struct.Control.TimeStepperValues={dtmin,dtmax,max_retries,opt_iter};

%Defining node sets
FEB_struct.Geometry.NodeSet{1}.Set=bcFixList;
FEB_struct.Geometry.NodeSet{1}.Name='bcFixList';

%Adding BC information
FEB_struct.Boundary.Fix{1}.bc='x';
FEB_struct.Boundary.Fix{1}.SetName=FEB_struct.Geometry.NodeSet{1}.Name;
FEB_struct.Boundary.Fix{2}.bc='y';
FEB_struct.Boundary.Fix{2}.SetName=FEB_struct.Geometry.NodeSet{1}.Name;
FEB_struct.Boundary.Fix{3}.bc='z';
FEB_struct.Boundary.Fix{3}.SetName=FEB_struct.Geometry.NodeSet{1}.Name;

%Load curves
FEB_struct.LoadData.LoadCurves.id=1;
FEB_struct.LoadData.LoadCurves.type={'linear'};
FEB_struct.LoadData.LoadCurves.loadPoints={[0 0;1 1;]};

%Adding output requests
FEB_struct.Output.VarTypes={'displacement','stress','relative volume'};

%Specify log file output
run_disp_output_name=[modelNameEnd,'_node_out.txt'];
run_force_output_name=[modelNameEnd,'_force_out.txt'];
FEB_struct.run_output_names={run_disp_output_name,run_force_output_name};
FEB_struct.output_types={'node_data','node_data'};
FEB_struct.data_types={'ux;uy;uz','Rx;Ry;Rz'};

%% SAVING .FEB FILE

FEB_struct.disp_opt=0; %Display waitbars
febStruct2febFile(FEB_struct);

%% RUNNING FEBIO JOB

FEBioRunStruct.run_filename=FEB_struct.run_filename;
FEBioRunStruct.run_logname=FEB_struct.run_logname;
FEBioRunStruct.disp_on=1;
FEBioRunStruct.disp_log_on=1;
FEBioRunStruct.runMode='external';%'internal';
FEBioRunStruct.t_check=0.25; %Time for checking log file (dont set too small)
FEBioRunStruct.maxtpi=1e99; %Max analysis time
FEBioRunStruct.maxLogCheckTime=3; %Max log file checking time

[runFlag]=runMonitorFEBio(FEBioRunStruct);%START FEBio NOW!!!!!!!!

%%
if runFlag==1 %i.e. a succesful run
    %% IMPORTING NODAL DISPLACEMENT RESULTS
    % Importing nodal displacements from a log file
    [~, N_disp_mat,~]=importFEBio_logfile(fullfile(savePath,FEB_struct.run_output_names{1})); %Nodal displacements    
    
    %% IMPORTING NODAL FORCES
    % Importing nodal forces from a log file
    [time_mat, N_force_mat,~]=importFEBio_logfile(fullfile(savePath,FEB_struct.run_output_names{2})); %Nodal forces
    time_mat=[0; time_mat(:)]; %Time
    
    %% Plotting the deformed model
    
    N_disp_mat=N_disp_mat(:,2:end,:);
    sizImport=size(N_disp_mat);
    sizImport(3)=sizImport(3)+1;
    N_disp_mat_n=zeros(sizImport);
    N_disp_mat_n(:,:,2:end)=N_disp_mat;
    N_disp_mat=N_disp_mat_n;
    DN=N_disp_mat(:,:,end);
    DN_magnitude=sqrt(sum(DN(:,3).^2,2));
    V_def=V+DN;
    [CF]=vertexToFaceMeasure(F,DN_magnitude);
    
    %%
    hf=cFigure;
    xlabel('X','FontSize',fontSize); ylabel('Y','FontSize',fontSize); zlabel('Z','FontSize',fontSize); hold on;
    
    hp=gpatch(F,V_def,CF,'k',1);
%     gpatch(F,V,0.5*ones(1,3),'k',0.25);
    
    axisGeom; 
    colormap(gjet(250)); colorbar;
    caxis([0 max(DN_magnitude)]);
    axis([min(V_def(:,1)) max(V_def(:,1)) min(V_def(:,2)) max(V_def(:,2)) min(V(:,3)) max(V(:,3))]);

    camlight headlight;    
    drawnow;
    
    animStruct.Time=time_mat;
    
    for qt=1:1:size(N_disp_mat,3)
        
        DN=N_disp_mat(:,:,qt);
        DN_magnitude=sqrt(sum(DN(:,3).^2,2));
        V_def=V+DN;
        [CF]=vertexToFaceMeasure(F,DN_magnitude);
        
        %Set entries in animation structure
        animStruct.Handles{qt}=[hp hp]; %Handles of objects to animate
        animStruct.Props{qt}={'Vertices','CData'}; %Properties of objects to animate
        animStruct.Set{qt}={V_def,CF}; %Property values for to set in order to animate
    end
        
    anim8(hf,animStruct);
    drawnow;
    
end

%% 
%
% <<gibbVerySmall.gif>>
% 
% _*GIBBON*_ 
% <www.gibboncode.org>
% 
% _Kevin Mattheus Moerman_, <gibbon.toolbox@gmail.com>
 
%% 
% _*GIBBON footer text*_ 
% 
% License: <https://github.com/gibbonCode/GIBBON/blob/master/LICENSE>
% 
% GIBBON: The Geometry and Image-based Bioengineering add-On. A toolbox for
% image segmentation, image-based modeling, meshing, and finite element
% analysis.
% 
% Copyright (C) 2018  Kevin Mattheus Moerman
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
