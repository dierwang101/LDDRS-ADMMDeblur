%即插即用ADMM去噪
clearvars; close all; clc;
%读取图像
In=imread('F:\DA\红外偏振可见光\新建文件夹\20220805185220.bmp');
[s,t]=size(In);I=double(In);
for i=1:s/2
    for j=1:t/2
        I_4(i,j)=I(2*i-1,2*j-1);%提取135°偏振图像
        I_1(i,j)=I(2*i-1,2*j);%提取0°偏振图像
        I_3(i,j)=I(2*i,2*j-1);%提取90°偏振图像
        I_2(i,j)=I(2*i,2*j);%提取45°偏振图像
    end
end
S0 = ( I_1 + I_3 + I_2 + I_4 ) / 2;%强度S0
S1 = I_1 - I_3;
S2 = (I_2 - I_4);
AoLP = 0.5*atan(S2./S1);%偏振角
DoLP  = sqrt(S2.*S2+S1.*S1)./S0;%偏振度


addpath(genpath('./utilities/'));
%add path to denoisers
addpath(genpath('E:/个人资料/博一/algorithm/refcode/BM3D-master/'));
addpath(genpath('./denoisers/TV/'));
addpath(genpath('./denoisers/NLM/'));
addpath(genpath('./denoisers/RF/'));

%initialize a blurring filter
h = fspecial('gaussian',[7 7],0.6);

%reset random number generator
rng(0);

%set noies level
%noise_level = 10/255;

%calculate observed image
%y = imfilter(z,h,'circular')+noise_level*randn(size(z));

%parameters切换去噪器
method = 'BM3D';
switch method
    case 'RF'
        lambda = 0.0005;
    case 'NLM'
        lambda = 0.005;
    case 'BM3D'
        lambda = 0.001;
    case 'TV'
        lambda = 0.01;
end

%optional parameters
opts.rho     = 1;
opts.gamma   = 1;
opts.max_itr = 50;
opts.print   = true;

%%
I_cell={I_1,I_2,I_3,I_4};
for i=1:4
    Iout=I_cell{i};
    maxvaule=max(max(Iout));
    minvaule=min(min(Iout));
    Iout_temp=(Iout-minvaule)./(maxvaule-minvaule);
    y=Iout_temp;
    Iout = PlugPlayADMM_deblur(y,h,lambda,method,opts);
    Iout=Iout.*(maxvaule-minvaule)+minvaule;
    I_cell{i}=round(Iout);
end

S1 = I_cell{1} - I_cell{3};
S2 = (I_cell{2} - I_cell{4});

%main routine
%y=mat2gray(S1);
%y = proj(y,[0,1]);
maxvaule=max(max(S1));
minvaule=min(min(S1));
S1_temp=(S1-minvaule)./(maxvaule-minvaule);
y=S1_temp;
S1_out = PlugPlayADMM_deblur(y,h,lambda,method,opts);
S1_out=S1_out.*(maxvaule-minvaule)+minvaule;
S1_out=round(S1_out);

figure;
subplot(121);
imagesc(y);
title('Input');

subplot(122);
imagesc(S1_out);
title('Output');

%main routine
% y=mat2gray(S2);
% y = proj(y,[0,1]);
maxvaule=max(max(S2));
minvaule=min(min(S2));
S2_temp=(S2-minvaule)./(maxvaule-minvaule);
y=S2_temp;
S2_out = PlugPlayADMM_deblur(y,h,lambda,method,opts);
S2_out=S2_out.*(maxvaule-minvaule)+minvaule;
S2_out=round(S2_out);

figure;
subplot(121);
imagesc(y);
title('Input');

subplot(122);
imagesc(S2_out);
title('Output');

% opts.max_itr = 10;
% lambda=0.0005;
% h = fspecial('gaussian',[3 3],0.5);
%method = 'Guide';
AoLP = 0.5*atan(S2_out./S1_out);%偏振角
AoLP(isnan(AoLP))=0;
maxvaule=max(max(S0));
minvaule=min(min(S0));
S0_temp=(S0-minvaule)./(maxvaule-minvaule);
maxvaule=max(max(AoLP));
minvaule=min(min(AoLP));
AoLP_temp=(AoLP-minvaule)./(maxvaule-minvaule);
y=(AoLP_temp);
%AoLP2 = PnPADMM_de_Guide(y,h,S0_temp,lambda,method,opts);
AoLP2 = PlugPlayADMM_deblur(y,h,lambda,method,opts);
AoLP2=AoLP2.*(maxvaule-minvaule)+minvaule;

figure;
subplot(121);
imagesc(y);
title('Input');

subplot(122);
imagesc(AoLP2);
title('Output');











