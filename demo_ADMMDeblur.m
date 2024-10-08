%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a demo code for basic pre-processing of DoFP image, including denoising, 
% demosaicking and calculating Stokes parameters.
% 
% [1] Li, N., Zhao, Y., Pan, Q., Kong, S.G., J.C.W., "Full-Time Monocular Road Detection 
% Using Zero-Distribution Prior of Angle of Polarization" ECCV, 2020.
%
% [2] Li, N., Zhao, Y., Pan, Q., Kong, S.G., J.C.W., "Illumination-invariant road detection and tracking
% using LWIR polarization characteristics" ISPRS Journal of Photogrammetry and Remote Sensing, 180, 357-369, 2020.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Copyright (c) Northwestern Polytechnical University.                    %
%                                                                         %
% All rights reserved.                                                    %
% This work should only be used for nonprofit purposes.                   %
%                                                                         %
% AUTHORS:                                                                %
%     Ning Li, Yongqiang Zhao, Quan Pan, Seong G. Kong, and               %
%     Jonathan Cheung-Wai Chan                                            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all
%% load raw DoFP image
i = 884; % i=1:2113
filename = ['.\RAW\',num2str(i),'.png']; %add the filepath of RAW DoFP images of LDDRS
I = double((imread('F:\Dataset\VIS-IRP\myvisirp\IRP\00526.bmp')));
% I = double(imread(filename));
figure;imshow(I,[]);title('Raw DoFP image') % display raw DoFP image
%% BM3D denoising
maxI = max(max(I));
minI = min(min(I));
widthI = maxI - minI;
I = (I - minI)/widthI;
% [~, Id] = BM3D(1, I, 1.2, 'lc', 0);
% ADMM-BM3D parameter
h = fspecial('gaussian',[1 1],1);
lambda = 0.0001;%regularization parameter
opts.rho     = 0.5;%internal parameter of ADMM
opts.gamma   = 0.5;%parameter for updating rho
opts.max_itr = 3;
opts.print   = true;
opts.tol=1e-10;
Id = PlugPlayADMM_deblur(I,h,lambda,'BM3D',opts);
Id = Id*widthI + minI;
%% Polarization demosaicking
[I0,I45,I90,I135] = FFC_Polynomial_interpolation(Id);
%% Calculate the Stokes parameters,DoP and AoP
[s0, s1, s2] = Mypolar_calibration(I0,I45,I90,I135); % polar calibration
dolp = (sqrt(s1.*s1 + s2.*s2))./s0;
aop = (1/2) * atan2(s2,s1)*180/pi;
% Selecting a threshold
[dolp_th1,dolp_th2]=histsort(dolp);
% display S0, DoP and AoP
% S0 = IRHDRv1(s0); % HDR correction of the S0 image
% figure;imshow(S0,[]);title('S_0^{HDR}')
figure;imshow(dolp,[]);colormap Parula;colorbar;title('DoLP')
figure;imshow(dolp,[dolp_th1,dolp_th2]);colormap Parula;colorbar;title('DoLP_{hist}')
figure;imshow(aop,[]);colormap HSV;colorbar;title('AoP')

% Filter the image histogram with a Gaussian distribution to select the threshold.
function [th1,th2]=histsort(I)
A=sort(I(:));
A(isnan(A))=0;
miu=mean(A);
sigma=std(A);
th1=miu-0.5*sigma;
th2=miu+0.5*sigma;

th1=max(0,th1);%最小值
th2=min(1,th2);%最大值
end